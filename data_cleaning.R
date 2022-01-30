# data cleaning for structural gravity modelling
# version 1.0 (24/01/22)

#load packages
library(tidyverse)
library(readxl)

# read in data and codes
trade <- read_csv("BACI_HS07_Y2014_V202102.csv")  # trade data
gravity <- read_xls("dist_cepii.xls") # bilateral gravity variables from CEPII
country_codes <- read_csv("country_codes_V202102.csv")
hs6_codes <- read_csv("CBAM_HS6_codes.csv") # read in codes

# read in tariff data
data_files <- list.files("C:/Rprojects/international_econ/tariffs")  # Identify file names
for(i in 1:length(data_files)) {                              # Head of for-loop
  assign(paste0("data", i),                                   # Read and store data frames
         read.delim(paste0("C:/Rprojects/international_econ/tariffs/",
                          data_files[i])))
}
tariffs1 <- rbind(data1,data2,data3,data4,data5,data6,data7,data8,data9,data10)
tariffs1 <- filter(tariffs1, ProductCode %in% hs6_codes$`HS6 code`)
tariffs2 <- rbind(data11,data12,data13,data14,data15,data16,data17,data18,data19,data20)
tariffs2 <- filter(tariffs2, ProductCode %in% hs6_codes$`HS6 code`)
tariffs3 <- rbind(data21,data22,data23,data24,data25,data26,data27,data28,data29,data30)
tariffs3 <- filter(tariffs3, ProductCode %in% hs6_codes$`HS6 code`)
tariffs4 <- rbind(data31,data32,data33,data34,data35,data36,data37,data38,data39,data40)
tariffs4 <- filter(tariffs4, ProductCode %in% hs6_codes$`HS6 code`)
tariffs5 <- rbind(data41,data42,data43,data44,data45,data46,data47,data48,data49,data50)
tariffs5 <- filter(tariffs5, ProductCode %in% hs6_codes$`HS6 code`)

tariffs <- rbind(tariffs1,tariffs2,tariffs3,tariffs4,tariffs5)


# HS6 codes to filter the data down to size
trade <- filter(trade, k %in% hs6_codes$`HS6 code`) # filter data by codes

# country codes to ensure the data uses the same
trade <- left_join(trade, country_codes, by = c("i" = "country_code"))
trade <- left_join(trade, country_codes, by = c("j" = "country_code"),
                   suffix = c(".exp",".imp"))
tariffs <- left_join(tariffs, country_codes,
                     by = c("ReportingCountry" = "country_code"))
tariffs <- left_join(tariffs, country_codes, 
                     by = c("PartnerCountry" = "country_code"),
                     suffix = c(".imp",".exp"))

# filter trade for columns we want
trade <- select(trade, c("t", "k", "v", 
                         "iso_3digit_alpha.exp", "iso_3digit_alpha.imp"))
trade <- trade %>% 
  rename(year = t,
         hs6 = k,
         trade = v,
         iso_o = iso_3digit_alpha.exp,
         iso_d = iso_3digit_alpha.imp)

# filter tariffs for the columns we want
tariffs <- select(tariffs, c("iso_3digit_alpha.imp","iso_3digit_alpha.exp",
                             "ProductCode","MinAve"))

tariffs <- rename(tariffs,
                  iso_d = iso_3digit_alpha.imp,
                  iso_o = iso_3digit_alpha.exp,
                  hs6 = ProductCode,
                  tariff = MinAve)
tariffs <- mutate(tariffs, hs6 = as.character(hs6))

# join trade and gravity together
dat <- left_join(trade, gravity)
dat <- left_join(dat, tariffs)

# finally we filter the exporters and importers for the countries we're interested in
countries <- c("ARG","AUS","AUT","BEL","BRA","BGR","CAN","CHL","CHN","COL","CRI","HRV","CZE","DNK","FIN","FRA",
               "DEU","GRC","ISL","IND","IDN","IRL","ISR","ITA","JPN","KOR","LVA","LTU","MYS","MEX","NLD","NZL",
               "NGA","NOR","PAK","PRY","PER","POL","PRT","ROM","RUS","RWA","SAU","SVK","SVN","ZAF","ESP","LKA",
               "SWE","CHE","THA","TUR","UKR","GBR","USA","VNM")
dat <- filter(dat, iso_d %in% countries)
dat <- filter(dat, iso_o %in% countries)

write_csv(dat, "gravity_data.csv")
