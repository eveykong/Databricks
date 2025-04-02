-- Databricks notebook source
           CREATE TABLE databricks_workspace_sandbox_03.tf_raw_ingest.ok_tb_cc_oz4_b2_acct_ard (
      bnk_nbr varchar(65535),
      prcs_dte date
      )
      USING PARQUET
         PARTITIONED BY (prcs_dte)
         LOCATION 's3://raw-data-sandbox-813140711/fis_bic/ok/tb_cc_oz4_b2_acct_ard';

      CREATE OR REPLACE TABLE databricks_workspace_sandbox_03.tf_warehouse_staging.ok_tb_cc_oz4_b2_acct_ard CLONE databricks_workspace_sandbox_03.tf_raw_ingest.ok_tb_cc_oz4_b2_acct_ard;
      
      DROP TABLE databricks_workspace_sandbox_03.tf_raw_ingest.ok_tb_cc_oz4_b2_acct_ard;
