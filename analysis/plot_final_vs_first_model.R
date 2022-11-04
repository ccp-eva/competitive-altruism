library(matrixStats)
library(tidyverse)

m <- read_rds( "increase_prob.rds")

nd <- expand_grid(game_type=c("dyadic", "triadic"), session=1:16)
preds <- posterior_linpred(m, newdata=nd, re_formula=NA) 

dyadic_probs <- plogis(preds[,1:16])
mean(dyadic_probs)
quantile(dyadic_probs, probs=c(0.025, 0.975))

triadic_probs <- plogis(preds[,17:32])
mean(triadic_probs)
quantile(triadic_probs, probs=c(0.025, 0.975))

nd$mean_p <- plogis(colMeans(preds))
nd$lower_p <- plogis(colQuantiles(preds, probs=0.025))
nd$upper_p <- plogis(colQuantiles(preds, probs=0.975))
nd$poster_above_chance <- colMeans(preds > 0)

ggplot(nd, aes(x=session)) +
	geom_line(aes(y=mean_p, colour=game_type)) +
	geom_ribbon(aes(ymin=lower_p, ymax=upper_p, fill=game_type), alpha=0.25) +
	geom_hline(yintercept=0.5, linetype="dotted")
ggsave("../plots/increase_probabilities.png")

diff_pred <- matrix(, nrow=4000, ncol=16)
for(i in 1:16) {
	diff_pred[,i] <- plogis(preds[,i+16]) - plogis(preds[,i])
}
dd <- tibble(session=1:16,
	     mean_diff=colMeans(diff_pred),
	     lower_diff=colQuantiles(diff_pred, probs=0.025),
	     upper_diff=colQuantiles(diff_pred, probs=0.975)
	     )
ggplot(dd, aes(x=session)) +
	geom_line(aes(y=mean_diff)) +
	geom_ribbon(aes(ymin=lower_diff, ymax=upper_diff), alpha=0.25) +
	geom_hline(yintercept=0.0, linetype="dotted")
ggsave("../plots/increase_probabilities_diff.png")
