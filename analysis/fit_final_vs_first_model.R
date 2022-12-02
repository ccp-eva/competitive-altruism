library(brms)

d <- read_csv("../data/session_level_data.csv") %>%
	mutate(increased = final_offer > first_offer)

m <- brm(increased ~ 0 + game_type*session + (0 + game_type|triad_id),
	 data=d, family="bernoulli",
	 prior=prior(normal(0, 1.5), class="b"),
	 cores=4, control=list(adapt_delta=0.95))

write_rds(m, "first_last.rds")
