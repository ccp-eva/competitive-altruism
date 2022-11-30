library(matrixStats)
library(tidyverse)
library(brms)

m_self <- read_rds("increase_over_self.rds")

nd <- expand_grid(previous_accepted=c(T,F), session=1:16)
preds <- plogis(posterior_linpred(m_self, newdata=nd, re_formula=NA))
nd$mean_p <- colMeans(preds)
nd$lower_p <- colQuantiles(preds, p=0.025)
nd$upper_p <- colQuantiles(preds, p=0.975)

ggplot(nd, aes(x=session)) +
	geom_line(aes(y=mean_p, colour=previous_accepted)) +
	geom_ribbon(aes(ymin=lower_p, ymax=upper_p, fill=previous_accepted), alpha=0.5) +
	ylim(0, 1) +
	geom_hline(yintercept=0.5, linetype="dashed")
ggsave("../plots/increase_over_self.png")

m_winner <- read_rds("increase_over_winner.rds")

preds <- plogis(posterior_linpred(m_winner, newdata=nd, re_formula=NA))
nd$mean_p <- colMeans(preds)
nd$lower_p <- colQuantiles(preds, p=0.025)
nd$upper_p <- colQuantiles(preds, p=0.975)
ggplot(nd, aes(x=session)) +
	geom_line(aes(y=mean_p, colour=previous_accepted)) +
	geom_ribbon(aes(ymin=lower_p, ymax=upper_p, fill=previous_accepted), alpha=0.5) +
	ylim(0, 1) +
	geom_hline(yintercept=0.5, linetype="dashed")
ggsave("../plots/increase_over_winner.png")
