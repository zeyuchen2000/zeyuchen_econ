
log using "Rep_folder\output_logs\TableA9.log", replace

global cov lngdp lnp max_temp min_temp windpow

use "Rep_folder\data\Shandong_sample.dta", clear

reghdfe lnAQI lnC26 $cov if boundary==1, absorb(ym monitor_id winddir) cluster(monitor_id)
est store AQI_C26
reghdfe lnAQI lnC28 $cov if boundary==1, absorb(ym monitor_id winddir) cluster(monitor_id)
est store AQI_C28
reghdfe lnAQI lnC29 $cov if boundary==1, absorb(ym monitor_id winddir) cluster(monitor_id)
est store AQI_C29
reghdfe lnAQI lnC32 $cov if boundary==1, absorb(ym monitor_id winddir) cluster(monitor_id)
est store AQI_C32
reghdfe lnAQI lnC25 $cov if boundary==1, absorb(ym monitor_id winddir) cluster(monitor_id)
est store AQI_C25
reghdfe lnAQI lnC30 $cov if boundary==1, absorb(ym monitor_id winddir) cluster(monitor_id)
est store AQI_C30
reghdfe lnAQI lnC31 $cov if boundary==1, absorb(ym monitor_id winddir) cluster(monitor_id)
est store AQI_C31

esttab AQI_C*, mtitle b(%6.3f) ar2 star(* 0.1 ** 0.05 *** 0.01) se(%6.3f) keep(lnC*)

log close