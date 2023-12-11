
# Libraries ---------------------------------------------------------------
library(tidyverse)
library(here)
library(janitor)
library(readxl)

# Programmaitc Loading of Files -----------------------------------------------------------

#find names
files <- list.files(here("inputs"), pattern = "^[^~]")
year <- c()

#get the year
## How to make this more 'R-like'
for(file in seq(files)){
  year <- append(year, str_sub(files[file], 1, 4))
  }

#function to get file
kff_2015 <- read_xlsx(here("inputs",
                           files[1]), skip = 1, 
                      sheet = "Medical Issuers") %>%
  mutate(year = str_sub(files[1], 1, 4))

names_of_columns  <- names(kff_2015)

columns_of_interest <- names_of_columns[1:5]

#Creating other dfs to combine:
kff_files <- list()
for (i in seq(files)){
  kff_year <- read_xlsx(here("inputs",  #note we break up the function a call to make it easier to read
                             files[i]), 
                        skip = 1, 
                        sheet = "Medical Issuers") %>%
    mutate(year = str_sub(files[i], 1, 4))
  
  kff_files[[i]] <- kff_year
}

kff_2015 <- kff_files[[1]] %>%
  select(all_of(columns_of_interest)) %>%
  mutate(year = year[1])

kff_2016 <- kff_files[[2]] %>%
  select(all_of(columns_of_interest)) %>%
  mutate(year = year[2])

kff_2017 <- kff_files[[3]] %>%
  select(all_of(columns_of_interest)) %>%
  mutate(year = year[3])


kff_total <- bind_rows(kff_2015, kff_2016, kff_2017)

kff_2018 <- read_xlsx(here("inputs", files[4]), 
                      skip = 2,
                      sheet = "Medical Issuers") %>%
  select(all_of(columns_of_interest)) %>%
  mutate(year = year[4])

kff_total <- kff_total %>%
  bind_rows(kff_2018)

kff_2019 <- read_xlsx(here("inputs", files[5]),
                      skip = 2,
                      sheet = "Medical Issuers")%>%
  select(all_of(columns_of_interest)) %>%
  mutate(year = year[5])

kff_total <- kff_total %>%
  bind_rows(kff_2019)

kff_2020 <- read_xlsx(here("inputs", files[6]),
                      sheet = "Medical Issuers") %>%
  select(1:3, 5:6) %>%
  mutate(year = year[6]) %>%
  clean_names()
# 
# kff_heading <- names(kff_total)
# names(kff_2020) <- kff_heading

#neat experimetn
kff_total <- kff_total %>%
  clean_names() %>%
  bind_rows(kff_2020)


kff_2021 <-  read_xlsx(here("inputs", files[7]),
                       sheet = "Medical Issuers") %>%
  select(1:3, 5:6) %>%
  mutate(year = year[7]) %>%
  clean_names() %>%
  mutate(issuer_id = as.double(issuer_id),
         claims_received = as.double(claims_received),
         claims_denials = as.double(claims_denials))

kff_total <- kff_total %>%
  bind_rows(kff_2021)

kff_total %>%
  write_rds(here("inputs", "kff_totals.RDS"))
