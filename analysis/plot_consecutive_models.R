library(tidyverse)
library(brms)
library(viridis)

.blue <- "#27408B"
.red <- "#CD3700"

dir.create("../plots/", showWarnings = FALSE)

# First plot model vs baseline by session
nd <- read_csv("raising_by_first_offer_preds.csv")

nd_long <- nd %>%
	pivot_longer(cols=c("baseline", "mean"), names_to="type", values_to="p") %>%
	mutate(posterior=if_else(type=="baseline", 1, model_higher),
	       pretty_prev = if_else(second_previously_accepted, "Previously accepted", "Previously rejected"))

nd_prev_accept <- filter(nd_long, second_previously_accepted==TRUE)
nd_prev_reject <- filter(nd_long, second_previously_accepted==FALSE)

common_theme <- theme_bw() +
	theme(plot.title = element_text(size = rel(1), hjust=0.5)) +
	theme(axis.title.y = element_text(size = rel(0.75), angle = 90)) +
	theme(axis.title.x = element_text(size = rel(0.75), angle = 00)) +
	theme(axis.text = element_text(size = rel(0.5))) +
	theme(legend.title = element_text(size = rel(0.75))) +
	theme(legend.text = element_text(size = rel(0.5))) +
	theme(strip.text = element_text(size = rel(0.75)))

ggplot() +
	geom_col(aes(x=first_offer, y=p), colour="black", data=filter(nd_long, type=="mean"), fill="white", position="dodge") +
	geom_col(aes(x=first_offer, y=p, fill=posterior), color=NA, data=filter(nd_long, type=="mean"), position="dodge") +
	scale_fill_gradientn(colours=viridis(256, option="D", direction=1),
			     name = "Posterior\nprob. that\nrate\nexceeds\nbaseline") +
	geom_line(aes(x=first_offer, y=p), colour="black", linewidth=0.75, data=filter(nd_long, type=="baseline")) +
	geom_hline(yintercept=0.5, linetype="dotted") +
	facet_grid(pretty_prev~session) +
	ylim(c(0, 1)) +
	ylab("Probability to outcompete 1st offers") +
	xlab("First offer value") +
#	ggtitle("Posterior mean outbidding probabilities for a previously accepted second proposer") +
	common_theme
ggsave("../plots/raising_by_first_offer_by_session.png",
       width = 210, height = 210/1.5, units="mm", dpi=600)

# Next plot raw data vs model, collapsing sessions

d <- read_csv("../data/consecutive_data.csv") %>%
	mutate(raises = second_offer > first_offer) %>%
	group_by(first_offer, second_proposer_id) %>%
	summarise(p=mean(raises), N=length(raises))

nd2 <- nd %>%
	group_by(first_offer) %>%
	summarise(mean=mean(mean), baseline=mean(baseline))

ggplot(data=nd2, mapping=aes(x=first_offer)) +
	geom_col(aes(y=mean), fill=.red) +
	geom_line(aes(y=baseline), colour=.blue, size=2) +
	geom_jitter(data=d, aes(y=p, size=N)) +
	geom_hline(yintercept=0.5, linetype="dotted")
ggsave("../plots/raising_by_first_offer_no_sessions_with_data.png",
       width = 105, height = 105, units="mm", dpi=600)
