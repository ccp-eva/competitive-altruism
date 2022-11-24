library(matrixStats)
library(tidyverse)
library(brms)

p95 <- c(0.025, 0.975)

# Summarise pre-registered models

print("")
print("PRE-REGISTERED MODELS")
print("##################")
print("")

# m1
m1 <- read_rds("model1.rds")
preds <- posterior_predict(m1,re_formula=NA,
			   newdata=expand_grid(game_type=c("dyadic", "triadic"),
					       session=8))
print("Posterior predictive distribution for total proportional offers in 8th session: (M1)")
condition_values <- cbind(colMeans(preds), colQuantiles(preds, probs=p95))
colnames(condition_values)[1] <- "mean"
rownames(condition_values) <- c("dyadic", "triadic")
print(condition_values)

print("")
print("Condition contrast:")
contrast <- preds[,2] - preds[,1]
contrast <- c(mean(contrast), quantile(contrast, probs=p95))
names(contrast)[1] <- "mean"
print(contrast)

# m2
m2 <- read_rds("model2.rds")
preds <- posterior_predict(m2,re_formula=NA,
			   newdata=expand_grid(game_type=c("triadic"), consec=c(-0.5, 0.5),
					       session=8))
print("Including effect of consecutive vs simultaneous: (M2)")
consec_values <- cbind(colMeans(preds), colQuantiles(preds, probs=p95))
colnames(consec_values)[1] <- "mean"
rownames(consec_values) <- c("simultaneous", "consecutive")
print(consec_values)

print("")
print("con/sec contrast:")
contrast <- preds[,2] - preds[,1]
contrast <- c(mean(contrast), quantile(contrast, probs=p95))
names(contrast)[1] <- "mean"
print(contrast)
# Summarise consecutive models

print("")
print("CONSECUTIVE MODELS")
print("##################")
print("")

# Choosing first offer
m_chooses_first <- read_rds("chooses_first.rds")
draws <- as_draws_df(m_chooses_first)
p <- plogis(draws$b_Intercept)
print("Probability that responder chooses first offer in consecutive trials:")
print(c("Posterior mean: ", round(mean(p), 2)))
print(c("95% HPD: ", round(quantile(p, probs=p95), 2)))

responders <- unique(m_chooses_first$data$responder)
preds <- plogis(posterior_linpred(m_chooses_first, newdata=tibble(responder=responders)))
indiv_values <- cbind(colMeans(preds), colQuantiles(preds, probs=p95))
colnames(indiv_values)[1] <- "mean"
rownames(indiv_values) <- responders
print("Individual responder probabilities:")
print(indiv_values)

# Raising above second offer
m_raises <- read_rds("second_raises.rds")
draws <- as_draws_df(m_raises)
p <- plogis(draws$b_Intercept)
print("Probability that second proposer offers more than first proposer in consecutive trials:")
print(c("Posterior mean: ", round(mean(p), 2)))
print(c("95% HPD: ", round(quantile(p, probs=p95), 2)))

proposers <- unique(m_raises$data$second_proposer)
preds <- plogis(posterior_linpred(m_raises, newdata=tibble(second_proposer=proposers)))
indiv_values <- cbind(colMeans(preds), colQuantiles(preds, probs=p95))
colnames(indiv_values)[1] <- "mean"
rownames(indiv_values) <- proposers
print("Individual proposer probabilities:")
print(indiv_values)
