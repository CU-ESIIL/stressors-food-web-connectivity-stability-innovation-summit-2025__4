### Download and filter Lake Champlain - Main Lake data


# Install packages
if (!requireNamespace("dataRetrieval", quietly = TRUE)) {
  install.packages("dataRetrieval")
}

# Load packages
library(dataRetrieval)


# If working in cyverse, set working directory and project root
#setwd("/home/jovyan/data-store/stressors-food-web-connectivity-stability-innovation-summit-2025_4")
#here::i_am("README.md")   # or any file guaranteed to exist in the project


# Query WQP directly and stream into R
lc_wq_dat <- readWQPdata(
  countrycode = "US",
  statecode = "US:50",
  siteType = "Lake, Reservoir, Impoundment",
  organization = "1VTDECWQ",
  huc = "04150408",
  providers = c("NWIS", "STORET"),
  sampleMedia = c("Water", "Biological"),
  startDateLo = "2000-01-01",
  startDateHi = "2010-12-31"
)

# Inspect results
head(lc_wq_dat)
names(lc_wq_dat)
