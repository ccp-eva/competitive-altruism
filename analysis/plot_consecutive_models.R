library(tidyverse)

.blue <- "#27408B"
.red <- "#CD3700"

# First plot model vs baseline by session

nd <- read_csv("raising_by_first_offer_preds.csv")

nd_long <- nd %>%
	pivot_longer(cols=c("baseline", "mean"), names_to="type", values_to="p") %>%
	mutate(posterior=if_else(type=="baseline", 1, model_higher))

ggplot() +
	geom_col(aes(x=first_offer, y=p, colour=type), data=filter(nd_long, type=="mean"), fill="white", position="dodge") +
	geom_col(aes(x=first_offer, y=p, alpha=posterior), color=NA, data=filter(nd_long, type=="mean"), fill=.red, position="dodge") +
	geom_line(aes(x=first_offer, y=p, colour=type), data=filter(nd_long, type=="baseline")) +
	geom_hline(yintercept=0.5, linetype="dotted") +
	facet_wrap(~session, ncol=4, nrow=4) +
	scale_color_manual(name = "foo", values = c("baseline" = .blue, "mean" = .red)) +
	ylim(c(0, 1))
ggsave("../plots/raising_by_first_offer_by_session.png")

# Next plot raw data vs model, collapsing sessions

d <- read_csv("../data/consecutive_data.csv") %>%
	mutate(raises = second_offer > first_offer) %>%
	group_by(first_offer, second_proposer) %>%
	summarise(p=mean(raises), N=length(raises))

nd2 <- nd %>%
	group_by(first_offer) %>%
	summarise(mean=mean(mean), baseline=mean(baseline))

ggplot(data=nd2, mapping=aes(x=first_offer)) +
	geom_col(aes(y=mean), fill=.red) +
	geom_line(aes(y=baseline), colour=.blue, size=2) +
	geom_jitter(data=d, aes(y=p, size=N)) +
	geom_hline(yintercept=0.5, linetype="dotted")
ggsave("../plots/raising_by_first_offer_no_sessions_with_data.png")
