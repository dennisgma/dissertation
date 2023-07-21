/*************************************************************************************
*	code to peice together the event data into time series w/ network coefficients   *
*************************************************************************************/
clear
run getprojnum.do //obtain secret compute canada project number to get $proj_num
/****************************************GLOBALS***************************************/
global root "/project/$proj_num/dennisma/Data/link_data/"
global finished "/project/$proj_num/dennisma/Data/processed_stata/"

local prefix "_3_6_monthly" 	//default: monthly

global blist "0000000000000000000000000000000000000000"
global inc = 2628000	//increments by one month 
global st = 1823726050 	//starting unix timestamp in stata terms -- this will be > not >=
global numper =26 		//number of time periods
local name "`1'"	  	//name of the address
local tpinc =`2'		//time period increment 
local tppr = `3'		//time periods per row
local period="`4'"		//time increment "weekly" or "monthly" (default)
//NEW for weekly (which makes more sense for analyses than monthly):
if ("`4'"=="weekly") {
	global inc = 604800		//increments by one month -- 604800 if weekly; 2628000 if monthly
	global numper = 112		//number of time periods 26 if monthly; 28*4=112 if weekly
}
local prefix "_`tpinc'_`tppr'_`period'"

global et = $st + $numper*$inc

/***************
* PROGRAMS *
***************/
//write a fxn that splits multiple topics into long form...
//for now just go w/ data as it only has one topic...
//maximum fxn size is 32 chars so need to truncate...
//Transfer (address from, address to, uint256 tokenId)
cap program drop _ddf252ad1be2c89b69c2b068fc378da
program define _ddf252ad1be2c89b69c2b068fc378da
	//partition out the text into its component parts
	//three components 192 characters total, take right 40 of first 64; right 40 of second 64, then entirety of last 64, or decode?
	replace fr_addr=substr(data,25,40) if topic=="ddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef"
	replace to_addr=substr(data,89,40) if topic=="ddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef"
	replace to_token=substr(data,-64,.) if topic=="ddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef"
end

//take the to from data and replaces the hex format addresses with simple integers 
//can sort by centrality first to help w/ _cfcoeff runtime
cap program drop _reID
program define _reID
	//at this point, the data should have a variable to and variable from to represent directed transactions
	rename from v1
	rename to v2
	g id=_n
	reshape long v, i(id) j(j)
	egen del=group(v)	//get IDs represented as manageable integers (should make runs more efficient)
	//need to reserve a spot for the central contract -- will give it the 0 slot
	foreach b of global blist {
		replace del=0 if v=="`b'"
	}
	//do again so that the central contract gets the #1 lot and that there are no gaps
	egen addr=group(del)	
	drop v del
	reshape wide addr, i(id) j(j)
	rename addr1 from
	rename addr2 to
end

//collapse duplicate directed transactions and generate a variable with frequency of transactions
cap program drop _collapseTXNs
program define _collapseTXNs
	egen del=group(from to)
	bys del: egen freq=total(del)
	drop id del
	duplicates drop
	sort freq
	g id=_n
end

//NEW
//takes a string and returns a version with duplicate strings removed
cap program drop _uniquify
program define _uniquify, rclass
	local dedupeme="`1'"
	local uniques ""
	foreach w of local dedupeme {
		if (strpos("`uniques'","`w'")==0) {
			local uniques "`uniques' `w'"
		}
	}
	return local uniques "`uniques'"
end

//NEW
//takes a string of #s and returns a version with numbers lower than an input removed
cap program drop _removelower
program define _removelower, rclass
	local threshold=`1'
	local nlist "`2'"
	local rlist ""
	foreach n of local nlist {
		if (`threshold'<`n') {
			local rlist "`rlist' `n'"
		}
	}
	return local rlist "`rlist'"
end
cap program drop _ilist
program define _ilist, rclass
	local i="`1'"	
	levelsof from if from==`i' | to==`i' , local(frlevs)
	levelsof to if from==`i' | to==`i' , local(tolevs)
	local ilist "`frlevs' `tolevs'"
	local ilist: subinstr local ilist "`i'" "", word all	//don't need this one here			
	_uniquify "`ilist'"
	local ilist "`r(uniques)'"
	if ("`2'"!="") {
		_removelower `2' "`ilist'"
		local ilist "`r(rlist)'"
	}
	return local ilist "`ilist'"
end

//collapse the directed (frequency collapsed) dyadic data into undirected dyads (with lower value address ID as addr1)
cap program drop _toundirected
program define _toundirected
	rename from v1
	rename to v2
	//long form the data 
	reshape long v, i(id) j(j) 
	//sort so that addr1 is the lower integer id and addr2 is the higher
	bys id: egen addr1=min(v)
	bys id: egen addr2=max(v)
	//make sure the frequencies match up and that 1to2 and 2to1 are distinct
	bys id: g _freq12=cond(addr1==v,freq,.)
	bys id: g _freq21=cond(addr2==v,freq,.) 
	//wide form
	drop v j freq 
	//de dupe
	duplicates drop
end

//calculate the crossfunctionality coefficient -- the more efficient way
cap program drop _cfcoeff
program define _cfcoeff
	keep to from 
	save "_temp.dta", replace
	_2in 
	global cf2in=`r(cf2in)'
	use "_temp.dta", clear
	_2out
	global cf2out=`r(cf2out)'
	use "_temp.dta", clear
	_seq
	global cfseq=`r(cfseq)'
	erase "_temp.dta"
end

cap program drop _2in
program define _2in, rclass
	sort to
	by to: egen tocount=count(to)
	keep if tocount>1
	drop from 
	local cf2in=0
	qui count
	if (r(N)>0) {
		duplicates drop
		g a=tocount-1
		g b=a*a
		g _2in=(b+a)/2
		drop a b
		su _2in
		local cf2in=r(N)*r(mean)
	}
	return local cf2in `cf2in'
end

cap program drop _2out
program define _2out, rclass
	sort from
	by from : egen frcount=count(from)
	keep if frcount>1
	drop to
	local cf2out=0
	qui count
	if (r(N)>0) {
		duplicates drop
		g a=frcount-1
		g b=a*a
		g _2out=(b+a)/2
		drop a b 
		su _2out
		local cf2out=r(N)*r(mean)
	}
	return local cf2out `cf2out'
end

cap program drop _seq
program define _seq, rclass
	keep from to
	sort from to
	duplicates drop
	//NOTE: confirm that all tocount and frcount are unique (duplicates removed first)

	//it's technically impossible to have a two link three node motif if two nodes only appear once. so we can prune those nodes from CF coeff detection
	by from : egen frcount=count(from)
	sort to
	by to : egen tocount=count(to)
	g tot=tocount+frcount
	gsort -frcount
	drop if tot<=1
	drop tot
	local cf2seq=0
	qui count
	if (r(N)>0) {
		//so really just need to identify (1) sequential (2) two out and (3) two out
		save "seqtemp.dta", replace
		keep from frcount
		duplicates drop
		rename from ID
		save "frtemp.dta", replace
		use "seqtemp.dta", clear
		keep to tocount
		duplicates drop
		rename to ID
		merge m:m ID using "frtemp.dta"
		keep if _merge==3
		g seq=frcount*tocount
		su seq
		local cfseq=r(N)*r(mean)
		erase "frtemp.dta"
		erase "seqtemp.dta"
	}
	//return seq
	return local cfseq `cfseq'
end

//calculate unique connectance
cap program drop _connectance
program define _connectance
	//for now, it's just a simple count of unique connections
	//just make sure you run this only after data has be set to undirected dyad format
	global _connectance=count
end

//open the file
cap import delimited "/project/$proj_num/dennisma/Data/link_data/`name'_links.csv", clear varnames(1)
if (c(rc)==0) {
import delimited "/project/$proj_num/dennisma/Data/link_data/`name'_links.csv", clear varnames(1)
//set it in seconds terms:
replace timestamp=timestamp/1000 

local tp=0
local ct=0							//holds max timestamp of current datafile
g tp=.
forv at=$st($inc)$et {
	local tp=`tp'+1						//tracks the time period as an integer
	local bt=`at' + $inc					//end time for this period
	
replace tp=`tp' if timestamp>`at' & timestamp<=`bt'
}
drop if tp==.	//shave off the out of range obvs
drop if to=="" & from==""  //kill off blanks
levelsof tp
local tps=r(N) 	//records how many unique tps there are for this contract

//now compute all relevant network measures for each tp then collapse to tp level data
//ACTIVITY
sort tp
by tp: egen activity=count(tp)

//Need to do the cf coeff now since the data is still directed
//before that tho, transform the data to make computations as efficient as possible
//re-ID
_reID			//this will shorten the IDs to make things more manageable.
//then sort by # of txns 
sort from
by from: egen fr_tot=total(from)	//sort descending by # txns to make things more efficient
sort to
by to: egen to_tot=total(to)
g pseudo=fr_tot+to_tot
gsort -pseudo
drop pseudo fr_tot to_tot
drop tx_hash weight id token data timestamp	//too many variables ...clogging up processing time
	g _cf2in=0
	g _cf2out=0
	g _cfseq=0
	//g _cfrec=0
	//g cfcoeff=.
//CROSS-FUNCTIONALITY
save whole.dta, replace
levelsof tp, local(tps) 
foreach t of local tps {
	//process each time period
	keep if tp==`t'
	_cfcoeff	
	use whole.dta, clear
	replace _cf2in=$cf2in if tp==`t'
	replace _cf2out=$cf2out if tp==`t'
	replace _cfseq=$cfseq if tp==`t'
	//replace _cfrec=$_cfrec if tp==`t'
	//replace cfcoeff=_cfseq/(_cf2in+_cf2out)
save whole.dta, replace
}

//CONNECTANCE
//drop timestamp
//new variable here to record frequency of such ties if you want to deal with "weighting"
duplicates drop
sort tp
by tp: egen connectance=count(tp) //need to make undirected first...
//Then save out for R (for centralization, RCcoeff, and clustering)
save "/project/$proj_num/dennisma/Data/processed_stata/`name'`prefix'.dta", replace

}
else {
global incomp "$incomp `name'"
}
