
# libraries ---------------------------------------------------------------

library(tidyverse)
library(here)
library(janitor)
library(readxl)


# programmatic loading -----------------------------------------------------------------

files <- list.files(here("inputs"))

x <- files[1]

kff_2015 <- read_xlsx(here("inputs", "2015-KFF-Transparency-Data-Working-Files.xlsx"))
kff_2015_1 <- read_xlsx(here("inputs", files[1]))


