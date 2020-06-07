## DATA CLEANING
library(tidyverse)
library(lubridate)



scraped_reviews_raw <- read_rds("scraped_reviews_raw.RDS")


scraped_reviews_clean <- scraped_reviews_raw %>% 
  mutate(
    stars =
      str_sub(stars, 1,3) %>% 
      str_remove("o") %>% 
      trimws() %>% 
      as.numeric(),
    
    date_posted = date_posted %>% 
      str_remove("\n") %>% 
      trimws() %>% 
      parse_date_time("mdy"),
    
    review_text = review_text %>% 
      str_remove("\n") %>% 
      trimws(),
    review_id = row_number()
      )


write_rds(scraped_reviews_clean, "scraped_reviews_clean.RDS")
write_tsv(scraped_reviews_clean, "scraped_review_clean.tsv")
