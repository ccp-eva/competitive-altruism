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
