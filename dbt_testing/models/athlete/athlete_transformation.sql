-- By default, DBT store transformation as views,
-- we can change this behavior by adding the config() steps below
{{ config(
   materialized='table'
) }}

SELECT
  UPPER(contactLastName) as contactLastName
FROM {{ source('postgres','customers') }} -- source is used to reference "external sources" 
                                       -- coming from outside DBT with an EL tool for example