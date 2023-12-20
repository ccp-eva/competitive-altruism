library(tidyverse)
library(brms)
library(matrixStats)

d <- read_csv("../data/consecutive_data.csv") %>%
	mutate(outbids = second_offer > first_offer,
	       previously_accepted = if_else(second_previously_accepted, 0.5, -0.5))

m_second_proposer_raises <- brm(outbids ~ 1 + session +
				         (1 + session | second_proposer_id) +
				         (1 | responder_id),
		data=d, family="bernoulli",
		prior = prior(normal(0, 1.5), class="Intercept") +
                        prior(normal(0, 0.75/16), class="b", coef="session"),
		control=list(adapt_delta=0.95), cores=4)
write_rds(m_second_proposer_raises, "second_raises.rds")

m_second_proposer_raises_by_prev <- brm(outbids ~ 1 + previously_accepted*session +
					         (1 + previously_accepted + session | second_proposer_id) +
					         (1 | responder_id),
		data=d, family="bernoulli",
		prior = prior(normal(0, 1.5), class="Intercept") +
			prior(normal(0, 0.75), class="b", coef="previously_accepted") +
			prior(normal(0, 0.75/16), class="b", coef="session") +
			prior(normal(0, 0.75/32), class="b", coef="previously_accepted:session"),
		control=list(adapt_delta=0.975), iter=5000, cores=4)
write_rds(m_second_proposer_raises, "second_raises_by_prev.rds")

m_second_proposer_raises_by_first <- brm(outbids ~ 1 + mo(first_offer) + session +
			          (1 + mo(first_offer) + session | second_proposer_id) +
			          (1 | responder_id),
		data=d, family="bernoulli",
		prior = prior(normal(0, 1.5), class="Intercept") +
			prior(normal(0, 0.75), class="b", coef="mofirst_offer") +
			prior(normal(0, 0.75/16), class="b", coef="session"),
		control=list(adapt_delta=0.975), iter=5000, cores=4)
write_rds(m_second_proposer_raises_by_first, "second_raises_by_first.rds")

m_second_proposer_raises_by_first_and_prev <- brm(outbids ~ 1 + previously_accepted*session + mo(first_offer) +
						           (1 + previously_accepted + session + mo(first_offer) | second_proposer_id) +
						           (1 | responder_id),
		data=d, family="bernoulli",
		prior = prior(normal(0, 1.5), class="Intercept") +
			prior(normal(0, 0.75), class="b", coef="previously_accepted") +
			prior(normal(0, 0.75), class="b", coef="mofirst_offer") +
			prior(normal(0, 0.75/16), class="b", coef="session") +
			prior(normal(0, 0.75/32), class="b", coef="previously_accepted:session"),
		control=list(adapt_delta=0.975), iter=5000, cores=4)
write_rds(m_second_proposer_raises_by_first_and_prev, "second_raises_by_first_and_prev.rds")

# Estimate expected raising probability due entirely to tendency
# not to make high offers, by randomly pairing first offers
N_trials <- sum(0.5**(1:8))
N_sessions <- sum(0.75**(1:16))
full_empirical <- rep(0, 9)
for(i in 1:16) {
	session_empirical <- rep(0, 9)
	for(j in 1:8) {
		sub_empirical <- d %>% filter(session == i, trial == j) %>% pull(first_offer) %>% factor(levels=0:8)
		sub_empirical <- table(sub_empirical) / length(sub_empirical)
		weight_t <- 0.5**j / N_trials
		session_empirical <- session_empirical + weight_t*sub_empirical
	}
	weight_s <- 0.75**i / N_sessions
	full_empirical <- full_empirical + weight_s*session_empirical
}
tibble(offer=0:8, probability=as.numeric(full_empirical)) %>%
	write_csv("estimated_offer_preferences.csv")

first_offers <-  sample(0:8, size=10000, prob=full_empirical, replace=TRUE)
second_offers <-  sample(0:8, size=10000, prob=full_empirical, replace=TRUE)
d_r <- tibble(first_offer=first_offers, second_offer=second_offers) %>%
	mutate(second_higher=second_offer > first_offer) %>%
	group_by(first_offer) %>%
	summarise(baseline=mean(second_higher))

# Extract predictions of raising probability for each possible
# first offer according to monotonic model and compare against
# baselines
nd <- expand_grid(first_offer=0:8, previously_accepted=c(-0.5, 0.5), session=1:16) %>%
	left_join(d_r)
preds <- posterior_linpred(m_second_proposer_raises_by_first_and_prev, newdata=nd,
			   re_formula=NA, transform=TRUE)
nsamps <- dim(preds)[1]
nd$second_previously_accepted <- nd$previously_accepted > 0
nd$mean <- colMeans(preds)
nd$lower <- colQuantiles(preds, probs=0.025)
nd$upper <- colQuantiles(preds, probs=0.975)
nd$above_chance <- colMeans(preds > 0.5)
nd$below_chance <- colMeans(preds < 0.5)
nd$model_higher <- colMeans(preds > matrix(rep(nd$baseline, nsamps), nrow=nsamps, byrow=TRUE))
write_csv(nd, "raising_by_first_offer_preds.csv")
