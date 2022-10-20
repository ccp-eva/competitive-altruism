library(tidyverse)
library(brms)

d <- read_csv("../data/reformatted_dataset.csv")

m1 <- brm(bf(total_offer_prop ~ 0 + game_type*session + (0 + game_type|triad_id),
	    phi ~ 0 + game_type + (0 + game_type|triad_id)),
	 data=d, family="beta",
	 prior=prior(normal(-1, 1.5), class="b") +
	       prior(exponential(0.7), lb=0, class="b", dpar="phi"),
	 cores=4, control=list(adapt_delta=0.95))

write_rds(m1, "model1.rds")

m2 <- brm(bf(first_half_offer_prop ~ 0 + game_type + consec*session + (0 + game_type|triad_id),
	    phi ~ 0 + game_type + (0 + game_type|triad_id)),
	 data=d, family="beta",
	 prior=prior(normal(-1, 1.5), class="b") +
	       prior(exponential(0.7), lb=0, class="b", dpar="phi"),
	 cores=4, control=list(adapt_delta=0.95))

write_rds(m2, "model2.rds")
