library(tidyverse)

get_session_proportions <- function(d) {
	d <- d %>%
		group_by(triad_id, proposer_id, responder_id, session, game_type) %>%
		summarise(total_offer=sum(offer), N=length(offer),
			  type_trial=first(type_trial)) %>%
		ungroup() %>%
		mutate(total_offer_prop=case_when(
					  total_offer == 0 ~ 0.0001,
					  total_offer == 8*N ~ 0.9999,
					  TRUE ~ total_offer/(8*N)))
	return(d)
}

raw_data <- read_csv("../data/competitive_altruism_dataset.csv") %>%
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

full_sessions <- raw_data %>%
	get_session_proportions()

first_halves <- raw_data %>%
	filter(game_type == "dyadic" | trial <= 4) %>%
	get_session_proportions() %>%
	rename(first_half_offer=total_offer,
	       first_half_offer_prop = total_offer_prop)

combined <- right_join(full_sessions, first_halves,
		       by=c("triad_id", "proposer_id", "responder_id", "session", "game_type",
			    "type_trial")) %>%
	mutate(consec=case_when(type_trial == "cons_left" ~ 0.5,
			  type_trial == "cons_right" ~ 0.5,
			  type_trial == "simultaneous" ~ -0.5,
			  TRUE ~ 0))

write_csv(combined, "../data/reformatted_dataset.csv")
