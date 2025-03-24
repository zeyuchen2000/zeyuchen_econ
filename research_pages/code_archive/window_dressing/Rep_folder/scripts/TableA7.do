
log using "Rep_folder\output_logs\TableA7.log", replace

global cov lngdp lnp max_temp min_temp windpow

use "Rep_folder\data\Full_sample.dta", clear
keep if ym>=201501&ym<=201912
gen post = (ym>=201703)
gen dudt = post * boundary
rename wind windpower

reghdfe lnAQI dudt $cov if prov=="山西"&(dist_to_henan!=0|dist_to_hebei!=0|boundary==0), ///
	absorb(monitor_id ym) cluster(monitor_id)
est store shanxi

reghdfe lnAQI dudt $cov if prov=="河南"&(dist_to_shandong!=0|dist_to_shanxi!=0|dist_to_hebei!=0|boundary==0), ///
	absorb(monitor_id ym) cluster(monitor_id)
est store henan

reghdfe lnAQI dudt $cov if prov=="河北"&(dist_to_shandong!=0|dist_to_shanxi!=0|dist_to_hebei!=0|boundary==0), ///
	absorb(monitor_id ym) cluster(monitor_id)
est store hebei

esttab shanxi henan hebei, mtitle se(%6.3f) b(%6.3f) ar2 keep(dudt) star(* 0.1 ** 0.05 *** 0.01)


log close