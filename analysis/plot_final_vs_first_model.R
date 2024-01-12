library(matrixStats)
library(tidyverse)
library(brms)
library(grid)

dir.create("../plots/", showWarnings = FALSE)

m <- read_rds("first_last.rds")

nd <- expand_grid(game_type=c(-0.5, 0.5), session=1:16 - 8.5)
preds <- posterior_linpred(m, newdata=nd, re_formula=NA) 
nd$game_type <- if_else(nd$game_type < 0, "dyadic", "triadic")
nd$session <- nd$session + 8.5

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
ggsave("../plots/increase_probabilities.png",
       width = 105, height = 105, units="mm", dpi=600)

diff_pred <- matrix(, nrow=dim(preds)[1], ncol=16)
for(i in 1:16) {
	diff_pred[,i] <- plogis(preds[,i+16]) - plogis(preds[,i])
}
dd <- tibble(session=1:16,
	     mean_diff=colMeans(diff_pred),
	     lower_diff=colQuantiles(diff_pred, probs=0.025),
	     upper_diff=colQuantiles(diff_pred, probs=0.975)
	     )
ggplot(dd, aes(x=session) ) +
  ylab("difference between conditions") +
	geom_line(aes(y=mean_diff), col="#8a49a1") +
	geom_ribbon(aes(ymin=lower_diff, ymax=upper_diff), fill="#e56969", alpha=0.35) +
	geom_hline(yintercept=0.0, linetype="dotted", col="#8a49a1") +
  theme_bw() +
  theme(panel.border = element_blank()) +
  theme(axis.line = element_line(colour = "black"))+
  theme(axis.title.y = element_text(size = rel(1.3), angle = 90)) +
  theme(axis.title.x = element_text(size = rel(1.3), angle = 00)) +
  theme(axis.text=element_text(size=12))

grid.text("1a",0.975, 0.965)
ggsave("../plots/increase_probabilities_diff.png",
       width = 105, height = 105, units="mm", dpi=600)
