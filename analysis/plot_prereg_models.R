library(tidyverse)
library(scales)
library(brms)

dir.create("../plots/", showWarnings = FALSE)

# Model 1
m <- read_rds("model1.rds")

nd <- expand_grid(game_type=c("dyadic", "triadic"), session=8)
preds <- posterior_predict(m, newdata=nd, re_formula=NA)
plot_table <- tibble(game_type=character(),
		     total_offer_prop=numeric())
for(i in 1:nrow(preds)) {
	plot_table <- add_row(plot_table, game_type="dyadic", total_offer_prop=preds[i,1])
	plot_table <- add_row(plot_table, game_type="triadic", total_offer_prop=preds[i,2])
}

dyadic_mean <- mean(preds[,1])
triadic_mean <- mean(preds[,2])
colours <- hue_pal()(2)
ggplot(plot_table) +
	geom_density(aes(x=total_offer_prop,
			 colour=game_type,
			 fill=game_type),
		     alpha=0.25, bw=0.15) +
	geom_line(data=tibble(x=c(dyadic_mean, dyadic_mean), y=c(0,Inf)),
		  aes(x=x, y=y),
		  linetype="dotted", color=colours[1], size=1) +
	geom_line(data=tibble(x=c(triadic_mean, triadic_mean), y=c(0,Inf)),
		  aes(x=x, y=y),
		  linetype="dotted", color=colours[2], size=1)

ggsave("../plots/model1_preds.png")

# Model 2
m <- read_rds("model2.rds")

nd <- filter(expand_grid(game_type=c("dyadic", "triadic"), consec=c(-0.5, 0, 0.5), session=8), (game_type == "dyadic" & consec==0) | (game_type == "triadic" & consec != 0))
preds <- posterior_predict(m, newdata=nd, re_formula=NA)
plot_table <- tibble(game_type=character(),
		     total_offer_prop=numeric())
for(i in 1:nrow(preds)) {
	plot_table <- add_row(plot_table, game_type="dyadic", total_offer_prop=preds[i,1])
	plot_table <- add_row(plot_table, game_type="triadic_sim", total_offer_prop=preds[i,2])
	plot_table <- add_row(plot_table, game_type="triadic_con", total_offer_prop=preds[i,3])
}

dyadic_mean <- mean(preds[,1])
triadic_sim_mean <- mean(preds[,2])
triadic_con_mean <- mean(preds[,3])
colours <- hue_pal()(3)
ggplot(plot_table) +
	geom_density(aes(x=total_offer_prop,
			 colour=game_type,
			 fill=game_type),
		     alpha=0.25, bw=0.15) +
	geom_line(data=tibble(x=c(dyadic_mean, dyadic_mean), y=c(0,Inf)),
		  aes(x=x, y=y),
		  linetype="dotted", color=colours[1], size=1) +
	geom_line(data=tibble(x=c(triadic_con_mean, triadic_con_mean), y=c(0,Inf)),
		  aes(x=x, y=y),
		  linetype="dotted", color=colours[2], size=1) +
	geom_line(data=tibble(x=c(triadic_sim_mean, triadic_sim_mean), y=c(0,Inf)),
		  aes(x=x, y=y),
		  linetype="dotted", color=colours[3], size=1)

ggsave("../plots/model2_preds.png")
