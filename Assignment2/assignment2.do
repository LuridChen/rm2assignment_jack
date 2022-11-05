*change directory*
cd "/Users/cc4878/Library/CloudStorage/OneDrive-Personal/文档/Fall 2022 Course Files/Research Methods/assignment/Assignment2"

*read in files*
clear

import delimited "/Users/cc4878/Library/CloudStorage/OneDrive-Personal/文档/Fall 2022 Course Files/Research Methods/assignment/Assignment2/vaping-ban-panel.csv"


**pre-coding
gen treatment = 0
replace treatment = 1 if stateid <24

gen control = 0
replace control = 1 if stateid >= 24

gen treatment_lung = treatment*lunghospitalizations
gen control_lung = control*lunghospitalizations

bysort year: egen avg_lung_treatment = mean(treatment_lung) if treatment == 1
bysort year: egen avg_lung_control = mean(control_lung) if control == 1

gen avg_lung = 0
replace avg_lung = avg_lung_treatment if treatment == 1
replace avg_lung = avg_lung_control if control == 1

**test for par trend
line avg_lung_treatment avg_lung_control year if year < 2021, title("Lung Cancers Incidents") subtitle("Treatment vs Control States") scheme(s1mono)
graph export "dnd_graph_pre.jpg", replace

gen treatment_year = year*treatment
reg lunghospitalizations year treatment treatment_year if year < 2021

**generate dnd graph
line avg_lung_treatment avg_lung_control year, xline(2021, lpattern(dash)) title("Lung Cancers Incidents") subtitle("Treatment vs Control States") scheme(s1mono)
graph export "dnd_graph.jpg", replace

**estimate dnd
gen post_ = 0
replace post_ = 1 if year >= 2021
gen post_treatment = post_ * treatment

reg lunghospitalizations post_ treatment post_treatment i.(stateid)

*** fixed effect test
testparm i.(stateid)
**create tables

est clear
eststo: reg lunghospitalizations year treatment treatment_year if year < 2021
eststo: reg lunghospitalizations post_ treatment post_treatment i.(stateid)
esttab using regression_table.rtf, label nonumber title("Regression of Lung Cancers Incidents on Vaping Ban") mtitle("Model 1" "Model 2") coeflabel(post_ "Post Period" treatment "Vaping Ban" treatment_year "Post X Vaping Ban" _cons "Constant") note(Model 1 tests the parallel trend assumption by regressing the number of lung cancer incidents on the treatment condition, year, and their interaction. States with and without vaping band does not differ significant in the occurrence of lung cancer; trend in change of occurrence over year is parallel between the two kinds of states. Model 2 regress lung cancer occurrence over vaping ban treatment, a period fixed effect(1 if after 2021) and its interaction with treatment, as well as state fixed effects. States without vaping ban see a significant increases in cancer occurrence of 521.5 incidents after the ban; states with vaping ban has -4917.5 less occurrence, on average; and the difference in difference of change in cancer occurrence between the treatment and control states (estimated causal effect) is a significant -4030.5 incidents decrease in cancer occurrence.) replace
