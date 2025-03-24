

log using "Rep_folder\output_logs\Fig9.log", replace

global cov lngdp lnp max_temp min_temp windpow
global ind_C_key C26 C28 C29 C32
global ind_C_other_heavy C25 C30 C31
global ind_C_other_nonheavy C27 C33 C34 C35 C36 C37 C38 C39 C40 C41
global ind C26 C28 C29 C32 C25 C30 C31 C27 C33 C34 C35 C36 C37 C38 C39 C40 C41

use "Rep_folder\data\Shandong_sample.dta", clear
cap drop post dudt
gen post = (ym>=201703)
gen dudt = post * boundary
replace city = city1
merge m:1 city year using "Rep_folder\data\Shandong_enterprises.dta"
drop _merge
foreach i in $ind{
	cap drop ln`i'
	quietly gen ln`i' = ln(`i')
}


est drop _all
cap mat drop results
foreach i in _supply_num _manu_num $ind_C_key $ind_C_other_heavy $ind_C_other_nonheavy{
	local y = `y' - 2
	// JAPCP-covered boundary
	quietly reghdfe ln`i' dudt $cov if (hnhb==1|boundary==0), absorb(monitor_id ym winddir) cluster(monitor_id) level(90)
	est store hnhb_`i'
	mat a = r(table)
	local b = a[1,1]
	local ll = a[5,1]
	local ul = a[6,1]
	mat a = [`b', `ll', `ul', 1]
	mat rowname a = "`i'"
	// JAPCP-uncovered boundary
	quietly reghdfe ln`i' dudt $cov if (js==1|boundary==0), absorb(monitor_id ym winddir) cluster(monitor_id) level(90)
	est store js_`i'
	mat b = r(table)
	local b = b[1,1]
	local ll = b[5,1]
	local ul = b[6,1]
	mat b = [`b', `ll', `ul', 2]
	mat rowname b = "`i'"
	
	mat results = nullmat(results) \ a \ b
}
mat colnames results = "b" "ll" "ul" "type"
mat list results

clear
svmat results, names(col) 
gen n = _n
replace n = 31-n

twoway (rcap ll ul n if type == 1 , hor lp(solid) lc(gs6)) (scatter n b if type == 1 , mc(gs6) m(oh)) ///
       (rcap ll ul n if type == 2 , hor lp(solid) lc(gs10)) (scatter n b if type == 2 , mc(gs10) m(oh)), ///
       xtit("Coefficient") ytit(" ") xsize(3) ysize(2.5) xline(0 , lc(gs12) lp(dash)) ///
       legend(order(2 "JAPCP-convered provincial boundary" 4 "JAPCP-uncovered provincial boundary") r(2)) ///
	   yline(26.5) yline(18.5) yline(12.5) ylabel(29.5 "Supplying" 27.5 "Manufacturing" 25.5 "C26" 23.5 "C28" 21.5 "C29" ///
	   19.5 "C32" 17.5 "C25" 15.5 "C30" 13.5 "C31" 11.5 "C27" 9.5 "C33" 7.5 "C34" 5.5 "C35" 3.5 "C36" 1.5 "C37" -0.5 ///
	   "C38" -2.5 "C39" -4.5 "C40" -6.5 "C41", nogrid) text(25 0.25 "A. Key regulated industries", size(small) place(right)) ///
	   text(17 0.25 "B. Other polluting industries", size(small) place(right)) ///
	   text(11 0.25 "C. Low-polluting industries", size(small) place(right))

graph export "Rep_folder\output_figures\Fig9.pdf", replace

log close