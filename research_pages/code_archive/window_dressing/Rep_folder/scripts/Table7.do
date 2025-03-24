

log using "Rep_folder\output_logs\Table7.log", replace

global cov lngdp lnp max_temp min_temp windpow

use "Rep_folder\data\Shandong_sample.dta", clear
cap drop post dudt
gen post = (ym>=201703)
gen dudt = post * boundary
gen ln_key_regulated = ln(C26 + C28 + C29 + C32)
gen ln_others = ln(C25 + C30 + C31)
est drop _all

/* Regression */

** JAPCP-covered boundary
reghdfe ln_key_regulated dudt $cov if hnhb==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_key_regulated
reghdfe lnC26 dudt $cov if hnhb==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_C26
reghdfe lnC28 dudt $cov if hnhb==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_C28
reghdfe lnC29 dudt $cov if hnhb==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_C29
reghdfe lnC32 dudt $cov if hnhb==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_C32
reghdfe ln_others dudt $cov if hnhb==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_others
reghdfe lnC25 dudt $cov if hnhb==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_C25
reghdfe lnC30 dudt $cov if hnhb==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_C30
reghdfe lnC31 dudt $cov if hnhb==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_C31

** JAPCP-uncovered boundary
reghdfe ln_key_regulated dudt $cov if js==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_key_regulated
reghdfe lnC26 dudt $cov if js==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_C26
reghdfe lnC28 dudt $cov if js==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_C28
reghdfe lnC29 dudt $cov if js==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_C29
reghdfe lnC32 dudt $cov if js==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_C32
reghdfe ln_others dudt $cov if js==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_others
reghdfe lnC25 dudt $cov if js==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_C25
reghdfe lnC30 dudt $cov if js==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_C30
reghdfe lnC31 dudt $cov if js==1|boundary==0, absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_C31

* Panel A
esttab hnhb_key_regulated hnhb_C26 hnhb_C28 hnhb_C29 hnhb_C32 hnhb_others hnhb_C25 hnhb_C30 hnhb_C31, ///
	mtitle se(%6.3f) b(%6.3f) ar2 star(* 0.1 ** 0.05 *** 0.01) keep(dudt)
* Panel B
esttab js_key_regulated js_C26 js_C28 js_C29 js_C32 js_others js_C25 js_C30 js_C31, ///
	mtitle se(%6.3f) b(%6.3f) ar2 star(* 0.1 ** 0.05 *** 0.01) keep(dudt)   

	
/* Coefficient comparison */

reg ln_key_regulated dudt $cov i.ym i.winddir i.monitor_id if hnhb==1|boundary==0
est store hnhb_key_regulated_suest
reg ln_key_regulated dudt $cov i.ym i.winddir i.monitor_id if js==1|boundary==0
est store js_key_regulated_suest
suest hnhb_key_regulated_suest js_key_regulated_suest, vce(cluster monitor_id)
test [hnhb_key_regulated_suest_mean]dudt = [js_key_regulated_suest_mean]dudt

reg lnC26 dudt $cov i.ym i.winddir i.monitor_id if hnhb==1|boundary==0
est store hnhb_manu_chm_suest
reg lnC26 dudt $cov i.ym i.winddir i.monitor_id if js==1|boundary==0
est store js_manu_chm_suest
suest hnhb_manu_chm_suest js_manu_chm_suest, vce(cluster monitor_id)
test [hnhb_manu_chm_suest_mean]dudt = [js_manu_chm_suest_mean]dudt

reg lnC28 dudt $cov i.ym i.winddir i.monitor_id if hnhb==1|boundary==0
est store hnhb_manu_chmfibra_suest
reg lnC28 dudt $cov i.ym i.winddir i.monitor_id if js==1|boundary==0
est store js_manu_chmfibra_suest
suest hnhb_manu_chmfibra_suest js_manu_chmfibra_suest, vce(cluster monitor_id)
test [hnhb_manu_chmfibra_suest_mean]dudt = [js_manu_chmfibra_suest_mean]dudt

reg lnC29 dudt $cov i.ym i.winddir i.monitor_id if hnhb==1|boundary==0
est store hnhb_manu_rubber_suest
reg lnC29 dudt $cov i.ym i.winddir i.monitor_id if js==1|boundary==0
est store js_manu_rubber_suest
suest hnhb_manu_rubber_suest js_manu_rubber_suest, vce(cluster monitor_id)
test [hnhb_manu_rubber_suest_mean]dudt = [js_manu_rubber_suest_mean]dudt

reg lnC32 dudt $cov i.ym i.winddir i.monitor_id if hnhb==1|boundary==0
est store hnhb_manu_nonferrous_suest
reg lnC32 dudt $cov i.ym i.winddir i.monitor_id if js==1|boundary==0
est store js_manu_nonferrous_suest
suest hnhb_manu_nonferrous_suest js_manu_nonferrous_suest, vce(cluster monitor_id)
test [hnhb_manu_nonferrous_suest_mean]dudt = [js_manu_nonferrous_suest_mean]dudt

reg ln_others dudt $cov i.ym i.winddir i.monitor_id if hnhb==1|boundary==0
est store hnhb_others_suest
reg ln_others dudt $cov i.ym i.winddir i.monitor_id if js==1|boundary==0
est store js_others_suest
suest hnhb_others_suest js_others_suest, vce(cluster monitor_id)
test [hnhb_others_suest_mean]dudt = [js_others_suest_mean]dudt

reg lnC25 dudt $cov i.ym i.winddir i.monitor_id if hnhb==1|boundary==0
est store hnhb_manu_petrol_suest
reg lnC25 dudt $cov i.ym i.winddir i.monitor_id if js==1|boundary==0
est store js_manu_petrol_suest
suest hnhb_manu_petrol_suest js_manu_petrol_suest, vce(cluster monitor_id)
test [hnhb_manu_petrol_suest_mean]dudt = [js_manu_petrol_suest_mean]dudt

reg lnC30 dudt $cov i.ym i.winddir i.monitor_id if hnhb==1|boundary==0
est store hnhb_manu_nonmetal_suest
reg lnC30 dudt $cov i.ym i.winddir i.monitor_id if js==1|boundary==0
est store js_manu_nonmetal_suest
suest hnhb_manu_nonmetal_suest js_manu_nonmetal_suest, vce(cluster monitor_id)
test [hnhb_manu_nonmetal_suest_mean]dudt = [js_manu_nonmetal_suest_mean]dudt

reg lnC31 dudt $cov i.ym i.winddir i.monitor_id if hnhb==1|boundary==0
est store hnhb_manu_ferrous_suest
reg lnC31 dudt $cov i.ym i.winddir i.monitor_id if js==1|boundary==0
est store js_manu_ferrous_suest
suest hnhb_manu_ferrous_suest js_manu_ferrous_suest, vce(cluster monitor_id)
test [hnhb_manu_ferrous_suest_mean]dudt = [js_manu_ferrous_suest_mean]dudt


log close

