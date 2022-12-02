library(tidyverse)
library(brms)

d <- read_csv("../data/increase_data.csv") %>%
	filter(game_type == "triadic")

# Discard trials where both offers on the previous trial were 0, resulting
# in there being no "winner" against to measure increases.
# (removes about 10% of trials)
d <- filter(d, !is.na(increased_winner))

m_self <- brm(increased_self ~ previous_accepted*session + (1|proposer_id),
	      data=d, family="bernoulli", control=list(adapt_delta=0.95),
              prior = prior(normal(0, 1.5), class="b"))
write_rds(m_self, "increase_over_self.rds")

m_winner <- brm(matched_winner ~ previous_accepted*session + (1|proposer_id),
	        data=d, family="bernoulli", control=list(adapt_delta=0.95),
                prior = prior(normal(0, 1.5), class="b"))

write_rds(m_winner, "increase_over_winner.rds")
