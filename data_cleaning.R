# data cleaning for structural gravity modelling
# data:

# version 1.0 (24/01/22)

#load packages
library(tidyverse)
library(readxl)

# read in data
trade <- read_csv("BACI_HS92_Y2015_V202102.csv")  # trade data
gravity <- read_xls("dist_cepii.xls") # bilateral gravity variables from CEPII
#tariffs <- 

# HS6 codes to filter the data down to size
hs6_codes <- read_csv("CBAM_HS6_codes.csv") # read in codes
trade <- filter(trade, k %in% hs6_codes$`HS6 code`) # filter data by codes

# country codes to ensure the data uses the same
country_codes <- read_csv("country_codes_V202102.csv")
trade <- left_join(trade, country_codes, by = c("i" = "country_code"))
trade <- left_join(trade, country_codes, by = c("j" = "country_code"),
                   suffix = c(".exp",".imp"))

# filter trade for columns we want
trade <- select(trade, c("t", "k", "v", 
                         "iso_3digit_alpha.exp", "iso_3digit_alpha.imp"))
trade <- trade %>% 
  rename(year = t,
         hs6 = k,
         trade = v,
         iso_o = iso_3digit_alpha.exp,
         iso_d = iso_3digit_alpha.imp)

# join trade and gravity together
dat <- left_join(trade, gravity)
