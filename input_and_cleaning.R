
# libraries ---------------------------------------------------------------

library(tidyverse)
library(janitor)
library(readxl)
library(here)


# loading code ------------------------------------------------------------

contents <- list.files(here("inputs"), all.files = FALSE)

medical_issues <- list()

issue_year_2 <- read_xlsx(
  here("inputs", 
       contents[1]), 
       sheet = 2,
       skip = 1) %>% 
    clean_names()
  

for (i in contents) {
  year_name <- str_sub(contents[i], 1, 4)
  # issue_year <- read_xlsx( here("inputs", contents[i]), sheet = 2, skip = 1)
  # %>% mutate(year = year_name) %>% clean_names() medical_issues[[i]] <-
  # issue_year
  print(year_name)
}

contents[1]
contents
str_sub(contents[1], 1, 4)

medical_issues[[1]] <- issue_year_1
medical_issues[[2]] <- issue_year_2
