

log using "Rep_folder\output_logs\Table4.log", replace

global cov lngdp lnp max_temp min_temp windpow

/* Panel A: Setting Post = 1 after March 2017. */
* By county
use "Rep_folder\data\Shandong_sample.dta", clear
cap drop post dudt
gen post = (ym>=201703)
gen dudt = post * boundary
est drop _all

reghdfe lnAQI dudt $cov if js==1|boundary==0, absorb(monitor_id ym winddir#ym) cluster(monitor_id)
est store bm20_winddirym

cap drop nomiss
gen nomiss = e(sample)
drop if nomiss==0

reghdfe lnAQI dudt if (js==1|boundary==0), absorb(monitor_id ym) cluster(monitor_id)
est store bm20_no_covs
reghdfe lnAQI dudt $cov if js==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store bm20_with_covs


* By distance to the boundaries
use "Rep_folder\data\Shandong_sample.dta", clear
cap drop post dudt
gen post = (ym>=201703)
gen dudt = post * boundary
sum dist if js==1&boundary==1 // The average distance to the boundaries of the boundary stations is 30,903 m.

// replace lnAQI = AQI
replace boundary = dist<=10000
replace dudt = post * boundary
reghdfe lnAQI dudt $cov if js==1|boundary==0, absorb(monitor_id ym winddir#ym) cluster(monitor_id)
est store bm20_d10000

replace boundary = dist<=30000
replace dudt = post * boundary
reghdfe lnAQI dudt $cov if js==1|boundary==0, absorb(monitor_id ym winddir#ym) cluster(monitor_id)
est store bm20_d30000

replace boundary = dist<=50000
replace dudt = post * boundary
reghdfe lnAQI dudt $cov if js==1|boundary==0, absorb(monitor_id ym winddir#ym) cluster(monitor_id)
est store bm20_d50000

replace boundary = dist<=70000
replace dudt = post * boundary
reghdfe lnAQI dudt $cov if js==1|boundary==0, absorb(monitor_id ym winddir#ym) cluster(monitor_id)
est store bm20_d70000


/* Panel B: Setting Post = 1 after October 2017. */
* By county
use "Rep_folder\data\Shandong_sample.dta", clear
cap drop post dudt
gen post = (ym>=201710)
gen dudt = post * boundary

reghdfe lnAQI dudt $cov if js==1|boundary==0, absorb(monitor_id ym winddir#ym) cluster(monitor_id)
est store bm21_winddirym

cap drop nomiss
gen nomiss = e(sample)
drop if nomiss==0

reghdfe lnAQI dudt if (js==1|boundary==0), absorb(monitor_id ym) cluster(monitor_id)
est store bm21_no_covs
reghdfe lnAQI dudt $cov if js==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store bm21_with_covs


* By distance to the boundaries
use "Rep_folder\data\Shandong_sample.dta", clear
cap drop post dudt
gen post = (ym>=201710)
gen dudt = post * boundary
sum dist if js==1&boundary==1 // The average distance to the boundaries of the boundary stations is 30,903 m.

// replace lnAQI = AQI
replace boundary = dist<=10000
replace dudt = post * boundary
reghdfe lnAQI dudt $cov if js==1|boundary==0, absorb(monitor_id ym winddir#ym) cluster(monitor_id)
est store bm21_d10000

replace boundary = dist<=30000
replace dudt = post * boundary
reghdfe lnAQI dudt $cov if js==1|boundary==0, absorb(monitor_id ym winddir#ym) cluster(monitor_id)
est store bm21_d30000

replace boundary = dist<=50000
replace dudt = post * boundary
reghdfe lnAQI dudt $cov if js==1|boundary==0, absorb(monitor_id ym winddir#ym) cluster(monitor_id)
est store bm21_d50000

replace boundary = dist<=70000
replace dudt = post * boundary
reghdfe lnAQI dudt $cov if js==1|boundary==0, absorb(monitor_id ym winddir#ym) cluster(monitor_id)
est store bm21_d70000

** Panel A
esttab bm20_no_covs bm20_with_covs bm20_winddirym bm20_d*, mtitle se(%6.3f) b(%6.3f) ar2 star(* 0.1 ** 0.05 *** 0.01) 

** Panel B
esttab bm21_no_covs bm21_with_covs bm21_winddirym bm21_d*, mtitle se(%6.3f) b(%6.3f) ar2 star(* 0.1 ** 0.05 *** 0.01) 


log close

