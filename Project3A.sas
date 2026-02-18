/* Jordan Abel IDC4252C Project3A */

FILENAME REFFILE '/home/u64360188/sasuser.v94/stock.csv';

PROC IMPORT DATAFILE=REFFILE
DBMS=CSV
OUT=WORK.RAW
REPLACE;
GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.RAW;
RUN;

PROC UNIVARIATE DATA=raw; 
ID date; 
VAR stock; 
RUN; 

/* 1. Create a numeric version of the market share */
DATA build;
    SET raw;
    /* Convert "18.85%" (text) to 0.1885 (number) */
    Global_mkt_num = INPUT(Global_mkt_share, PERCENT10.);
RUN;

/* 2. Run the regression using the new numeric variable */
PROC REG DATA=build PLOTS=DIAGNOSTICS(UNPACK); 
    ID date; 
    /* List the variables explicitly to avoid character columns */
    MODEL stock = basket_index EPS Top_10_GDP Global_mkt_num 
                  P_E_ratio Media_analytics_index 
                  Top_10_Economy_inflation M1_money_supply_index; 
RUN;
QUIT;

PROC ARIMA Data=build; 
IDENTIFY VAR=STOCK; 
RUN; 

PROC ARIMA Data=build; 
IDENTIFY VAR=STOCK(1); 
RUN; 

PROC ARIMA Data=build; 
IDENTIFY VAR=STOCK(1); 
ESTIMATE p=1 q=1; 
RUN; 

PROC ARIMA Data=build; 
IDENTIFY VAR=STOCK(1); 
ESTIMATE p=1; 
RUN; 

PROC ARIMA DATA=build; 
IDENTIFY VAR=STOCK SCAN; 
RUN; 

PROC ARIMA DATA=build; 
IDENTIFY VAR=STOCK SCAN; 
ESTIMATE p=1 q=0; 
FORECAST LEAD=30 OUT=PREDICT; 
RUN; 