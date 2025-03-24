

log using "Rep_folder\output_logs\Fig7.log", replace

use "Rep_folder\data\Shandong_sample.dta", clear

xtset monitor_id ym
cap drop post dudt
gen post = (ym>=201703)
gen dudt = post * boundary
gen season1 = string(season)
encode season1, gen(season2)

quietly reghdfe lnAQI dudt $cov if (hnhb==1|boundary==0), absorb(monitor_id ym) cluster(monitor_id)
gen nomiss = e(sample)
quietly reghdfe lnAQI dudt $cov if (js==1|boundary==0), absorb(monitor_id ym) cluster(monitor_id)
replace nomiss = e(sample) if nomiss==0
drop if nomiss!=1

gen group = 1 if boundary==0
replace group = 2 if boundary==1&hnhb==1
replace group = 3 if boundary==1&js==1
label define group 1 "non-boundary area" 2 "JAPCP-covered boundary" 3 "JAPCP-uncovered boundary"
label values group group

bysort group season: egen avg_lnAQI = mean(lnAQI)
twoway (connect avg_lnAQI season2 if group==2&year<2020, msymbol(i) lp(solid))  ///
	   (connect avg_lnAQI season2 if group==3&year<2020, msymbol(i) lp(shortdash)) ///
	   (connect avg_lnAQI season2 if group==1&year<2020, msymbol(i) lp(dash)) ///
	   (pcarrowi 5.4 9.5 5.3 9.1 (2) "The first stage of the JAPCP: the JAPCP starting", color(black)) ///
	   (pcarrowi 5.2 11.5 5.1 11.1 (2) "The second stage of the JAPCP: entering the", color(black)) ///
	   (pcarrowi 5.13 11.5 5.03 11.1 (2) "autumn and winter prevention and control", color(white)),  ///
	   legend(order(1 "JPACP-covered boundary" 2 "JPACP-uncovered boundary" 3 "non-boundary area") row(2) ///
	   size(medsmall)) xtitle("") ytitle(logarithm of AQI, size(medlarge)) xlabel(1 "2015Q1" 5 "2016Q1" 9 "2017Q1" ///
	   11 "2017Q3" 13 "2018Q1" 17 "2019Q1" 20 " ") xline(9, lp(dash)) xline(11, lp(dash))
graph export "Rep_folder\output_figures\Fig7.pdf", replace
	   
log close