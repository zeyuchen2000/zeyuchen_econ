
log using "Rep_folder\output_logs\TableA2.log", replace

use "Rep_folder\data\Shandong_sample.dta", clear
replace dist = dist / 10000
gen dist2 = dist ^ 2
gen lndist = ln(dist)
gen lnpergdp = ln(gdp / population)
gen pol_num = C26 + C28 + C29 + C32 + C25 + C30 + C31
gen ln_pol_num = ln(C26 + C28 + C29 + C32 + C25 + C30 + C31)

reghdfe lngdp dist c.dist#post, absorb(ym winddir) cluster(monitor_id)
est store lngdp1
reghdfe lngdp dist dist2 c.dist#post c.dist2#post, absorb(ym winddir) cluster(monitor_id)
est store lngdp2

reghdfe lnp dist c.dist#post, absorb(ym winddir) cluster(monitor_id)
est store lnp
reghdfe windpow dist c.dist#post, absorb(ym winddir) cluster(monitor_id)
est store windpow

* Whether more heavily polluting enterprises agglomerated at boundaries before JAPCP
reghdfe industry_num dist lngdp lnp windpow if year<2017, absorb(ym winddir) cluster(monitor_id)
est store ind
reghdfe pol_num dist lngdp lnp windpow if year<2017, absorb(ym winddir) cluster(monitor_id)
est store pol

esttab lngdp* lnp windpow ind pol, mtitle se(%6.3f) b(%6.3f) ar2 star(* 0.1 ** 0.05 *** 0.01)

log close