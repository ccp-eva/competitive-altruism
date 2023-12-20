library(matrixStats)
library(tidyverse)
library(brms)
library(grid)

dir.create("../plots/", showWarnings = FALSE)

m_self <- read_rds("increase_over_self.rds")

nd <- expand_grid(previous_accepted=c(-0.5,0.5), session=1:16)
preds <- plogis(posterior_linpred(m_self, newdata=nd, re_formula=NA))
nd$previous_accepted <- nd$previous_accepted > 0
nd$mean_p <- colMeans(preds)
nd$lower_p <- colQuantiles(preds, p=0.025)
nd$upper_p <- colQuantiles(preds, p=0.975)

nd = mutate(nd, previous_accepted=replace(previous_accepted, previous_accepted==FALSE, "rejected")) %>% 
  mutate(previous_accepted=replace(previous_accepted, previous_accepted==TRUE, "accepted")) 


plot <- ggplot(nd, aes(x=session)) +
  geom_line(aes(y=mean_p, colour=previous_accepted)) +
  scale_color_manual(values = c("rejected" = "#f97b36", "accepted"= "#c155a4")) +
  geom_ribbon(aes(ymin=lower_p, ymax=upper_p, fill=previous_accepted), alpha=0.5) +
  scale_fill_manual(values = c("rejected" = "#f97b36", "accepted"= "#c155a4")) +
  ylim(0, 1) +
  ylab("probability to increase offer") +
  geom_hline(yintercept=0.5, linetype="dashed") + 
  labs(color="Previous offer", fill='Previous offer')+
  theme_bw() +
  theme(panel.border = element_blank()) +
  theme(axis.line = element_line(colour = "black")) +
  theme(axis.title.y = element_text(size = rel(1.3), angle = 90)) +
  theme(axis.title.x = element_text(size = rel(1.3), angle = 00)) +
  theme(axis.text=element_text(size=12)) +
  theme(legend.text=element_text(size=11)) +
  theme(legend.title=element_text(size=11))
plot  
grid.text("1b",0.8, 0.965)
ggsave("../plots/increase_over_self.png")

m_winner <- read_rds("increase_over_winner.rds")

nd <- expand_grid(previous_accepted=c(-0.5,0.5), session=1:16)
preds <- plogis(posterior_linpred(m_winner, newdata=nd, re_formula=NA))
nd$previous_accepted <- nd$previous_accepted > 0
nd = mutate(nd, previous_accepted=replace(previous_accepted, previous_accepted==FALSE, "rejected")) %>%
  mutate(previous_accepted=replace(previous_accepted, previous_accepted==TRUE, "accepted"))
nd$mean_p <- colMeans(preds)
nd$lower_p <- colQuantiles(preds, p=0.025)
nd$upper_p <- colQuantiles(preds, p=0.975)
ggplot(nd, aes(x=session)) +
	geom_line(aes(y=mean_p, colour=previous_accepted)) +
	geom_ribbon(aes(ymin=lower_p, ymax=upper_p, fill=previous_accepted), alpha=0.5) +
	ylim(0, 1) +
	geom_hline(yintercept=0.5, linetype="dashed")
ggsave("../plots/increase_over_winner.png")
