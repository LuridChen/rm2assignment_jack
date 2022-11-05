*change directory*
cd "/Users/cc4878/Library/CloudStorage/OneDrive-Personal/文档/Fall 2022 Course Files/Research Methods/assignment"

*read in files*
clear

import delimited "/Users/cc4878/Library/CloudStorage/OneDrive-Personal/文档/Fall 2022 Course Files/Research Methods/assignment/assignment1-research-methods.csv"

est clear

reg calledback eliteschoolcandidate male candidate

eststo regression_one

global tableoptions "bf(%15.2gc) sfmt(%15.2gc) se label noisily noeqlines nonumbers varlabels(_cons Constant, end("" ) nolast)  starlevels(* 0.1 ** 0.05 *** 0.01) replace r2"

esttab regression_one using regression-one-Table.rtf, $tableoptions keep(eliteschoolcandidate malecandidate) 
