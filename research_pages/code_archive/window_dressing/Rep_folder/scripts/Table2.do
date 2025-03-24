
log using "Rep_folder\output_logs\Table2.log", replace

use "Rep_folder\data\Shandong_sample.dta", clear

global list_industry manu_num supply_num key_num C26 C28 C29 C32 C25 C30 C31 
gen key_num = C26 + C28 + C29 + C32

foreach i in $list_industry{
quietly sum `i' if boundary==0&year<2017
scalar non_boundary0 = r(mean)
quietly sum `i' if boundary==0&year>=2017
scalar non_boundary1 = r(mean)
dis "`i'" " (non_boundary): " (non_boundary1 - non_boundary0) / non_boundary0

quietly sum `i' if hnhb==1&boundary==1&year<2017
scalar hnhb0 = r(mean)
quietly sum `i' if hnhb==1&boundary==1&year>=2017
scalar hnhb1 = r(mean)
dis "`i'" " (JAPCP-covered boundary): " (hnhb1 - hnhb0) / hnhb0

quietly sum `i' if js==1&boundary==1&year<2017
scalar js0 = r(mean)
quietly sum `i' if js==1&boundary==1&year>=2017
scalar js1 = r(mean)
dis "`i'" " (JAPCP-uncovered boundary): " (js1 - js0) / js0
}

log close