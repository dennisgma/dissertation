run getprojnum.do //obtain secret compute canada project number to get $proj_num
//log output
log using lgm_3_6_weekly_rawRC_min50_act1_ln.smcl, replace

//set params
set matsize 11000
global minact=50

//open dataset
use "/project/$proj_num/dennisma/Data/processed_stata/weekly_3_6/weekly_3_6_rawRC.dta", clear

//remove rows that have missing data (i.e., contract doesn't exist) in any of the six time periods used to measure the latent growth curve
egen ID=group(address)
egen rownm=rownonmiss(activity*)
sort address tp_s
by address: egen nrows=count(rownm==6)
keep if rownm==6
drop rownm


//shave off rows where there is fewer than $minact
egen rm=rowmin(activity*)
drop if activity1<$minact
drop rm

//some calculations and transformations:
forv x=1/6 {
	g cf`x'=_cfseq`x'/(_cf2out`x'+_cf2in`x')
	replace activity`x'=ln(activity`x'+1)	
}

//now to analyze the data:
//set reference groups for contract and time period FEs
char tp_s[omit]70
char ID[omit]41

//model:

xi: regress activity1 i.tp_s i.ID //use this to break out the FE terms
//model:
sem (Intercept@1 Slope@0 -> activity1) ///
(Intercept@1 Slope@1 -> activity2) ///
(Intercept@1 Slope@2 -> activity3) ///
(Intercept@1 Slope@3 -> activity4) ///
(Intercept@1 Slope@4 -> activity5) ///
(Intercept@1 Slope@5 -> activity6) ///
(Intercept Slope <- _Itp_s_* _IID_* size1 _cons), ///
var(e.activity1@var e.activity2@var ///
    e.activity3@var e.activity4@var ///
	e.activity5@var e.activity6@var) ///
latent(Intercept Slope) ///
noconstant method(mlmv) 


estat gof, stats(all)	
estadd scalar srmr=r(srmr)
estadd scalar cd=r(cd)
estadd scalar rmsea=r(rmsea)
estadd scalar rmsea_p=r(pclose)
estadd scalar aic=r(aic)
estadd scalar bic=r(bic)
estadd scalar cfi=r(cfi)
estadd scalar tli=r(tli)
estadd scalar chi2_bs=r(chi2_bs)
estadd scalar df_bs=r(df_bs)
estadd scalar p_bs=r(p_bs) 
estadd scalar chi2_ms=r(chi2_ms)
estadd scalar df_ms=r(df_ms)
estadd scalar p_ms=r(p_ms) 
estimates store lgm1

xi: regress activity1 i.tp_s i.ID //use this to break out the FE terms

//add connectance
sem (Intercept@1 Slope@0 -> activity1) ///
(Intercept@1 Slope@1 -> activity2) ///
(Intercept@1 Slope@2 -> activity3) ///
(Intercept@1 Slope@3 -> activity4) ///
(Intercept@1 Slope@4 -> activity5) ///
(Intercept@1 Slope@5 -> activity6) ///
(Intercept Slope <- _Itp_s_* _IID_* size1 connectance1  _cons), ///
var(e.activity1@var e.activity2@var ///
    e.activity3@var e.activity4@var ///
	e.activity5@var e.activity6@var) ///
latent(Intercept Slope) ///
noconstant method(mlmv) 


estat gof, stats(all)	
estadd scalar srmr=r(srmr)
estadd scalar cd=r(cd)
estadd scalar rmsea=r(rmsea)
estadd scalar rmsea_p=r(pclose)
estadd scalar aic=r(aic)
estadd scalar bic=r(bic)
estadd scalar cfi=r(cfi)
estadd scalar tli=r(tli)
estadd scalar chi2_bs=r(chi2_bs)
estadd scalar df_bs=r(df_bs)
estadd scalar p_bs=r(p_bs) 
estadd scalar chi2_ms=r(chi2_ms)
estadd scalar df_ms=r(df_ms)
estadd scalar p_ms=r(p_ms) 
estimates store lgm2

xi: regress activity1 i.tp_s i.ID //use this to break out the FE terms

//add centralization
sem (Intercept@1 Slope@0 -> activity1) ///
(Intercept@1 Slope@1 -> activity2) ///
(Intercept@1 Slope@2 -> activity3) ///
(Intercept@1 Slope@3 -> activity4) ///
(Intercept@1 Slope@4 -> activity5) ///
(Intercept@1 Slope@5 -> activity6) ///
(Intercept Slope <- _Itp_s_* _IID_* size1 connectance1 centralization1 _cons), ///
var(e.activity1@var e.activity2@var ///
    e.activity3@var e.activity4@var ///
	e.activity5@var e.activity6@var) ///
latent(Intercept Slope) ///
noconstant method(mlmv) 

estat gof, stats(all)	
estadd scalar srmr=r(srmr)
estadd scalar cd=r(cd)
estadd scalar rmsea=r(rmsea)
estadd scalar rmsea_p=r(pclose)
estadd scalar aic=r(aic)
estadd scalar bic=r(bic)
estadd scalar cfi=r(cfi)
estadd scalar tli=r(tli)
estadd scalar chi2_bs=r(chi2_bs)
estadd scalar df_bs=r(df_bs)
estadd scalar p_bs=r(p_bs) 
estadd scalar chi2_ms=r(chi2_ms)
estadd scalar df_ms=r(df_ms)
estadd scalar p_ms=r(p_ms) 
estimates store lgm3

xi: regress activity1 i.tp_s i.ID //use this to break out the FE terms
//add clustering
sem (Intercept@1 Slope@0 -> activity1) ///
(Intercept@1 Slope@1 -> activity2) ///
(Intercept@1 Slope@2 -> activity3) ///
(Intercept@1 Slope@3 -> activity4) ///
(Intercept@1 Slope@4 -> activity5) ///
(Intercept@1 Slope@5 -> activity6) ///
(Intercept Slope <- _Itp_s_* _IID_* size1 connectance1 centralization1 clustering1 _cons), ///
var(e.activity1@var e.activity2@var ///
    e.activity3@var e.activity4@var ///
	e.activity5@var e.activity6@var) ///
latent(Intercept Slope) ///
noconstant method(mlmv) 

estat gof, stats(all)	
estadd scalar srmr=r(srmr)
estadd scalar cd=r(cd)
estadd scalar rmsea=r(rmsea)
estadd scalar rmsea_p=r(pclose)
estadd scalar aic=r(aic)
estadd scalar bic=r(bic)
estadd scalar cfi=r(cfi)
estadd scalar tli=r(tli)
estadd scalar chi2_bs=r(chi2_bs)
estadd scalar df_bs=r(df_bs)
estadd scalar p_bs=r(p_bs) 
estadd scalar chi2_ms=r(chi2_ms)
estadd scalar df_ms=r(df_ms)
estadd scalar p_ms=r(p_ms) 
estimates store lgm4


xi: regress activity1 i.tp_s i.ID //use this to break out the FE terms
//add centralized clustering (rich club)
sem (Intercept@1 Slope@0 -> activity1) ///
(Intercept@1 Slope@1 -> activity2) ///
(Intercept@1 Slope@2 -> activity3) ///
(Intercept@1 Slope@3 -> activity4) ///
(Intercept@1 Slope@4 -> activity5) ///
(Intercept@1 Slope@5 -> activity6) ///
(Intercept Slope <- _Itp_s_* _IID_* size1 connectance1 centralization1 clustering1 rc_raw1 _cons), ///
var(e.activity1@var e.activity2@var ///
    e.activity3@var e.activity4@var ///
	e.activity5@var e.activity6@var) ///
latent(Intercept Slope) ///
noconstant method(mlmv) 

estat gof, stats(all)	
estadd scalar srmr=r(srmr)
estadd scalar cd=r(cd)
estadd scalar rmsea=r(rmsea)
estadd scalar rmsea_p=r(pclose)
estadd scalar aic=r(aic)
estadd scalar bic=r(bic)
estadd scalar cfi=r(cfi)
estadd scalar tli=r(tli)
estadd scalar chi2_bs=r(chi2_bs)
estadd scalar df_bs=r(df_bs)
estadd scalar p_bs=r(p_bs) 
estadd scalar chi2_ms=r(chi2_ms)
estadd scalar df_ms=r(df_ms)
estadd scalar p_ms=r(p_ms) 
estimates store lgm5


xi: regress activity1 i.tp_s i.ID //use this to break out the FE terms
//add cross functionality
sem (Intercept@1 Slope@0 -> activity1) ///
(Intercept@1 Slope@1 -> activity2) ///
(Intercept@1 Slope@2 -> activity3) ///
(Intercept@1 Slope@3 -> activity4) ///
(Intercept@1 Slope@4 -> activity5) ///
(Intercept@1 Slope@5 -> activity6) ///
(Intercept Slope <- _Itp_s_* _IID_* size1 connectance1 centralization1 clustering1 rc_raw1 cf1 _cons), ///
var(e.activity1@var e.activity2@var ///
    e.activity3@var e.activity4@var ///
	e.activity5@var e.activity6@var) ///
latent(Intercept Slope) ///
noconstant method(mlmv) 

estat gof, stats(all)	
estadd scalar srmr=r(srmr)
estadd scalar cd=r(cd)
estadd scalar rmsea=r(rmsea)
estadd scalar rmsea_p=r(pclose)
estadd scalar aic=r(aic)
estadd scalar bic=r(bic)
estadd scalar cfi=r(cfi)
estadd scalar tli=r(tli)
estadd scalar chi2_bs=r(chi2_bs)
estadd scalar df_bs=r(df_bs)
estadd scalar p_bs=r(p_bs) 
estadd scalar chi2_ms=r(chi2_ms)
estadd scalar df_ms=r(df_ms)
estadd scalar p_ms=r(p_ms) 
estimates store lgm6
estout * using "/project/$proj_num/dennisma/Data/lgm_weekly_3_6_rawRC_min50_act1_ln.csv" , cells(b(star) se p ci_l ci_u) stats(r2 N_pop N_subpop N_sub chi2_ms df_ms p_ms gof_cd gof_srmr) replace stardetach

close
//this is the constant term + full model run. 
//simply remove _cons from SEM specification to run without constant terms.
//use the lower half data to run with bottom 50% subsample (robustness check)
