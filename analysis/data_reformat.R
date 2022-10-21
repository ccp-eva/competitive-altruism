library(tidyverse)

# Reformat raw data to facilitate the two pre-registered analyses of
# session-total offers

get_session_measures <- function(d) {
	d <- d %>%
		arrange(trial) %>%
		group_by(triad_id, proposer_id, responder_id, session, game_type) %>%
		summarise(total_offer=sum(offer),
		          first_offer=first(offer),
			  fourth_offer=offer[4],
		          final_offer=last(offer),
			  N=length(offer),
			  type_trial=first(type_trial)) %>%
		ungroup() %>%
		mutate(total_offer_prop=case_when(
					  total_offer == 0 ~ 0.0001,
					  total_offer == 8*N ~ 0.9999,
					  TRUE ~ total_offer/(8*N)))
	return(d)
}

raw_data <- read_csv("../data/competitive_altruism_dataset.csv")

clean_trial_data <- raw_data %>%
	select(dyad, proposer_L, proposer_right, responder,
	       session, trial, condition_tri_di, type_trial,
	       offer_left, offer_right)  %>%
	pivot_longer(cols=c("offer_left", "offer_right"),
		     values_to="offer",
		     names_to="proposer_side") %>%
	filter(!(type_trial == "left" & proposer_side =="offer_right")) %>%
	filter(!(type_trial == "right" & proposer_side =="offer_left")) %>%
	mutate(proposer = if_else(proposer_side == "offer_left",
				 proposer_L, proposer_right),
	       offer = as.integer(offer)) %>%
	select(-proposer_side, -proposer_L, -proposer_right) %>%
	rename(responder_id = responder,
	       proposer_id = proposer,
	       triad_id = dyad,
	       game_type = condition_tri_di)

write_csv(clean_trial_data, "../data/trial_level_data.csv")

full_sessions <- clean_trial_data %>%
	get_session_measures()

first_halves <- clean_trial_data %>%
	filter(game_type == "dyadic" | trial <= 4) %>%
	get_session_measures() %>%
	rename(first_half_offer=total_offer,
	       first_half_offer_prop = total_offer_prop)

combined <- right_join(full_sessions, first_halves,
		       by=c("triad_id", "proposer_id", "responder_id", "session", "game_type",
			    "type_trial")) %>%
	mutate(consec=case_when(type_trial == "cons_left" ~ 0.5,
			  type_trial == "cons_right" ~ 0.5,
			  type_trial == "simultaneous" ~ -0.5,
			  TRUE ~ 0))

write_csv(combined, "../data/session_level_data.csv")

# Reformat raw data to facilitate exploratory modelling of
# trial-by-trial behaviour in triadic trials

raw_data <- read_csv("../data/competitive_altruism_dataset.csv") %>%
	select(dyad, proposer_L, proposer_right, responder,
	       session, trial, condition_tri_di, type_trial,
	       offer_left, offer_right, responder_choice_side) %>%
	filter(condition_tri_di == "triadic") %>%
	mutate(offer_left=as.integer(offer_left),
	       offer_right=as.integer(offer_right))

simultaneous_data <- filter(raw_data, type_trial == "simultaneous")

consecutive_data <- raw_data %>%
	filter(type_trial != "simultaneous") %>%
	mutate(first_offer=if_else(type_trial == "cons_left", offer_left, offer_right),
	       second_offer=if_else(type_trial == "cons_right", offer_left, offer_right),
	       chose_first=(type_trial == "cons_left" & responder_choice_side == "L") | (type_trial == "cons_right" & responder_choice_side == "R")
	       )

stopifnot(nrow(simultaneous_data) + nrow(consecutive_data) == nrow(raw_data))

write_csv(simultaneous_data, "../data/simultaneous_data.csv")
write_csv(consecutive_data, "../data/consecutive_data.csv")
