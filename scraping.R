library(tidyverse)
library(rvest)
library(glue)




#developing code to go in  scraper
review <- read_html("https://apps.shopify.com/recurring-orders/reviews?page=10") %>% 
  html_nodes(".review-metadata+ .review-content .truncate-content-copy") %>% 
  html_text() 

date_posted <- read_html("https://apps.shopify.com/recurring-orders/reviews?page=10") %>% 
  html_nodes(".review-metadata__item+ .review-metadata__item .review-metadata__item-value") %>% 
  html_text()
 
star_rating <- read_html("https://apps.shopify.com/recurring-orders/reviews?page=100") %>% 
  html_nodes(".review-metadata__item-value .ui-star-rating") %>% 
  html_text() 

test_df <- tibble(star_rating, date_posted, review)

test_df %>% mutate(date_posted = parse_date_time(date_posted,"mdy"))






#building the scraper funciton            
get_reviews <- function(page){
  
  Sys.sleep(3)
  
  cat(".")
  
  
  url <-  glue("https://apps.shopify.com/recurring-orders/reviews?page={page}")
  
 review_scrape <- read_html(url) %>% 
   html_nodes(".review-metadata+ .review-content .truncate-content-copy") %>% 
   html_text() 
 
 date_posted_scrape <- read_html(url) %>% 
   html_nodes(".review-metadata__item+ .review-metadata__item .review-metadata__item-value") %>% 
   html_text() 
 
 star_rating_scrape <- read_html(url) %>% 
   html_nodes(".review-metadata__item-value .ui-star-rating") %>% 
   html_text() 
 
   
 
 scraped_df <- data.frame(star_rating_scrape, date_posted_scrape, review_scrape) %>% 
   set_names(c("stars", "date_posted", "review_text"))
 
 
 
 scraped_df 
 
 }




scaffold <- tibble(pages = c(1:165))

scraped_reviews <- scaffold %>% 
  mutate(data = map(pages, ~get_reviews(.x)))

scraped_reviews %>% unnest() %>% write_rds("scraped_reviews_raw.RDS") %>% 
  write_tsv("scraped_reviews_raw.tsv")
