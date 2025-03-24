
log using "Rep_folder\output_logs\TableA10.log", replace

use "Rep_folder\data\Full_sample.dta", clear
keep if prov=="江苏"
replace city = city + "市"
gen post = (ym>=201702)
cap drop dudt
gen dudt = boundary * post

cap drop lngdp lnp
gen lngdp = ln(gdp)
gen lnp = ln(population)

merge m:1 city year using "Rep_folder\data\Jiangsu_enterprises.dta"
gen lnC26 = ln(C26)
gen lnC28 = ln(C28)
gen lnC29 = ln(C29)
gen lnC32 = ln(C32)

reghdfe lnC26 dudt lngdp lnp max_temp min_temp wind, absorb(monitor_id ym) cluster(monitor_id)
est store js_p_C26
reghdfe lnC28 dudt lngdp lnp max_temp min_temp wind, absorb(monitor_id ym) cluster(monitor_id)
est store js_p_C28
reghdfe lnC29 dudt lngdp lnp max_temp min_temp wind, absorb(monitor_id ym) cluster(monitor_id)
est store js_p_C29
reghdfe lnC32 dudt lngdp lnp max_temp min_temp wind, absorb(monitor_id ym) cluster(monitor_id)
est store js_p_C32

esttab js_p_*, mtitle se(%6.3f) b(%6.3f) ar2 keep(dudt) star(* 0.1 ** 0.05 *** 0.01)


log close