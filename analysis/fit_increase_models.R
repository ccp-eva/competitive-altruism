library(tidyverse)
library(brms)

d <- read_csv("../data/increase_data.csv") %>%
	filter(game_type == "triadic")

m_self <- brm(increased_self ~ previous_accepted*session + (1|proposer_id),
	      data=d, family="bernoulli", control=list(adapt_delta=0.95),
              prior = prior(normal(0, 1.5), class="b"))
write_rds(m_self, "increase_over_self.rds")

m_winner <- brm(increased_winner ~ previous_accepted*session + (1|proposer_id),
	        data=d, family="bernoulli", control=list(adapt_delta=0.95),
                prior = prior(normal(0, 1.5), class="b"))
write_rds(m_winner, "increase_over_winner.rds")
