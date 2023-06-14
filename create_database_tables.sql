/*
    T-SQL script to create the SQL_DEVELOPER_SAMPLE database and tables.
    Foreign key constraints are added to ensure data integrity and match the database design map provided for "Bonus 2" question.
    Clustered and nonclustered indexes are created to improve query performance.

    Generally in a production environment, I would begin with staging tables to load the data into and then use stored procedures to transform and load the data into the final tables.
    However, for this exercise, I am loading the data directly into the final tables.

*/

-- Drop the database if it already exists
USE master;
IF DB_ID('SQL_DEVELOPER_SAMPLE') IS NOT NULL DROP DATABASE SQL_DEVELOPER_SAMPLE;

IF @@ERROR = 3702
    RAISERROR('Database cannot be dropped because there still open connections.', 127, 127) WITH NOWAIT, LOG;

-- Create the SQL_DEVELOPER_SAMPLE database
CREATE DATABASE SQL_DEVELOPER_SAMPLE;
GO

-- Switch to the newly created database
USE SQL_DEVELOPER_SAMPLE;
GO

-- Create the Patient table
CREATE TABLE dbo.Patient (
    MRN                     INT             NOT NULL,
    BIRTH_DT                DATETIME        NULL,
    SEX                     VARCHAR(5)      NULL,
    PRIMARY_RACE_NM         VARCHAR(100)    NULL,
    PRIMARY_ETHNICITY_NM    VARCHAR(50)     NULL,

    CONSTRAINT PK_Patient PRIMARY KEY (MRN)
);

-- Create the Provider table
CREATE TABLE dbo.[Provider] (
    NPI                     BIGINT          NOT NULL,
    [Provider Description]  VARCHAR(100)    NULL,
    EPIC_PROV_TYPE_NM       VARCHAR(100)    NULL,

    CONSTRAINT PK_Provider PRIMARY KEY (NPI)
);

-- Create the Rev_Codes table
CREATE TABLE dbo.Rev_Codes (
    REVENUE_CODE            VARCHAR(50)     NOT NULL,
    REVENUE_CODE_NAME       VARCHAR(500)    NULL,

    CONSTRAINT PK_Rev_Codes PRIMARY KEY (REVENUE_CODE)
);

-- Create the Account_Number table
CREATE TABLE dbo.Account_Number (
    ACCOUNT_NUMBER          BIGINT          NOT NULL,
    MRN                     INT             NULL,
    PRIM_ENC_NUMBER         BIGINT          NULL,
    VST_PROV_NPI            BIGINT          NULL,
    ACCT_ADMIT_DT           DATE            NULL,
    ACCT_DISCH_DT           DATE            NULL,
    PRIM_PAYOR_NM           VARCHAR(250)    NULL,
    PRIM_FIN_CLASS_NM       VARCHAR(100)    NULL,
    PRIN_DX_CD              VARCHAR(50)     NULL,
    PRIN_PROC_CD            VARCHAR(50)     NULL,
    VISIT_BASECLS_NM        VARCHAR(50)     NULL,
    VISIT_CLASS_NM          VARCHAR(50)     NULL,
    TOT_ACCT_BAL            MONEY           NULL,
    TOT_CHGS                MONEY           NULL,

    CONSTRAINT PK_Account_Number PRIMARY KEY (ACCOUNT_NUMBER),
    CONSTRAINT FK_Account_Number_Patient FOREIGN KEY (MRN) REFERENCES dbo.Patient(MRN),
    CONSTRAINT FK_Account_Number_Provider FOREIGN KEY (VST_PROV_NPI) REFERENCES dbo.[Provider](NPI)
);

-- Create indexes for Account_Number table
CREATE NONCLUSTERED INDEX IX_Account_Number_MRN ON dbo.Account_Number(MRN);
CREATE NONCLUSTERED INDEX IX_Account_Number_VST_PROV_NPI ON dbo.Account_Number(VST_PROV_NPI);

-- Create the Encounter_Number table
CREATE TABLE dbo.Encounter_Number (
    ACCOUNT_NUMBER          BIGINT          NULL,
    ENC_NUMBER              BIGINT          NOT NULL,
    ENC_CLASS_NM            VARCHAR(100)    NULL,
    ENC_SVC_DT              DATETIME        NULL,
    ENC_DISCH_DT            DATETIME        NULL,
    UNIT_QTY                NUMERIC(8,0)    NULL,
    CHRG_TOTAL              MONEY           NULL,

    CONSTRAINT PK_Encounter_Number PRIMARY KEY (ENC_NUMBER),
    CONSTRAINT FK_Encounter_Number_Account_Number FOREIGN KEY (ACCOUNT_NUMBER) REFERENCES dbo.Account_Number(ACCOUNT_NUMBER)
);

-- Create index for Encounter_Number table
CREATE NONCLUSTERED INDEX IX_Encounter_Number_ACCOUNT_NUMBER ON dbo.Encounter_Number(ACCOUNT_NUMBER);

-- Create the Transactions table
CREATE TABLE dbo.Transactions (
    Surrogate_Key           INT IDENTITY(1,1)   NOT NULL,
    ACCOUNT_NUMBER          BIGINT              NULL,
    Enc_Number              BIGINT              NULL,
    MRN                     INT                 NULL,
    AcctGroup               VARCHAR(100)        NULL,
    Sdate                   DATETIME            NULL,
    PostingDate             DATETIME            NOT NULL,
    Revcode                 VARCHAR(50)         NULL,
    [RevCode Desc]          VARCHAR(500)        NULL,
    CPT                     VARCHAR(50)         NULL,
    Units                   SMALLINT            NULL,
    LineCharges             MONEY               NULL,

    CONSTRAINT PK_Transactions PRIMARY KEY (Surrogate_Key),
    CONSTRAINT FK_Transactions_Account_Number FOREIGN KEY (ACCOUNT_NUMBER) REFERENCES dbo.Account_Number(ACCOUNT_NUMBER),
    CONSTRAINT FK_Transactions_Encounter_Number FOREIGN KEY (ENC_NUMBER) REFERENCES dbo.Encounter_Number(ENC_NUMBER),
    CONSTRAINT FK_Transactions_Rev_Codes FOREIGN KEY (Revcode) REFERENCES dbo.Rev_Codes(REVENUE_CODE)
);

-- Create indexes for Transactions table
CREATE NONCLUSTERED INDEX IX_Transactions_ACCOUNT_NUMBER ON dbo.Transactions(ACCOUNT_NUMBER);
CREATE NONCLUSTERED INDEX IX_Transactions_ENC_NUMBER ON dbo.Transactions(ENC_NUMBER);
CREATE NONCLUSTERED INDEX IX_Transactions_Revcode ON dbo.Transactions(Revcode);
