CREATE TABLE &LIBREF..CORPORATE_OWNER_DETAIL (
     OWNER_RK             NUMERIC(10) FORMAT=&FMTRK INFORMAT=&FMTRK label='Owner Key',
     VALID_START_DTTM     DATE NOT NULL FORMAT=&DTTMFMT INFORMAT=&DTTMFMT label='Valid From Datetime',
     VALID_END_DTTM       DATE NOT NULL FORMAT=&DTTMFMT INFORMAT=&DTTMFMT label='Valid To Datetime',
     OWNER_ID             VARCHAR(32) label='Owner Id',
     IND_CUSTOMER_RK      NUMERIC(10) FORMAT=&FMTRK INFORMAT=&FMTRK label='Customer Key',
     CUSTOMER_RK          NUMERIC(10) FORMAT=&FMTRK INFORMAT=&FMTRK label='Customer Key',
     CUSTOMER_NM          VARCHAR(83) label='First Name',
     BIRTH_DT             DATE FORMAT=&DTTMFMT INFORMAT=&DTTMFMT label='Birth Date',
     GENDER_CD            VARCHAR(3) label='Gender Code',
     EDUCATION_LEVEL_CD   VARCHAR(10) label='Education Code',
     MARITAL_STATUS_CD    VARCHAR(3) label='Marital Status Code',
     TAX_ID               VARCHAR(32) label='Tax Id',
     TAX_ID_TYPE_CD       VARCHAR(3) label='Tax Id Type Code',
     OWNERSHIP_AMT        NUMERIC(18,5) FORMAT=NLNUM18.5 INFORMAT=NLNUM18.5 label='Ownership Amount',
     PERCENT_OWNED        NUMERIC(9,4) FORMAT=NLNUM9.4 INFORMAT=NLNUM9.4 label='Percent Owned',
     RESIDENT_STATUS_CD   VARCHAR(3) label='Resident Status Code',
     ANNUAL_SALARY_BUSINESS_AMT NUMERIC(18,5) FORMAT=NLNUM18.5 INFORMAT=NLNUM18.5 label='Annual Salary Business Amount',
     LIQUID_ASSETS_AMT    NUMERIC(18,5) FORMAT=NLNUM18.5 INFORMAT=NLNUM18.5 label='Liquid Assets Amount',
     REAL_ESTATE_AMT      NUMERIC(18,5) FORMAT=NLNUM18.5 INFORMAT=NLNUM18.5 label='Real Estate Amount',
     ASSET_OTHER_AMT      NUMERIC(18,5) FORMAT=NLNUM18.5 INFORMAT=NLNUM18.5 label='Asset Other Amount',
     TOTAL_ASSETS_AMT     NUMERIC(18,5) FORMAT=NLNUM18.5 INFORMAT=NLNUM18.5 label='Total Assets Amount',
     LIABILITY_REAL_ESTATE_AMT NUMERIC(18,5) FORMAT=NLNUM18.5 INFORMAT=NLNUM18.5 label='Liability Real Estate Amount',
     MONTHLY_HOUSING_AMT  NUMERIC(18,5) FORMAT=NLNUM18.5 INFORMAT=NLNUM18.5 label='Monthly Housing Amount',
     LIABILITY_OTHER_AMT  NUMERIC(18,5) FORMAT=NLNUM18.5 INFORMAT=NLNUM18.5 label='Liability Other Amount',
     TOTAL_LIABILITY_AMT  NUMERIC(18,5) FORMAT=NLNUM18.5 INFORMAT=NLNUM18.5 label='Total Liability Amount',
     NET_WORTH_AMT        NUMERIC(18,5) FORMAT=NLNUM18.5 INFORMAT=NLNUM18.5 label='Net Worth Amount',
     PENDING_LAWSUIT_FLG  CHARACTER(1) label='Pending Lawsuit Flag',
     BANKRUPTCY_FILED_DT  DATE FORMAT=&DTTMFMT INFORMAT=&DTTMFMT label='Bankruptcy Filed Date',
     BANKRUPTCY_STATUS_CD VARCHAR(3) label='Bankruptcy Status Code',
     POSTAL_CD            VARCHAR(20) label='Postal Code',
     STATE_REGION_CD      VARCHAR(4) label='State/Region Code',
     TAX_BRACKET_CD       VARCHAR(3) label='Tax Bracket Code',
     DEPENDENTS_CNT       NUMERIC(6) label='Dependents Count',
     EMPLOYMENT_STATUS_CD VARCHAR(3) label='Employment Status Code',
     EMPLOYMENT_YEARS_CNT NUMERIC(6,2) FORMAT=NLNUM6.2 INFORMAT=NLNUM6.2 label='Employment Years Count',
     NO_OF_EMPLOYERS_CNT  NUMERIC(6) label='No Of Employers Count',
     TOTAL_EMPLOYMENT_YEARS_CNT NUMERIC(6,2) FORMAT=NLNUM6.2 INFORMAT=NLNUM6.2 label='Total Employment Years Count',
     STD_OCCUPATION_CD    VARCHAR(3) label='Std Occupation Code',
     TIME_RESIDENCE_YEAR_CNT NUMERIC(6,2) FORMAT=NLNUM6.2 INFORMAT=NLNUM6.2 label='Time Residence Year Count',
     OTHER_CREDIT_CARDS_CNT NUMERIC(6) label='Other Credit Cards Count',
     LIQUID_NET_WORTH_AMT NUMERIC(18,5) FORMAT=NLNUM18.5 INFORMAT=NLNUM18.5 label='Liquid Net Worth Amount',
     LEGAL_JUDGEMENT_FLG  CHARACTER(1) label='Legal Judgement Flag',
     MAINTENANCE_FLG      CHARACTER(1) label='Maintenance Flag',
     OWNER_TYPE_CD        VARCHAR(3) label='Owner Type Code',
     ANNUAL_INCOME_AMT    NUMERIC(18,5) FORMAT=NLNUM18.5 INFORMAT=NLNUM18.5 label='Annual Income Amount',
     HHOLD_INCOME_AMT     NUMERIC(18,5) FORMAT=NLNUM18.5 INFORMAT=NLNUM18.5 label='Household Income Amount',
     FRAUD_FLG            CHARACTER(1) label='Fraud Flag',
     DELINQUENCY_FLG      CHARACTER(1) label='Delinquency Flag',
     FORECLOSED_FLG       CHARACTER(1) label='Foreclosed Flag',
     CREATED_BY           VARCHAR(20) label='CREATED_BY',
     CREATED_DTTM         DATE FORMAT=&DTTMFMT INFORMAT=&DTTMFMT label='_DTTM',
     PROCESSED_DTTM       DATE FORMAT=&DTTMFMT INFORMAT=&DTTMFMT label='Processed Datetime',
     CONSTRAINT PRIM_KEY PRIMARY KEY (CUSTOMER_RK,OWNER_TYPE_CD, VALID_START_DTTM)
);

