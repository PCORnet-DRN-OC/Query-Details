/*System Options*/
options mprint linesize=150 pagesize=50 compress=yes reuse=no symbolgen ERRORS=0 noquotelenmax validvarname=v7 LRECL=32767 SQLREMERGE NOMAUTOLOCINDES
				NOSYNTAXCHECK;

/*************************/
/*    User Inputs      */
/*************************/

/*
1) Edit DMID and Site ID 
*/
%LET DMID=;
%LET SITEID=;
 
   /*------------------------------------------------------------------------------*\
   ||                                                                             ||
   ||  DATA PARTNERS                                 DMID      SITEID             ||
   ||  ---------------------------------------------------------------------------||
   ||   		Please see the Harvest Reference  table for DMID Site ID:         ||
   ||          		https://pcornet.imeetcentral.com/p/aQAAAAAD85av               ||
   \*------------------------------------------------------------------------------*/

/*
2) Edit this section to reflect your name for each Table/File (or View)
*/
   
%let ENRTABLE=Enrollment;            
%let DEMTABLE=Demographic;
%let DISTABLE=Dispensing;            
%let DIATABLE=Diagnosis;
%let PROCTABLE=Procedures;           
%let ENCTABLE=Encounter;
%let VITTABLE=Vital;
%let PRESCTABLE=prescribing;
%let LABTABLE=lab_result_cm;
%let DEATHTABLE=death;
%let DEATHCAUSETABLE=;
%let CONDTABLE=Condition;      
%let PROTABLE=Pro_cm;     
%let MEDTABLE=Med_admin;   
%let OBSTABLE=Obs_clin;       
%let PROVTABLE=Provider;   
%let ADDRESSTABLE=Lds_address_history;
%let IMMUNIZATIONTABLE=immunization;
%let HASH_TOKENTABLE=hash_token;
%let OBSGENTABLE=obs_gen;

/*
3) Edit this section to define the macro parameters;
*/

*Values below the THRESHOLD parameter will be considered as low cell count.;
*If left empty, the program will assign a default value of 11; 
%let THRESHOLD=0;
*select Y if you want the attrition table to be populated in the DRNOC folder and report or N if you
 wish to opt out;
%let ATTRITIONTABLE=Y;
*Identify sleep time in seconds, leave to zero if not used;
%let TIME_FOR_FILE_RELEASE=0;
 
/*
4) Edit this section to reflect locations for the libraries/folders for PCORNET Data 
   and Output folders
*/
/********** FOLDER CONTAINING INPUT DATA FILES AND CDM DATA ***************************************/
/* IMPORTANT NOTE: end of path separators are needed;                                               */
/*   Windows-based platforms:    "\", e.g. "C:\user\sas\" and not "C:\user\sas";                    */
/*   Unix-based platforms:      "/", e.g."/home/user/sas/" and not "/home/user/sas";                */
/*                                                                                                  */
/********** FOLDER CONTAINING INPUT DATA FILES AND CDM DATA ***************************************/;
/*Data in CDM Format*/            libname indata 'C:\Case\PCORNET\testMaterials_statlog\testMaterials_statlog\testcases_v01\' ACCESS=READONLY;

/*NDC/ICD9 Codes File Location*/  %LET infolder=C:\Case\PCORNET\PMP3\pcornet.pmp3.v2\infolder\;								  
/*SAS Output Files*/              libname infolder "&infolder.";

/*Macro Files Location*/          %let sasmacr=C:\Case\PCornet\PMP3\pcornet.pmp3.v2\infolder\macros\;
/*Report Macro Files Location*/   %let reportmacr=C:\case\PCornet\PMP3\pcornet.pmp3.v2\infolder\macros\reportmacros\;			
/*Program Files Location*/        %let sasprog=C:\Case\PCornet\PMP3\pcornet.pmp3.v2\sasprograms\;


/********** FOLDER CONTAINING SUMMARY FILES TO BE EXPORTED TO OPERATION CENTER (DRNOC)*/;
/*CSV Output Files*/              %LET DRNOC=C:\Case\PCornet\PMP3\pcornet.pmp3.v2\drnoc\;       
/*SAS Output Files*/              libname DRNOC "&DRNOC.";

/*********** FOLDER CONTAINING FINAL DATASETS TO BE KEPT LOCAL AT THE PARTNER SITE (DMLocal)**********/;
/*CSV Output Files*/              %LET DMLocal=C:\Case\PCornet\PMP3\pcornet.pmp3.v2\dmlocal\;       
/*SAS Output Files*/              libname DMLocal "&DMLocal.";

/*Input file Location*/	          %let whoinput=C:\Case\PCornet\PMP3\pcornet.pmp3.v2\infolder\whoinput; /*no backslash at end of path*/
							      libname _reflib "&whoinput";

/*Input file Location*/	          %let bmiinput=C:\Case\PCornet\PMP3\pcornet.pmp3.v2\infolder\cdctables; /*no backslash at end of path*/
							      libname bmiinput "&bmiinput.";

/*---------------------------------------------------------------------------------------------------*/
/*                                       End of User Inputs                                          */
/*---------------------------------------------------------------------------------------------------*/

/*****************************************************************************************************/
/**************************** PLEASE DO NOT EDIT CODE BELOW THIS LINE ********************************/
/*****************************************************************************************************/

*Modular program;
%include "&sasmacr.pcornet_mp3.sas" ;
%include "&sasmacr.pc_tablecount.sas" ;
%include "&sasmacr.pc_report.sas" ;
%include "&sasmacr.ms_periodsoverlap.sas" ;
%include "&sasmacr.pc_getcond.sas" ;
%include "&sasmacr.ms_agestrat.sas" ;
%include "&sasmacr.pc_extractlabs.sas" ;
%include "&sasmacr.pc_pre_extraction.sas" ;

*For CQA OPTION;
**Include Files ** ;  
%include "&sasmacr.ms_time.sas" ;   
%include "&sasmacr.ms_macros.sas" ;   
%include "&sasmacr.pc_summarycounts.sas" ;
%include "&sasmacr.pc_singlefreq.sas" ;
%include "&sasmacr.pc_singledist.sas" ;
%include "&sasmacr.pc_bmi.sas" ;
%include "&sasmacr.igrowup_restricted_pcornet.sas" ;
%include "&sasmacr.gc_calculate_biv.sas" ;
%include "&sasmacr.pc_tablecheck.sas" ;   

%include "&sasmacr.pc_process_count.sas" ;   
%include "&sasmacr.pc_process_freq.sas" ;   
%include "&sasmacr.pc_process_dist.sas" ;   
%include "&sasmacr.pc_cqa_report.sas" ;   

*For baseline table;
%include "&sasmacr.pc_covariates.sas" ;   
%include "&sasmacr.pc_cci_elix.sas" ;   

*for vitals;
%include "&sasmacr.reversemacro.sas";
%include "&sasmacr.pc_vitals.sas";

**for lab values;
%include "&sasmacr.pc_selectlabdt.sas";
%include "&sasmacr.pc_labvalues.sas";

**for GEOG;
%include "&sasmacr.pc_selectgeogdt.sas";
%include "&sasmacr.pc_geogvalues.sas";
%include "&sasmacr.geog_valueset.sas";

**for data pull;
%include "&sasmacr.pc_datapull.sas";

**Include reporting macros ** ;  
%include "&reportmacr.runreport.sas";

%include "&reportmacr.ms_assignformats.sas";
%include "&reportmacr.ms_computelevel1.sas";
%include "&reportmacr.ms_create_t1t2_report.sas";
%include "&reportmacr.ms_createbaselinetable.sas";
%include "&reportmacr.ms_definegroupsruns.sas";
%include "&reportmacr.ms_initializemacrovariables.sas";
%include "&reportmacr.ms_outputbaselinetable.sas";
%include "&reportmacr.ms_outputt1t2report.sas";
%include "&reportmacr.ms_t1t2table.sas";
%include "&reportmacr.ms_reportutilitymacros.sas";
%include "&reportmacr.pc_reportformats.sas";

*Modular program calls;
/*Program execution run 1*/

%MODULARPROGRAM3(REQUESTID=fd2wp002,
				 RUNID=b01,
                 QUERYFROM=1/1/2006,
                 QUERYTO=9/30/2015,
                 QUERYFILE=qrp_queryfile.sas7bdat,
                 CONDFILE=qrp_cond.sas7bdat,
                 AGESTRAT=45-64 65-74,
				 SEX='M' 'F',
				 HISPANIC='Y',
				 RACE='04',
				 ENROPTION=EB1,
				 AGECALC=F,
				 THRESHOLD=&THRESHOLD.,
				 EB2TABLE=,
				 EB2DAYS=,
				 EB2ENCNUMS=,
				 EB2ENCLIST=,
 				 RequestName=%quote(The Best Request Name I found),
				 QueryName=%quote(and not so much for QueryName),
				 KeepDMLocal=Y,
				 DiffTable=N,
				 CQANFILE=,
				 CQADFILE=,
				 PULLFILE=,
			 	 TABLE1FILE=qrp_covariatecodes.sas7bdat,
				 COMORBFILE=qrp_comorbfile.sas7bdat,
				 VITALFILE=vitals_specs.sas7bdat,
				 LABFILE=,
				 GEOGFILE=GEOGFILE_1.sas7bdat,
				 CREATEREPORT_FILE=T1_reportparams_pcornetv3.sas7bdat,
				 RUNTABLECOUNT=Y,
				 VALUESETFILE=valueset,
				 ANALYSISLEVEL=,
				 SELECTINDEX=,
				 EXTRATABLESTRAT=
);

/************************************ END OF CODE *********************************************/

