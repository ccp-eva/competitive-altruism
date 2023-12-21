library(tidyverse)
library(brms)

d <- read_csv("../data/session_level_data.csv") %>%
	mutate(increased = final_offer > first_offer,
	       game_type = if_else(game_type == "triadic", 0.5, -0.5),
	       session = session - 8.5)

m <- brm(increased ~ 1 + game_type*session + (1 + game_type + session | triad_id),
	 data=d, family="bernoulli",
	 prior=prior(normal(0, 1.5), class="Intercept") +
               prior(normal(0, 0.75), class="b", coef="game_type") +
               prior(normal(0, 0.75/15), class="b", coef="session") +
               prior(normal(0, 0.75/15), class="b", coef="game_type:session"),
	 cores=4, control=list(adapt_delta=0.95))

write_rds(m, "first_last.rds")
