
log using "Rep_folder\output_logs\TableA12.log", replace

global cov lngdp lnp max_temp min_temp windpow

use "Rep_folder\data\Shandong_sample.dta", clear
replace city = city1
merge m:1 city year using "Rep_folder\data\Government_work_report.dta", keepusing(text len huanjing huanbao wuran) nogen

cap drop post dudt
gen post = (ym>=201703)
gen dudt = post * boundary
gen total_words = huanjing + huanbao + wuran
gen total_r = (huanjing + huanbao + wuran) / len * 10000
gen huanjing_r = huanjing / len * 10000
gen huanbao_r = huanbao / len * 10000
gen wuran_r = wuran / len * 10000
est drop _all

reghdfe huanjing dudt $cov if (hnhb==1|boundary==0)&(policy_city==1), absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_adj_huanjing 
reghdfe huanbao dudt $cov if (hnhb==1|boundary==0)&(policy_city==1), absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_adj_huanbao
reghdfe wuran dudt $cov if (hnhb==1|boundary==0)&(policy_city==1), absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_adj_wuran
reghdfe huanjing_r dudt $cov if (hnhb==1|boundary==0)&(policy_city==1), absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_adj_huanjing_r 
reghdfe huanbao_r dudt $cov if (hnhb==1|boundary==0)&(policy_city==1), absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_adj_huanbao_r
reghdfe wuran_r dudt $cov if (hnhb==1|boundary==0)&(policy_city==1), absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_adj_wuran_r

reghdfe huanjing dudt $cov if (js==1|boundary==0)&(policy_city==0), absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_adj_huanjing 
reghdfe huanbao dudt $cov if (js==1|boundary==0)&(policy_city==0), absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_adj_huanbao
reghdfe wuran dudt $cov if (js==1|boundary==0)&(policy_city==0), absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_adj_wuran
reghdfe huanjing_r dudt $cov if (js==1|boundary==0)&(policy_city==0), absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_adj_huanjing_r 
reghdfe huanbao_r dudt $cov if (js==1|boundary==0)&(policy_city==0), absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_adj_huanbao_r
reghdfe wuran_r dudt $cov if (js==1|boundary==0)&(policy_city==0), absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_adj_wuran_r

** Panel A
esttab hnhb_adj_*, mtitle se(%6.3f) b(%6.3f) ar2 star(* 0.1 ** 0.05 *** 0.01) keep(dudt)
** Panel B
esttab js_adj_*, mtitle se(%6.3f) b(%6.3f) ar2 star(* 0.1 ** 0.05 *** 0.01) keep(dudt)


log close

