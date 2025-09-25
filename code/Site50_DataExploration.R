# Site 50 - shallow lake site - visuals
# Alyssa Gleichsner
# Last updated: 2025-09-25

#Load libraries:
library(tidyverse)
install.packages("dataRetrieval")
library(dataRetrieval)
install.packages("janitor")
library(janitor)
library(dplyr)
library(ggplot2)

# Define custom ggplot themes for consistent plot styling
mytheme <- theme_classic() +
  theme(
    axis.title.y = element_text(margin = margin(t = 0, r = 10, l = 0)),
    axis.title.x = element_text(margin = margin(t = 10, l = 0)),
    text = element_text(size = 13)
  )

characteristics <- c(
  "Chlorophyll a",
  "Chlorophyll a, corrected for pheophytin",
  "Depth, Sechhi disk depth",
  "Dissolved oxygen (DO)",
  "Dissolved oxygen saturation",
  "Nitrogen",
  "Phosphorus",
  "Orthophosphate",
  "Silica",
  "Specific conductance",
  "Temperature, water",
  "Total suspended solids",
  "Turbidity",
  "pH"
)

# Site 50 - Missisqoi Bay (shallow lake site)
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
lc_wq_dat %>% count(CharacteristicName)

min(lc_wq_dat$ActivityStartDate) # 1980-04-11
max(lc_wq_dat$ActivityStartDate) # 2023-11-16

unique(lc_wq_dat$ActivityMediaName) # only 'Water'


data <- lc_wq_dat


lc_annual <- data %>% remove_empty(which = "cols") %>%
  mutate(ResultMeasureValue = as.numeric(ResultMeasureValue)) %>%
  filter(!is.na(ResultMeasureValue)) %>%
  mutate(year = year(ActivityStartDate)) %>%
  group_by(CharacteristicName, year) %>%
  summarise(
    mean_val = mean(ResultMeasureValue, na.rm = TRUE),
    sd_val = sd(ResultMeasureValue, na.rm = TRUE)
  ) %>%
  mutate(
    CharacteristicName = if_else(
      CharacteristicName == "Chlorophyll a" |
        CharacteristicName == "Chlorophyll a, corrected for pheophytin",
      "Chlorophyll",
      CharacteristicName
    )
  )



#Graph it
  
lc_annual %>%
  filter((
    CharacteristicName %in%
      c("Chlorophyll",
        "Dissolved oxygen (DO)",
        "Phosphorus",
        "Silica",
        "Temperature, water")
  )) %>%
  ggplot() +
  geom_line(aes(x = year, y = mean_val, color = CharacteristicName)) +
  # geom_pointrange(aes(x = year, y = mean_val, ymin = mean_val - sd_val, ymax = mean_val + sd_val, color = characteristic_name)) +
  mytheme +
  labs(
    x = "Year",
    y = NULL,
    title = "Water quality data in Missisquoi Bay, Lake Champlain over time",
    subtitle = "Site ID: 1VTDECWQ-500476, Site 50",
    color = NULL
  ) + geom_vline(xintercept = c(1993, 2003, 2009, 2010, 2014, 2018), 
               linetype = "dashed", color = "red")


