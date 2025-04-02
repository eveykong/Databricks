-- Databricks notebook source
select --base.table_name,
'      CREATE TABLE databricks_workspace_sandbox_03.default.'||substring(base.table_name,4)||' (
      '||base.column_name||' '||base.data_type_translate||',
      prcs_dte date
      )
      USING PARQUET
         PARTITIONED BY (prcs_dte)
         LOCATION ''s3://raw-data-sandbox-813140711/fis_bic/'||substring(base.table_name,1,2)||'/'|| substring(base.table_name,4)||''';'||'
      CREATE OR REPLACE TABLE databricks_workspace_sandbox_03.bronze.'||base.table_name||' CLONE databricks_workspace_sandbox_03.default.'||substring(base.table_name,4)||';
      DROP TABLE databricks_workspace_sandbox_03.default.'||substring(base.table_name,4)||';'||
      case when history.table_name is not null then '
        CREATE TABLE databricks_workspace_sandbox_03.default.'||substring(base.table_name,4)||'_history
        USING PARQUET
            LOCATION ''s3://raw-data-sandbox-813140711/ods_history/'||substring(base.table_name,1,2)||'/'|| substring(base.table_name,4)||''';
        merge WITH SCHEMA EVOLUTION INTO databricks_workspace_sandbox_03.bronze.'||base.table_name||'  -- allows extra columns in history in
        using databricks_workspace_sandbox_03.default.'||substring(base.table_name,4)||'_history
        on 1 = 2
        WHEN NOT MATCHED
       THEN INSERT * ;
        DROP TABLE databricks_workspace_sandbox_03.default.'||substring(base.table_name,4)||'_history;'
     else 
        ''
     end as sql
from (select s.* , min(ordinal_position) over (partition by table_catalog, table_schema, table_name) mop,
      case data_type
       when 'character varying'
         then 'varchar('||character_maximum_length||')'
       when 'timestamp without time zone'
         then 'timestamp'  
       else 
         data_type
       end data_type_translate
              from svv_columns s
             where table_schema = 'tf_raw_ingest'
               and substring(table_name,3,1) = '_') base
           left outer join 
           (select *               
              from svv_tables 
             where table_schema like '%external_raw%') history
            on base.table_name = history.table_name
where base.ordinal_position = mop  -- get an extra column for the table\r\n  order by table_name, ordinal_position
  and base.table_name = 'o3_tb_ci_oz9_acct_ard'
order by base.table_name