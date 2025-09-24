# ESIIL Summit Data Exploration
# Ruby Krasnow
# Last updated: 2025-09-24

library(tidyverse)
library(dataRetrieval)
library(janitor)

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

# also Main Station but different location and only 1990-1996
# siteid = "1VTDECWQ-500452"

# Query WQP directly and stream into R
# 557622 obs of 65 variables! from 1980-04-11 to 2023-11-16
lc_wq_dat <- readWQPdata(
  countrycode = "US",
  statecode = "US:50",
  siteType = "Lake, Reservoir, Impoundment",
  organization = "1VTDECWQ",
  huc = "04150408",
  providers = c("NWIS", "STORET"),
  sideid = "1VTDECWQ-500456"
  # startDateLo = "2000-01-01",
  # startDateHi = "2010-12-31"
)

# Inspect results
head(lc_wq_dat)
names(lc_wq_dat)
lc_wq_dat %>% count(CharacteristicName)

min(lc_wq_dat$ActivityStartDate) # 1980-04-11
max(lc_wq_dat$ActivityStartDate) # 2023-11-16

unique(lc_wq_dat$ActivityMediaName) # only 'Water'

lc_water <- lc_wq_dat %>%
  filter(CharacteristicName %in% characteristics) %>%
  filter(!is.na(ResultMeasureValue)) %>%
  remove_empty(which = "cols") %>% clean_names()

# write_csv(lc_water, "lc_water_2025-09-24.csv") # >190 MB

water_temp <- lc_water %>%
  filter(characteristic_name == "Temperature, water") %>%
  remove_empty(which = "cols") %>%
  mutate(result_measure_value = as.numeric(result_measure_value))

summary(water_temp$activity_start_date) # 1990-05-01 to 2023-11-16

ggplot(water_temp) +
  geom_line(aes(x = activity_start_date, y = result_measure_value)) +
  mytheme +
  labs(x = "Year", y = "Temp (°C)", title = "Water temperature in Lake Champlain, 1990-2023")

phosphorus <- lc_water %>%
  filter(characteristic_name == "Phosphorus") %>%
  remove_empty(which = "cols") %>%
  mutate(result_measure_value = as.numeric(result_measure_value))

summary(phosphorus$activity_start_date) # 1980-05-01 to 2023-11-16

ggplot(phosphorus) +
  geom_line(aes(x = activity_start_date, y = result_measure_value)) +
  mytheme +
  labs(x = "Year", y = "P (ug/L)", title = "Phosphorus in Lake Champlain, 1980-2023")

lc_wq_summary <- readWQPsummary(
  countrycode = "US",
  statecode = "US:50",
  siteType = "Lake, Reservoir, Impoundment",
  organization = "1VTDECWQ",
  huc = "04150408",
  providers = c("NWIS", "STORET")
)

lc_wq_summary %>%
  count(CharacteristicType)

lc_wq_summary %>%
  filter(CharacteristicType == "Biological, Algae, Phytoplankton") %>%
  count(CharacteristicName) # All Chlorophyll, no plankton

lc_means <- lc_water %>% remove_empty(which = "cols") %>%
  mutate(result_measure_value = as.numeric(result_measure_value)) %>%
  filter(!is.na(result_measure_value)) %>%
  group_by(characteristic_name, activity_start_date) %>%
  summarise(mean_val = mean(result_measure_value))

lc_wide <- lc_water %>% remove_empty(which = "cols") %>%
  mutate(result_measure_value = as.numeric(result_measure_value)) %>%
  filter(!is.na(result_measure_value)) %>%
  pivot_wider(names_from = "characteristic_name", values_from = "result_measure_value") %>%
  mutate(
    chl_a = if_else(
      is.na(`Chlorophyll a, corrected for pheophytin`),
      `Chlorophyll a`,
      `Chlorophyll a, corrected for pheophytin`
    ),
    .keep = "unused"
  )


lc_annual <- lc_water %>% remove_empty(which = "cols") %>%
  mutate(result_measure_value = as.numeric(result_measure_value)) %>%
  filter(!is.na(result_measure_value)) %>%
  mutate(year = year(activity_start_date)) %>%
  group_by(characteristic_name, year) %>%
  summarise(
    mean_val = mean(result_measure_value, na.rm = TRUE),
    sd_val = sd(result_measure_value, na.rm = TRUE)
  ) %>%
  mutate(
    characteristic_name = if_else(
      characteristic_name == "Chlorophyll a" |
        characteristic_name == "Chlorophyll a, corrected for pheophytin",
      "Chlorophyll",
      characteristic_name
    )
  )

lc_annual %>% count(characteristic_name)

lc_annual %>%
  filter((
    characteristic_name %in%
      c("Chlorophyll",
        "Dissolved oxygen (DO)",
        "Phosphorus",
        "Silica",
        "Temperature, water")
  )) %>%
  ggplot() +
  geom_line(aes(x = year, y = mean_val, color = characteristic_name)) +
 # geom_pointrange(aes(x = year, y = mean_val, ymin = mean_val - sd_val, ymax = mean_val + sd_val, color = characteristic_name)) +
  mytheme +
  labs(
    x = "Year",
    y = NULL,
    title = "Water quality data in Lake Champlain, 1980-2023",
    subtitle = "Site ID: 1VTDECWQ-500456",
    color = NULL
  )