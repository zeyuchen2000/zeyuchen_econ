
log using "Rep_folder\output_logs\Fig8.log", replace

global cov lngdp lnp max_temp min_temp windpow

** JAPCP-covered boundary
use "Rep_folder\data\Shandong_sample.dta", clear
drop dudt
keep if (hnhb==1)|(boundary==0)
gen before = (ym<201606)&(boundary==1)
gen dudt_9 = (ym==201606)&(boundary==1)
gen dudt_8 = (ym==201607)&(boundary==1)
gen dudt_7 = (ym==201608)&(boundary==1)
gen dudt_6 = (ym==201609)&(boundary==1)
gen dudt_5 = (ym==201610)&(boundary==1)
gen dudt_4 = (ym==201611)&(boundary==1)
gen dudt_3 = (ym==201612)&(boundary==1)
gen dudt_2 = (ym==201701)&(boundary==1)
gen dudt_1 = (ym==201702)&(boundary==1)
gen dudt0 = (ym==201703)&(boundary==1)
gen dudt1 = (ym==201704)&(boundary==1)
gen dudt2 = (ym==201705)&(boundary==1)
gen dudt3 = (ym==201706)&(boundary==1)
gen dudt4 = (ym==201707)&(boundary==1)
gen dudt5 = (ym==201708)&(boundary==1)
gen dudt6 = (ym==201709)&(boundary==1)
gen dudt7 = (ym==201710)&(boundary==1)
gen dudt8 = (ym==201711)&(boundary==1)
gen dudt9 = (ym==201712)&(boundary==1)
gen dudt10 = (ym==201801)&(boundary==1)
gen dudt11 = (ym==201802)&(boundary==1)
gen after = (ym>201802)&(boundary==1)
replace dudt_7 = 0
		 
jackknife: reghdfe lnAQI before* dudt* after $cov , absorb(monitor_id ym winddir) cluster(monitor_id)
est store hnhb_dynamic_effect

** JAPCP-uncovered boundary
use "Rep_folder\data\Shandong_sample.dta", clear
drop dudt
keep if (js==1)|(boundary==0)
gen before = (ym<201606)&(boundary==1)
gen dudt_9 = (ym==201606)&(boundary==1)
gen dudt_8 = (ym==201607)&(boundary==1)
gen dudt_7 = (ym==201608)&(boundary==1)
gen dudt_6 = (ym==201609)&(boundary==1)
gen dudt_5 = (ym==201610)&(boundary==1)
gen dudt_4 = (ym==201611)&(boundary==1)
gen dudt_3 = (ym==201612)&(boundary==1)
gen dudt_2 = (ym==201701)&(boundary==1)
gen dudt_1 = (ym==201702)&(boundary==1)
gen dudt0 = (ym==201703)&(boundary==1)
gen dudt1 = (ym==201704)&(boundary==1)
gen dudt2 = (ym==201705)&(boundary==1)
gen dudt3 = (ym==201706)&(boundary==1)
gen dudt4 = (ym==201707)&(boundary==1)
gen dudt5 = (ym==201708)&(boundary==1)
gen dudt6 = (ym==201709)&(boundary==1)
gen dudt7 = (ym==201710)&(boundary==1)
gen dudt8 = (ym==201711)&(boundary==1)
gen dudt9 = (ym==201712)&(boundary==1)
gen dudt10 = (ym==201801)&(boundary==1)
gen dudt11 = (ym==201802)&(boundary==1)
gen after = (ym>201802)&(boundary==1)
replace dudt_7 = 0
		 
jackknife: reghdfe lnAQI before* dudt* after $cov , absorb(monitor_id ym winddir) cluster(monitor_id)
est store js_dynamic_effect

coefplot (hnhb_dynamic_effect, keep(dudt*) drop(dudt_9 dudt_8) omit) ///
		 (js_dynamic_effect, keep(dudt*) drop(dudt_9 dudt_8) omit), ///
		 yline(0) xline(7.5, lpattern(dash)) xline(14.5, lpattern(dash)) vertical ciopts(recast(rcap)) ///
		 xtitle("Months") ytitle("Coefficient") ci(95) ///
		 coeflabels(dudt_7=`""Aug" "2016""' dudt_6=`""Sep" """' dudt_5=`""Oct" """' dudt_4=`""Nov" """' ///
					dudt_3=`""Dec" """' dudt_2=`""Jan" "2017""' dudt_1=`""Feb" """' dudt0=`""Mar" """' ///
					dudt1=`""Apr" """' dudt2=`""May" """' dudt3=`""Jun" """' dudt4=`""Jul" """' ///
					dudt5=`""Aug" """' dudt6=`""Sep" """' dudt7=`""Oct" """' dudt8=`""Nov" """' ///
					dudt9=`""Dec" """' dudt10=`""Jan" "2018""' dudt11=`""Feb" """') ///
		 legend(row(1) label(2 "JAPCP-covered provincial boundary") label(4 "JAPCP-uncovered provincial boundary") ///
				size(medsmall)) ///
		 text(0.43 9.3 "First stage of JAPCP", size(small)) text(0.43 16.5 "Second stage of JAPCP", size(small))

graph export "Rep_folder\output_figures\Fig8.pdf", replace

log close

