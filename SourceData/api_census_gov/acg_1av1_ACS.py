import requests ## Required for the Census API
import pandas as pd # For reading, writing and wrangling data
import json # used to read in metadata for Census variables
import numpy as np # For setting missing values
import urllib.request, json  # reading in json files

class planning_methods():
  """
  Python File with Functions used in Planning Methods Course.

  version 0.0.2 2022-06-15T1246
  version 0.1.0 2026-02-19 - Update for URSC 645 - Urban and Regional Analytics

  """

  def obtain_census_api(
                      state: str = "*",
                      county: str = "*",
                      census_geography: str = 'county:*',
                      vintage: str = "2010", 
                      dataset_name: str = 'dec/sf1',
                      get_vars: str = 'GEO_ID'):

          """General utility for obtaining census from Census API.

          Args:
              state (str): 2-digit FIPS code. Default * for all states
              county (str): 3-digit FIPS code. Default * all counties
              census_geography (str): example '&for=block:*' would be for all blocks
                default is for all counties
              vintage (str): Census Year. Default 2010
              dataset_name (str): Census dataset name. Default Decennial SF1
              for a list of all Census API
              get_vars (str): list of variables to get from the API.

          Returns:
              obj, dict: A dataframe for with Census data

          """
          # Check geography hierarchy
          if (
            census_geography == 'county:*' or 
            census_geography == 'tract:*' or 
            census_geography == 'block:*'
            ):
            geography_hierarchy =  '&in=state:' + state + '&in=county:' + county 
          else:
            geography_hierarchy = ''
          # Set up hyperlink for Census API
          api_hyperlink = ('https://api.census.gov/data/' + vintage + '/'+dataset_name + '?get=' + get_vars +
                          geography_hierarchy + '&for=' + census_geography)

          print("Census API data from: " + api_hyperlink)

          # Obtain Census API JSON Data
          apijson = requests.get(api_hyperlink)

          # Convert the requested json into pandas dataframe
          df = pd.DataFrame(columns=apijson.json()[0], data=apijson.json()[1:])

          return df


  def clean_acs_variables(df,vintage,dataset_name,get_vars, print_annotations = False):
    """
    Function runs loop to rename variables, set variable type, and 
    address missing values in ACS data.
    """

    for variable in get_vars.split(","):
      variable_metadata_hyperlink = (f'https://api.census.gov/data/{vintage}/{dataset_name}/variables/{variable}.json')
      # Obtain Census API JSON Data
      print("Census API metadata from: "+ variable_metadata_hyperlink)
      metadata_json = requests.get(variable_metadata_hyperlink).json()

      # Find the variable label 
      census_label_string = str(metadata_json["label"])
      last_exclamation_point_position = census_label_string.rfind("!!")
      if last_exclamation_point_position >= 0:
        last_exclamation_point_position = last_exclamation_point_position + 2
      else:
        last_exclamation_point_position = 0
      label = census_label_string[last_exclamation_point_position:] 

      # Add vintage to label name (skip geo_id and name variables)
      if variable not in ['GEO_ID','NAME']:
        label_addvintage = label + f' {vintage}'
      else:
        label_addvintage = label

      # Add estimate or Margin of Error to label
      last_letter_of_variable = variable[-1]
      if variable not in ['GEO_ID','NAME']:
        if last_letter_of_variable == 'E':
          label_addvintage_addtype = label_addvintage + ' (Estimate)'
        if last_letter_of_variable == 'M':
          label_addvintage_addtype = label_addvintage + ' (MOE)'
      else:
        label_addvintage_addtype = label_addvintage
      if print_annotations == True:
        print(vintage,"Renaming",variable," = ",label_addvintage_addtype,"Changing type to",metadata_json["predicateType"])

      # Change variable type
      df[variable] = df[variable].astype(metadata_json["predicateType"])

      # Reset Estimates and MOE with Annotation Values
      Annotation_values = {-999999999 : 'Number of sample cases is too small.',
      -888888888 : 'Estimate is not applicable or not available.',
      -666666666 : 'No sample observations or too few sample observations were available to compute an estimate.',
      -555555555 : 'Estimate is controlled. A statistical test for sampling variability is not appropriate.',
      -333333333 : 'Median falls in the lowest interval or upper interval of an open-ended distribution. A statistical test is not appropriate.',
      -222222222 : 'No sample observations or too few sample observations were available to compute a standard error and thus the margin of error. A statistical test is not appropriate.'}

      for Annotation_value in Annotation_values:
        observations_with_annotation = len(df.loc[(df[variable] == Annotation_value)])
        if observations_with_annotation > 0:
          if print_annotations == True:
            print(observations_with_annotation,"Observations have",Annotation_value)
            print(Annotation_values[Annotation_value])
            print('Replacing values with missing.')
          df.loc[(df[variable] == Annotation_value), variable] = np.nan


      df = df.rename(columns={variable: label_addvintage_addtype}) 

    return df


  def create_data_dictionary(df, vintage, dataset_name, get_vars):
    """
    Function creates a data dictionary for the variables in the dataframe.
    
    Args:
        df: pandas DataFrame with the data
        vintage: Census year (e.g., '2022')
        dataset_name: Census dataset (e.g., 'acs/acs5')
        get_vars: comma-separated string of variable names (e.g., 'B19013_001E,B19013_001M')
    
    Returns:
        data_dictionary: DataFrame with columns 'name', 'label', 'concept' containing metadata
    """
    
    metadata_records = []
    
    # Get metadata for each variable
    for variable in get_vars.split(","):
      variable = variable.strip()
      variable_metadata_hyperlink = (f'https://api.census.gov/data/{vintage}/{dataset_name}/variables/{variable}.json')
      metadata_json = requests.get(variable_metadata_hyperlink).json()
      
      metadata_records.append({
        'name': metadata_json['name'],
        'label': metadata_json['label'],
        'concept': metadata_json['concept']
      })
    
    # Create dataframe from metadata records
    data_dictionary = pd.DataFrame(metadata_records)
    
    # Filter to only variables that exist in the dataframe columns
    data_dictionary = data_dictionary[data_dictionary['name'].isin(df.columns)]
    
    # Sort by name
    data_dictionary = data_dictionary.sort_values(by='name').reset_index(drop=True)
    
    return data_dictionary