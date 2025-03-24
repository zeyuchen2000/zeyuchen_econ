
log using "Rep_folder\output_logs\TableA11.log", replace

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
reghdfe lnC26 dudt $cov if (hnhb==1|boundary==0)&(policy_city==1), absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_C26
reghdfe lnC28 dudt $cov if (hnhb==1|boundary==0)&(policy_city==1), absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_C28
reghdfe lnC29 dudt $cov if (hnhb==1|boundary==0)&(policy_city==1), absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_C29
reghdfe lnC32 dudt $cov if (hnhb==1|boundary==0)&(policy_city==1), absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_C32
reghdfe lnC25 dudt $cov if (hnhb==1|boundary==0)&(policy_city==1), absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_C25
reghdfe lnC30 dudt $cov if (hnhb==1|boundary==0)&(policy_city==1), absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_C30
reghdfe lnC31 dudt $cov if (hnhb==1|boundary==0)&(policy_city==1), absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_C31

** JAPCP-uncovered boundary
reghdfe lnC26 dudt $cov if (js==1|boundary==0)&(policy_city==0), absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_C26
reghdfe lnC28 dudt $cov if (js==1|boundary==0)&(policy_city==0), absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_C28
reghdfe lnC29 dudt $cov if (js==1|boundary==0)&(policy_city==0), absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_C29
reghdfe lnC32 dudt $cov if (js==1|boundary==0)&(policy_city==0), absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_C32
reghdfe lnC25 dudt $cov if (js==1|boundary==0)&(policy_city==0), absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_C25
reghdfe lnC30 dudt $cov if (js==1|boundary==0)&(policy_city==0), absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_C30
reghdfe lnC31 dudt $cov if (js==1|boundary==0)&(policy_city==0), absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_C31

** Panel A
esttab hnhb_C*, mtitle se(%6.3f) b(%6.3f) ar2 star(* 0.1 ** 0.05 *** 0.01) keep(dudt)
** Panel B
esttab js_C*, mtitle se(%6.3f) b(%6.3f) ar2 star(* 0.1 ** 0.05 *** 0.01) keep(dudt)



/* Coefficient comparison */
global ind_list lnC26 lnC28 lnC29 lnC32 lnC25 lnC30 lnC31
foreach var in dudt $ind_list $cov{
	bysort monitor_id: center `var', prefix(c_) // Add monitoring station fixed effects through demeaning
}
global c_cov c_lngdp c_lnp c_max_temp c_min_temp c_windpow

reg c_lnC26 c_dudt $c_cov i.ym i.winddir if (hnhb==1|boundary==0)&(policy_city==1)
est store hnhb_C26
reg c_lnC26 c_dudt $c_cov i.ym i.winddir if (js==1|boundary==0)&(policy_city==0)
est store js_C26
suest hnhb_C26 js_C26, vce(cluster monitor_id)
test [hnhb_C26_mean]c_dudt = [js_C26_mean]c_dudt

reg c_lnC28 c_dudt $c_cov i.ym i.winddir if (hnhb==1|boundary==0)&(policy_city==1)
est store hnhb_C28
reg c_lnC28 c_dudt $c_cov i.ym i.winddir if (js==1|boundary==0)&(policy_city==0)
est store js_C28
suest hnhb_C28 js_C28, vce(cluster monitor_id)
test [hnhb_C28_mean]c_dudt = [js_C28_mean]c_dudt

reg c_lnC29 c_dudt $c_cov i.ym i.winddir if (hnhb==1|boundary==0)&(policy_city==1)
est store hnhb_C29
reg c_lnC29 c_dudt $c_cov i.ym i.winddir if (js==1|boundary==0)&(policy_city==0)
est store js_C29
suest hnhb_C29 js_C29, vce(cluster monitor_id)
test [hnhb_C29_mean]c_dudt = [js_C29_mean]c_dudt

reg c_lnC32 c_dudt $c_cov i.ym i.winddir if (hnhb==1|boundary==0)&(policy_city==1)
est store hnhb_C32
reg c_lnC32 c_dudt $c_cov i.ym i.winddir if (js==1|boundary==0)&(policy_city==0)
est store js_C32
suest hnhb_C32 js_C32, vce(cluster monitor_id)
test [hnhb_C32_mean]c_dudt = [js_C32_mean]c_dudt

reg c_lnC25 c_dudt $c_cov i.ym i.winddir if (hnhb==1|boundary==0)&(policy_city==1)
est store hnhb_C25
reg c_lnC25 c_dudt $c_cov i.ym i.winddir if (js==1|boundary==0)&(policy_city==0)
est store js_C25
suest hnhb_C25 js_C25, vce(cluster monitor_id)
test [hnhb_C25_mean]c_dudt = [js_C25_mean]c_dudt

reg c_lnC30 c_dudt $c_cov i.ym i.winddir if (hnhb==1|boundary==0)&(policy_city==1)
est store hnhb_C30
reg c_lnC30 c_dudt $c_cov i.ym i.winddir if (js==1|boundary==0)&(policy_city==0)
est store js_C30
suest hnhb_C30 js_C30, vce(cluster monitor_id)
test [hnhb_C30_mean]c_dudt = [js_C30_mean]c_dudt

reg c_lnC31 c_dudt $c_cov i.ym i.winddir if (hnhb==1|boundary==0)&(policy_city==1)
est store hnhb_C31
reg c_lnC31 c_dudt $c_cov i.ym i.winddir if (js==1|boundary==0)&(policy_city==0)
est store js_C31
suest hnhb_C31 js_C31, vce(cluster monitor_id)
test [hnhb_C31_mean]c_dudt = [js_C31_mean]c_dudt

log close

