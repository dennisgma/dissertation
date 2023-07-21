clear
run getprojnum.do //obtain secret compute canada project number to get $proj_num
//CODE TO STITCH TOGETHER RESTRUCTURED DATA
//globals
local tofolder "/project/$proj_num/dennisma/Data/processed_stata/weekly_3_6/to_append/" 	//remember to make this folder beforehand

global dir "`tofolder'"			//edit accordingly 
//look in directory
local filelist ""
cd "`tofolder'"
fs 
foreach f in `r(files)' {
	di "processing `f'..."
	local filelist "`filelist' `f'"
	use "`f'", clear 			//start with a single datafile
	cap drop rec
	g rec=_n	
	order address tp_s
	destring tp_s-rec, replace force
	save `f', replace
}

//append all data in directory
local starter "dac17f958d2ee523a2206206994597c13d831ec7"				//starting file
use "`tofolder'/`starter'_merged.dta" 			//start with a single datafile
local filelist: subinstr local filelist "`starter'_merged.dta" ""

append using `filelist'

save "/project/$proj_num/dennisma/Data/weekly_3_6_rawRC.dta" , replace

