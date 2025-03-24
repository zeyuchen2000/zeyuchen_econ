
log using "Rep_folder\output_logs\TableA6.log", replace

global cov lngdp lnp max_temp min_temp windpow

* JAPCP-covered boundary
use "Rep_folder\data\Shandong_sample.dta", clear
keep if hnhb==1|boundary==0
cap drop post dudt
gen post = (ym>=201703)
gen dudt = post * boundary

reghdfe lnPM10 dudt $cov , absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_dv_lnPM10
reghdfe lnPM25 dudt $cov , absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_dv_lnPM25
reghdfe lnCO dudt $cov , absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_dv_lnCO
reghdfe lnNO2 dudt $cov , absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_dv_lnNO2
						   
* JAPCP-uncovered boundary
use "Rep_folder\data\Shandong_sample.dta", clear
keep if js==1|boundary==0
cap drop post dudt
gen post = (ym>=201710)
gen dudt = post * boundary

reghdfe lnPM10 dudt $cov , absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_dv_lnPM10
reghdfe lnPM25 dudt $cov , absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_dv_lnPM25
reghdfe lnCO dudt $cov , absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_dv_lnCO
reghdfe lnNO2 dudt $cov , absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_dv_lnNO2
				
** Panel A
esttab hnhb_dv_*, mtitle se(%6.3f) b(%6.3f) ar2 keep(dudt) star(* 0.1 ** 0.05 *** 0.01)
** Panel B
esttab js_dv_*, mtitle se(%6.3f) b(%6.3f) ar2 keep(dudt) star(* 0.1 ** 0.05 *** 0.01)

log close