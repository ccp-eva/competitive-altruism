library(matrixStats)
library(tidyverse)
library(brms)

p95 <- c(0.025, 0.975)

pretty_header <- function(h) {
	cat(paste("\n", h, "\n", sep=""))
	for(i in 1:nchar(h)) { cat("#") }
	cat("\n\n")
}

pretty_str <- function(s) {
	cat(paste(s, "\n", sep=""))
}

nl <- function() { cat("\n") }

# tee output to a file
sink(fp <- file("summary.txt"), split=TRUE)

# Summarise pre-registered models

pretty_header("PRE-REGISTERED MODELS")

# m1
m1 <- read_rds("model1.rds")
preds <- posterior_predict(m1,re_formula=NA,
			   newdata=expand_grid(game_type=c("dyadic", "triadic"),
					       session=8))
pretty_str("Posterior predictive distribution for total proportional offers in 8th session: (M1)")
nl()
condition_values <- cbind(colMeans(preds), colQuantiles(preds, probs=p95))
colnames(condition_values)[1] <- "mean"
rownames(condition_values) <- c("dyadic", "triadic")
print(condition_values)

nl()
pretty_str("Condition contrast:")
nl()
contrast <- preds[,2] - preds[,1]
contrast <- c(mean(contrast), quantile(contrast, probs=p95))
names(contrast)[1] <- "mean"
print(contrast)

# m2
m2 <- read_rds("model2.rds")
preds <- posterior_predict(m2,re_formula=NA,
			   newdata=expand_grid(game_type=c("triadic"), consec=c(-0.5, 0.5),
					       session=8))
pretty_str("Including effect of consecutive vs simultaneous: (M2)")
nl()
consec_values <- cbind(colMeans(preds), colQuantiles(preds, probs=p95))
colnames(consec_values)[1] <- "mean"
rownames(consec_values) <- c("simultaneous", "consecutive")
print(consec_values)

nl()
pretty_str("con/sec contrast:")
contrast <- preds[,2] - preds[,1]
contrast <- c(mean(contrast), quantile(contrast, probs=p95))
names(contrast)[1] <- "mean"
print(contrast)
# Summarise consecutive models

nl()
pretty_header("CONSECUTIVE MODELS")

# Choosing first offer
m_chooses_first <- read_rds("chooses_first.rds")
draws <- as_draws_df(m_chooses_first)
p <- plogis(draws$b_Intercept)
pretty_str("Probability that responder chooses first offer in consecutive trials:")
print(c("Posterior mean: ", round(mean(p), 2)))
print(c("95% HPD: ", round(quantile(p, probs=p95), 2)))

responders <- unique(m_chooses_first$data$responder)
preds <- plogis(posterior_linpred(m_chooses_first, newdata=tibble(responder=responders)))
indiv_values <- cbind(colMeans(preds), colQuantiles(preds, probs=p95))
colnames(indiv_values)[1] <- "mean"
rownames(indiv_values) <- responders
pretty_str("Individual responder probabilities:")
print(indiv_values)

# Raising above second offer
m_raises <- read_rds("second_raises.rds")
draws <- as_draws_df(m_raises)
p <- plogis(draws$b_Intercept)
pretty_str("Probability that second proposer offers more than first proposer in consecutive trials:")
nl()
print(c("Posterior mean: ", round(mean(p), 2)))
print(c("95% HPD: ", round(quantile(p, probs=p95), 2)))
nl()

proposers <- unique(m_raises$data$second_proposer)
preds <- plogis(posterior_linpred(m_raises, newdata=tibble(second_proposer=proposers)))
indiv_values <- cbind(colMeans(preds), colQuantiles(preds, probs=p95))
colnames(indiv_values)[1] <- "mean"
rownames(indiv_values) <- proposers
pretty_str("Individual proposer probabilities:")
print(indiv_values)

nl()
pretty_header("FIRST VS LAST MODELS")

m_first_last <- read_rds("first_last.rds")
preds <- plogis(posterior_linpred(m_first_last, re_formula=NA,
				  newdata=expand_grid(game_type=c("dyadic", "triadic"), session=1:16)))
per_session_probs <- cbind(colMeans(preds), colQuantiles(preds, probs=p95))
colnames(per_session_probs)[1] <- "mean"

pretty_str("Probability that final offer of session is higher than first:")
nl()
pretty_str("Dyadic:")
nl()
print(per_session_probs[1:16,])
nl()
pretty_str("Triadic")
nl()
print(per_session_probs[17:32,])
nl()
pretty_str("Per-session contrast (triadic - dyadic) in probabilites:")
nl()
contrast <- preds[,17:32] - preds[,1:16]
print(cbind(colMeans(contrast), colQuantiles(contrast, probs=p95)))

nl()
pretty_header("CONDITIONAL INCREASING MODELS")

# Relative to self

m_self <- read_rds("increase_over_self.rds")
preds <- plogis(posterior_linpred(m_self, re_formula=NA,
			   newdata=expand_grid(game_type=c("triadic"), previous_accepted=c(TRUE, FALSE),
					       session=8)))
pretty_str("Probability of increasing over own previous offer in 8th triadic trial:")
nl()
cond_probs <- cbind(colMeans(preds), colQuantiles(preds, probs=p95))
colnames(cond_probs)[1] <- "mean"
rownames(cond_probs) <- c("Previous offer accepted", "Previous offer rejected")
print(cond_probs)

nl()
pretty_str("Accepted vs rejected contrast:")
nl()
contrast <- preds[,2] - preds[,1]
contrast <- c(mean(contrast), quantile(contrast, probs=p95))
names(contrast)[1] <- "mean"
print(contrast)

nl()

# Relative to winner

m_winner <- read_rds("increase_over_winner.rds")
preds <- plogis(posterior_linpred(m_winner, re_formula=NA,
			   newdata=expand_grid(game_type=c("triadic"), previous_accepted=c(TRUE, FALSE),
					       session=8)))
pretty_str("Probability of increasing over previous winning offer in 8th triadic trial:")
nl()
cond_probs <- cbind(colMeans(preds), colQuantiles(preds, probs=p95))
colnames(cond_probs)[1] <- "mean"
rownames(cond_probs) <- c("Previous offer accepted", "Previous offer rejected")
print(cond_probs)

nl()
pretty_str("Accepted vs rejected contrast:")
nl()
contrast <- preds[,2] - preds[,1]
contrast <- c(mean(contrast), quantile(contrast, probs=p95))
names(contrast)[1] <- "mean"
print(contrast)

sink()
close(fp)
