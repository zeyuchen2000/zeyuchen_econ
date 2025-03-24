

log using "Rep_folder\output_logs\FigA1.log", replace

use "Rep_folder\data\Full_sample.dta", clear
keep if ym<=201702
keep if prov=="山东"|prov=="山西"|prov=="河南"|prov=="河北"
sort prov dist
by prov dist: egen average_lnAQI = mean(lnAQI) if ym<=201702
duplicates drop prov dist, force

twoway (scatter average_lnAQI dist if prov=="河南"&(city!="三门峡"&city!="洛阳")) ///
	   (scatter average_lnAQI dist if prov=="河南"&(city=="三门峡"|city=="洛阳"), mc(gs12)) ///
	   , nodraw title(Henan, size(medlarge)) legend(lab(1 other cities) lab(2 high-altitude cities) ///
	   row(1) size(medlarge)) xtitle(Distance to the boundary, size(medlarge)) ///
	   ytitle(Logarithm of AQI, size(medlarge)) graphregion(color(white))
graph save "Rep_folder\output_figures\hn_high.gph", replace

twoway (scatter average_lnAQI dist if prov=="河北"&(city!="张家口"&city!="承德")) ///
	   (scatter average_lnAQI dist if prov=="河北"&(city=="张家口"|city=="承德"), mc(gs12)) ///
	   , nodraw title(Hebei, size(medlarge)) legend(lab(1 other cities) lab(2 high-altitude cities) ///
	   row(1) size(medlarge)) xtitle(Distance to the boundary, size(medlarge)) ///
	   ytitle(Logarithm of AQI, size(medlarge)) graphregion(color(white))
graph save "Rep_folder\output_figures\hb_high.gph", replace

						
graph combine "Rep_folder\output_figures\hn_high.gph" "Rep_folder\output_figures\hb_high.gph" ///
			  "Rep_folder\output_figures\hn_high.gph" "Rep_folder\output_figures\hb_high.gph"
graph export "Rep_folder\output_figures\FigA1.pdf", replace

erase "Rep_folder\output_figures\hn_high.gph"
erase "Rep_folder\output_figures\hb_high.gph"

log close