
# libraries ---------------------------------------------------------------

library(tidyverse)
library(ggmap)
library(here)
library(mapboxer)
library(geojsonio)
library(broom)
library(sf)


# Loading Data ------------------------------------------------------------

kff_data <- read_rds(here("inputs", "kff_totals.RDS"))

kff_data <- kff_data %>%
  mutate(denial_ratio = claims_denials/claims_received) %>%
  arrange(desc(denial_ratio)) %>%
  select(1:5, 7, 6)

kff_data %>%
  group_by(state) %>%
  summarize(n = n()) %>%
  arrange(desc(n))

kff_ratio <- kff_data %>%
  group_by(state, year, issuer_name, denial_ratio) %>%
  filter(denial_ratio >= .5 )

kff_data %>%
  ggplot(aes(x = state)) +
  geom_bar(aes(y = claims_received, fill = "Claims Received"),stat = "identity") +
  geom_bar(aes(y = -claims_denials, fill = "Claim Denied"), stat = "identity") +
  coord_flip()

kff_ratio_viz <- kff_ratio %>%
  filter(denial_ratio >= .45) %>%
ggplot(aes(x = issuer_name)) +
  geom_bar(aes(y = claims_received, fill = "Claims Received"),stat = "identity") +
  geom_bar(aes(y = -claims_denials, fill = "Claim Denied"), stat = "identity") +
  coord_flip() +
  labs(title = "Claims Denied vs Claims Recieved: 2015 - 2019",
       subtitle = "Providers with over a 45% denial rate. Source: Kaiser Family Foundation",
       x = "Insurance Providers",
       y = "Claims Denied and Claims Received",
       fill = "Amount of Denials or Received") +
  theme_minimal()


kff_ratio %>%
  ggplot(aes(x = issuer_name, y = state, fill = claims_received)) + geom_tile()


kff_ratio %>%
  ggplot(aes(x = issuer_name, color = state, y = claims_denials)) +
  geom_line(aes(group = issuer_name)) + coord_flip()


kff_data %>%
  ggplot(aes(x = state, y = claims_received, fill = year)) + 
  geom_bar(stat = "identity") +
  facet_grid(~claims_received)

kff_summary <- kff_data %>%
  group_by(state, year, issuer_name) %>%
  summarize(total_recieved = sum(claims_received),
            total_denied = sum(claims_denials)) %>%
  mutate(ratio = total_denied/total_recieved) %>% 
  ungroup() %>%
  arrange(desc(ratio))


# map ---------------------------------------------------------------------

hexbin <- list.files(here("shapefiles"), pattern = "^[^~]")
basemap <- geojson_read(here("shapefiles", hexbin), what = "sp")

basemap_sf <- st_as_sf(basemap) %>%
  rename(state_abb = iso3166_2)


ggplot(basemap_sf) + 
  geom_sf() + 
  geom_sf_text(aes(label = state_abb)) 

basemap_data <- basemap_sf %>% 
  left_join(kff_summary, 
            by = c("state_abb" = "state"))


basemap_data %>% 
  filter(year == "2015") %>%
  ggplot(aes(fill = ratio)) +
  geom_sf() +
  geom_sf_text(aes(label = state_abb),
                   color = "white") +
  facet_wrap(~year)

kff_summary %>%
  select(-3) %>%
  group_by(state) %>%
  summarize(total_total = sum(total_recieved),
            total_denial = sum(total_denied),
            ratio = scales::percent(total_denial/total_total, 1)) %>%
  arrange(desc(ratio))


options(scipen = 100, digits = 4)
kff_data_viz <- basemap_data %>%
  group_by(state_abb) %>%
  summarize(state_total = sum(total_recieved),
            total_denial = sum(total_denied),
            ratio = scales::percent(total_denial/state_total, 1)) %>%
  ggplot(aes(fill = state_total)) +
  geom_sf() +
  geom_sf_text(aes(label = glue::glue("{state_abb}\n{ratio}")),
               color = "white") +
  viridis::scale_fill_viridis(option = "H") +
  labs(title = "Total Health Care Claims Recieved 2015 -2021 \nAnd Percentage of Denials",
       subtitle = "Source: Kaiser Family Foundation",
       fill = "Health Care \nClaims Recieved") +
  theme_void()


# saved images ------------------------------------------------------------





ggsave(here("outputs", "kff_ratio_viz.png"), plot = kff_ratio_viz )
ggsave(here("outputs", "kff_ratio_viz.jpg"), plot = kff_ratio_viz )
ggsave(here("outputs", "kff_data_viz.jpg"), plot = kff_data_viz )
