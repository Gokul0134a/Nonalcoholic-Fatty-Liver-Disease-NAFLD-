/* Adapted from "Normality checks.sas" (Gokul0134a/Project---NAFLD).
   Original read a SAS Studio uploaded file via
   FILENAME REFFILE '/home/u63985153/Train/NAFLD_imputed.csv' and called
   the SAS Studio session helpers %web_drop_table / %web_open_table,
   which only exist inside that hosted IDE. Replaced below with inline
   DATALINES sampling 6 of this repo's own numeric NAFLD_imputed.csv
   columns (Age, BMI, AST, ALT, Glucose, Fibrosis) across 25 patients.
   The %check_normality macro itself -- which discovers numeric columns
   via PROC CONTENTS + PROC SQL and runs PROC UNIVARIATE across them --
   is copied unchanged from the original script.
*/

data NAFLD;
    input Age BMI AST ALT Glucose Fibrosis;
    datalines;
60 35.56 27 49 119 1
55 30.78 17 18 102 0
53 34.95 51 74 93 3
33 31.02 31 72 90 1
23 25.91 32 51 89 0
36 30.06 38 96 96 0
54 24.65 29 47 95 1
50 34.38 37 55 97 2
32 26.09 23 31 119 1
18 35.49 88 206 80 0
32 36.65 66 66 87 0
43 34.09 25 39 96 0
28 24.02 51 121 84 0
60 34.48 47 59 100 0
28 24.99 64 96 87 3
51 35.4 41 63 105 0
43 27.4 24 26 106 0
52 37.3 58 56 97 2
55 36.65 37 67 102 3
43 27.4 24 26 106 0
30 37.18 45 89 93 0
55 27.92 20 19 141 3
62 31.12 50 84 92 2
33 31.64 25 43 83 0
42 33.91 39 84 89 2
;
run;

proc contents data=NAFLD; run;

%macro check_normality(data=);

    proc contents data=&data out=vars(keep=name type) noprint; run;

    proc sql noprint;
        select cats("'", strip(name), "'n")
        into :numvars separated by " "
        from vars
        where type=1;
    quit;

    ods output TestsForNormality=normality_results;
    proc univariate data=&data normal plot;
        var &numvars;
    run;
    ods output close;
%mend;

%check_normality(data=NAFLD);

proc print data=normality_results; run;
