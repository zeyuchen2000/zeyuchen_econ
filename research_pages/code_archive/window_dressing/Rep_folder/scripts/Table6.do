

log using "Rep_folder\output_logs\Table6.log", replace

global cov lngdp lnp max_temp min_temp windpow

use "Rep_folder\data\Shandong_sample.dta", clear
cap drop post dudt
gen post = (ym>=201703)
gen dudt = post * boundary
est drop _all

** JAPCP-covered boundary
reghdfe ln_manu_num dudt $cov if hnhb==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_manu_num
reghdfe ln_supply_num dudt $cov if hnhb==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_supply_num

** JAPCP-uncovered boundary
reghdfe ln_manu_num dudt $cov if js==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_manu_num
reghdfe ln_supply_num dudt $cov if js==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_supply_num

esttab hnhb_* js_*, mtitle se(%6.3f) b(%6.3f) ar2 star(* 0.1 ** 0.05 *** 0.01) keep(dudt)

log close

