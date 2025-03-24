
log using "Rep_folder\output_logs\Table9.log", replace

global cov lngdp lnp max_temp min_temp windpow

* Pollution
use "Rep_folder\data\Shandong_sample.dta", clear
cap drop post dudt
gen post = (ym>=201703)
gen dudt = post * boundary
est drop _all

reghdfe lnAQI dudt $cov if (hnhb==1|boundary==0)&policy_city==1, absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_pollution

replace post = (ym>=201710)
replace dudt = post * boundary
reghdfe lnAQI dudt $cov if (js==1|boundary==0)&policy_city==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_pollution

* Enterprises
use "Rep_folder\data\Shandong_sample.dta", clear
cap drop post dudt
gen post = (ym>=201703)
gen dudt = post * boundary
gen ln_key_regulated = ln(C26 + C28 + C29 + C32) 

reghdfe ln_manu_num dudt $cov if (hnhb==1|boundary==0)&(policy_city==1), absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_manu
reghdfe ln_supply_num dudt $cov if (hnhb==1|boundary==0)&(policy_city==1), absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_supply
reghdfe ln_key_regulated dudt $cov if (hnhb==1|boundary==0)&(policy_city==1), absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_key_regulated
reghdfe ln_manu_num dudt $cov if (js==1|boundary==0)&(policy_city==0), absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_manu
reghdfe ln_supply_num dudt $cov if (js==1|boundary==0)&(policy_city==0), absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_supply
reghdfe ln_key_regulated dudt $cov if (js==1|boundary==0)&(policy_city==0), absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_key_regulated

* Regulation intensity
use "Rep_folder\data\Shandong_sample.dta", clear
replace city = city1
merge m:1 city year using "Rep_folder\data\Government_work_report.dta", keepusing(text len huanjing huanbao wuran) nogen
cap drop post dudt
gen post = (ym>=201703)
gen dudt = post * boundary
gen total_words = huanjing + huanbao + wuran
gen total_r = (huanjing + huanbao + wuran) / len * 10000

reghdfe total_r dudt $cov if (hnhb==1|boundary==0)&(policy_city==1), absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_regulation
reghdfe total_r dudt $cov if (js==1|boundary==0)&(policy_city==0), absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_regulation

** Panel A
esttab hnhb_pollution hnhb_manu hnhb_supply hnhb_key_regulated hnhb_regulation, ///
	mtitle se(%6.3f) b(%6.3f) ar2 keep(dudt) star(* 0.1 ** 0.05 *** 0.01)
** Panel B
esttab js_pollution js_manu js_supply js_key_regulated js_regulation, ///
	mtitle se(%6.3f) b(%6.3f) ar2 keep(dudt) star(* 0.1 ** 0.05 *** 0.01)

	
log close

