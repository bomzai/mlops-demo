-- By default, DBT store transformation as views,
-- we can change this behavior by adding the config() steps below
{{ config(
   materialized='table'
) }}

SELECT
  tconst,
  UPPER(titleType) as titleType,
  UPPER(primaryTitle) AS primaryTitle,
  originalTitle,
  isAdult,
  startYear,
  endYear,
  runtimeMinutes,
  genres
FROM {{ source('postgres','basics') }} -- source is used to reference "external sources" 
                                       -- coming from outside DBT with an EL tool for example