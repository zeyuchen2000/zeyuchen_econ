

log using "Rep_folder\output_logs\TableA5.log", replace

global cov lngdp lnp max_temp min_temp windpow

* JAPCP-covered boundary
use "Rep_folder\data\Shandong_sample.dta", clear
keep if hnhb==1|boundary==0
cap drop post dudt
gen post = (ym>=201703)
gen dudt = post * boundary

psmatch2 treated lngdp lnp windpow max_temp min_temp i.winddir, logit ate neighbor(1) out(lnAQI) common
reghdfe lnAQI dudt $cov if _support==1&_weight!=0, absorb(monitor_id ym winddir#ym) cluster(monitor_id)
est store psm_hnhb_neighbor1

psmatch2 treated lnp lngdp windpow max_temp min_temp i.winddir, logit ate radius common ties out(lnAQI) cal(0.01) 
reghdfe lnAQI dudt $cov if _support==1&_weight!=0, absorb(monitor_id ym winddir#ym) cluster(monitor_id)
est store psm_hnhb_radius01

psmatch2 treated lngdp lnp windpow max_temp min_temp i.winddir, logit ate common ties out(lnAQI) kernel
reghdfe lnAQI dudt $cov if _support==1&_weight!=0, absorb(monitor_id ym winddir#ym) cluster(monitor_id)
est store psm_hnhb_kernel

* JAPCP-uncovered boundary
use "Rep_folder\data\Shandong_sample.dta", clear
keep if js==1|boundary==0
cap drop post dudt
gen post = (ym>=201710)
gen dudt = post * boundary

psmatch2 treated lngdp lnp windpow max_temp min_temp i.winddir, logit ate neighbor(1) out(lnAQI) common
reghdfe lnAQI dudt $cov if _support==1&_weight!=0, absorb(monitor_id ym winddir#ym) cluster(monitor_id)
est store psm_js_neighbor1

psmatch2 treated lnp lngdp windpow max_temp min_temp i.winddir, logit ate radius common ties out(lnAQI) cal(0.01)
reghdfe lnAQI dudt $cov if _support==1&_weight!=0, absorb(monitor_id ym winddir#ym) cluster(monitor_id)
est store psm_js_radius01

psmatch2 treated lngdp lnp windpow max_temp min_temp i.winddir, logit ate common ties out(lnAQI) kernel
reghdfe lnAQI dudt $cov if _support==1&_weight!=0, absorb(monitor_id ym winddir#ym) cluster(monitor_id)
est store psm_js_kernel

** Panel A
esttab psm_hnhb_*, mtitle se(%6.3f) b(%6.3f) ar2 keep(dudt) star(* 0.1 ** 0.05 *** 0.01)
** Panel B
esttab psm_js_*, mtitle se(%6.3f) b(%6.3f) ar2 keep(dudt) star(* 0.1 ** 0.05 *** 0.01)

log close