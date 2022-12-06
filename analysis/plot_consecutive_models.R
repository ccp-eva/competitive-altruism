library(tidyverse)

nd <- read_csv("raising_by_first_offer_preds.csv")

ggplot(nd) +
	geom_line(aes(x=first_offer, y=mean)) +
	geom_ribbon(aes(x=first_offer, ymax=upper, ymin=lower), alpha=0.5) +
	geom_point(aes(x=first_offer, y=theory)) +
	geom_hline(yintercept=0.5, linetype="dotted")
ggsave("../plots/raising_by_first_offer.png")
