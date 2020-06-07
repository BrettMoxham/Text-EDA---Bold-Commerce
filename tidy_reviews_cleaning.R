## word map
library(tidyverse)
library(tidytext)
library(wordcloud)



tidy_reviews <- scraped_reviews_clean %>% 
  unnest_tokens(word, review_text) %>%  
  anti_join(stop_words)


saveRDS(tidy_reviews,"tidy_reviews.RDS")

tidy_reviews <- readRDS("tidy_reviews.RDS")

word_count_plot <-  (tidy_reviews %>% 
  count(word, sort = TRUE) %>% 
  filter(n>150) %>% 
  mutate(word = reorder(word, n)) %>% 
  ggplot(aes(n, word)) +
  geom_col()+
  xlab("Word Count")+
  ylab(NULL)) 

ggsave("word_count_plot.png", word_count_plot)  
  
 