

log using "Rep_folder\output_logs\TableA1.log", replace

use "Rep_folder\data\Full_sample.dta", clear
drop if year==2014|year==2020
keep if ym<=201702

gen lndist = ln(dist)
reghdfe lnAQI lndist if prov=="山东", absorb(ym) cluster(monitor_id)
est store shandong
reghdfe lnAQI lndist if prov=="山西", absorb(ym) cluster(monitor_id)
est store shanxi
reghdfe lnAQI lndist if prov=="河南", absorb(ym) cluster(monitor_id)
est store henan
reghdfe lnAQI lndist if prov=="河北", absorb(ym) cluster(monitor_id)
est store hebei

esttab shandong shanxi henan hebei, mtitle keep(lndist) star(* 0.1 ** 0.05 *** 0.01) ar2 se(%6.3f) b(%6.3f)

log close