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

# Site code for "19 - Main Lake"
site_id <- "1VTDECWQ-503411"

# Query WQP directly and stream into R
lc_wq_dat <- readWQPdata(
  siteid = site_id,
  providers = c("NWIS", "STORET")
)

# Inspect results
head(lc_wq_dat)
names(lc_wq_dat)
nrow(lc_wq_dat)


# Inspect which characteristic names are available
unique_chars <- unique(lc_wq_dat$CharacteristicName)

# Look for plankton-related entries
grep("zoop", unique_chars, ignore.case = TRUE, value = TRUE)
