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

