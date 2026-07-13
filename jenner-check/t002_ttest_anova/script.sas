/* Adapted from "t-test,Anova.sas" (Gokul0134a/Project---NAFLD).
   Original read a SAS Studio uploaded file via
   FILENAME REFFILE '/home/u63985153/Train/nafld.csv' and called the
   SAS Studio session helper %web_drop_table / %web_open_table, neither
   of which exist outside that hosted IDE. Replaced below with inline
   DATALINES sampling Age, Gender, BMI and Fibrosis for 30 patients from
   this repo's own NAFLD_imputed.csv. The two PROC ANOVA models (BMI and
   Age by Fibrosis stage, each with Tukey pairwise comparisons) and the
   PROC TTEST of BMI by Gender are exactly the original script's analysis.
*/

data work_import;
    input Age Gender BMI Fibrosis;
    datalines;
60 1 35.56 1
55 1 30.78 0
53 2 34.95 3
33 2 31.02 1
23 2 25.91 0
36 2 30.06 0
54 1 24.65 1
50 1 34.38 2
32 2 26.09 1
18 2 35.49 0
32 2 36.65 0
43 2 34.09 0
28 2 24.02 0
60 1 34.48 0
28 2 24.99 3
51 2 35.4 0
43 2 27.4 0
52 1 37.3 2
55 2 36.65 3
43 2 27.4 0
30 2 37.18 0
55 2 27.92 3
62 2 31.12 2
33 2 31.64 0
42 2 33.91 2
39 1 32.1 0
38 2 32 1
35 2 37.8 1
44 2 27.85 0
47 1 42.04 0
;
run;

proc contents data=work_import; run;

proc anova data=work_import;
   class Fibrosis;
   model BMI = Fibrosis;
   means Fibrosis / tukey cldiff;
run;

proc anova data=work_import;
   class Fibrosis;
   model Age = Fibrosis;
   means Fibrosis / tukey cldiff;
run;

proc ttest data=work_import;
   class Gender;
   var BMI;
run;
