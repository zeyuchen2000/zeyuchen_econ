

log using "Rep_folder\output_logs\Table5.log", replace

global cov lngdp lnp max_temp min_temp windpow

use "Rep_folder\data\Shandong_sample.dta", clear
cap drop post dudt
gen post = (ym>=201703)
gen dudt = post * boundary
est drop _all

** JAPCP-covered boundary
reghdfe ln_ind_num dudt $cov if hnhb==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_ind
reghdfe lnheavy dudt $cov if hnhb==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_heavy
reghdfe lnlight dudt $cov if hnhb==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_light
reghdfe lnlarge dudt $cov if hnhb==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_large
reghdfe lnmiddle dudt $cov if hnhb==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_middle
reghdfe lnsmall dudt $cov if hnhb==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_small

** JAPCP-uncovered boundary
reghdfe ln_ind_num dudt $cov if js==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_ind
reghdfe lnheavy dudt $cov if js==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_heavy
reghdfe lnlight dudt $cov if js==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_light
reghdfe lnlarge dudt $cov if js==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_large
reghdfe lnmiddle dudt $cov if js==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_middle
reghdfe lnsmall dudt $cov if js==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_small

** Panel A
esttab hnhb_*, mtitle se(%6.3f) b(%6.3f) ar2 star(* 0.1 ** 0.05 *** 0.01) keep(dudt)

** Panel B
esttab js_*, mtitle se(%6.3f) b(%6.3f) ar2 star(* 0.1 ** 0.05 *** 0.01) keep(dudt)

log close

