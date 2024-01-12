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

d %>% filter(	(game_type=="triadic" & trial == 1) |
	        (game_type=="dyadic" & trial %in% c(1, 3))
	) %>%
	ggplot() +
	geom_histogram(aes(x=offer, colour=game_type, fill=game_type),
			position="dodge")

ggsave("../plots/first_offers_dyadic_vs_triadic.png")

d %>%
	group_by(game_type, proposer_id, session) %>%
	summarise(mean_offer=mean(offer)) %>%
	ungroup() %>%
	ggplot() +
	geom_line(aes(x=session, y=mean_offer, colour=proposer_id, group=proposer_id)) +
	facet_wrap(~game_type)

ggsave("../plots/mean_offer_by_session.png")

#####

d %>%
	mutate(session = case_when(session %in% c(1,2) ~  "01-02",
	                           session %in% c(3,4) ~  "03-04",
	                           session %in% c(5,6)  ~ "05-06",
	                           session %in% c(7,8) ~  "07-08",
	                           session %in% c(9,10) ~ "09-10",
	                           session %in% c(11,12) ~ "11-12",
	                           session %in% c(13,14) ~ "13-14",
	                           session %in% c(15,16) ~ "15-16",
	                           session %in% c(17,18) ~ "17-18")) %>%
	group_by(game_type, trial, session) %>%
	summarise(mean_offer=mean(offer)) %>%
	rename(`mean offer` = mean_offer,
	       `Game type` = game_type) %>%
	ggplot() +
	geom_col(aes(x=trial, y=`mean offer`, fill=`Game type`)) +
	geom_smooth(aes(x=trial, y=`mean offer`),
		    method="lm", color="black", se=FALSE) +
	theme_bw() +
        scale_fill_manual(values = c("dyadic" = "#f97b36", "triadic" = "#c155a4")) +
	facet_grid(`Game type` ~ session)
ggsave("../plots/mean_offer_by_trial.png",
       width = 210, height = 210/1.618, units="mm", dpi=600)

#####

d_cons <- read_csv("../data/consecutive_data.csv") %>%
	select(session, trial, offer_left, offer_right) %>%
	mutate(trial_type = "consecutive")
d_sim <- read_csv("../data/simultaneous_data.csv") %>%
	select(session, trial, offer_left, offer_right) %>%
	mutate(trial_type = "simultaneous")
d_triad <- rbind(d_cons, d_sim) %>%
	mutate(offer_A = offer_left,
	       offer_B = offer_right) %>%
	mutate(session = case_when(session %in% c(1,2) ~  "01-02",
	                           session %in% c(3,4) ~  "03-04",
	                           session %in% c(5,6)  ~ "05-06",
	                           session %in% c(7,8) ~  "07-08",
	                           session %in% c(9,10) ~ "09-10",
	                           session %in% c(11,12) ~ "11-12",
	                           session %in% c(13,14) ~ "13-14",
	                           session %in% c(15,16) ~ "15-16",
	                           session %in% c(17,18) ~ "17-18"))

d_triad %>%
	group_by(trial_type, trial, session) %>%
	summarise(mean_difference=mean(abs(offer_A - offer_B))) %>%
	rename(`mean difference` = mean_difference,
	       `Trial type` = trial_type) %>%
	ggplot() +
	geom_col(aes(x=trial, y=`mean difference`, fill=`Trial type`)) +
	geom_smooth(aes(x=trial, y=`mean difference`), color="black",
		    method="lm", se=FALSE) +
	theme_bw() +
        scale_fill_manual(values = c("consecutive" = "#f97b36", "simultaneous" = "#c155a4")) +
	facet_grid(`Trial type` ~ session)

ggsave("../plots/mean_abs_diff_by_trial.png",
       width = 210, height = 210/1.618, units="mm", dpi=600)

d_triad %>%
	group_by(trial_type, session) %>%
	summarise(mean_difference=mean(abs(offer_A - offer_B))) %>%
	rename(`mean difference` = mean_difference,
	       `Trial type` = trial_type) %>%
	ggplot() +
	geom_col(aes(x=session, y=`mean difference`, fill=`Trial type`),
		 position="dodge") +
	geom_smooth(aes(x=session, y=`mean difference`), color="black",
		    method="lm", se=FALSE) +
	theme_bw() +
        scale_fill_manual(values = c("consecutive" = "#f97b36", "simultaneous" = "#c155a4"))

ggsave("../plots/mean_abs_diff_by_session.png",
       width = 210, height = 210/1.618, units="mm", dpi=600)

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
	theme_bw() +
        scale_x_discrete(guide = guide_axis(n.dodge = 2)) +
        scale_fill_manual(values = c("dyadic" = "#f97b36", "triadic" = "#c155a4")) +
	ylim(c(0, 1)) +
	ggtitle("Proportion of triadic sessions 9-16 with final offer exceeding initial offer,\ngrouped by proposer, responder or triad")

ggsave("../plots/empirical_increasing_within_session.png",
       width = 210, height = 210/1.618, units="mm", dpi=600)

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
	theme_bw() +
        scale_x_discrete(guide = guide_axis(n.dodge = 2)) +
        scale_fill_manual(values = c("FALSE" = "#f97b36", "TRUE" = "#c155a4")) +
	ylim(c(0, 1)) +
	labs(`Previous offer accepted`="Previous\noffer\naccepted") +
	ggtitle("Proportion of trials in sessions 9-16 where proposer offered\nmore than in previous trial, grouped by proposer, responder and triad")

ggsave("../plots/empirical_increasing_over_self.png",
       width = 210, height = 210/1.618, units="mm", dpi=600)

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
	theme_bw() +
        scale_x_discrete(guide = guide_axis(n.dodge = 2)) +
        scale_fill_manual(values = c("#f97b36", "#c155a4")) +
	ylim(c(0, 1)) +
	ggtitle("Proportion of first offers of 4 grapes or fewer in sessions 9-16\nwhich were matched or outbid by the second proposer,\ngrouped by proposer, responder and triad")

ggsave("../plots/empirical_outbidding.png",
       width = 210, height = 210/1.618, units="mm", dpi=600)



