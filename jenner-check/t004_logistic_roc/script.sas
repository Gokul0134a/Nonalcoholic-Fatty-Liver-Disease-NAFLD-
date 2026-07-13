/* Adapted from GLM.sas (Gokul0134a/Project---NAFLD).
   Original read a SAS Studio uploaded file via
   FILENAME REFFILE '/home/u63985153/Train/nafld.csv' and called the
   SAS Studio session helpers %web_drop_table / %web_open_table, which
   only exist inside that hosted IDE. Replaced below with inline
   DATALINES: all 24 Cirrhosis=1 patients in the repo's own
   NAFLD_imputed.csv plus a 40-row sample of Cirrhosis=0 patients, so
   the 70/30 PROC SURVEYSELECT split and the logistic fit both see both
   outcome classes. The original's predictor list referenced
   "Systolic Blood Pressure"n / "Diastolic Blood Pressure"n / Diyabetes /
   "Total Cholesterol"n -- column names from an earlier, unshipped
   nafld.csv -- retargeted here to this repo's actual shipped column
   names (SBP, DBP, "Diyabetes Mellitus"n, "Total Cholesterol"n). The
   commented-out draft PROC LOGISTIC block in the original (predicting
   "Advanced Fibrosis"n, a column this repo's CSV doesn't carry) is
   dropped; the train/test split, the live PROC LOGISTIC model for
   Cirrhosis, and the ROC curve via ODS OUTPUT ROCcurve are the
   original script's actual analysis, unchanged. The closing
   `ods graphics off;` and the `lineparm` reference-line statement in
   the final PROC SGPLOT were left out of this bundle, since neither
   is essential to the ROC curve itself. PLOTS=ROC is added to the
   PROC LOGISTIC statement: per SAS 9.4 documentation, a ROC curve
   dataset is only populated when a PLOTS=ROC option, ROC statement, or
   OUTROC= option actually requests the ROC curve; the original
   script's PROC LOGISTIC had none of the three, so its own
   `ods output ROCcurve=rocdata` line would not have produced rocdata
   even under real SAS. This bundle gets the same sensitivity/specificity
   points into `rocdata` via the documented MODEL-statement OUTROC=
   option instead.
*/

data nafld;
    input Age Gender BMI SBP DBP Diyabetes Hypertension Hyperlipidemia
          AST ALT GGT TotalCholesterol Triglycerides HDL LDL Glucose Insulin Cirrhosis;
    datalines;
57 2 27.08 140 80 0 1 1 34 33 115 292 121 64 199 72 4.83 0
46 2 27.33 120 80 1 0 1 51 97 61 238 317 42 132 177 11.8 0
32 2 48.23 136 88 1 0 1 69 153 48 261 220 31 200 98 20.29 1
31 1 28 120 90 0 0 0 69 95 76 192 176 43 126 99 14.6 0
39 1 34 120 70 0 0 0 57 73 34 226 285 32 137 100 11.58 0
51 1 34.02 120 70 0 0 0 106 77 71 196 111 53 121 92 18.7 1
36 2 30.09 110 80 0 0 1 33 46 37 214 311 46 146 88 9 0
45 1 30.48 120 80 0 0 1 95 184 42 236 88 50 168 100 7.49 0
48 2 33.45 140 95 1 1 1 36 34 82 197 225 52 100 144 28.52 1
39 1 29.74 129 75 1 0 1 106 147 99 171 175 25 111 145 16 0
40 2 30.78 130 95 0 1 1 56 101 38 218 147 42 147 113 20.28 0
71 1 31.23 120 80 1 0 0 34 32 43 233 145 67 139 114 3.77 1
51 1 32.39 190 100 1 1 1 55 57 89 227 241 37 142 132 13.75 1
46 2 36.68 144 70 1 0 1 38 74 53 141 144 35 91 192 38.11 1
54 1 24.65 110 89 0 0 0 29 47 30 224 177 59 144 95 16.43 0
28 1 24.27 108 74 0 0 1 241 343 87 258 235 37 174 92 25.16 0
62 1 36.98 120 80 1 1 0 44 28 47 182 119 52 124 103 13.45 0
39 1 32.1 131 88 0 0 1 18 12 9 182 210 35 105 110 23.6 0
51 1 33.32 154 93 1 0 1 40 39 66 160 160 40 91 106 5.99 0
64 2 29.94 135 85 1 0 1 53 27 23 173 463 38 400 138 19.26 0
60 1 36.5 120 80 1 1 1 29 29 60 200 197 46 115 160 18.7 1
43 1 39.9 160 110 0 1 0 55 79 31 201 175 57 135 89 17 0
70 1 28.52 120 80 1 0 1 37 32 130 221 120 71 126 184 10.8 1
57 1 35.38 117 77 1 1 1 43 48 82 250 152 72 147 110 33.78 1
37 2 36.16 134 89 0 0 0 38 59 20 265 152 33 66 99 46.65 0
40 1 23.12 115 75 0 0 1 29 51 70 185 203 31 113 92 16.29 0
60 1 39.48 110 70 1 1 0 47 18 165 311 150 84 197 114 8.85 1
58 1 29.38 128 75 0 1 0 34 49 35 168 116 43 102 113 28.25 1
54 1 32.03 110 70 0 0 1 28 53 50 146 122 68 54 100 23.6 0
54 1 32.45 120 80 0 1 1 38 58 42 227 219 46 137 87 12 0
37 1 30.08 110 80 1 0 1 35 63 37 195 102 45 130 119 11.41 0
51 1 34 120 70 0 0 0 106 77 71 196 111 53 121 92 20.3 1
50 1 33.52 130 80 0 0 0 147 196 115 271 135 49 218 99 13.8 0
43 2 30.08 120 80 0 0 1 70 120 57 242 553 29.82 101 116 7.9 0
29 1 43.57 120 70 0 0 0 29 38 26 194 200 37 117 79 21 0
52 2 35.92 112 51 1 1 1 60 79 268 204 350 36 98 269 26.99 1
54 1 32.46 150 90 1 1 0 58 30 87 90 164 51 95 140 13.75 1
45 2 31.63 110 70 0 0 0 56 67 50 202 148 50 134 76 12.6 0
48 2 25.38 130 100 0 0 0 75 142 78 211 302 47 104 90 5.65 0
47 1 31.25 132 88 1 1 1 41 39 44 201 208 42 126 163 21.86 0
39 1 27 120 80 1 0 1 25 31 38 217 427 42 169 188 4.9 0
63 2 27.72 120 80 1 0 1 57 56 32 220 138 49 145 158 6.6 0
58 2 25.4 148 92 1 0 0 25 33 44 140 138 40 72 100 13.85 1
44 1 30.5 110 70 0 0 0 45 69 21 211 166 42 114 94 13.45 0
39 2 32.79 130 74 0 0 0 66 107 169 86 42 46 32 91 29.1 1
36 2 35.63 114 80 0 0 0 38 68 20 130 208 47 135 98 18.98 0
68 1 38.45 120 80 1 0 1 40 30 110 257 81 78 163 139 33.9 1
36 1 34.58 130 90 0 1 0 35 57 25 187 73 58 124 101 13 0
58 1 35.8 118 85 1 1 1 35 37 180 166 227 33 99 240 22.38 1
38 2 28.02 120 80 0 0 0 55 116 43 200 84 51 132 93 13.63 0
60 1 33.62 123 75 1 1 1 35 43 86 206 78 61 129 103 16 1
62 1 37 120 80 1 1 0 44 28 47 182 119 52 124 103 11.02 1
33 2 24.38 110 70 0 0 0 30 60 22 207 44 53 145 96 8 0
46 2 40.9 140 90 1 1 1 23 39 166 203 140 53 122 126 25.62 1
29 1 25.78 120 80 0 0 0 82 112 59 103 49 62 31.2 71 11.6 0
59 1 34.96 142 92 1 0 0 162 134 65 178 88 49 111 83 14.5 1
39 2 24.9 120 80 0 0 1 22 31 42 128 65 43 77 96 13 0
34 2 35.51 125 75 1 0 0 56 110 56 198 81 43 139 86 14.6 0
55 2 31.12 124 83 1 0 1 60 102 158 161 193 35 87 116 25.78 0
35 2 37.8 120 80 0 0 1 16 26 19 226 170 40 152 99 45.02 0
41 1 55.96 170 110 1 0 0 32 17 40 190 99 51 121 105 12 0
60 2 39.3 134 79 1 1 1 40 66 104 129 76 44 70 122 27.24 1
48 2 35.15 112 86 0 0 0 68 133 92 217 142 53 139 85 76.12 0
55 1 35.46 100 60 1 0 1 91 59 85 270 109 57 191 77 14.5 1
;
run;

proc contents data=nafld; run;

proc surveyselect data=nafld out=work.split seed=12345 samprate=0.7
        outall;
run;

data train test;
    set work.split;

    if selected=1 then
        output train;
    else
        output test;
run;

ods graphics on;

PROC LOGISTIC DATA=Train PLOTS=ROC;
    CLASS Gender(ref='1') / PARAM=REF;
    MODEL Cirrhosis (EVENT='1')=Age Gender BMI SBP DBP Diyabetes
        Hypertension Hyperlipidemia AST ALT GGT TotalCholesterol
        Triglycerides HDL LDL Glucose Insulin / Rsquare
        OUTROC=rocdata;
RUN;

proc sgplot data=rocdata;
    series x=_1MSPEC_ y=_SENSIT_ / lineattrs=(thickness=2 color=blue);
    xaxis label="1 - Specificity" grid;
    yaxis label="Sensitivity" grid;
    title "ROC Curve - Binary Logistic Model for Cirrhosis";
run;
