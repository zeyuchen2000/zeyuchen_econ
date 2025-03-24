
log using "Rep_folder\output_logs\TableA8.log", replace

global cov lngdp lnp max_temp min_temp windpow

use "Rep_folder\data\Shandong_sample.dta", clear
cap drop post dudt
gen post = (ym>=201703)
gen dudt = post * boundary
gen dist_bj_ln = ln(dist_bj)
gen dudt_dist = post * dist_bj
gen dudt_dist_ln = post * dist_bj_ln
est drop _all

* JAPCP-covered boundary
reghdfe lnAQI dudt $cov if (hnhb==1|boundary==0), absorb(monitor_id ym winddir#ym) cluster(monitor_id)
est store bm_hnhb
reghdfe lnAQI dudt dudt_dist $cov if (hnhb==1|boundary==0), absorb(monitor_id ym winddir#ym) cluster(monitor_id)
est store bm_hnhb_dist
reghdfe lnAQI dudt dudt_dist_ln $cov if (hnhb==1|boundary==0), absorb(monitor_id ym winddir#ym) cluster(monitor_id)
est store bm_hnhb_dist_ln

* JAPCP-uncovered boundary
replace post = (ym>=201710)
replace dudt = post * boundary
replace dudt_dist = post * dist_bj
reghdfe lnAQI dudt $cov if (js==1|boundary==0), absorb(monitor_id ym winddir#ym) cluster(monitor_id)
est store bm_js
reghdfe lnAQI dudt dudt_dist $cov if (js==1|boundary==0), absorb(monitor_id ym winddir#ym) cluster(monitor_id)
est store bm_js_dist
reghdfe lnAQI dudt dudt_dist_ln $cov if (js==1|boundary==0), absorb(monitor_id ym winddir#ym) cluster(monitor_id)
est store bm_js_dist_ln

esttab bm_*, mtitle se(%6.3f) b(%6.3f) ar2 keep(dudt dudt_dist dudt_dist_ln) star(* 0.1 ** 0.05 *** 0.01)

log close

