# USA Home Valuations Exploratory Data Analysis
## ELT & Data Lakehousing with Snowflake & dbt
### Background and Overview:
This Exploratory Data Analysis set out to explore how home values in the USA have changed over the years spanning 1996-2024. Throughout the analysis process trends emerged, largely linked to major economic events within the USA. This prompted further exploration of the dataset, focused on these major economic events, with an emphasis on the housing market crash of 2007-2009.

To conduct this analysis, ELT principles and a Medallion-aligned data lakehouse architecture were used to build a pipeline in Snowflake. Raw data was first loaded into Snowflake stages, then transformed using dbt into the Bronze layer (1 to 1 relationship with Raw Data files). From there, it was further processed via dbt models (SQL & Python) into the Silver layer (cleaned and filtered data), culminating in the Gold layer (curated and aggregated data), ensuring data quality and optimized performance. Final Gold-layer data in Snowflake was then visualized in Tableau, in order to provide key insights for this analysis.

