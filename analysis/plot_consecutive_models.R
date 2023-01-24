library(tidyverse)

nd <- read_csv("raising_by_first_offer_preds.csv")

ggplot(nd) +
	geom_line(aes(x=first_offer, y=mean)) +
	geom_ribbon(aes(x=first_offer, ymax=upper, ymin=lower), alpha=0.5) +
	geom_point(aes(x=first_offer, y=theory)) +
	geom_hline(yintercept=0.5, linetype="dotted") +
	facet_wrap(~session, ncol=4, nrow=4)
ggsave("../plots/raising_by_first_offer_by_session.png")

nd %>%
	pivot_longer(cols=c("baseline", "mean"), names_to="type", values_to="p") %>%
	mutate(posterior=if_else(type=="baseline", 1, model_higher)) %>%
	ggplot() +
	geom_col(aes(x=first_offer, y=p, color=type), fill="white", position="dodge") +
	geom_col(aes(x=first_offer, y=p, fill=type, color=NULL, alpha=posterior), position="dodge") +
	geom_hline(yintercept=0.5, linetype="dotted") +
	facet_wrap(~session, ncol=4, nrow=4)
ggsave("../plots/raising_vs_baseline.png")
