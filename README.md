**PHP-2560-Programming-in-R Final Group Project Abednego, Safi and Caleb**

**Tobacco Use in the United States**

  Tobacco Use in the U.S. 1990 - 2030 is a Shiny app that allows users to explore the Center for Disease Control and Prevention's Behavioral Risk Factor Surveillance System (BRFSS) Prevalence and Trends Data: Tobacco Use - Four Levels Smoking Data for 1995 - 2010 [1]. By accessing the applicaton, users can examine tobacco use rates over time across the United States. As the BRFSS dataset utilized in this shiny app is limited in timespan (1990 to 2010) this shiny app additionally provides users with a visual representation of future data simulations by plotting the best fit model as determined by the application selection criteria. The link to the app is: 
  
 **Dataset**
 
 Tobacco_Use_Data_for_1995-2010.xlsx
 
 **Source**
 
[1] Centers for Disease Control and Prevention. (2015, August 27). BRFSS prevalence and trends data: Tobacco use - four level smoking data for 1995-2010. Centers for Disease Control and Prevention. Retrieved December 15, 2021, from https://data.cdc.gov/Smoking-Tobacco-Use/BRFSS-Prevalence-and-Trends-Data-Tobacco-Use-Four-/8zak-ewtm 

This dataset comes from the Center for Disease Control and Prevention's website https://data.cdc.gov/Smoking-Tobacco-Use/BRFSS-Prevalence-and-Trends-Data-Tobacco-Use-Four-/8zak-ewtm and contains 876 unique records across 7 columns.  We downloaded this dataset from the CDC's website. As this dataset is regularly maintained by CDC, minimal data cleaning and preparation steps are needed and all necessary steps are taking in the app. The data origination and access legality is all covered by the CDC as the CDC provides public access to this dataset via their data.cdc.gov website. There are no privacy concerns worth noting in this dataset as all data records are non-descript or personally identifiable to any one individual. Furthermore, the CDC makes this dataset publicly accessible.
 
 **Packages**
 
 This shiny app requires the use of:
 
    dplyr - for data cleaning and manipulation
    ggplot2 - for data visualization
    shinywidgets - for application creation and publication
    dslabs - for data science techniques
    plotly - for data visualization
    tidyverse - for data cleaning and manipulation
    shiny - for application creation and publication
    readr - for text data manipulation
    broom - for data manipulation
    rlang - for tidyverse function utlization
    
 **In-App**
 1. In the app users start by choosing their selection criteria. Here users have three possible inputs to change: Measure, State and Year. The measure input is a drop down selection for one of the four measures collected in this dataset: Never smokers, sometimes smokers, former smokers and everyday smokers. The next dropdown is for State. Here users can select the state they are interested to examine. Here users can also specify if they want to examine the 50 states, Puerto Rico, Guam, the Virgin Islands or nationwide (including DC). Finally users have access to a sliding range panel where users can specify the time frame of interested by selecting the start and end years of interest. 
 2. After the user has established their selection criteria the shiny app will automatically populate a percentage over time line plot with two lines. The dark colored line represents historical data while the red colored line represents the best fit model simulation as outlines below.
 3. The best fit model simulation is determined using the get_model(). This model uses the Year1 input (the lower end of the Year sliding scale input). This function compares statistical significance between the quadratic regression model and the pre-determined 0.05 significance level and outputs the quadratic model if the p-value as determined by the lmp() function is less than 0.05. If this p-value is greater than 0.05 the linear model is assigned as the best_model. 
 4. Using the best_model output from the get_model() function the predict_model() function uses the best_model to simulate future datapoints for the selected time frame (the time between Year1 and Year2) and plots these points on a line graph in red and plots historical data in black. 
 
 **Functions**
 
 **lmp(modelobject)** - finds the p-value for a given model
    modelobject = regression model (linear or quadratic)
    
 **get_model(State, Year1, Var)** - Takes in selection criteria and determines which model, linear or quadratic, is the best fit model for the given selection criteria. Returns the best fit model. 
    State = One of the drop down selections (All 50 states, nationwide, and DC)
    Year1 = Start year; encompasses all datapoints in or before the given year
    Var = One of the drop down selections (Never smoked, Former smoker, Smoke somedays or Smoke everyday)
    
 **predict_model(State, Year1, Year2, Var)** - Using the model determined in the get_model function, this function simulated future datapoints for the specified time period range and plots these points in a data visualization panel. 
    State = One of the drop down selections (All 50 states, nationwide, and DC)
    Year1 = Start year; encompasses all datapoints in or after the given year
    Year2 = End year; encompasses all datapoints in or before the given year
    Var = One of the drop down selections (Never smoked, Former smoker, Smoke somedays or Smoke everyday)
 
 
 
 
