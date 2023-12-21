library(tidyverse)
library(brms)

d <- read_csv("../data/increase_data.csv") %>%
	filter(game_type == "triadic") %>%
# Discard trials where both offers on the previous trial were 0, resulting
# in there being no "winner" against to measure increases.
# (removes about 10% of trials)
	filter(!is.na(increased_winner)) %>%
	mutate(previous_accepted = if_else(previous_accepted, 0.5, -0.5),
	       session = session - 8.5)

m_self <- brm(increased_self ~ 1 + previous_accepted*session +
	                      (1 + previous_accepted + session | proposer_id) +
	                      (1 | responder_id),
	      data=d, family="bernoulli",
              prior =	prior(normal(0, 1.5), class="Intercept") +
			prior(normal(0, 0.75), class="b", coef="previous_accepted") +
			prior(normal(0, 0.75/15), class="b", coef="session") +
			prior(normal(0, 0.75/15), class="b", coef="previous_accepted:session"),
	      control=list(adapt_delta=0.975), cores=4)
write_rds(m_self, "increase_over_self.rds")

m_winner <- brm(increased_winner ~ 1 + previous_accepted*session +
	                          (1 + previous_accepted + session | proposer_id) +
	                          (1 | responder_id),
	      data=d, family="bernoulli",
              prior =	prior(normal(0, 1.5), class="Intercept") +
			prior(normal(0, 0.75), class="b", coef="previous_accepted") +
			prior(normal(0, 0.75/15), class="b", coef="session") +
			prior(normal(0, 0.75/15), class="b", coef="previous_accepted:session"),
	      control=list(adapt_delta=0.975), cores=4)
write_rds(m_winner, "increase_over_winner.rds")

m_winner_matched <- brm(matched_winner ~ 1 + previous_accepted*session +
	                                (1 + previous_accepted + session | proposer_id) +
	                                (1 | responder_id),
	      data=d, family="bernoulli",
              prior =	prior(normal(0, 1.5), class="Intercept") +
			prior(normal(0, 0.75), class="b", coef="previous_accepted") +
			prior(normal(0, 0.75/15), class="b", coef="session") +
			prior(normal(0, 0.75/15), class="b", coef="previous_accepted:session"),
	      control=list(adapt_delta=0.975), cores=4)
write_rds(m_winner_matched, "match_winner.rds")

trial_data <- read_csv("../data/trial_level_data.csv") %>%
	filter(game_type == "triadic") %>%
	select(session, trial, triad_id, type_trial) %>%
	mutate(type_trial = if_else(type_trial == "simultaneous", -0.5, 0.5),
	       session = session - 8.5) %>%
	unique()
d <- d %>% left_join(trial_data, by=c("session", "trial", "triad_id"))

m_self_consim <- brm(increased_self ~ 1 + previous_accepted*session + type_trial*session +
		                     (1 + previous_accepted + type_trial + session | proposer_id) +
				     (1 | responder_id),
	      data=d, family="bernoulli",
              prior =	prior(normal(0, 1.5), class="Intercept") +
			prior(normal(0, 0.75), class="b", coef="previous_accepted") +
			prior(normal(0, 0.75), class="b", coef="type_trial") +
			prior(normal(0, 0.75/15), class="b", coef="session") +
			prior(normal(0, 0.75/15), class="b", coef="previous_accepted:session") +
			prior(normal(0, 0.75/15), class="b", coef="session:type_trial"),
	      control=list(adapt_delta=0.975), cores=4)
write_rds(m_self_consim, "increase_over_self_consim.rds")
