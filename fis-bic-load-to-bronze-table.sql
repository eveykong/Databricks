-- Databricks notebook source
-- MAGIC %md
# Move data frim redshift to databricks

-- COMMAND ----------
-- MAGIC %sql
-- Create tf_raw_ingest.ok_tb_cc_oz4_b2_acct_ard table in databricks raw ingest schema
CREATE TABLE databricks_workspace_sandbox_03.tf_raw_ingest.ok_tb_cc_oz4_b2_acct_ard (
    bnk_nbr varchar(65535),
      prcs_dte date
      )
      USING PARQUET
         PARTITIONED BY (prcs_dte)
         LOCATION 's3://raw-data-sandbox-813140711/fis_bic/ok/tb_cc_oz4_b2_acct_ard';
    
-- COMMAND ----------
-- MAGIC %sql
-- Copy databricks raw ingest table to databricks tf_warehouse_staging schema
      
CREATE OR REPLACE TABLE databricks_workspace_sandbox_03.tf_warehouse_staging.ok_tb_cc_oz4_b2_acct_ard CLONE databricks_workspace_sandbox_03.tf_raw_ingest.ok_tb_cc_oz4_b2_acct_ard;

-- COMMAND ----------
-- MAGIC %sql
-- Drop the raw_ingest table from databricks   
DROP TABLE databricks_workspace_sandbox_03.tf_raw_ingest.ok_tb_cc_oz4_b2_acct_ard;
