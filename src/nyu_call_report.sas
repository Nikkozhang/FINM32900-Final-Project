/* 
NOTE: This source file is included for reference. This is how the NYU call report data is generated. */


/*  READ ME FIRST */

/*The latest version of the code and the other files are available on the website of Philipp Schnabl
at http://pages.stern.nyu.edu/~sternfin/pschnabl/

This code documents how to form consistent time-series data with U.S. Bank Balance Sheets from 1976Q1 to 2020Q1.
The code, data, and data dictionary are  provided free of charge.  If you use any part of the code, data, or data dictionary,
we kindly ask you to acknowledge the use of this code and to cite at least one of the papers on which this work is based:

1) Drechsler, Itamar, Alexi Savov, and Philipp Schnabl, 2017, The deposits channel of monetary policy, The Quarterly Journal of Economics
2) Drechsler, Itamar, Alexi Savov, and Philipp Schnabl, 2020, Banking on Deposits: Maturity Transformation without Interest Rate Risk

You create the file by running this SAS code using SAS Studio in WRDS.
Log in to WRDS, and navigate to the GET DATA dropdown menu. Open SAS Studio under the PROGRAMS heading.
Log in to SAS Studio using your WRDS login information. Create a new SAS program in your home directory,
paste the contents of callreport_1976_2020_WRDS.sas into the blank program, and save it.
Run the SAS program. The program will create a file named callreports_1976_2020.dta in the home directory.
This file should be downloaded to your computer.

Note that SAS Studio can be somewhat unreliable when working with data sets of this size. There are two recurring errors to be aware of.
First, the output variables will sometimes not be renamed by the program. You will be able to tell this from the results tab
that is presented when the program completely runs through. The table of contents should not include any variables
like RCON1234 or RCFD4321. Second, whether the program succeeds or not,  the final file will appear to be 0kbs in the file manager
(you can see this by right-clicking on the file name and clicking PREFERENCES). However, when you click to download the file to
your computer it should download as a 2.7GB file. Yet, sometimes the file downloads and is 0kbs.
If either error occurs, delete any datasets created by this program, fully exit SAS Studio, and then re-run the program.

NOTE ON DATA DICTIONARY: You can download the codebook (in Excel) from Philipp Schnabl's website

NOTE ON INCOME AND EXPENSE VARIABLES: Be aware that all income and expense variables are at the quarterly level.  
	They are computed by converting YTD data into quarterly data.  The variable is set to missing if a bank does 
	not report a value for the current or past period.  You need to multiply them by 4 if you want to annualize these numbers.

NOTE ON SAMPLE: We include all financial institutions that file Call reports.  One can restrict the sample to commercial banks,
	by limiting the analysis to institutions with a chartertype equal to 200.

NOTE ON FILING FREQUENCY: Most financial institutions file income statements quarterly after 1982.  Before 1982, most institutions 
	file semi-annualy.  The code sets income and expense variables to missing for banks that file semi-annualy.

NOTE ON DATA AFTER 2010: Starting from 20110331, banks without foreign offices do not report RCFD series. This code replaces 
	the missing RCFD values with the corresponding RCON values.

*/
/* SAS Code STARTS HERE */


options linesize=250;
libname out "$HOME/.";

/*This process loops through all call report files and selects the variables*/
%macro loop(start_month=, stop_month=);
    %local month;
    %do month=&start_month %to &stop_month %by 3;
        %put Month: &month;

        data call&month (keep=date2 rssdid name cert bhcid rcon8725 rcon8729 rconA589 rcon3450 rconA126 rssd9048 rcfd0010 rcfd2170 
        rcfd1400 rcfd2165 rcfd1410 rcfd1590 rcfd1600 rcfd1766 rcfd2122 rcfd3123 rcfd1975 rcfd1350 rcfdB989 rcfdB987 rcfd3545 rcfd2146 
        rcfd1000 rcfd0400 rcfd0600 rcfd0900 rcfd0380 rcfd0390 rcfd0950 rcfd1754 rcfd1771 rcfd1772 rcfd1773 rcfd2948 rcfd2950 rcfd3200 
        rcfd3210 rcon2200 rcfn2200 rcfn6636 rcon6631 rcon6636 rcfd2800 rcfdB993 rcfdB995 rconB993 rconB995 rcfd3548 rcfd3190 rcfd1935 
        rcfd2861 rcfd2869 rcfd2850 rcon2215 rcon2210 rcon2350 rcon2385 rcon2365 rcon6810 rcon0352 rcon6648 rcon2604 rconJ473 rconJ474 
        rcon2389 riad4000 riad4107 riad4079 riad4010 riad4020 riad4130 riad4073 riad4093 riad4230 riad4135 riad4170 riad4180 riad4217 
        riad4340 riad4024 riad4012 riad4065 riad4069 riad4218 riad4508 riad0093 riadA517 riadA518 riad4185 riad4200 riad4074 riad4080 
        riadA220 riad4150 riad4460 riad4174 riad4172 riad4509 riad4511 rcfdB558 rcfdB559 rcfdB560 rcfd3365 riad4115 riadB488 riadB489 
        riad4060 rcfd3401 rcfd3381 rcon3360 rcon3465 rcon3466 riad4435 riad4436 rcon3386 rcon3387 rconB561 riadB485 rconB562 riadB486 
        rcfn3360 riad4059 rcfd3484 rcfd3368 rcon3485 rconB563 rconA514 rconA529 rcfn3404 rcfd3353 rcfd3355 rcon3388 rcon3385 rcfd3382 
        rcfd3383 rcfd3384 rcon3345 riad4011 rcfdA549 rcfdA550 rcfdA551 rcfdA552 rcfdA553 rcfdA554 rcfdA555 rcfdA556 rcfdA557 rcfdA558 
        rcfdA559 rcfdA560 rcfdA561 rcfdA562 rcfdA247 rcfdA248 rconA564 rconA565 rconA566 rconA567 rconA568 rconA569 rcfdA570 rcfdA571 
        rcfdA572 rcfdA573 rcfdA574 rcfdA575 rconA579 rconA580 rconA581 rconA582 rconA241 rconA584 rconA585 rconA586 rconA587 riad4512 
        rcfd2930 rcon2343 rcon2344 riadhk04 riadhk03 rcon0010 rcon0380 rcon0390 rcon0400 rcon0600 rcon0900 rcon0950 rcon1000 rcon1350 
        rcon1400 rcon1410 rcon1590 rcon1600 rcon1754 rcon1766 rcon1771 rcon1772 rcon1773 rcon1935 rcon1975 rcon2122 rcon2146 rcon2165 
        rcon2170 rcon2800 rcon2850 rcon2861 rcon2869 rcon2930 rcon2948 rcon2950 rcon3123 rcon3190 rcon3200 rcon3210 rcon3353 rcon3355 
        rcon3365 rcon3368 rcon3381 rcon3382 rcon3383 rcon3384 rcon3401 rcon3484 rcon3545 rcon3548 rconA247 rconA248 rconA549 rconA550 
        rconA551 rconA552 rconA553 rconA554 rconA555 rconA556 rconA557 rconA558 rconA559 rconA560 rconA561 rconA562 rconA570 rconA571 
        rconA572 rconA573 rconA574 rconA575 rconB558 rconB559 rconB560 rconB987 rconB989 rcon6942 rcon2357 rcon2215 rconhk07 rconhk08 
        rconhk09 rconhk10 rconhk11 rconhk12 rconhk13 rconhk14 rconhk15 rcon6645 rconhk16 rconhk17 RCFDF158 RCFDF159 RCFD1420 RCFD1797 
        RCFD5367 RCFD5368 RCONF158 RCONF159 RCON1420 RCON1797 RCON5367 RCON5368 RCFDB538 RCFDB539 RCFD2011 RCONB538 RCONB539 RCON2011
        RIADB488 RIADB489 RIAD4060 RCFD0071 RCFD0081 RCON0071 RCON0081 RCFD8725 RCFD8729 RCFDA589 RCFD3450 RCFDA126);
		set bank.call&month;
		rename rssd9001=rssdid rssd9010=name rssd9999=date2 rssd9050=cert rssd9348=bhcid;
	run;

        %if %substr(&month,5,2)=12 %then %let month=%eval(&month+88);
    %end;
%mend loop;
%loop(start_month=197603,stop_month=202003)

data temp;
     set call:;
     rename date2=date;
	 rename rssd9048=chartertype;
run;


data fixed;
	set temp; 
	
/*Starting from 20110331, banks without foreign offices do not report RCFD series.
This process replaces the missing RCFD values with RCON values*/
%let list=RCFD2170 RCFD0010 RCFD0380 RCFD0390 RCFD0400 RCFD0600 RCFD0900 RCFD0950 RCFD1000 RCFD1350 RCFD1400 RCFD1410 RCFD1590 RCFD1600 
			RCFD1754 RCFD1766 RCFD1771 RCFD1772 RCFD1773 RCFD1935 RCFD1975 RCFD2122 RCFD2146 RCFD2165  RCFD2800 RCFD2850 
			RCFD2861 RCFD2869 RCFD2930 RCFD2948 RCFD2950 RCFD3123 RCFD3190 RCFD3200 RCFD3210 RCFD3353 RCFD3355 RCFD3365 RCFD3368 
			RCFD3381 RCFD3382 RCFD3383 RCFD3384 RCFD3401 RCFD3484 RCFD3545 RCFD3548 RCFDA247 RCFDA248 RCFDA549 RCFDA550 RCFDA551 
			RCFDA552 RCFDA553 RCFDA554 RCFDA555 RCFDA556 RCFDA557 RCFDA558 RCFDA559 RCFDA560 RCFDA561 RCFDA562 RCFDA570 RCFDA571 
			RCFDA572 RCFDA573 RCFDA574 RCFDA575 RCFDB558 RCFDB559 RCFDB560 RCFDB987 RCFDB989 RCFDB993 RCFDB995 RCFDF158 RCFDF159 
			RCFD1420 RCFD1797 RCFD5367 RCFD5368 RCFDB538 RCFDB539 RCFD2011 RCFD0071 RCFD0081 RCFD8725 RCFD8729 RCFDA589 RCFD3450 
			RCFDA126; 


%macro loop(vlist);
%let nwords=%sysfunc(countw(&vlist));

%do i=1 %to &nwords;

	%let old= %scan(&vlist, &i);
	%let new = RCON%substr(%scan(&vlist, &i),5,4);
	if &old=. then &old=&new ;
%end;
%mend;
%loop(&list);

run;




/*Generate new variables*/
data out.callreports (drop=rcfd: rcon: rcfn: riad:);
	set fixed;

		assets=rcfd2170; /* 197603- Total assets    */
		reloans=rcfd1410; /* 197603- Real estate loans*/
		cash=rcfd0010; /* 197603- Cash this variable is sparsely reported starting from 201503*/
		if cash=. then cash=rcfd0071+rcfd0081; /*198403- Cash can also be calculated as the sum of noninterest-bearing balances and currency and coin (0081) and interest-bearing balances (0071). This method is used to fill in the missing values of RCFD0010*/
		persloans=rcfd1975; /* 197603- Personal loans*/
		agloans=rcfd1590; /* 197603- Agricultural loans*/
		subordinateddebt=rcfd3200; /* 197603- Subordinated debt*/
		equity=rcfd3210; /* 197603- Total equity*/
		demanddep=rcon2210; /* 197603- Demand deposits*/
		transdep=rcon2215; /* 198403- Transaction deposits*/
		brokereddep=rcon2365; /* 198309- Brokered deposits*/
		brokereddeple100k=rcon2343; /*19840331-20161231- Brokered deposits issued by the bank in denominations of less than $100,000 */
        brokereddepeq100k=rcon2344; /*19840331-20091231- Brokered deposits issued by the bank in denominations equal to or greater than $100,000 */
        timedepge100k=rcon2604; /* 197603- Total time deposits of $100K or more*/
		if timedepge100k=. then timedepge100k = sum(rconj473, rconj474); /* 197603- Sum of time deposits $100K-$250K and time deposits of $250K or more*/
		timedeple100k=rcon6648; /* 198403- Total time deposits less than $100K*/
		cdge100k=rcon6645; /*197603-199703 Time certificates of deposit of $100K or more in domestic offices*/
        timedepge250k=rconj474; /* 201003- Total time deposits more than $250K*/
        timedeple250k=rconj473+rcon6648; /* 201003- Total time deposits of $250K or less. Sum of time deposits $100K-$250K (j473) and time deposits less than $100K (6648)*/
		

	    /* There are two C&I loan series: rcfd1600 up to 20001231 and rcfd1766 from 19840331. The difference between them is rcfd1755 "Acceptances of other banks",
			which is excluded from rcfd1600. Since rcfd1755 is only available from 19840331 to 20001231, there is no way to form a consistent time series for the
			entire sample. Yet since there is some overlap between rcfd1600 and rcfd1766, it is possible to construct a consistent growth rate series. */
	    ciloans=rcfd1766; /* 198403- */
		if ciloans=. then ciloans=rcfd1600; /* 197603-200012 */

	    /* Total loans and leases is rcfd1400. Prior to 198312, it does not include lease financing receivables, rcfd2165 */
	    if date<=19831231 then loans=sum(rcfd1400,rcfd2165); 
	    else loans=rcfd1400; /* 197603- */

	    /* Loans and leases net of unearned income and allowance for loan and lease losses. This is the variable that makes assets add up on the balance sheet. */
	    if rcfd3123 ne . then loansnet=rcfd2122-rcfd3123;
	    else loansnet=rcfd2122; /* 197603- */
	
		/* Fed funds sold and securities purchased under agreements to resell is rcfd1350 through 20011231, after which it is broken up into Fed funds sold, rcfdB987
		   and securities purchased under agreements to resell, rcfd989. Note that the balance sheet includes only Fed funds sold in domestic offices, rconB987.
		   However, using this series would not form a consistent time series with rcfd1350. */
		fedfundsrepoasset=rcfd1350; /* 197603-200112 */
	    if fedfundsrepoasset=. then fedfundsrepoasset=rcfdB987+rcfdB989; /* 200203- */

		/* Trading assets, rcfd3545, starts in 19940331. From 19840331 to 19931231 it is reported under rcfd2146, which goes back to 19840331. Trading assets up to
		   19831231 are reported at book value as rcfd1000. This creates a possible discontinuity at 19831231 hence we do not use it. */
		tradingassets=rcfd3545; /* 199403- */
		if tradingassets=. then tradingassets=rcfd2146; /* 198403-199312 */
	
		/* Up to 19831231, securities are reported separately as Treasury securities, rcfd0400, agency and corporate securities, rcfd0600, obligations of states and political subdivisions, rcfd0900, and other seucrities, rcfd0950. After that, until 19931231 they are available as rcfd0390. After 19940331, they are broken down into securities held to maturity, rcfd1754, and securities available for sale, rcfd1773. */
		if date<=19831231 then securities=sum(rcfd0400,rcfd0600,rcfd0900,rcfd0950); /* 197603-198312 */
		else if date<=19931231 then securities=rcfd0390; /* 198403-199312 */
		else securities=sum(rcfd1754,rcfd1773); /* 199403- */
		/* Securities available for sale are reported at fair value by default but are also available at historical cost under rcfd1772. */
		securities_ammcost = sum(rcfd1754,rcfd1772); /* 199403- */
	
		/* Securities held to maturity are reported as rcfd1754 since 19940331. Securities available for sale are reported as rcfd1773 since 19940331. Securities held to maturity are reported at amortized cost. Securities available for sale are reported at fair value. There appears to be some reclassification between securities held to maturity and securities available for sale between 19950930 and 19951231. */
		securitiesheldtomaturity=rcfd1754;
		securitiesavailableforsale=rcfd1773;
	
		/* Total liabilities is rcfd2948. It can also be computed as the sum of rcfd2950, liabilities excluding subordinated debt, and rcfd3200, subordinated debt.  The latter measure is also occasionally present when rcfd2948 is missing in later years. */
		liabilities=rcfd2948; /* 197603- */
		if liabilities=. then liabilities=sum(rcfd2950,rcfd3200); /* 197603- */
	
		/* Total deposits, rcon2200, is defined excluding foreign deposits, rcfn2200. */
		deposits=rcon2200; /* 197603- */
		foreigndep=rcfn2200; /* 197603- */
	
		/* Noninterest-bearing, rcon6631, and interest-bearing, rcfd6636, start in 19840331. Foreign interest-bearing deposits, rcfn6636 starts in 197812. */
		nonintbeardep=rcon6631; /* 198403- */
		intbeardep=rcon6636; /* 198403- */
		intbearfordep=rcfn6636; /* 197812- */
	
		/* Fed funds purchased and securities sold under agreements to repurchase is rcfd2800 through 20011231, after which it is broken up into Fed funds purchased,
		   rcfdB993 and securities sold under agreements to repurchase, rcfdB995. Note that the balance sheet includes only Fed funds ourchased in domestic offices,
		   rconB993. However, using this series would not form a consistent time series with rcfd2800. */
		fedfundsrepoliab=rcfd2800; /* 197603-200112 */
	    if fedfundsrepoliab=. then fedfundsrepoliab=sum(rcfdB993,rcfdB995); /* 200203- */
	
		/* Trading liabilities, rcfd3548, starts in 19940331. There does not appear to be a corresponding series prior to that date. */
		tradingliabilities=rcfd3548; /* 199403- */
		
		/* Other borrowed money is reported as rcfd2850 until 19931231 then rcfd3190 after that. It can also be reconstructed as the sum of rcfd1935, total other
		   borrowed money owed to nonrelated banks in foreign countries, rcfd2861, other borrowed money owed to nonrelated banks in the U.S. (including their IBFs),
		   and rcfd2869, total other borrowed money owed to others. */
		otherborrowedmoney=rcfd3190; /* 199403- */
		if otherborrowedmoney=. then otherborrowedmoney=rcfd2850; /* 197612-199312 */
		if otherborrowedmoney=. then otherborrowedmoney=sum(rcfd1935,rcfd2861,rcfd2869); /* 198006- */
		
		/* Time and savings deposits are reported as rcon2350 until 19951231 and then again from 20040930 on. They can also be calculated as the sum of transaction
		   and non-transaction accounts, minus demand deposits. Therefore some of these are counted as transaction deposits but not demand deposits. 
		   NOTE: For the 3/31/84 and the 6/30/84 reporting period, RCON2350 excludes NOW and "Super" NOW accounts. 
		   We use total deposits(RCON2200) less demand deposits (RCON2210) to derive the values for these two period */
		timesavdep=rcon2350; /* 197603-199512, 200409- */
		if date=19840331 | date=19840630 then timesavdep=rcon2200-rcon2210;
		if timesavdep=. then timesavdep=rcon2215+rcon2385-rcon2210; /* 198406- */
		
		/* Non-transaction accounts */
		nontransdep=rcon2385; /* 198406- Non-transaction accounts are reported as rcon2385 after 19840630*/
		
		/* Time deposits is the sum of time deposits less than $100k and more than $100k. */
		timedep=timedeple100k+timedepge100k; /* 198403- */
		
		/* Uninsured time deposits is time deposits greater than $100k until 20091231 and greater than $250k after that. */
		if date<=20091231 then timedepuninsured=rcon2604; /* 197603- */
		else timedepuninsured=rconJ474; /* 201003- */
		
		/* Nontransaction savings deposits are reported as other nontransaction accounts, rcon0352, plus MMDA accounts, rcon6810. 
		Their sum is also reported as rcon2389. This is the series for which interest expense is reported as riad0093.*/
		savdep=rcon2389; /* 198403- */
		if savdep=. then savdep=rcon0352+rcon6810; /* 198703- */
		
		/* Total savings deposits, which includes transaction savings deposits can be calculated as time and savings deposits minus time deposits. */
		totsavdep=timesavdep-timedep; /* 198403- */
		
		/* The following income and expense measures are well populated since at least 19840331. */
		operinc=riad4000; /* 198303- */
		if operinc=. then operinc=sum(riad4079, riad4107); /*198403- Operating income can also be computed as sum of total noninterest (riad4079) and interest (riad4107) income */
		intexp=riad4073; /* 198403- */
		intincnet=riad4074; /* 198403- */
		nonintinc=riad4079; /* 198403- */
		domdepservicecharges=riad4080; /* 198303- */
		nonintexp=riad4093; /* 198303- */
		intandnonintexp=riad4130; /* 198303- */
		if intandnonintexp=. then intandnonintexp=sum(riad4073, riad4093); /* 198303- It can also be computed as sum of interest (RIAD4073) and noninterest expense (RIAD4093) */
		salaries=riad4135; /* 198303- */
		numemployees=riad4150; /* 198403- */
		intexpsubordinated=riad4200; /* 198303- */
		exponpremises=riad4217; /* 198303- */
		intanddivincsecurities=riad4218; /* 198403- */
		if intanddivincsecurities=. and date>=20110301 then intanddivincsecurities=sum(RIADB488,RIADB489,RIAD4060);
		loanleaselossprovision=riad4230; /* 198303- */
		netinc=riad4340; /* 198303- */

		/* Interest expense on total deposits */
		intexpalldep=riad4170; /* 198303-200912 Interest expense on total deposits is reported in RIAD4170*/
        if date>=20100331 and date<=20161231 then intexpalldep=sum(riad4172, riada517, riada518, riad0093, riad4508);  
        /*200103-201612* Sum of interest on time deposits of 100K or more(A517) and of less than 100K(A518), 
        deposits in foreign offices (4172), nontransaction savings deposit(0093) and transaction accounts (4508) */
		if date>=20170331 then intexpalldep=sum(riad4172, riadhk04, riadhk03, riad0093, riad4508); 
		/*201703-*Sum of interest on time deposits of more than 250K(HK04) and of 250K or less(HK03), 
		deposits in foreign offices (4172), savings deposit(0093) and transaction accounts (4508) */

		/* Interest on large time deposits is available as riadA517. 
		After 20161231, interest on time deposits of $100K or more is no longer reported. This field is replaced by interest on time deposits of more than $250K (riadhk04).*/  
		intexptimedepge100k=riada517; /* 199703-201612 */
		
		/* Interest on small time deposits is available as riadA518.
		After 20161231, interest on time deposits less than 100K is no longer reported. This field is replaced by interest on time deposits of $250K or less (riadhk03).*/
		intexptimedeple100k=riadA518; /* 199703-201612*/
		
		intexptimedeple250k=riadhk03; /*201703-*/
		intexptimedepge250k=riadhk04; /*201703-*/
		
		
		
		/*Interest on time CD's of $100K or more*/
		intexpcdge100k=riad4174; /*197603-199612*/
		
		/* Interest on total time deposits*/
		if date<=19961231 then intexptimedep=riad4174+riad4512; /*198703-199612 Sum of interest on certificate deposits of $100K or more (riad4174) and all other time deposits (riad4512). 
																All other time deposits here include time deposits of less than $100K and open-account time deposits of $100K or more*/ 
		if date>=19970331 and date<=20161231 then intexptimedep=riada517+riada518; /*199703-201612 Sum of interest on time deposits of $100K or more (riada517) and less than $100K (riada518)*/
		if date>=20170331 then intexptimedep=riadhk03+riadhk04; /*201703- Sum of interest on time deposits of $250K or less (riadhk03) and more than $250K (riadhk04) */

		/* Trading revenue is available as riadA220 since 19970930 for FFIEC 031 filers and 20010331 for FFIEC 041 filers. */
		tradingrevenue=riadA220; /* 199709- */
		/* Cash dividend on common stock is available as riad4460. Most banks seem to report this variable semi-annually from 19760331 to 19821231,
		   annually from 19830331 to 20001231, and quarterly after 20010331. Therefore for any analysis this variable should be summed over each
		   year to remove seasonality. */
		dividendoncommonstock=riad4460; /* 198303- */

		/* Quarterly average balance sheet items and corresponding income items used to compute rates. */
		qavgbaldue=rcfd3381; /* 198403- */
		intincbaldue=riad4115; /* 198303- */
		qavgtreasuriesagencydebt=rcfdB558; /* 200103- */
		intinctreasuriesagencydebt=riadB488; /* 200103- */
		qavgmbs=rcfdB559; /* 200103- */
		intincmbs=riadB489; /* 200103- */
		qavgothersecurities=rcfdB560; /* 200103- */
		intincothersecurities=riad4060; /* 200103- */
		qavgtradingassets=rcfd3401; /* 198403- */
		qavgfedfundsrepoasset=rcfd3365; /* 197603- */
		intincfedfundsrepoasset=riad4020; /* 198303- */
		qavgloans=rcon3360; /* 197603- */
		intincloans=riad4010; /* 198303- */
		qavgreloans1to4fam=rcon3465; /* 200803- */
		intincreloans1to4fam=riad4435; /* 200803- */
		qavgreloansother=rcon3466; /* 200803- */
		intincreloansother=riad4436; /* 200803- */
		qavgagloans=rcon3386; /* 200103- */
		intincagloans=riad4024; /* 200103- */
		qavgciloans=rcon3387; /* 200103- */
		intincciloans=riad4012; /* 200103- */
		qavgpersccards=rconB561; /* 200103- */
		intincpersccards=riadB485; /* 200103- */
		qavgpersother=rconB562; /* 200103- */
		intincpersother=riadB486; /* 200103- */
		qavgforloans=rcfn3360; /* 197812- */
		intincforloans=riad4059; /* 198403- */
		qavgleases=rcfd3484; /* 198703- */
		intincleases=riad4065; /* 198303- */
		qavgassets=rcfd3368; /* 197812- */
		intincassets=riad4107; /* 198403- */
		qavgtransdep=rcon3485; /* 198703- */
		intexptransdep=riad4508; /* 198703- */
		qavgsavdep=rconB563; /* 200103- */
		/*Savings deposit interest expense (excludes tansaction savings deposits such as NOW and ATS) */
		intexpsavdep=riad0093; /* 200103-- */
		if intexpsavdep=. then intexpsavdep=riad4509+riad4511; /*198703-200012*/
		qavgtimedepge100k=rconA514; /* 199703-201612 Quarterly average of time deposits greater than $100K*/
		qavgcdge100k=rcon3345; /*197812-199612 Quarterly average of time certificates of deposit in denominations of $100K or more in domestic office*/
		qavgtimedeple100k=rconA529; /* 199703-201612*/
		qavgtimedeple250k=rconhk16; /* 201703-*/
		qavgtimedepge250k=rconhk17; /* 201703-*/


		
		qavgfordep=rcfn3404; /* 198403- */
		intexpfordep=riad4172; /* 198303- */
		qavgfedfundsrepoliab=rcfd3353; /* 197603- */
		intexpfedfundsrepoliab=riad4180; /* 198303- */
		qavgtradingandotherborrowed=rcfd3355; /* 197603- */
		intexptradingandborrowed=riad4185; /* 198303- */
		/* There is an earlier series for quarterly average of personal loans, rcon3388, but coverage is sparse. */
		qavgpersloans=rconB561+rconB562; /* 200103- */
		intincpersloans=riadB485+riadB486; /* 200103- */
		qavgreloans=rcon3385; /* 200103- */
		if qavgreloans=. then qavgreloans=rcon3465+rcon3466; /* 200803- */
		intincreloans=riad4011; /* 200103- */
		if intincreloans=. then intincreloans=riad4435+riad4436; /* 200803- */
		qavgsecurities=rcfdB558+rcfdB559+rcfdB560; /* 200103- */
		
		
		
		
		/* Maturity and repricing data available starting in 19970630 */
		securities_less_3m=rcfdA549+rcfdA555;
		securities_3m_1y=rcfdA550+rcfdA556;
		securities_1y_3y=rcfdA551+rcfdA557;
		securities_3y_5y=rcfdA552+rcfdA558;
		securities_5y_15y=rcfdA553+rcfdA559;
		securities_over_15y=rcfdA554+rcfdA560;
		securitiestreasury_less_3m=rcfdA549;
		securitiestreasury_3m_1y=rcfdA550;
		securitiestreasury_1y_3y=rcfdA551;
		securitiestreasury_3y_5y=rcfdA552;
		securitiestreasury_5y_15y=rcfdA553;
		securitiestreasury_over_15y=rcfdA554;
		securitiesrmbs_less_3m=rcfdA555;
		securitiesrmbs_3m_1y=rcfdA556;
		securitiesrmbs_1y_3y=rcfdA557;
		securitiesrmbs_3y_5y=rcfdA558;
		securitiesrmbs_5y_15y=rcfdA559;
		securitiesrmbs_over_15y=rcfdA560;
		securitiesothermbs_less_3y=rcfdA561;
		securitiesothermbs_over_3y=rcfdA562;
		loansleases_mat_less_1y=rcfdA247;
		securities_mat_less_1y=rcfdA248;
		resloans_less_3m=rconA564;
		resloans_3m_1y=rconA565;
		resloans_1y_3y=rconA566;
		resloans_3y_5y=rconA567;
		resloans_5y_15y=rconA568;
		resloans_over_15y=rconA569;
		loansleases_less_3m=rcfdA570+rconA564;
		loansleases_3m_1y=rcfdA571+rconA565;
		loansleases_1y_3y=rcfdA572+rconA566;
		loansleases_3y_5y=rcfdA573+rconA567;
		loansleases_5y_15y=rcfdA574+rconA568;
		loansleases_over_15y=rcfdA575+rconA569;
		
		/*Time deposits by maturity. Small and large time deposit cutoff amount is $100K from 19970630-20161231*/
		timedeple100k_less_3m=rconA579; /*199706-201612*/
		timedeple100k_3m_1y=rconA580; /*199706-201612*/
		timedeple100k_1y_3y=rconA581; /*199706-201612*/
		timedeple100k_over_3y=rconA582; /*199706-201612*/
		timedeple100k_less_1y=rconA241; /*199706-201612*/
		timedepge100k_less_3m=rconA584; /*199706-201612*/
		timedepge100k_3m_1y=rconA585; /*199706-201612*/
		timedepge100k_1y_3y=rconA586; /*199706-201612*/
		timedepge100k_over_3y=rconA587; /*199706-201612*/
		
	
		/*Time deposits by maturity. Small and large time deposit cutoff amount is $250K from 201703 onward*/
		timedeple250k_less_3m=rconHK07; /*201703-*/
		timedeple250k_3m_1y=rconHK08; /*201703-*/
		timedeple250k_1y_3y=rconHK09; /*201703-*/
		timedeple250k_over_3y=rconHK10; /*201703-*/
		timedeple250k_less_1y=rconHK11; /*201703-*/
		timedepge250k_less_3m=rconHK12; /*201703-*/
		timedepge250k_3m_1y=rconHK13; /*201703-*/
		timedepge250k_1y_3y=rconHK14; /*201703-*/
		timedepge250k_over_3y=rconHK15; /*201703-*/


		/*Derivatives data*/
		interestratederivatives = RCFD8725; /*199503- *Total gross notional amount of IR derivativs for purposes other than trading*/
		interestratederivatives_par = RCFD8729; /*199503- 200012 *Total gross notional amount of IR derivativs for purposes other than trading - not marked to market*/
		grosshedging= sum(RCFD8725,RCFD8729);
		
		fixedrateswaps= RCFDA589; /*199706- * Interest rate swaps where bank has agreed to pay a fixed rate*/
		totalswaps = RCFD3450; /*198503- * Notional value of all outstanding interest rate swaps*/
		floatingrateswaps= RCFD3450 - RCFDA589; /*199706 - * Total swaps minus pay-fixed swaps*/
		nethedging=fixedrateswaps-floatingrateswaps; 
		
		grosstrading = RCFDA126; /*199503 - *Total gross notional amount of interest rate derivate contracts held for trading*/

run;

/*Generating year*/
data new;
     set out.callreports;
     year=int(date/10000);
run;

/** generating ymd**/
data new;
	set new;
	month = floor(date/100)-100*year;
	quarter= floor(month/4)+1;
	day = date- 100*(floor(date/100));
	dateq= mdy(month,day,year);
	format dateq yyq6.;
run;

/*Compute deposit in foreign offices and interest expense for deposits in foreign offices*/
data new;
	set new;
	if foreigndep=. then foreigndep=0;
	if intexpfordep=. then intexpfordep=0;
	intexpdomdep=intexpalldep-intexpfordep;
run; 


/*Sort data and prepare for the deduplication process below*/
proc sort data=new;
      by rssdid dateq descending assets;
run;


/*If a bank-date pair has multiple records in the raw data,
  this process will keep the record with highest asset value*/
PROC SORT DATA=new NODUPKEY;
 BY rssdid dateq;
RUN ;


/*Income and expense variables are reported in a year-to-date basis in the raw data.
  The process below will compute the querterly values for those variables*/

data new;
	set new;
	dateref=year*100+quarter*25;
	lag_rssdid=lag(rssdid);
	datedelta=dateref-lag(dateref); /*The delta here is used to identify gaps in time series below*/
run;

proc sort data=new;
      by rssdid dateq;
run;


%macro addnewlag(x);
   data new;
    set new;
    diff_&x = &x - lag(&x);
    if quarter = 1 then diff_&x = &x; /*YTD and quarterly values are the same for the first quarter*/
    else if lag_rssdid = rssdid and quarter ^= 1 and datedelta ^= 25 then diff_&x =.; /*Set value to missing if the delta between the current and previous filings is greater than 1 quarter*/
	by rssdid;
    if first.rssdid and quarter ^= 1 then diff_&x =.; /*Set the first observation of each bank time series to be missing if it's not in Q1*/

run;
%mend;


%let list=dividendoncommonstock  exponpremises intanddivincsecurities intandnonintexp intexp intexpalldep intexpdomdep 	
	intexpfedfundsrepoliab intexpfordep intexpsavdep intexpsubordinated intexpcdge100k intexptimedep intexptimedepge100k 
	intexptimedeple100k intexptradingandborrowed intexptransdep intincagloans intincassets intincbaldue intincciloans 
	intincfedfundsrepoasset intincforloans intincleases intincloans intincmbs intincpersother intincreloansother intincothersecurities 
	intincpersccards intincpersloans intincreloans intinctreasuriesagencydebt loanleaselossprovision netinc intincnet nonintexp 
	nonintinc operinc salaries domdepservicecharges tradingrevenue intincreloans1to4fam intexptimedeple250k intexptimedepge250k;



%macro loop(vlist);
%let nwords=%sysfunc(countw(&vlist));

%do i=1 %to &nwords;
	%addnewlag(%scan(&vlist, &i));
%end;
%mend;

%loop(&list);

%let list=dividendoncommonstock  exponpremises intanddivincsecurities intandnonintexp intexp intexpalldep intexpdomdep 	
	intexpfedfundsrepoliab intexpfordep intexpsavdep intexpsubordinated intexpcdge100k intexptimedep intexptimedepge100k 
	intexptimedeple100k intexptradingandborrowed intexptransdep intincagloans intincassets intincbaldue intincciloans 
	intincfedfundsrepoasset intincforloans intincleases intincloans intincmbs intincpersother intincreloansother intincothersecurities 
	intincpersccards intincpersloans intincreloans intinctreasuriesagencydebt loanleaselossprovision netinc intincnet nonintexp 
	nonintinc operinc salaries domdepservicecharges tradingrevenue intincreloans1to4fam intexptimedeple250k intexptimedepge250k;



/*Drop original variables with YTD values*/
%macro drop(vlist);
%let nwords=%sysfunc(countw(&vlist));

%do i=1 %to &nwords;
	data new;
    set new(drop = %scan(&vlist, &i));
%end;
%mend;

%drop(&list);


%let list=dividendoncommonstock  exponpremises intanddivincsecurities intandnonintexp intexp intexpalldep intexpdomdep 	
	intexpfedfundsrepoliab intexpfordep intexpsavdep intexpsubordinated intexpcdge100k intexptimedep intexptimedepge100k 
	intexptimedeple100k intexptradingandborrowed intexptransdep intincagloans intincassets intincbaldue intincciloans 
	intincfedfundsrepoasset intincforloans intincleases intincloans intincmbs intincpersother intincreloansother intincothersecurities 
	intincpersccards intincpersloans intincreloans intinctreasuriesagencydebt loanleaselossprovision netinc intincnet nonintexp 
	nonintinc operinc salaries domdepservicecharges tradingrevenue intincreloans1to4fam intexptimedeple250k intexptimedepge250k;

/*Rename variables with quarterly values*/
%macro rename(vlist);
%let nwords=%sysfunc(countw(&vlist));

%do i=1 %to &nwords;
	data new;
    set new;
    rename diff_%scan(&vlist, &i)=%scan(&vlist, &i);
%end;
%mend;

%rename(&list);                           

data new(drop=dateref datedelta lag_rssdid);
	 set new;
run;


data new(compress=yes);
      set new; 
run;

proc export data=new outfile="$HOME/callreports_1976_2020.dta" replace;
	