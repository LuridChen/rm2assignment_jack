**change directory
cd "/Users/cc4878/Library/CloudStorage/OneDrive-Personal/文档/Fall 2022 Course Files/Research Methods/assignment/Assignment3"

**load data
clear

import delimited "/Users/cc4878/Library/CloudStorage/OneDrive-Personal/文档/Fall 2022 Course Files/Research Methods/assignment/Assignment3/sports-and-education.csv"

**create balance table
global balanceopts "prehead(\begin{tabular}{l*{6}{c}}) postfoot(\end{tabular}) noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01)"

estpost ttest academicquality athleticquality nearbigmarket, by(ranked2017) unequal welch

esttab using test.tex, cell("mu_1(f(3)) mu_2(f(3)) b(f(3) star)") wide label collabels("Control" "Treatment" "Difference") noobs $balanceopts mlabels(none) eqlabels(none) replace mgroups(none)


**build a simple model of treatment
est clear
eststo: reg ranked2017 academicquality athleticquality nearbigmarket
esttab using "treatment_linear.csv", replace

**predict propensity score
drop propensity_score
logit ranked2017 athleticquality nearbigmarket
predict propensity_score, pr
** variable academic quality is dropped for it does not significantly predict treatment

**creating stacked histograms
twoway (histogram propensity_score if ranked2017==1, start(0) width(0.05) color(red%70)) (histogram propensity_score if ranked2017==0, start(0) width(0.05) fcolor(none) lcolor(black)), legend(order(1 "Treatment" 2 "Control" )) scheme(s1mono)
graph export "propensity.png", replace

**dropping observations
drop if propensity_score < 0.25 | propensity_score > 0.8

**blocking using propensity score
sort propensity_score
gen block = floor(_n/4)

** estimate regressions with fixed effect 
est clear
eststo: reg alumnidonations2018 ranked2017 academicquality athleticquality nearbigmarket i.(block)
eststo: reg alumnidonations2018 ranked2017 academicquality athleticquality nearbigmarket
esttab using regression_table.rtf, label nonumber title("Linear & Propensity-matched Regressions of Alumni Donations") mtitle("Linear" "Propensity-matched") coeflabel(ranked2017 "Ranked" academicquality "Academic Qual" athleticquality "Athletic Qual" nearbigmarket "Big Market" _cons "Constant") note(Table 3: presents linear regression and propensity-mactched regressions of alumni donations a school receive on whether it being ranked, controlling for academic quality, athletic quality, and its closeness to big markets. All predictors in both models are significant at 0.1% level and the magnitudes are similar between the two models. Blocking fixed effect based on propensity scores are dropped. Being ranked on "Top Basketball Programs" significant increases alumni donations by $500k for a university.) $tableoptions keep(ranked2017 academicquality athleticquality nearbigmarket)

