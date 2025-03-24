
log using "Rep_folder\output_logs\Fig5.log", replace

use "Rep_folder\data\Full_sample.dta", clear
keep if ym<=201702
sort prov dist
by prov dist: egen average_lnAQI = mean(lnAQI)
duplicates drop prov dist, force

** Shandong Province
twoway (scatter average_lnAQI dist if prov=="山东"&ym<=201702), nodraw title(Shandong, size(medlarge)) legend(off) ///
	    xtitle(Distance to the boundary, size(medlarge)) ytitle(Logarithm of AQI, size(medlarge))
graph save "Rep_folder\output_figures\sd_all.gph", replace

** Shanxi Province
twoway (scatter average_lnAQI dist if prov=="山西"&ym<=201702), nodraw title(Shanxi, size(medlarge)) legend(off) ///
	    xtitle(Distance to the boundary, size(medlarge)) ytitle(Logarithm of AQI, size(medlarge))
graph save "Rep_folder\output_figures\sx_all.gph", replace

** Henan Province
twoway (scatter average_lnAQI dist if prov=="河南"&ym<=201702), nodraw title(Henan, size(medlarge)) legend(off) ///
	    xtitle(Distance to the boundary, size(medlarge)) ytitle(Logarithm of AQI, size(medlarge))
graph save "Rep_folder\output_figures\hn_all.gph", replace

** Hebei Province
twoway (scatter average_lnAQI dist if prov=="河北"&ym<=201702), nodraw title(Hebei, size(medlarge)) legend(off) ///
	    xtitle(Distance to the boundary, size(medlarge)) ytitle(Logarithm of AQI, size(medlarge))
graph save "Rep_folder\output_figures\hb_all.gph", replace				

** Fig. 5
graph combine "Rep_folder\output_figures\sd_all.gph" "Rep_folder\output_figures\sx_all.gph" ///
			  "Rep_folder\output_figures\hn_all.gph" "Rep_folder\output_figures\hb_all.gph"
graph export "Rep_folder\output_figures\Fig5.pdf", replace

erase "Rep_folder\output_figures\sd_all.gph"
erase "Rep_folder\output_figures\sx_all.gph"
erase "Rep_folder\output_figures\hn_all.gph"
erase "Rep_folder\output_figures\hb_all.gph"


log close

