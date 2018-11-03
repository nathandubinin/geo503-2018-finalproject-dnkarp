library(ggplot2)
library(tibble)
library(scales)

factor1 <- as.factor(c("ABC", "CDA", "XYZ", "YRO"))
factor2 <- as.factor(c("A", "B"))

set.seed(43)
data <- tibble(x = sample(factor1, 1000, replace = TRUE),
               z = sample(factor2, 1000, replace = TRUE))

set.seed(1234)
data <- tibble(x = sample(factor1, 1000, replace = TRUE),
               z = sample(factor2, 1000, replace = TRUE))

data %>% 
  mutate(x = forcats::fct_reorder(x, as.numeric(z), fun = mean)) %>% 
  ggplot(aes(x, fill = z)) +
  geom_bar(position = "fill") +
  scale_y_continuous(labels = percent)