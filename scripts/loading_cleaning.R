
# libraries ---------------------------------------------------------------

library(tidyverse)
library(here)
library(janitor)
library(readxl)


# programmatic loading -----------------------------------------------------------------

#step one, find the files!
files <- list.files(here("inputs"), pattern = "^[^~]")

#note the files are stored as a character vector, which means we can pull files out with the [] operator

x <- files[1]
y <- files[2]

# This is how you read a spreadsheet... but if we look at it in Glimpse.
kff_2015 <- read_xlsx(here("inputs", "2015-KFF-Transparency-Data-Working-Files.xlsx"))

glimpse(kff_2015)

# how to get the year based on the file name
year <- str_sub(files[1], 1, 4)

#we see a 2 column dataframe. that's not at all what this is. To fix skip, the rows that have descriptions, and select the right SHEET you want to work on.
kff_2015_1 <- read_xlsx(here("inputs",  #note we break up the function a call to make it easier to read
                             files[1]), 
                        skip = 1, 
                        sheet = 2) %>%
  mutate(year = year) %>% #this lets us make sure we know the date of the script
  clean_names()


glimpse(kff_2015_1)

#combining it all to pull all of this into a list of data frame - for loop

kff_files <- list()

for (i in seq(files)){
  kff_year <- read_xlsx(here("inputs",  #note we break up the function a call to make it easier to read
                               files[i]), 
                          skip = 1, 
                          sheet = 2) %>%
    mutate(year = str_sub(files[i], 1, 4)) %>% #this lets us make sure we know the date of the data
    clean_names()
  
  kff_files[[i]] <- kff_year
}



kff_2015 <- read_xlsx(here("inputs",  #note we break up the function a call to make it easier to read
                           files[1]), skip = 1, 
                      sheet = "Medical Issuers") %>%
  mutate(year = str_sub(files[1], 1, 4)) %>% #this lets us make sure we know the date of the data
  clean_names() %>%
  mutate(enrollment_data = as.double(enrollment_data))

kff_2016 <- read_xlsx(here("inputs",  #note we break up the function a call to make it easier to read
                           files[2]), skip = 1, 
                      sheet = "Medical Issuers") %>%
  mutate(year = str_sub(files[2], 1, 4)) %>% 
  clean_names()  %>%
  mutate(enrollment_data = as.double(enrollment_data),
         disenrollment_data = as.double(disenrollment_data),
         percent_enrollment_in_medical_plans = as.double(percent_enrollment_in_medical_plans),
         percent_enrollment_in_dental_only_plans = as.double(percent_enrollment_in_dental_only_plans))

kff_2017 <- read_xlsx(here("inputs",  #note we break up the function a call to make it easier to read
                           files[3]), skip = 1, 
                      sheet = "Medical Issuers")  %>%
  clean_names()  %>%
  mutate(enrollment_data = as.double(enrollment_data),
         disenrollment_data = as.double(disenrollment_data),
         percent_enrollment_in_medical_plans = as.double(percent_enrollment_in_medical_plans),
         percent_enrollment_in_dental_only_plans = as.double(percent_enrollment_in_dental_only_plans)) %>%
  clean_names()

kff_2018 <- read_xlsx(here("inputs",  #note we break up the function a call to make it easier to read
                           files[4]), skip = 2, 
                      sheet = "Medical Issuers") %>%
  mutate(year = str_sub(files[4], 1, 4)) %>% 
  clean_names()  %>%
  mutate(enrollment_data = as.double(enrollment_data),
         disenrollment_data = as.double(disenrollment_data),
         percent_enrollment_in_medical_plans = as.double(percent_enrollment_in_medical_plans),
         percent_enrollment_in_dental_only_plans = as.double(percent_enrollment_in_dental_only_plans))

kff_2019 <- read_xlsx(here("inputs",  #note we break up the function a call to make it easier to read
                           files[5]), skip = 2, 
                      sheet = "Medical Issuers") %>%
  mutate(year = str_sub(files[5], 1, 4)) %>% 
  clean_names()

kff_files[[6]]

kff_2020 <- read_xlsx(here("inputs",  #note we break up the function a call to make it easier to read
                           files[6]), skip = 1,
                      sheet = "Medical Issuers") %>%
  mutate(year = str_sub(files[6], 1, 4)) %>% 
  clean_names()

%>%
  mutate(claims_denials = as.double(claims_denials))

kff_2021 <- read_xlsx(here("inputs",  #note we break up the function a call to make it easier to read
                           files[7]),  
                      sheet = "Medical Issuers") %>%
  mutate(year = str_sub(files[7], 1, 4)) %>% 
  clean_names() %>%
  mutate(issuer_id = as.double(issuer_id))


kff_data_set <- bind_rows(kff_2015, kff_2016, kff_2017, kff_2018, kff_2019, kff_2020, kff_2021)

kff_data_set %>% filter(year == "2018")
, kff_2017, kff_2018, kff_2019, kff_2020, kff_2021)



kff_files <- list()
for (i in seq(files)){
  kff_year <- read_xlsx(here("inputs",  #note we break up the function a call to make it easier to read
                             files[i]), 
                        skip = 1, 
                        sheet = "Medical Issuers") %>%
    mutate(year = str_sub(files[i], 1, 4))
  
  kff_files[[i]] <- kff_year
}


kff_2015 %>% select(all_of(columns_of_interest))
