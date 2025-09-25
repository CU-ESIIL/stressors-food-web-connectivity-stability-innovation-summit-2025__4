### Download and filter Lake Champlain - Main Lake data


# Install packages
if (!requireNamespace("dataRetrieval", quietly = TRUE)) {
  install.packages("dataRetrieval")
}

# Load packages
library(dataRetrieval)


# If working in cyverse, set working directory and project root
setwd("/home/joyan/data-store/stressors-food-web-connectivity-stability-innovation-summit-2025_4")
#here::i_am("README.md")   # or any file guaranteed to exist in the project

# Site code for "50 - Missisquoi bay"
site_id <-  "1VTDECWQ-500476"
#Other site IDs for site 50: c["1VTDECWQ-523002", "1VTDECWQ-500477",

# Query WQP directly and stream into R
lc_wq_dat <- readWQPdata(
  siteid = site_id,
  providers = c("NWIS", "STORET")
)

# Inspect results
head(lc_wq_dat)
names(lc_wq_dat)
nrow(lc_wq_dat)

# Load necessary libraries
library(dplyr)
library(ggplot2)



# Filter for temperature
tempData <- lc_wq_dat %>% filter(CharacteristicName == "Temperature, water")

# Plot temperature over time
ggplot(tempData, aes(x = ActivityStartDate, y = ResultMeasureValue)) +
  geom_line() +
  geom_point() +
  labs(title = "Temperature Over Time",
       x = "Year",
       y = "Temperature") +
  theme_minimal()

tempData$ActivityStartDate

#Remove the single 1994 data point: 

# Assuming your data frame is called df
temp_filtered <- tempData %>% filter(ActivityStartDate != "1994-06-08" )

#Regraph:
ggplot(temp_filtered, aes(x = ActivityStartDate, y = ResultMeasureValue)) +
  geom_line() +
  geom_point() +
  labs(title = "Temperature Over Time",
       x = "Year",
       y = "Temperature") +
  theme_minimal()
