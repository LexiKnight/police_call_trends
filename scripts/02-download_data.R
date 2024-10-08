#### Preamble ####
# Purpose: Downloads and saves the data from opendatatoronto.
# Author: Lexi Knight
# Date: 7 October 2024
# Contact: lexi.knight@mail.utoronto.ca
# License: MIT


#### Workspace setup ####
# Install the necessary packages if needed
# install.packages("readr")

# Load required libraries
library(readr)


#### Download and save data ####
# Replace with the direct URL to the CSV file
csv_url <- "https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/police-annual-statistical-report-miscellaneous-calls-for-service/resource/af62a2f5-987b-41e6-944b-272256d25619/download/Miscellaneous%20Calls%20for%20Service.csv"

# Download the CSV file and save it
download.file(csv_url, destfile = "data/01-raw_data/police_raw_data.csv")

# Read the CSV file into R
police_raw_data <- read_csv("data/01-raw_data/police_raw_data.csv")

# Print the first few rows of the data as a check
head(police_raw_data)



