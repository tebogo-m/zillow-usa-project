# python model calculates the year-over-year (YOY) percentage change in average home values for each state and indicator
# model is created as a python function with relevant packages imported first
# model excludes District of Columbia data as it is erroneously listed as a state in the dataset
# model sorts the data by state, indicator_id and valuation to make the pct_change calculation possible
# model then groups the sorted data by state and indicator id to ensure the pct change calc does not calculate the pct_change using data from 2 different states or 2 different indicators 
# due to the nature of the pct_change calculation the year 1996 will have a null value as there is no data for the year 1995 hence the usage of fillna
# fillna fills any null values with 0
# the results are rounded to 2 decimal places
# dataframe results are returned in the column order specified (this is how the data will appear in Snowflake)

import pandas as pd
from snowflake.snowpark.functions import col

def model(dbt, session):
    df = dbt.ref('gold_zillow_home_values_states').to_pandas()

    df_filtered = df[df['STATE'] != 'District of Columbia']

    df_sorted = df_filtered.sort_values(by=['STATE','INDICATOR_ID','VALUATION_YEAR'])
    df_sorted['YOY_PERCENTAGE_CHANGE'] = df_sorted.groupby(['STATE', 'INDICATOR_ID'])['AVG_HOME_VALUE'].pct_change()*100
    df_sorted['YOY_PERCENTAGE_CHANGE'] = df_sorted['YOY_PERCENTAGE_CHANGE'].fillna(0)
    df_sorted['YOY_PERCENTAGE_CHANGE'] = df_sorted['YOY_PERCENTAGE_CHANGE'].round(2)

    result_df = df_sorted
    return result_df[['STATE', 'INDICATOR_ID', 'VALUATION_YEAR','AVG_HOME_VALUE','YOY_PERCENTAGE_CHANGE']]