###Attempt to fit brms model 1

xdata<-data_model1_Luke


library(brms)
install.packages("ggmcmc")
install.packages("ggthemes")
install.packages("ggridges")
install.packages("ggs")
library(ggmcmc)
library(dplyr)
library(ggplot2)

#interception model

interception_model<-brm(total_offer_prop ~ 1 + (1| triad_id) + (1| proposer_id), 
                        data = xdata,
                        warmup = 1000,
                        iter = 2000,
                        chains = 2,
                        init = "random", cores = 32)

# 
# Warning messages:
#   1: Bulk Effective Samples Size (ESS) is too low, indicating posterior means and medians may be unreliable.
# Running the chains for more iterations may help. See
# https://mc-stan.org/misc/warnings.html#bulk-ess 
# 2: Tail Effective Samples Size (ESS) is too low, indicating posterior variances and tail quantiles may be unreliable.
# Running the chains for more iterations may help. See
# https://mc-stan.org/misc/warnings.html#tail-ess 


summary(interception_model)
# 
# Family: beta 
# Links: mu = logit; phi = identity 
# Formula: total_offer_prop ~ 1 + (1 | triad_id) + (1 | proposer_id) 
# Data: xdata (Number of observations: 220) 
# Draws: 4 chains, each with iter = 3000; warmup = 2000; thin = 1;
# total post-warmup draws = 4000
# 
# Group-Level Effects: 
#   ~proposer_id (Number of levels: 5) 
# Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
# sd(Intercept)     0.72      0.36     0.27     1.69 1.00     1175     1941
# 
# ~triad_id (Number of levels: 7) 
# Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
# sd(Intercept)     0.36      0.19     0.09     0.84 1.00     1250     1448
# 
# Population-Level Effects: 
#   Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
# Intercept    -0.45      0.38    -1.26     0.31 1.00     1106     1334
# 
# Family Specific Parameters: 
#   Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
# phi     4.47      0.39     3.74     5.25 1.00     3749     2701
# 
# Draws were sampled using sampling(NUTS). For each parameter, Bulk_ESS
# and Tail_ESS are effective sample size measures, and Rhat is the potential
# scale reduction factor on split chains (at convergence, Rhat = 1).



#more iterations

interception_model<-brm(total_offer_prop ~ 1 + (1| triad_id) + (1| proposer_id), 
                        data = xdata,
                        warmup = 2000,
                        iter = 3000,
                        chains = 4,
                        inits = "random", cores = 32, family= "beta")



#calculate ICC

hyp <- "sd_class__Intercept^2 / (sd_class__Intercept^2 + sigma^2) = 0"
hypothesis(interception_model, hyp, class = NULL)

#not working, not sure why




#Model 1 with game type as condition


model1<-brm(total_offer_prop ~ 1 + game_type +(1 + game_type| triad_id) + (1 + game_type| proposer_id),
                        data = xdata,
                        warmup = 1000,
                        iter = 4000,
                        chains = 4,
                        inits = "random", cores = 32, family = "beta",
                        control = list(adapt_delta = 0.95))

#1 divergency
pp_check(model1)
summary(model1)
# 
# Links: mu = logit; phi = identity 
# Formula: total_offer_prop ~ 1 + game_type + (1 + game_type | triad_id) + (1 + game_type | proposer_id) 
# Data: xdata (Number of observations: 220) 
# Draws: 4 chains, each with iter = 4000; warmup = 1000; thin = 1;
# total post-warmup draws = 12000
# 
# Group-Level Effects: 
#   ~proposer_id (Number of levels: 5) 
# Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
# sd(Intercept)                       0.86      0.47     0.31     2.10 1.00     4378     6165
# sd(game_typetriadic)                0.40      0.34     0.02     1.26 1.00     3757     4700
# cor(Intercept,game_typetriadic)    -0.22      0.52    -0.96     0.86 1.00     8902     7587
# 
# ~triad_id (Number of levels: 7) 
# Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
# sd(Intercept)                       0.39      0.23     0.07     0.96 1.00     3922     3870
# sd(game_typetriadic)                0.27      0.22     0.01     0.81 1.00     4377     6320
# cor(Intercept,game_typetriadic)    -0.17      0.55    -0.95     0.90 1.00     8444     8674
# 
# Population-Level Effects: 
#   Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
# Intercept           -0.37      0.47    -1.32     0.58 1.00     3550     4422
# game_typetriadic    -0.16      0.29    -0.75     0.42 1.00     6063     5642
# 
# Family Specific Parameters: 
#   Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
# phi     4.61      0.42     3.84     5.48 1.00    14520     8429
# 
# Draws were sampled using sampling(NUTS). For each parameter, Bulk_ESS
# and Tail_ESS are effective sample size measures, and Rhat is the potential
# scale reduction factor on split chains (at convergence, Rhat = 1).



#convergence of the trace plots

#transformation of model 

model1tranformed <- ggs(model1)

get_prior(total_offer_prop ~ 1 + game_type +(1 + game_type | triad_id) + (1 + game_type| proposer_id),
          data = xdata)

# # 
# prior     class             coef       group resp dpar nlpar lb ub       source
# student_t(3, 0.3, 2.5) Intercept                                                         default
# (flat)         b                                                         default
# (flat)         b game_typetriadic                                   (vectorized)
# lkj(1)       cor                                                         default
# lkj(1)       cor                  proposer_id                       (vectorized)
# lkj(1)       cor                     triad_id                       (vectorized)
# student_t(3, 0, 2.5)        sd                                               0         default
# student_t(3, 0, 2.5)        sd                  proposer_id                  0    (vectorized)
# student_t(3, 0, 2.5)        sd        Intercept proposer_id                  0    (vectorized)
# student_t(3, 0, 2.5)        sd game_typetriadic proposer_id                  0    (vectorized)
# student_t(3, 0, 2.5)        sd                     triad_id                  0    (vectorized)
# student_t(3, 0, 2.5)        sd        Intercept    triad_id                  0    (vectorized)
# student_t(3, 0, 2.5)        sd game_typetriadic    triad_id                  0    (vectorized)
# student_t(3, 0, 2.5)     sigma                                               0         default                                                  default
# model1tranformed$Parameter

#caterpilar plots

ggplot(filter(model1tranformed, Parameter %in% c("b_Intercept", "b_game_typetriadic", "phi"),
              Iteration > 1000),
       aes(x   = Iteration,
           y   = value, 
           col = as.factor(Chain)))+
  geom_line()+
  facet_grid(Parameter ~ .,
             scale  = 'free_y',
             switch = 'y')+
  labs(title = "Caterpillar Plots",
       col   = "Chains")     



stanplot(model1, type = "trace")


#checks Gelmann Rubin diagnostic

install.packages("coda")
library(coda)


modelposterior <- as.mcmc(model1) # with the as.mcmc() command we can use all the CODA package convergence statistics and plotting options

gelman.diag(modelposterior[, 1:5])
gelman.plot(modelposterior[, 1:5])


#geweke diagnostic

geweke.diag(modelposterior[, 1:5])
geweke.plot(modelposterior[, 1:5])


#model with twice the iterations

model1_doubleiter<-brm(total_offer_prop ~ 1 + game_type +(1 + game_type| triad_id) + (1 + game_type | proposer_id),
            data = xdata,
            warmup = 1000,
            iter = 8000,
            chains = 4,
            inits = "random", cores = 32, family = "beta",
            control = list(adapt_delta = 0.95))


summary(model1_doubleiter)

# Family: beta 
# Links: mu = logit; phi = identity 
# Formula: total_offer_prop ~ 1 + game_type + (1 + game_type | triad_id) + (1 + game_type | proposer_id) 
# Data: xdata (Number of observations: 220) 
# Draws: 4 chains, each with iter = 8000; warmup = 1000; thin = 1;
# total post-warmup draws = 28000
# 
# Group-Level Effects: 
#   ~proposer_id (Number of levels: 5) 
# Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
# sd(Intercept)                       0.85      0.47     0.31     2.06 1.00    10696    13786
# sd(game_typetriadic)                0.40      0.35     0.02     1.29 1.00     7953    11694
# cor(Intercept,game_typetriadic)    -0.23      0.52    -0.96     0.86 1.00    20775    16828
# 
# ~triad_id (Number of levels: 7) 
# Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
# sd(Intercept)                       0.39      0.22     0.06     0.94 1.00     7301     6271
# sd(game_typetriadic)                0.27      0.22     0.01     0.81 1.00     9999    11977
# cor(Intercept,game_typetriadic)    -0.16      0.55    -0.95     0.91 1.00    17811    16246
# 
# Population-Level Effects: 
#   Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
# Intercept           -0.36      0.45    -1.26     0.58 1.00     8696    11175
# game_typetriadic    -0.16      0.29    -0.77     0.42 1.00    12824    11763
# 
# Family Specific Parameters: 
#   Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
# phi     4.61      0.42     3.82     5.47 1.00    30125    19487
# 
# Draws were sampled using sampling(NUTS). For each parameter, Bulk_ESS
# and Tail_ESS are effective sample size measures, and Rhat is the potential
# scale reduction factor on split chains (at convergence, Rhat = 1).
# Warning message:


modeldoubleniterposterior <- as.mcmc(model1_doubleiter)
# 
# Warning message:
#   as.mcmc.brmsfit is deprecated and will eventually be removed. 
# > 
modelposterior <- as.mcmc(model1) # with the as.mcmc() command we can use all the CODA package convergence statistics and plotting options
gelman.diag(modeldoubleniterposterior[, 1:5])

gelman.plot(modeldoubleniterposterior[, 1:5])



round(100*((summary(model1_doubleiter)$fixed - summary(model1)$fixed) / summary(model1)$fixed), 3)[,"Estimate"]

#unclear result, not sure if ok

stanplot(model1, type = "hist")



#autocorrelation information


autocorr.diag(modelposterior[,1:5], lags = c(0, 1,2,3,4, 5, 10, 50))

# b_Intercept b_game_typetriadic sd_proposer_id__Intercept sd_proposer_id__game_typetriadic
# Lag 0   1.000000000        1.000000000               1.000000000                       1.00000000
# Lag 1   0.532069769        0.320905300               0.335193026                       0.34014327
# Lag 2   0.315920705        0.156477462               0.194377532                       0.24124060
# Lag 3   0.183939840        0.082710278               0.115097065                       0.14283278
# Lag 4   0.114286343        0.035255663               0.085174923                       0.08889638
# Lag 5   0.069098327        0.015769706               0.048343437                       0.06694278
# Lag 10  0.004389269       -0.001692355               0.005927167                       0.00693575
# Lag 50 -0.024647246       -0.007248718               0.010390147                      -0.02144296
# sd_triad_id__Intercept
# Lag 0             1.000000000
# Lag 1             0.271516595
# Lag 2             0.197365166
# Lag 3             0.133299007
# Lag 4             0.077297765
# Lag 5             0.059063961
# Lag 10           -0.001746053
# Lag 50            0.010007761



#plot whether posteriors make sense

ggplot(filter(model1tranformed, Parameter %in% c("b_Intercept", "b_game_typetriadic"), 
              Iteration > 1000),
       aes(x    = value,
           fill = Parameter))+
  geom_density(alpha = .5)+
  geom_vline(xintercept = 0,
             col        = "red",
             size       = 1)+
  scale_x_continuous(name   = "Value",
                     limits = c(-2.2, 1.5))+ 
  geom_vline(xintercept = summary(model1)$fixed[1,3:4], col = "darkgreen", linetype = 2)+
  geom_vline(xintercept = summary(model1)$fixed[2,3:4], col = "blue",      linetype = 2)+
  theme_light()+
  scale_fill_manual(name   =  'Parameters', 
                    values = c("darkgreen" , "lightblue"), 
                    labels = c(expression( " "  ~  gamma[Intercept]),  
                               expression( " "  ~  gamma[GameType])))+
  labs(title = "Posterior Density of Parameters With 95% CCI lines (1)")

#IT DOES NOT WORK

#Error in is.finite(x) : default method not implemented for type 'list'

\