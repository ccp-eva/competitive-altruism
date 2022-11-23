library(matrixStats)
library(tidyverse)
library(brms)

p95 <- c(0.025, 0.975)

# Summarise consecutive models
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
