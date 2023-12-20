library(tidyverse)

dir.create("../plots/", showWarnings = FALSE)

d <- read_csv("../data/trial_level_data.csv")

d %>%
	filter(	(game_type=="triadic" & trial %in% c(1, 8)) |
	        (game_type=="dyadic" & trial %in% c(1, 3, 6, 8))
		) %>%
	mutate(trial=case_when(trial == 1 ~ "First",
	                       trial == 3 ~ "First",
	                       trial == 6 ~ "Final",
	                       trial == 8 ~ "Final")
	) %>%
	mutate(trial=factor(trial, c("First", "Final"))) %>%
	group_by(game_type, proposer_id, trial) %>%
	summarise(offer=mean(offer)) %>%
	ungroup() %>%
	ggplot() +
	geom_line(aes(x=trial, y=offer, colour=proposer_id, group=proposer_id)) +
	scale_x_discrete(expand=c(0.1,0)) +
	facet_wrap(~game_type)

ggsave("../plots/first_vs_final_offer.png")

d %>% filter(trial == 1) %>%
	ggplot() +
	geom_histogram(aes(x=offer, colour=game_type, fill=game_type),
			position="identity", alpha=0.25)

ggsave("../plots/first_offers_dyadic_vs_triadic.png")

d %>%
	group_by(game_type, proposer_id, session) %>%
	summarise(mean_offer=mean(offer)) %>%
	ungroup() %>%
	ggplot() +
	geom_line(aes(x=session, y=mean_offer, colour=proposer_id, group=proposer_id)) +
	facet_wrap(~game_type)

ggsave("../plots/mean_offer_by_session.png")

d %>%
	group_by(game_type, proposer_id, trial) %>%
	summarise(mean_offer=mean(offer)) %>%
	ungroup() %>%
	ggplot() +
	geom_line(aes(x=trial, y=mean_offer, colour=proposer_id, group=proposer_id)) +
	facet_wrap(~game_type)

ggsave("../plots/mean_offer_by_trial.png")

# Emprical within session offer increasing behaviour

d <- read_csv("../data/session_level_data.csv") %>%
	mutate(increased = final_offer > first_offer) %>%
	filter(session > 8)

emp1 <- d %>% group_by(proposer_id, game_type) %>%
	summarise(increase=mean(increased)) %>%
	rename(Unit=proposer_id) %>%
	mutate(role="Proposer")
emp2 <- d %>% group_by(responder_id, game_type) %>%
	summarise(increase=mean(increased)) %>%
	rename(Unit=responder_id) %>%
	mutate(role="Responder")
emp3 <- d %>% group_by(triad_id, game_type) %>%
	summarise(increase=mean(increased)) %>%
	rename(Unit=triad_id) %>%
	mutate(role="Triad")

rbind(emp1, emp2, emp3) %>%
	rename(`Game type` = game_type,
	       `Proportion of sessions` = increase) %>%
	ggplot() +
	geom_bar(aes(x=Unit, y=`Proportion of sessions`, fill=`Game type`),
		 stat="identity", position="dodge") +
	geom_hline(yintercept=0.5, linetype="dotted") +
	facet_wrap(~role, scales="free_x") +
	ggtitle("Proportion of sessions 9-16 with final offer exceeding intial offer, grouped by proposer, responder or triad")

ggsave("../plots/empirical_increasing_within_session.png")

# Empirical increasing relative to self behaviour

d <- read_csv("../data/increase_data.csv") %>%
	filter(game_type == "triadic",
	       session > 8)

emp1 <- d %>% group_by(proposer_id, previous_accepted, game_type) %>%
	summarise(increase=mean(increased_self)) %>%
	rename(Unit=proposer_id) %>%
	mutate(role="Proposer")
emp2 <- d %>% group_by(responder_id, previous_accepted, game_type) %>%
	summarise(increase=mean(increased_self)) %>%
	rename(Unit=responder_id) %>%
	mutate(role="Responder")
emp3 <- d %>% group_by(triad_id, previous_accepted, game_type) %>%
	summarise(increase=mean(increased_self)) %>%
	rename(Unit=triad_id) %>%
	mutate(role="Triad")

rbind(emp1, emp2, emp3) %>%
	rename(`Previous offer accepted` = previous_accepted,
	       `Proportion of trials` = increase) %>%
	ggplot() +
	geom_bar(aes(x=Unit, y=`Proportion of trials`, fill=`Previous offer accepted`),
		 stat="identity", position="dodge") +
	geom_hline(yintercept=0.5, linetype="dotted") +
	facet_wrap(~role, scales="free_x") +
	ggtitle("Proportion of trials in sessions 9-16 where proposer offered more than in previous trial, grouped by proposer, responder and triad")

ggsave("../plots/empirical_increasing_over_self.png")

# Empirical outbidding behaviour

d <- read_csv("../data/consecutive_data.csv") %>%
	filter(session > 8,
	       first_offer <= 4) %>%
	mutate(match  = second_offer >= first_offer,
	       outbid = second_offer >  first_offer)

emp1 <- d %>% group_by(second_proposer_id) %>%
	summarise(`Match or outbid`=mean(match),
		  `Strictly outbid`=mean(outbid)) %>%
	rename(Unit=second_proposer_id) %>%
	mutate(role="Proposer")
emp2 <- d %>% group_by(responder_id) %>%
	summarise(`Match or outbid`=mean(match),
		  `Strictly outbid`=mean(outbid)) %>%
	rename(Unit=responder_id) %>%
	mutate(role="Responder")
emp3 <- d %>% group_by(triad_id) %>%
	summarise(`Match or outbid`=mean(match),
		  `Strictly outbid`=mean(outbid)) %>%
	rename(Unit=triad_id) %>%
	mutate(role="Triad")

rbind(emp1, emp2, emp3) %>%
	pivot_longer(cols = c("Match or outbid", "Strictly outbid"),
		     names_to = "Criterion",
		     values_to = "prop") %>%
	rename(`Proportion of first offers` = prop) %>%
	ggplot() +
	geom_bar(aes(x=Unit, y=`Proportion of first offers`, fill=Criterion),
		 stat="identity", position="dodge") +
	geom_hline(yintercept=0.5, linetype="dotted") +
	facet_wrap(~role, scales="free_x") +
	ggtitle("Proportion of first offers of 4 grapes or fewer in sessions 9-16 which were matched or outbid by the second proposer, grouped by proposer, responder and triad")

ggsave("../plots/empirical_outbidding.png")
