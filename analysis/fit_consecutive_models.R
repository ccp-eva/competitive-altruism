library(tidyverse)
library(brms)

d <- read_csv("../data/consecutive_data.csv")

m_responder_chooses_first <- brm(chose_first ~ 1 + (1|responder), data=d,
		family="bernoulli",
		prior = prior(normal(0, 1.5), class="Intercept"),
		control=list(adapt_delta=0.95), cores=4)
write_rds(m_responder_chooses_first, "chooses_first.rds")

d$raises <- d$second_offer > d$first_offer
m_second_proposer_raises <- brm(raises ~ 1 + (1|second_proposer), data=d,
		family="bernoulli",
		prior = prior(normal(0, 1.5), class="Intercept"),
		control=list(adapt_delta=0.95), cores=4)
write_rds(m_second_proposer_raises, "second_raises.rds")

d$fair_raise_possible = d$first_offer < 4
m_raises_if_fair <- brm(raises ~ 0 + fair_raise_possible + (1|second_proposer), data=d,
		family="bernoulli",
		prior = prior(normal(0, 1.5), class="b"),
		control=list(adapt_delta=0.95), cores=4)
write_rds(m_raises_if_fair, "second_raises_if_fair.rds")

m_raises_by_first <- brm(raises ~ mo(first_offer) + (1|second_proposer), data=d,
		family="bernoulli",
		prior = prior(normal(0, 1.5), class="Intercept") +
		        prior(normal(0, 1.5), class="b"),
		control=list(adapt_delta=0.95), cores=4)
write_rds(m_raises_by_first, "second_raises_by_first.rds")

# Extract predictions of raising probability for each possible
# first offer according to monotonic model
nd <- tibble(expand_grid(first_offer=0:8))
preds <- plogis(posterior_linpred(m_raises_by_first, newdata=nd, re_formula=NA))
nd$mean <- colMeans(preds)
nd$lower <- colQuantiles(preds, probs=0.025)
nd$upper <- colQuantiles(preds, probs=0.975)

# Estimate expected raising probability due entirely to tendency
# not to make high offers, by randomly pairing first offers
d_r <- tibble(first_offer=integer(), second_higher=logical())
for(i in 1:8) {
	empirical <- d %>% filter(trial == i) %>% pull(first_offer)
	first_offers <- sample(empirical, size=10000, replace=TRUE)
	second_offers <- sample(empirical, size=10000, replace=TRUE)
	d_r <- add_row(d_r, first_offer=first_offers,
		       second_higher = second_offers > first_offers)
}

# Add baseline estimates to table of predictions
nd$theory <- d_r %>%
	group_by(first_offer) %>%
	summarise(p_raise=mean(second_higher)) %>%
	pull(p_raise)
write_csv(nd, "raising_by_first_offer_preds.csv")
