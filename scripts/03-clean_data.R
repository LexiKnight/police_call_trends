#### Preamble ####
# Purpose: Cleans the raw police data to prepare it for analysis.
# Author: Lexi Knight
# Date: 8 October 2024
# Contact: lexi.knight@mail.utoronto.ca
# License: MIT
# Pre-requisites: follow 01-download_data.R in scripts folder in order to access raw data

#### Workspace setup ####
# install required libraries 
# install.packages("readr")
# install.packages("dplyr")
# install.packages("e1071")

# load required libraries
library(readr)
library(dplyr)
library(e1071) # For skewness and kurtosis


#### Load Data ####
raw_data <- read_csv("data/01-raw_data/police_raw_data.csv")

#### Data Cleaning ####
cleaned_data <- raw_data %>%
  select(YEAR, CATEGORY, TYPE, COUNT_) %>%  # Keep only the specified columns
  distinct() %>%  # Remove exact duplicate rows
  filter(YEAR >= 2014 & YEAR <= 2018)  # Filter for years between 2014 and 2018

#### Output the cleaned data ####
print("Cleaned Data:")
print(cleaned_data)



#### Summary Statistics Function ####
calculate_summary_stats <- function(data, group_vars, is_overall = FALSE) {
  # Convert group_vars from string to symbol for correct grouping
  group_vars_syms <- syms(group_vars) 
  
  if (is_overall) {
    data %>%
      group_by(!!!group_vars_syms) %>%  # Grouping by the actual symbols
      summarise(
        mean_count = mean(COUNT_, na.rm = TRUE),
        median_count = median(COUNT_, na.rm = TRUE),
        mode_count = as.numeric(names(sort(table(COUNT_), decreasing = TRUE)[1])),
        sd_count = sd(COUNT_, na.rm = TRUE),
        range_count = max(COUNT_, na.rm = TRUE) - min(COUNT_, na.rm = TRUE),
        IQR_count = IQR(COUNT_, na.rm = TRUE)
      )
  } else {
    data %>%
      group_by(!!!group_vars_syms) %>%  # Grouping by the actual symbols
      summarise(
        mean_count = mean(COUNT_, na.rm = TRUE),
        median_count = median(COUNT_, na.rm = TRUE),
        mode_count = as.numeric(names(sort(table(COUNT_), decreasing = TRUE)[1]))
      )
  }
}

#### Summary Statistics for Alarm Calls and Calls Received ####
alarm_calls_data <- cleaned_data %>% filter(CATEGORY == "Alarm Calls")
calls_received_data <- cleaned_data %>% filter(CATEGORY == "Calls Received")

# Yearly statistics without sd, range, and IQR
alarm_summary_stats <- calculate_summary_stats(alarm_calls_data, group_vars = c("YEAR", "TYPE"), is_overall = FALSE)
calls_summary_stats <- calculate_summary_stats(calls_received_data, group_vars = c("YEAR", "TYPE"), is_overall = FALSE)

# Overall statistics with sd, range, and IQR
overall_alarm_summary_stats <- calculate_summary_stats(alarm_calls_data, group_vars = c("TYPE"), is_overall = TRUE)
overall_calls_summary_stats <- calculate_summary_stats(calls_received_data, group_vars = c("TYPE"), is_overall = TRUE)

#### Output the summaries ####
print("Summary Statistics for Alarm Calls (Valid and False Alarms) by Year:")
print(alarm_summary_stats)

print("Summary Statistics for Calls Received (Emergency and Non-Emergency) by Year:")
print(calls_summary_stats)

print("Overall Summary Statistics for Alarm Calls (Valid and False Alarms):")
print(overall_alarm_summary_stats)

print("Overall Summary Statistics for Calls Received (Emergency and Non-Emergency):")
print(overall_calls_summary_stats)



#### Summary Statistics for Non-English Languages ####
language_data <- cleaned_data %>% filter(CATEGORY == "Languages")

language_summary_stats <- language_data %>%
  group_by(TYPE) %>%
  summarise(
    mean_count = mean(COUNT_, na.rm = TRUE),
    median_count = median(COUNT_, na.rm = TRUE),
    mode_count = as.numeric(names(sort(table(COUNT_), decreasing = TRUE)[1])),
    sd_count = sd(COUNT_, na.rm = TRUE),
    range_count = max(COUNT_, na.rm = TRUE) - min(COUNT_, na.rm = TRUE),
    IQR_count = IQR(COUNT_, na.rm = TRUE),
    skewness_count = skewness(COUNT_, na.rm = TRUE),
    kurtosis_count = kurtosis(COUNT_, na.rm = TRUE)
  )

#### Output the language summary statistics ####
print("Summary Statistics for Non-English Languages:")
print(language_summary_stats)

#### Save Cleaned Data ####
write_csv(cleaned_data, "data/02-analysis_data/police_analysis_data.csv")

