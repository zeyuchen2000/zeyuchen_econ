
log using "Rep_folder\output_logs\Table1.log", replace

global cov lngdp lnp max_temp min_temp windpow

use "Rep_folder\data\Shandong_sample.dta", clear

xtset monitor_id ym
cap drop post dudt
gen post = (ym>=201703)
gen dudt = post * boundary

quietly reghdfe lnAQI dudt $cov if (hnhb==1|boundary==0), absorb(monitor_id ym) cluster(monitor_id)
gen nomiss = e(sample)
quietly reghdfe lnAQI dudt $cov if (js==1|boundary==0), absorb(monitor_id ym) cluster(monitor_id)
replace nomiss = e(sample) if nomiss==0

drop if nomiss!=1

* Desdcriptive statistics
gen group = 1 if boundary==0
replace group = 2 if boundary==1&hnhb==1
replace group = 3 if boundary==1&js==1
label define group 1 "non-boundary area" 2 "JAPCP-covered boundary" 3 "JAPCP-uncovered boundary"
label values group group

** Total
sum AQI PM25 PM10 CO NO2 gdp population max_temp min_temp windpow ///
	industry_num manu_num supply_num C25 C26 C28 C29 C30 C31 C32, sep(0)

** By area
bysort group: sum AQI PM25 PM10 CO NO2 gdp population max_temp min_temp windpow ///
				  industry_num manu_num supply_num C25 C26 C28 C29 C30 C31 C32, sep(0)
	

log close