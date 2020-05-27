CREATE TABLE &LIBREF..BANK_CARD_DETAIL (
     ACCOUNT_RK           NUMERIC(10) FORMAT=&FMTRK INFORMAT=&FMTRK label='_RKorSK',
     BANK_CARD_TYPE_CD    VARCHAR(3) label='_CD',
     CARD_ISSUE_DT        DATE FORMAT=&DTTMFMT INFORMAT=&DTTMFMT label='_DT',
     VALID_START_DTTM     DATE NOT NULL FORMAT=&DTTMFMT INFORMAT=&DTTMFMT label='_DTTM',
     CUSTOMER_RK          NUMERIC(10) FORMAT=&FMTRK INFORMAT=&FMTRK label='_RKorSK',
     CARD_EXPIRATION_DT   DATE FORMAT=&DTTMFMT INFORMAT=&DTTMFMT label='_DT',
     CARD_CANCEL_DT       DATE FORMAT=&DTTMFMT INFORMAT=&DTTMFMT label='_DT',
     CARD_CANCEL_REASON_CD VARCHAR(3) label='_CD',
     LOSS_AMT             NUMERIC(18,5) FORMAT=NLNUM18.5 INFORMAT=NLNUM18.5 label='_AMT',
     LOSS_DT              DATE FORMAT=&DTTMFMT INFORMAT=&DTTMFMT label='_DT',
     CREATED_BY           VARCHAR(20) label='CREATED_BY',
     CREATED_DTTM         DATE FORMAT=&DTTMFMT INFORMAT=&DTTMFMT label='_DTTM',
     VALID_END_DTTM       DATE NOT NULL FORMAT=&DTTMFMT INFORMAT=&DTTMFMT label='_DTTM',
     PROCESSED_DTTM       DATE FORMAT=&DTTMFMT INFORMAT=&DTTMFMT label='_DTTM',
     FINANCIAL_PRODUCT_TYPE_CD VARCHAR(3) label='_CD',
     PRODUCT_SUB_TYPE_CD  VARCHAR(3) label='_CD',
     ACCOUNT_TYPE_CD      VARCHAR(3) label='_CD',
     ACCOUNT_SUB_TYPE_CD  VARCHAR(3) label='_CD',
     ACCOUNT_HIERARCHY_CD VARCHAR(3) label='_CD',
     CONSTRAINT PRIM_KEY PRIMARY KEY (ACCOUNT_RK, BANK_CARD_TYPE_CD, CARD_ISSUE_DT,
      VALID_START_DTTM)
);

