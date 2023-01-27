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

#################################################

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
draws <- as_draws_df(m2)
preds <- posterior_predict(m2,re_formula=NA,
			   newdata=expand_grid(game_type=c("triadic"), consec=c(-0.5, 0.5),
					       session=1))
nl()
pretty_str("Including effect of consecutive vs simultaneous: (M2)")
nl()
consec_values <- cbind(colMeans(preds), colQuantiles(preds, probs=p95))
colnames(consec_values)[1] <- "mean"
rownames(consec_values) <- c("simultaneous", "consecutive")
print(consec_values)

nl()
pretty_str("prob con > sec:")
print(mean(draws$b_consec > 0))
nl()
pretty_str("con/sec contrast:")
contrast <- preds[,2] - preds[,1]
contrast <- c(mean(contrast), quantile(contrast, probs=p95))
names(contrast)[1] <- "mean"
print(contrast)
# Summarise consecutive models

nl()

#################################################

pretty_header("FIRST VS LAST MODELS")

m_first_last <- read_rds("first_last.rds")
preds <- plogis(posterior_linpred(m_first_last, re_formula=NA,
				  newdata=expand_grid(game_type=c("dyadic", "triadic"), session=1:16)))

marginal_dyadic_probs <- as.vector(preds)[1:64000]
marginal_triadic_probs <- as.vector(preds)[64001:128000]

pretty_str("Marginalised over session probabilities of increasing within a session:")
pretty_str("Dyadic: ")
print(c("    Posterior mean: ", round(mean(marginal_dyadic_probs), 2)))
print(c("    95% HPD: ", round(quantile(marginal_dyadic_probs, probs=p95), 2)))
pretty_str("Triadic: ")
print(c("    Posterior mean: ", round(mean(marginal_triadic_probs), 2)))
print(c("    95% HPD: ", round(quantile(marginal_triadic_probs, probs=p95), 2)))

nl()

per_session_probs <- cbind(colMeans(preds), colQuantiles(preds, probs=p95))
colnames(per_session_probs)[1] <- "mean"

pretty_str("Probabilities that final offer of session is higher than first, by session:")
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

#################################################

pretty_header("CONDITIONAL INCREASING MODELS")

# Relative to self

m_self <- read_rds("increase_over_self.rds")
preds <- plogis(posterior_linpred(m_self, re_formula=NA,
			   newdata=expand_grid(game_type=c("triadic"), previous_accepted=c(TRUE, FALSE),
					       session=1:16)))
nl()
marginal_accepted_probs <- as.vector(preds)[1:64000]
marginal_rejected_probs <- as.vector(preds)[64001:128000]

pretty_str("Marginalised over session probabilities of increasing over own last offer:")
nl()
pretty_str("Last offer accepted: ")
print(c("    Posterior mean: ", round(mean(marginal_accepted_probs), 2)))
print(c("    95% HPD: ", round(quantile(marginal_accepted_probs, probs=p95), 2)))
nl()
pretty_str("Last offer rejected: ")
print(c("    Posterior mean: ", round(mean(marginal_rejected_probs), 2)))
print(c("    95% HPD: ", round(quantile(marginal_rejected_probs, probs=p95), 2)))
nl()
pretty_str("Accepted vs rejected contrast:")
nl()
contrast <- preds[,17:32] - preds[,1:16]
contrast <- c(mean(contrast), quantile(contrast, probs=p95))
names(contrast)[1] <- "mean"
print(contrast)

nl()
nl()

# Relative to winner

m_winner <- read_rds("increase_over_winner.rds")
preds <- plogis(posterior_linpred(m_winner, re_formula=NA,
			   newdata=expand_grid(game_type=c("triadic"), previous_accepted=c(TRUE, FALSE),
					       session=1:16)))
marginal_accepted_probs <- as.vector(preds)[1:64000]
marginal_rejected_probs <- as.vector(preds)[64001:128000]

pretty_str("Marginalised over session probabilities of increasing over previous winning offer:")
nl()
pretty_str("Last offer accepted: ")
print(c("    Posterior mean: ", round(mean(marginal_accepted_probs), 2)))
print(c("    95% HPD: ", round(quantile(marginal_accepted_probs, probs=p95), 2)))
nl()
pretty_str("Last offer rejected: ")
print(c("    Posterior mean: ", round(mean(marginal_rejected_probs), 2)))
print(c("    95% HPD: ", round(quantile(marginal_rejected_probs, probs=p95), 2)))
nl()
pretty_str("Accepted vs rejected contrast:")
nl()
contrast <- preds[,17:32] - preds[,1:16]
contrast <- c(mean(contrast), quantile(contrast, probs=p95))
names(contrast)[1] <- "mean"
print(contrast)

#################################################

pretty_header("CONSECUTIVE MODELS")

# Choosing first offer
m_chooses_first <- read_rds("chooses_first.rds")
preds <- plogis(posterior_linpred(m_chooses_first, newdata=tibble(session=1:16), re_formula=NA))
pretty_str("Probability that responder chooses first offer in consecutive trials:")
print(c("Posterior mean: ", round(mean(preds), 2)))
print(c("95% HPD: ", round(quantile(preds, probs=p95), 2)))

# Raising above first offer
m_raises <- read_rds("second_raises.rds")
draws <- as_draws_df(m_raises)
preds <- plogis(posterior_linpred(m_raises, newdata=tibble(session=1:16), re_formula=NA))

pretty_str("Posterior probability that second proposer become more likely to outbid first proposer as sessions increase:")
print(mean(draws$b_session >0))

pretty_str("Probability that second proposer offers more than first proposer in consecutive trials, marginalising over sessions:")
nl()
print(c("Posterior mean: ", round(mean(preds), 2)))
print(c("95% HPD: ", round(quantile(preds, probs=p95), 2)))
nl()

pretty_str("Per session probabilities that second proposer offers more than first proposer in consecutive trials:")

per_session_probs <- cbind(colMeans(preds), colQuantiles(preds, probs=p95))
colnames(per_session_probs)[1] <- "mean"
print(per_session_probs)

# Raising vs initial offer
m_raises_by_first <- read_rds("second_raises_by_first.rds")
nd <- read_csv("raising_by_first_offer_preds.csv")

nl()
pretty_str("Outbidding probabilities in first session, stratified by first offer:")
print(filter(nd, session==1))
nl()
pretty_str("Outbidding probabilities in final session, stratified by first offer:")
print(filter(nd, session==16))

sink()
close(fp)
