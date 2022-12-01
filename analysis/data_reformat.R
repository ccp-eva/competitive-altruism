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

# Turn stringy NAs into the real deal
raw_data <- raw_data %>%
	mutate(offer_left = as.integer(ifelse(offer_left == "na", NA, offer_left)),
	       offer_right = as.integer(ifelse(offer_right == "na", NA, offer_right)),
	       responder_choice_side = ifelse(responder_choice_side == "na", NA, responder_choice_side),
	       )

clean_trial_data <- raw_data %>%
	select(dyad, proposer_L, proposer_right, responder,
	       session, trial, condition_tri_di, type_trial,
	       offer_left, offer_right, responder_choice_side)  %>%
	mutate(winning_offer = case_when(responder_choice_side == "L" ~ offer_left,
                                         responder_choice_side == "R" ~ offer_right)) %>%
	pivot_longer(cols=c("offer_left", "offer_right"),
		     values_to="offer",
		     names_to="proposer_side") %>%
	filter(!(type_trial == "left" & proposer_side =="offer_right")) %>%
	filter(!(type_trial == "right" & proposer_side =="offer_left")) %>%
	mutate(proposer = if_else(proposer_side == "offer_left",
				 proposer_L, proposer_right),
	       accepted = if_else(proposer_side == "offer_left",
				  responder_choice_side == "L",
				  responder_choice_side == "R"),
	       accepted = replace_na(accepted, FALSE),
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
	select(-first_offer, -fourth_offer, -final_offer) %>%
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
# offer increasing behaviour
increase_data <- tibble(triad_id=character(),
			proposer_id=character(),
			session=integer(),
			trial=integer(),
			previous_accepted=logical(),
			previous_null=logical(),
			consecutive_rejections=integer(),
			increased_self=logical(),
			increased_winner=logical(),
			)

all_triads <- unique(clean_trial_data$triad_id)
for(triad in all_triads) {
	triad_d <- filter(clean_trial_data, triad_id == triad)
	proposers <- unique(triad_d$proposer_id)
	for(proposer in proposers) {
		for(s in 1:16) {
			# Extract offer data for this proposer in this session
			own_offers <- triad_d %>%
				filter(proposer_id==proposer, session==s) %>%
				arrange(trial) %>%
				pull(offer)
			winning_offers <- triad_d %>%
				filter(proposer_id==proposer, session==s) %>%
				arrange(trial) %>%
				pull(winning_offer)
			stopifnot(length(own_offers) == length(winning_offers))
			accepted <- triad_d %>%
				filter(proposer_id==proposer, session==s) %>%
				arrange(trial) %>%
				pull(accepted)

			# Skip cases where no offers were made
			if(length(own_offers) == 0) { next }

			increases_self <- own_offers[2:length(own_offers)] > own_offers[1:(length(own_offers)-1)]
			increases_winner <- own_offers[2:length(own_offers)] > winning_offers[1:(length(winning_offers)-1)]
			previous_accepted <- accepted[1:length(own_offers)-1]
			previous_null <- is.na(winning_offers[1:length(winning_offers)-1])

			# Count how many offers it's been since we were accepted
			consec_rejections <- integer(length(previous_accepted))
			for(i in 1:length(previous_accepted)) {
				rej <- 0
				for(j in seq(i,1)) {
					if(previous_accepted[j]) {
						break
					}
					rej <- rej + 1
				}
				consec_rejections[i] <- rej
			}

			# Add row to main table
			increase_data <- add_row(increase_data,
						 triad_id=triad, proposer_id=proposer,
						 session=s,
						 trial=2:length(own_offers),
						 previous_accepted=accepted[1:length(own_offers)-1],
						 previous_null=previous_null,
						 consecutive_rejections = consec_rejections,
						 increased_self=increases_self,
						 increased_winner=increases_winner,
			)
		}
	}
}

increase_data <- left_join(increase_data,
			   unique(select(clean_trial_data, triad_id, session, game_type)))
write_csv(increase_data, "../data/increase_data.csv")

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
	rename(proposer_left = proposer_L,
	       triad_id = dyad) %>%
	mutate(first_offer=if_else(type_trial == "cons_left", offer_left, offer_right),
	       second_offer=if_else(type_trial == "cons_right", offer_left, offer_right),
	       first_proposer=if_else(type_trial == "cons_left", proposer_left, proposer_right),
	       second_proposer=if_else(type_trial == "cons_right", proposer_left, proposer_right),
	       chose_first=(type_trial == "cons_left" & responder_choice_side == "L") | (type_trial == "cons_right" & responder_choice_side == "R")
	       )

stopifnot(nrow(simultaneous_data) + nrow(consecutive_data) == nrow(raw_data))

write_csv(simultaneous_data, "../data/simultaneous_data.csv")
write_csv(consecutive_data, "../data/consecutive_data.csv")
