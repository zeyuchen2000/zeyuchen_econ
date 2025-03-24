
log using "Rep_folder\output_logs\Table3.log", replace

global cov lngdp lnp max_temp min_temp windpow

* By county
use "Rep_folder\data\Shandong_sample.dta", clear
cap drop post dudt
gen post = (ym>=201703)
gen dudt = post * boundary
est drop _all

reghdfe lnAQI dudt $cov if (hnhb==1|boundary==0), absorb(monitor_id ym winddir#ym) cluster(monitor_id)
est store bm10_winddirym
cap drop nomiss
gen nomiss = e(sample)
drop if nomiss==0

reghdfe lnAQI dudt if (hnhb==1|boundary==0), absorb(monitor_id ym) cluster(monitor_id)
est store bm10_no_covs
reghdfe lnAQI dudt $cov if (hnhb==1|boundary==0), absorb(monitor_id ym winddir) cluster(monitor_id)
est store bm10_with_covs

* By distance to the boundaries
use "Rep_folder\data\Shandong_sample.dta", clear
cap drop post dudt
gen post = (ym>=201703)
gen dudt = post * boundary
sum dist if boundary==1&hnhb==1 // The average distance to the boundaries of the boundary stations is 28,209 m.


replace boundary = (dist<=10000)
replace dudt = post * boundary
reghdfe lnAQI dudt $cov if (hnhb==1|boundary==0), absorb(monitor_id ym winddir#ym) cluster(monitor_id)
est store bm10_d10000

replace boundary = (dist<=30000)
replace dudt = post * boundary
reghdfe lnAQI dudt $cov if (hnhb==1|boundary==0), absorb(monitor_id ym winddir#ym) cluster(monitor_id)
est store bm10_d30000

replace boundary = (dist<=50000)
replace dudt = post * boundary
reghdfe lnAQI dudt $cov if (hnhb==1|boundary==0), absorb(monitor_id ym winddir#ym) cluster(monitor_id)
est store bm10_d50000

replace boundary = (dist<=70000)
replace dudt = post * boundary
reghdfe lnAQI dudt $cov if (hnhb==1|boundary==0), absorb(monitor_id ym winddir#ym) cluster(monitor_id)
est store bm10_d70000

esttab bm10_no_covs bm10_with_covs bm10_winddirym bm10_d*, mtitle se(%6.3f) b(%6.3f) ar2 star(* 0.1 ** 0.05 *** 0.01) 

log close

