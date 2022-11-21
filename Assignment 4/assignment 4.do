**change directory
cd "/Users/cc4878/Library/CloudStorage/OneDrive-Personal/文档/Fall 2022 Course Files/Research Methods/assignment/Assignment 4"

**load data
clear

import delimited "/Users/cc4878/Library/CloudStorage/OneDrive-Personal/文档/Fall 2022 Course Files/Research Methods/assignment/Assignment 4/crime-iv.csv"

**create balance table
global balanceopts "prehead(\begin{tabular}{l*{6}{c}}) postfoot(\end{tabular}) noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01)"

estpost ttest severityofcrime, by(republicanjudge) unequal welch

esttab using test.tex, cell("mu_1(f(3)) mu_2(f(3)) b(f(3) star) p(f(3))") wide label collabels("Control" "Treatment" "Difference" "P value") noobs $balanceopts mlabels(none) eqlabels(none) replace mgroups(none)

***estimate first stage regression
est clear
eststo: reg monthsinjail republicanjudge severityofcrime
esttab using first_stage.rtf, label nonumber title("Table 2: First stage regression on jail length") mtitle("Jail Length") coeflabel(republicanjudge "Republican" severityofcrime "crime severity") note(Table 2 presents first stage regression tetsting the relevance assumption using main explanatory variable, length of jail time, as the DV and the instrument, whether the judge is a republican, as IV.) replace

***estimate reduced form regression
est clear
eststo: reg recidivates republicanjudge severityofcrime
esttab using reduced_form.rtf, label nonumber title("Table 3: Reduced form regression on revidivism") mtitle("Recidivism") coeflabel(republicanjudge "Republican" severityofcrime "crime severity") note(Table 3 presents reduced formed regressionn on recidivism using partisanship of the judges as explanatory variable.) replace


***estimate instrumental regression
est clear
eststo: ivreg2 recidivates (monthsinjail = republicanjudge) severityofcrime
esttab using instrument.rtf, label nonumber title("Table 4: IV regression on recidivism") mtitle("Recidivism")  coeflabel(monthsinjail "Jail Length" severityofcrime "Crime Severity") note(Table 4 presents the IV regression on recidivism using republican partisanship of judges as instrument for explanatory variable length of jail time.) replace


