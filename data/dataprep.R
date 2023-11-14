library(tidyverse)

summer_start <- ymd("2022-08-01")
summer_end <- ymd("2022-09-01")

scoot_orig <- read_csv('./Motorized_Foot_Scooter_Trips_2022.csv')

scooter <- read_csv('./Motorized_Foot_Scooter_Trips_2022.csv') %>%
  separate(StartTime, into = c("StartDate", "StartTime"), sep = " ") %>%
  separate(EndTime, into = c("EndDate", "EndTime"), sep = " ") %>%
  select(-StartCenterlineID, -EndCenterlineID, -ObjectId) %>%
  mutate(
    StartDate = ymd(StartDate),
    EndDate = ymd(EndDate),
    StartTime = str_remove(StartTime, "\\+.*"),
    EndTime = str_remove(EndTime, "\\+.*")
  ) %>%
  filter(
    StartDate >= summer_start & StartDate < summer_end
  )

write_csv(scooter, "scooter-cleaned.csv")

police <- read_csv('./Police_Use_of_Force.csv') %>%
  select(
    -X,
    -Y,
    -TotalCityCallsForYear,
    -TotalPrecinctCallsForYear,
    -TotalNeighborhoodCallsForYear,
    -CenterGBSID,
    -CenterLatitude,
    -CenterLongitude,
    -CenterX,
    -CenterY,
    -TypeOfResistance
  ) %>%
  separate(
    ResponseDate, into = c("ResponseDate", "ResponseTime"), sep = " "
  ) %>%
  mutate(
    ResponseDate = ymd(ResponseDate),
    ResponseTime = str_remove(ResponseTime, "\\+.*"),
  ) %>%
  filter(ResponseDate >= ymd("2021-10-01"))
  
write_csv(police, "police_cleaned.csv")

police %>%
  count(ForceType) %>%
  arrange(desc(n))

art <- read_csv('./Artworks.csv')
