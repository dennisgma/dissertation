run getprojnum.do //obtain secret compute canada project number to get $proj_num
//CODE TO PROCESS AND SAVE OUT Address-based DATA 
//set up locals
local done ""
local notdone " "
//to do (done already after code fixed to accommodate errors):
//not done due to 0 obs error: bddab785b306bcd9fb056da189615cc8ece1d823	-- FIXED (if r(N)>0) and DONE (revisit to make sure error is understood--check)
//not done due to syntax error: 77fe30b2cf39245267c0a5084b66a560f1cf9e1f	 b5a5f22694352c15b00323844ad545abb2b11028 -- both FIXED (drop if to=="" & from=="") and DONE (revisit and make sure error is understood--check)
//now the top 200 (complete):
local notdone "dac17f958d2ee523a2206206994597c13d831ec7	174bfa6600bf90c885c7c01c7031389ed1461ab9	0e3a2a1f2146d86a604adc220b4967a898d7fe07	03cb0021808442ad5efb61197966aef72a1def96 06012c8cf97bead5deae237070f9587f8e7a266d	c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2	89d24a6b4ccb1b6faa2625fe562bdd9a23260359	f230b790e05390fc8295f4d3f60332c93bed42e2	86fa049857e0209aa7d9e616f7eb3b3b78ecfdb0	1f573d6fb3f13d689ff844b4ce37794d79a7ff1c	c0829421c1d260bd3cb3e0f06cfe2d52db2ce315 58959e0c71080434f237bd42d07cd84b74cef438 744d70fdbe2ba4cf95131626614a1763df805b9e	d5dc8921a5c58fb0eba6db6b40eab40283dc3c01	7a271d1df2c3f2fef734611c6c7ee6b9b8439204	f3e014fe81267870624132ef3a646b8e83853a96		1f28f618a2b4e1882ed062db9a4f6298f125e4b8	93e682107d1e9defb0b5ee701c71707a4b2e46bc	82070415fee803f94ce5617be1878503e58f0a6a	c0f1728d9513efc316d0e93a0758c992f88b0809	dd974d5c2e2928dea5f71b9825b8b646686bd200	8c9b261faef3b3c2e64ab5e58e04615f8c788099	3f5fa71ea48ae374faae502afa2e27715484c3b7	4a8f44be523580a11cdb20e2c7c470adf44ec9bb	8e1b448ec7adfc7fa35fc2e885678bd323176e34	5edc1a266e8b2c5e8086d373725df0690af7e3ea	818fc6c2ec5986bc6e2cbf00939d90556ab12ce5	c45ba8f03ac63e4505ac5eed4985fb4e5e94383a	4dc3643dbc642b72c158e7f3d2ff232df61cb6ce	a37d94e80eab7a5bcb6d2e76b7666e341e4b58f6	ef68e7c694f40c8202821edf525de3782458639f		bd13e53255ef917da7557db1b7d2d5c38a2efe24	05f4a42e251f2d52b8ed15e9fedaacfcef1fad27	45555629aabfea138ead1c1e5f2ac3cce2add830	aafd35ddb9189995937a2862e8ff17519f5aae78	8e870d67f660d95d5be530380d0ec0bd388289e1	d7cc16500d0b0ac3d0ba156a584865a43b0b0050	6a750d255416483bec1a31ca7050c6dac4263b57 595832f8fc6bf59c85c527fec3740a1b7a361269	d77bcd9cf4212a41defbcd2e2ff0f50fea2be643	bc2faad1ec407571249b0e874a9abd840111389b	4672bad527107471cb5067a887f4656d585a8a31	419d0d8bdd9af5e606ae2232ed285aff190e711b	bddab785b306bcd9fb056da189615cc8ece1d823	8971f9fd7196e5cee2c1032b50f656855af7dd26	e36df5bb57e80629cfc28a31e5f794071c085eca	41e5560054824ea6b0732e656e3ad64e20e94e45	0f5d2fb29fb7d3cfee444a200298f468908cc942	bf2179859fc6d5bee9bf9158632dc51678a4100e	d850942ef8811f2a866692a623011bde52a462c1	58a4884182d9e835597f405e5f258290e46ae7c2	fc87d4f82fc5fe80a2d1692ffee872b2517c34c7	5b8174e20996ec743f01d3b55a35dd376429c596	9992ec3cf6a55b00978cddf2b27bc6882d88d1ec	e7d7b37e72510309db27c460378f957b1b04bd5d	151bc71a40c56c7cb3317d86996fd0b4ff9bd907	e6b75a1960f91bfa7010dec8543685ead67f8cff	6f259637dcd74c767781e37bc6133cd6a68aa161	92e52a1a235d9a103d970901066ce910aacefd37	816051e2203ca534c4336d8d6df71987fa3ae0bd	77fe30b2cf39245267c0a5084b66a560f1cf9e1f	d97e471695f73d8186deabc1ab5b8765e667cd96	af47ebbd460f21c2b3262726572ca8812d7143b0	69b148395ce0015c13e36bffbad63f49ef874e03	457476bc97adef10aba63fcadaefe503553fa0d2	80fb784b7ed66730e8b1dbd9820afd29931aab03	ab4e1802c61e12fd7b10a69a226f5d727c76a8aa	1530df3e1c69501d4ecb7e58eb045b90de158873	3f17dd476faf0a4855572f0b6ed5115d9bba22ad	3616fd03f11e22942e4fc01cdd0f1ca7cc7bb93d	c5bbae50781be1669306b9e001eff57a2957b09d	02b3c88b805f1c6982e38ea1d40a1d83f159c3d4	bf5f8bfcee9502a30018d91c63eca66980e6e9bb	03df4c372a29376d2c8df33a1b5f001cd8d68b0e	b5a5f22694352c15b00323844ad545abb2b11028	3597bfd533a99c9aa083587b074434e61eb0a258	516e5436bafdc11083654de7bb9b95382d08d5de	04abeda201850ac0124161f037efd70c74ddc74c	bd65f6f9f9f87af2a677709e132debc3f242671d	b97048628db6b661d4c2aa833e95dbe1a905b280	f53ad2c6851052a81b42133467480961b2321c09	f3586684107ce0859c44aa2b2e0fb8cd8731a15a	fa1a856cfa3409cfa145fa4e20eb270df3eb21ab	1234567461d3f8db7496581774bd869c83d51c93	f5b0a3efb8e8e4c201e2a935f110eaaf3ffecb8d	275b69aa7c8c1d648a0557656bce1c286e69a29d	351d5ea36941861d0c03fdfb24a8c2cb106e068b	3c7b464376db7c9927930cf50eefdea2eff3a66a	d0929d411954c47438dc1d871dd6081f5c5e149c	08ceed1e8db59acbb687a5752f0a7db815cfda5e	5ca9a71b1d01849c0a95490cc00559717fcf0d1d	8912358d977e123b51ecad1ffa0cc4a7e32ff774	d0a4b8946cb52f0661273bfbc6fd0e0c75fc6433	6c6ee5e31d828de241282b9606c8e98ea48526e2	d4de05944572d142fbf70f3f010891a35ac15188	cba8162778e6a3eba60e1cf7c012b327340bd05d	fb5a551374b656c6e39787b1d3a03feab7f3a98e	53066cddbc0099eb6c96785d9b3df2aaeede5da3	bcc394d45c3613530a83cae62c716dc23b7f2152	8f8221afbb33998d8584a2b05749ba73c37a938a	42f1d3380cc1526eb182343dc3bdd970ce664322	f8c595d070d104377f58715ce2e6c93e49a87f3c	6b175474e89094c44da98b954eedeac495271d0f	47a16e51bcc89c0015622fe83eb482a4522f6c5c	9eec65e5b998db6845321baa915ec3338b1a469b	076641af1b8f06b7f8c92587156143c109002cbe	c12d1c73ee7dc3615ba4e37e4abfdbddfa38907e	49592d97be49033615a7fbc02c6853e4c58eb9bc	3cc83c2400e00a54fa1e588d62bc28bf15d5def5	809826cceab68c387726af962713b64cb5cb3cca	d2299b3098cf5e13144caebfdad61ebe505233dc	9b4e2b4b13d125238aa0480dd42b4f6fc71b37cc	a720911a58d948fc9328560aecfc51e907404fc4	419c4db4b9e25d6db2ad9691ccb832c8d9fda05e	f1ca9cb74685755965c7458528a36934df52a3ef	d4fa1460f537bb9085d22c7bccb5dd450ef28e3a	b6ed7644c69416d67b522e20bc294a9a9b405b31	d7732e3783b0047aa251928960063f863ad022d8	8853b05833029e3cf8d3cbb592f9784fa43d2a79	b63b606ac810a52cca15e44bb630fd42d8d1d83d	b68042de5b3da08a80c20d29aefab999d0848385	f6276830c265a779a2225b9d2fcbab790cbeb92b	1985365e9f78359a9b6ad760e32412f4a445e862	f226e38c3007b3d974fc79bcf5a77750035436ee	b62132e35a6c13ee1ee0f84dc5d40bad8d815206	d73be539d6b2076bab83ca6ba62dfe189abc6bbe	e62e6e6c3b808faad3a54b226379466544d76ea4	6ef77d991eb5306e9f235abc0cc65925da398ad0	007ac2f589eb9d4fe1cea9f46b5f4f52dab73dd4	e6bc60a00b81c7f3cbc8f4ef3b0a6805b6851753	2b7922fdf76fb3466902c7b702a20ea6a450a0a0	d48b633045af65ff636f3c6edd744748351e020d	3b8a1122316a9520b4ffe867f56a130c1524a64f	b31c219959e06f9afbeb36b388a4bad13e802725	2b591e99afe9f32eaa6214f7b7629768c40eeb39	8bcb64bfda77905398b67af0af084c744e777a20	e477292f1b3268687a29376116b0ed27a9c76170	b7cb1c96db6b22b0d3d9536e0108d062bd488f74	1519aff03b3e23722511d2576c769a77baf09580 8fdcc30eda7e94f1c12ce0280df6cd531e8365c5	dc17e8a84fee8b52e4de7a85160f8cdbb3bb2494	8e766f57f7d16ca50b4a0b90b88f6468a09b0439	d26114cd6ee289accf82350c8d8487fedb8a0c07	74fd51a98a4a1ecbef8cc43be801cce630e260bd	514910771af9ca656af840dff83e8264ecf986ca	9e15f8ad98e95033c1d4798458cec34a4b5972b0	0d8775f648430679a709e98d2b0cb6250d2887ef	21ab6c9fac80c59d401b37cb43f81ea9dde7fe34	0e50e6d6bb434938d8fe670a2d7a14cd128eb50f	b64ef51c888972c908cfacf59b47c1afbc0ab8ac	7b2f9706cd8473b4f5b7758b0171a9933fc6c4d6	a15c7ebe1f07caf6bff097d8a589fb8ac49ae5b3	c5d105e63711398af9bbff092d4b6769c82f793d	a5b46ff9a887180c8fb2d97146398ddfc5fef1cd	b64ffdca47d6c3895608c4e05faba6e617b3a031	a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48	ac08809df1048b82959d6251fbc9538920bed1fa	519475b31653e46d20cd09f9fdcf3b12bdacb4f5	bc4162d53f945266684f4e5e48d545f206bc1ca5	52903256dd18d85c2dc4a6c999907c9793ea61e3	06a6a7af298129e3a2ab396c9c06f91d3c54aba8	573aaaa81154cd24e96f0cb97fd86110b8f6767f	e41d2489571d322189246dafa5ebde1f4699f498	b8c77482e45f1f44de1745f52c74426c631bdd52	62b9f8741bf53a6986a5411c0557c30f6f11f3af	27695e09149adc738a978e9a678f99e4c39e9eb9	7c5cb1220bd293ff9cf903915732e51a71292038	ab95e915c123fded5bdfb6325e35ef5515f1ea69	0d152b9ee87ebae179f64c067a966dd716c50742	1f0480a66883de97d2b054929252aae8f664c15c	c9c4d9ec2b44b241361707679d3db0876ac10ca6	d3ebdaea9aeac98de723f640bce4aa07e2e44192	8a88f04e0c905054d2f33b26bb3a46d7091a039a	e1ac9eb7cddabfd9e5ca49c23bd521afcdf8be49	931abd3732f7eada74190c8f89b46f8ba7103d54	3495ffcee09012ab7d827abf3e3b3ae428a38443	cafe27178308351a12fffffdeb161d9d730da082	f629cbd94d3791c9250152bd8dfbdf380e2a3b9c	5da8d37485b4374fc338fc1f1ea31d07eb7bedd3	2e65e12b5f0fd1d58738c6f38da7d57f5f183d1c	5e7ebea68ab05198f771d77a875480314f1d0aae	e530441f4f73bdb6dc2fa5af7c3fc5fd551ec838	9f8f72aa9304c8b593d555f12ef6589cc3a579a2	686b30a80826340a59afa564c2a01b79128eb7dd	212d95fccdf0366343350f486bda1ceafc0c2d63	4092678e4e78230f46a1534c0fbc8fa39780892b	c4131c1893576e078a0b637b653f3e6a18e137ac	0e69d0a2bbb30abcb7e5cfea0e4fde19c00a8d47	a68920f6d3c996ac3c232e4e93914e9d76150735	0cf0ee63788a0849fe5297f3407f701e122cc023	68e54af74b22acaccffa04ccaad13be16ed14eac	9e9801bace260f58407c15e6e515c45918756e0f	ba7435a4b4c747e0101780073eeda872a69bdcd4"

//problematic contracts:
//not done due to variable v2 type mismatch with other v variables r(198): 58b6a8a3302369daec383334672404ee733ab239	6ebeaf8e8e946f0716e6533a6f2cefc83f60e8ab	564cb55c655f727b61d9baf258b547ca04e9e548
//removed because they threw errors (likely because they are dropship only): 629cdec6acc980ebeebea9e5003bcd44db9fc5ce	58b6a8a3302369daec383334672404ee733ab239 6ebeaf8e8e946f0716e6533a6f2cefc83f60e8ab	564cb55c655f727b61d9baf258b547ca04e9e548
global incomp ""
local tofolder "/project/$proj_num/dennisma/Data/processed_stata/" 	//remember to make this folder beforehand
local fromfolder "/project/$proj_num/dennisma/Data/link_data/"
local tpvar "tp"
local prefix "_3_6_weekly"
cd "`fromfolder'"
//process
log using top200weekly3-6.smcl,replace
foreach f of local notdone {
	//run stata processing code
	di "processing `f'..."
	qui do "/project/$proj_num/dennisma/Data/stata_metrics_cf.do" "`f'" 3 6 "weekly" 

	local done "`done' `f'"
}

foreach d of local done {
	local notdone: subinstr local notdone "`d'" "", all
}
di "still not done: `notdone'"
log close
/*
//then run the same list in R
//after that's done, merge the files
foreach f of local done {
	import delimited "`tofolder'\\`f'`prefix'.csv`", clear varnames(1)	//this is the file created in R
	merge 1:1 tp using "`tofolder'\\`f'`prefix'.dta`"
	//then restructure
	g address="`f'"
	
	//first, keep data
	preserve
	//next loop through the variables to store a temporary file for each
	qui ds
	local vlist "`r(varlist)'"
	local vlist: subinstr local vlist "`tpvar'" ""
	foreach v of vlist {
		keep address `tpvar' `v'
		//restructure data
		_lgmreshape `v'
		
		save `v'_temp.dta, replace
		restore
	}	
	local first=0
	foreach v of vlist {
		if (`first'!=0) {
			merge 1:1 address tp_s  using "`v'_temp.dta"
		}
		else {
			use `v'_temp.dta, clear
			local first=1			
		}
		erase "`v'_temp.dta"		//get rid of this
	}
	save "`tofolder'\toappend\`f'_merged.dta" , replace	
}

//CODE TO STITCH TOGETHER RESTRUCTURED DATA
//globals
global dir "`tofolder'"			//edit accordingly 
//look in directory
fs $dir
local files "`r(files)'"
//append all data in directory
local starter "[insert a file name here]"				//starting file
use "`tofolder'\toappend\\`starter'_merged.dta" 			//start with a single datafile
local files: subinstr local files "`starter'" ""
append using `files'
save "`tofolder'\weekly_3_6_final.dta" , replace

//save out -- but run this only after data is created...

//double check to see if all files got appended. if not, it could be due to a local maximum character count restriction. in that case, need to rename some files.

//in a SEPARATE FILE:
//need to restructure data so that it is conduscive for the LGM analysis...
/*wide form with six periods on each row

From:
tp	Val
1	#
2	#	
3	#
4	#
5	#
6	#
7	#
8	#
9	#
10	#
11	#
12	#
.
.
.

To:
TP_s	Val1 	Val2	Val3	Val4	Val5	Val6 
1		#		#		#		#		#		#
4		#		#		#		#		#		#
7		#		#		#		#		#		#
10		#		#		#		#		#		#

//set up program
cap program drop _lgmreshape
program define _lgmreshape
	//`1' is the name of the network measure variable
	local name="`1'"
	//`2' is the number of repeat measures of the variable per row (6)
	local mpr=`2'
	//`3' is the increment between time periods (3)
	local tpinc=`3'
	
	//first reshape wide
	g temp=1
	qui su tp
	local tpmax=`r(max)'-`mpr'+1
	reshape wide `name', i(temp) j(tp)	
	drop temp
	
	//duplicate rows 
	g numrows=floor(`tpmax'/`tpinc')+1 //calculate how many rows
	expand numrows
	drop numrows
	
	g tp_s=.
	//now to number the rows
	local tp=1
	local pos=1
	while (`tp'<=`tpmax') {
		replace tp_s=`tp' in `pos'
		forv x=1/`mpr' {
			local add=`x'-1+`tp' 					//this is how much to shift out the data 
			replace `name'`x'=`name'`add' in `pos'	//pull back all values accordin to tp_s
		}
		local pos=`pos'+1
		local tp=`tp'+`tpinc'
	}
	keep tp_s `name'1-`name'`mpr'
	drop if tp_s==.	//shave off the "remainders" that get created when the mpr and tpinc don't line up well
end
//use "example.dta", clear
//_lgmreshape "measure" 6 3 

//make sure there is only one row

//get the max # 
//then duplicate rows

*/
