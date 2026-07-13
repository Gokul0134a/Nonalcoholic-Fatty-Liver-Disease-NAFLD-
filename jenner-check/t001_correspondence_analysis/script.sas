/* Adapted from Correspondance_Analysis.sas (Gokul0134a/Project---NAFLD).
   Original read a SAS Studio uploaded file via
   FILENAME REFFILE '/home/u63985153/Train/nafld.csv' and called the
   SAS Studio helper macros %web_drop_table / %web_open_table, which only
   exist inside that hosted IDE session. Those two lines and the PROC
   IMPORT are replaced below with an inline sample of the repo's own
   NAFLD_imputed.csv (BMI, Fibrosis columns, 25 patient rows). Everything
   from the BMI_Group derivation onward -- the correspondence analysis
   logic itself -- is unchanged from the original script (the final
   PROC PRINT is retargeted from the original's nonexistent "coords" to
   the "Coord" dataset actually produced by PROC CORRESP above it).
*/

data nafld;
    input BMI Fibrosis;
    datalines;
35.56 1
30.78 0
34.95 3
31.02 1
25.91 0
30.06 0
24.65 1
34.38 2
26.09 1
35.49 0
36.65 0
34.09 0
24.02 0
34.48 0
24.99 3
35.4 0
27.4 0
37.3 2
36.65 3
27.4 0
37.18 0
27.92 3
31.12 2
31.64 0
33.91 2
;
run;

proc contents data=nafld; run;

data nafld;
    set nafld;
    if BMI < 25 then BMI_Group = "Normal";
    else if BMI < 30 then BMI_Group = "Overweight";
    else BMI_Group = "Obese";
run;

proc freq data=nafld noprint;
    tables BMI_Group*Fibrosis / out=FreqTable;
run;

proc corresp data=FreqTable all dimens=2 outc=Coord short;
    tables BMI_Group, Fibrosis;
    weight count;
run;

proc sgplot data=Coord;
    scatter x=Dim1 y=Dim2 / datalabel=_NAME_;
    xaxis label="Dimension 1";
    yaxis label="Dimension 2";
    title "Correspondence Analysis Biplot";
run;

proc print data=Coord;
run;
