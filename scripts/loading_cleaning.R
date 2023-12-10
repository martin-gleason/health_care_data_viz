
# libraries ---------------------------------------------------------------

library(tidyverse)
library(here)
library(janitor)
library(readxl)


# programmatic loading -----------------------------------------------------------------

#step one, find the files!
files <- list.files(here("inputs"))

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
  
  kff_files[i] <- kff_year
}



