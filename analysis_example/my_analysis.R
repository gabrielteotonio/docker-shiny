library(tidyr)
library(dplyr)

data("population")
pop_per_country <- population %>% 
                      group_by(country) %>% 
                      summarise(population = sum(population)) %>% 
                      arrange(desc(population))

write.csv(pop_per_country, "pop_per_country.csv")