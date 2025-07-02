# USA Home Valuations Exploratory Data Analysis
## ELT & Data Lakehousing with Snowflake & dbt
![Image alt](https://github.com/tebogo-m/zillow-usa-project/blob/main/images/diagrams/Updated_Achictecture_Diagram.drawio.png)

### Background and Overview:
This Exploratory Data Analysis set out to explore ***how home values for 1-bedroom homes in the USA have changed*** over the years spanning ***1996-2025.*** Throughout the analysis process, trends emerged, largely linked to major economic events within the USA. This prompted further exploration of the dataset, focused on these major economic events, with an emphasis on the ***housing market crash of 2007-2009.***

#### Insights are provided in the following areas:
- ***Home Value Trend Analysis:*** Analysis of the historical home values for 1-bedroom homes in the USA
- ***Top 10 significantly impacted states:*** Analysis of the 10 states that saw the highest decline in home values across 1-bedroom homes due to the housing market crash
- ***Nominal Home Value Recovery:*** Analysis of how many of the aforementioned 10 states have since recovered their nominal home value for 1-bedroom homes
- ***Inflation-Adjusted Home Value Recovery:*** Analysis of how many of the aforementioned 10 States have since recovered their real (inflation-adjusted)  home value for 1-bedroom homes

 **Note**: This project analyses the Zillow Home Value Index (ZHVI) for 1-bedroom homes (Z1BR). ZHVI represents the typical home value which is a seasonally adjusted, weighted average of the middle tier of the market (35th–65th percentile). It is distinct from median or mean values, as it excludes extreme highs/lows to reflect mainstream pricing trends.

### Technical Overview
- Built an ELT data pipeline within a Medallion Architecture-aligned data lakehouse on Snowflake.
- Extracted/Downloaded Zillow Real Estate CSV files from Nasdaq Data Link
- Converted large CSV file into parquet format for smoother  and faster upload into Lakehouse
- Loaded raw data files into Snowflake staging tables
- Transformed the data using **dbt models (written in [SQL](https://github.com/tebogo-m/zillow-usa-project/blob/main/zillow_pipeline/models/gold/gold_zillow_home_values_states_cpi_finrecovery_1br.sql) & [Python](https://github.com/tebogo-m/zillow-usa-project/blob/main/zillow_pipeline/models/gold/gold_zillow_home_values_states_allbr_py.py))** as follows:
  - [Bronze Layer](https://github.com/tebogo-m/zillow-usa-project/tree/main/zillow_pipeline/models/bronze): Created a 1:1 representation of raw data from Snowflake staging tables.
  - [Silver Layer](https://github.com/tebogo-m/zillow-usa-project/tree/main/zillow_pipeline/models/silver): Performed cleaning and filtering to enhance data quality.
  - [Gold Layer](https://github.com/tebogo-m/zillow-usa-project/tree/main/zillow_pipeline/models/gold): Curated and aggregated data for optimal performance and analytical readiness.
- Connected final Gold-layer data in Snowflake to **Tableau for visualization**


### Data Structure Overview
The ***database structure*** for this project consists of 3 tables:  zillow_home_values, zillow_regions and zillow_indicators with a ***total row count of 159,008,830 (159M) records***.

Below is the ***ER (Entity Relationship Diagram)*** for the dataset used throughout the project:
![Image alt](https://github.com/tebogo-m/zillow-usa-project/blob/main/images/diagrams/ER_diagram.png)


Below is the resultant ***dbt lineage*** which outlines the ***data models*** created throughout the analysis process:
![Image alt](https://github.com/tebogo-m/zillow-usa-project/blob/main/images/diagrams/dbt_lineage_final.png)

### Executive Summary

***Overview of Findings***

While the housing market crash primarily occurred between 2007 and 2009, its long-term effects persist, evident almost two decades later. Some of the most severely impacted U.S. states experienced dramatic declines, with typical 1-bedroom home values plummeting by up to 70% between 2007 and 2012. Interestingly, the COVID-19 pandemic significantly accelerated the nominal value recovery for these homes across the USA. However, a complete inflation-adjusted recovery for home values remains unobserved in 50% of the heavily impacted states.

Here is a snapshot of the ***Tableau dashboard for the date range 1996-2025:*** 

![Image alt](https://github.com/tebogo-m/zillow-usa-project/blob/main/images/dashboard_screenshots/final_dashboard_for_uploading_06_2025.png)

### Insights Deep Dive


***Home Value Trends:***

![Image alt](https://github.com/tebogo-m/zillow-usa-project/blob/main/images/dashboard_screenshots/usa_typical_home_values_for_1_bedroom_homes_1996_to_2025_final_image.png)

- This visualisation highlights two significant periods: the ***2007-2009 housing market crash*** and the ***2020 COVID-19 pandemic***, both marked by lasting economic after-effects.
- Despite concluding within 1-2 years, the 2007-2009 housing market crash led to continued declines in typical U.S. home values for 1-bedroom homes until 2012.
- Home value recovery, initiated post-2012, was significantly accelerated by market conditions following the COVID-19 pandemic.

***Top 10 Significantly Impacted States 2007-2012***
![Image alt](https://github.com/tebogo-m/zillow-usa-project/blob/main/images/dashboard_screenshots/top_10_declining_states_map_2007_to_2012.png)

- This analysis identified the top 10 U.S. states most affected throughout the decline period of 2007-2012
- Nevada experienced the most significant drop, with 1-bedroom home values plummeting by 70%, while other major economic hubs like Florida (-55%) and California (-43%) also saw substantial declines.
- Notably, no states from the central, largely rural, parts of the USA were among the top 10 states with the greatest home value losses during this period.

***Nominal Home Value Recovery***
![image alt](https://github.com/tebogo-m/zillow-usa-project/blob/main/images/dashboard_screenshots/total_years_to_recover_nominal_value.png)

- This analysis determined the recovery timelines for the top 10 most impacted states, using 2006 typical 1-bedroom home values as the benchmark home value to define "recovery."
- All ten states have nominally recovered their 2006 home values, with the first recovery occurring in Washington (2016) and the last in Nevada (2022).
- Notably, only four of the 10 states recovered their home values before the COVID-19 pandemic, while the majority recovered during or after it.

***Inflation-Adjusted Home Value Recovery***
![Image alt](https://github.com/tebogo-m/zillow-usa-project/blob/main/images/dashboard_screenshots/total_years_to%20recover_cpi_adjusted_06_2025_new.png)

- To accurately assess recovery, the Consumer Price Index (a measure of inflation) was applied, determining a "true recovery year" when home values regained their 2006 purchasing power.
- This inflation-adjusted analysis shows only 5 of the 10 most impacted states have truly recovered, meaning 50% remain in recovery.
- Of the inflation-adjusted recoveries no recoveries occurred earlier than 10 years after the start of the housing market crash in 2007.
- The inflation adjustment pushes back the previously observed nominal home value recovery by 1-2 years. 
- Taking this trend into account, states that have not yet achieved an inflation-adjusted recovery could potentially recover within the next five years if market conditions continue to remain favourable.

### Further Considerations

Outside of these insights, there are multiple factors that determine home values within a country. Another key factor, which has not been explored in this analysis yet could have had a very strong impact on 1-bedroom home value recovery, is the boom of Airbnb over the past 2 decades. Although this dataset only takes the Covid-19 pandemic as the main catalyst for the recovery observed, other factors should not be discounted. 


### Conclusion
This analysis reveals how the 2007-2009 housing market crash and COVID-19 reshaped U.S. home values, with half of impacted states still below pre-crash inflation-adjusted levels. By building an ELT pipeline in Snowflake and transforming 159M+ records using dbt, I uncovered persistent disparities, like Nevada’s 70% decline, that could inform real estate investment strategies. While nominal recoveries spiked post-2020, true inflation-adjusted recovery remains incomplete, suggesting long-term risks for homeowners in certain markets. This analysis could potentially be further enriched with rental data.






