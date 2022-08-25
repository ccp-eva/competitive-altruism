#try to transform dataset2

library(dplyr)
library(tidyr)


xdata<- competitive_altruism_dataset

library(dplyr)

##model 1


#dyadic data left offer
xdata_d<-subset(xdata,condition_tri_di=="dyadic")
xdata_d_l<-subset(xdata_d, offer_left!="na")

xdata_d_l$offer_left<-as.numeric(as.character(xdata_d_l$offer_left))

data_d_l<-xdata_d_l%>%group_by(dyad,proposer_L,condition_tri_di,session)%>% 
  summarise(offer_left = ((sum(offer_left)/32)))



#dyadic data right offer

xdata_d<-subset(xdata,condition_tri_di=="dyadic")
xdata_d_r<-subset(xdata_d, offer_right!="na")

xdata_d_r$offer_right<-as.numeric(as.character(xdata_d_r$offer_right))

data_d_r<-xdata_d_r%>%group_by(dyad,proposer_right,condition_tri_di,session)%>% 
  summarise(offer_right = ((sum(offer_right)/32)))


#triadic data left offer

xdata_t<-subset(xdata,condition_tri_di=="triadic")
xdata_t_l<-subset(xdata_t, offer_left!="na")

xdata_t_l$offer_left<-as.numeric(as.character(xdata_t_l$offer_left))

data_t_l<-xdata_t_l%>%group_by(dyad,proposer_L,condition_tri_di,session)%>% 
  summarise(offer_left = ((sum(offer_left)/64)))


#triadic data right offer

xdata_t<-subset(xdata,condition_tri_di=="triadic")
xdata_t_r<-subset(xdata_t, offer_right!="na")

xdata_t_r$offer_right<-as.numeric(as.character(xdata_t_r$offer_right))

data_t_r<-xdata_t_r%>%group_by(dyad,proposer_right,condition_tri_di,session)%>% 
  summarise(offer_right = ((sum(offer_right)/64)))
  
  




######model 2

#simultaneous

#triadic simultaneous left offer

xdata_t_l_sim<-subset(xdata, condition_tri_di=="triadic")
xdata_t_l_sim<-subset(xdata_t_l_sim, offer_left!="na")
xdata_t_l_sim<-subset(xdata_t_l_sim, type_trial=="simultaneous")

xdata_t_l_sim$offer_left<-as.numeric(as.character(xdata_t_l_sim$offer_left))

data_t_l_sim<-xdata_t_l_sim%>%group_by(dyad,proposer_L,type_trial,session)%>% 
summarise(offer_left = ((sum(offer_left)/32)))
  

###triadic simultaneous right offer

xdata_t_r_sim<-subset(xdata, condition_tri_di=="triadic")
xdata_t_r_sim<-subset(xdata_t_r_sim, offer_right!="na")
xdata_t_r_sim<-subset(xdata_t_r_sim, type_trial=="simultaneous")

xdata_t_r_sim$offer_right<-as.numeric(as.character(xdata_t_r_sim$offer_right))

data_t_r_sim<-xdata_t_r_sim%>%group_by(dyad,proposer_right,type_trial,session)%>% 
  summarise(offer_right = ((sum(offer_right)/32)))

#consecutive


#triadic consec left offer FIRST

xdata_t_l_cons_first<-subset(xdata, condition_tri_di=="triadic")
xdata_t_l_cons_first<-subset(xdata_t_l_cons_first, offer_left!="na")
xdata_t_l_cons_first<-subset(xdata_t_l_cons_first, type_trial=="cons_left")

xdata_t_l_cons_first$offer_left<-as.numeric(as.character(xdata_t_l_cons_first$offer_left))

data_t_l_cons_first<-xdata_t_l_cons_first%>%group_by(dyad,proposer_L,type_trial,session)%>% 
  summarise(offer_left = ((sum(offer_left)/16)))


#triadic consec left offer SECOND

xdata_t_l_cons_sec<-subset(xdata, condition_tri_di=="triadic")
xdata_t_l_cons_sec<-subset(xdata_t_l_cons_sec, offer_right!="na")
xdata_t_l_cons_sec<-subset(xdata_t_l_cons_sec, type_trial=="cons_left")

xdata_t_l_cons_sec$offer_right<-as.numeric(as.character(xdata_t_l_cons_sec$offer_right))

data_t_l_cons_sec<-xdata_t_l_cons_sec%>%group_by(dyad,proposer_right,type_trial,session)%>% 
  summarise(offer_right = ((sum(offer_right)/16)))




#triadic consec right offer FIRST

xdata_t_r_cons_first<-subset(xdata, condition_tri_di=="triadic")
xdata_t_r_cons_first<-subset(xdata_t_r_cons_first, offer_right!="na")
xdata_t_r_cons_first<-subset(xdata_t_r_cons_first, type_trial=="cons_right")

xdata_t_r_cons_first$offer_right<-as.numeric(as.character(xdata_t_r_cons_first$offer_right))

data_t_r_cons_first<-xdata_t_r_cons_first%>%group_by(dyad,proposer_right,type_trial,session)%>% 
  summarise(offer_right = ((sum(offer_right)/16)))



#triadic consec right offer SECOND

xdata_t_r_cons_sec<-subset(xdata, condition_tri_di=="triadic")
xdata_t_r_cons_sec<-subset(xdata_t_r_cons_sec, offer_left!="na")
xdata_t_r_cons_sec<-subset(xdata_t_r_cons_sec, type_trial=="cons_right")

xdata_t_r_cons_sec$offer_left<-as.numeric(as.character(xdata_t_r_cons_sec$offer_left))

data_t_r_cons_sec<-xdata_t_r_cons_sec%>%group_by(dyad,proposer_L,type_trial,session)%>% 
  summarise(offer_left = ((sum(offer_left)/16)))






#####information for model 2 (updated)BASED ON FIRST HALF OF DATA

##simultaneous data
#triadic simultaneous left

xdata_triadic_first_half<-subset(xdata, condition_tri_di=="triadic")
xdata_triadic_first_half<-subset(xdata_triadic_first_half, trial<5)

xdata_triadic_first_half_left<-subset(xdata_triadic_first_half, offer_left!="na")
xdata_triadic_first_half_left_sim<-subset(xdata_triadic_first_half_left, type_trial=="simultaneous")


xdata_triadic_first_half_left_sim$offer_left<-as.numeric(as.character(xdata_triadic_first_half_left_sim$offer_left))

triadic_first_half_left_sim<-xdata_triadic_first_half_left_sim%>%group_by(dyad,proposer_L,type_trial,session)%>% 
  summarise(offer_left = ((sum(offer_left)/32)))

#triadic simultaneous right

xdata_triadic_first_half<-subset(xdata, condition_tri_di=="triadic")
xdata_triadic_first_half<-subset(xdata_triadic_first_half, trial<5)

xdata_triadic_first_half_right<-subset(xdata_triadic_first_half,offer_right!="na")
xdata_triadic_first_half_right_sim<-subset(xdata_triadic_first_half_right, type_trial=="simultaneous")


xdata_triadic_first_half_right_sim$offer_right<-as.numeric(as.character(xdata_triadic_first_half_right_sim$offer_right))

triadic_first_half_right_sim<-xdata_triadic_first_half_right_sim%>%group_by(dyad,proposer_right,type_trial,session)%>% 
  summarise(offer_right = ((sum(offer_right)/32)))


##consecutive data
#triadic consecutive left first proposer



xdata_triadic_first_half<-subset(xdata, condition_tri_di=="triadic")
xdata_triadic_first_half<-subset(xdata_triadic_first_half, trial<5)


xdata_t_l_cons_first_1half<-subset(xdata_triadic_first_half, offer_left!="na")
xdata_t_l_cons_first_1half<-subset(xdata_t_l_cons_first_1half, type_trial=="cons_left")

xdata_t_l_cons_first_1half$offer_left<-as.numeric(as.character(xdata_t_l_cons_first_1half$offer_left))

data_t_l_cons_first_1half<-xdata_t_l_cons_first_1half%>%group_by(dyad,proposer_L,type_trial,session)%>% 
  summarise(offer_left = ((sum(offer_left)/16)))





#triadic consecutive right first proposer



xdata_triadic_first_half<-subset(xdata, condition_tri_di=="triadic")
xdata_triadic_first_half<-subset(xdata_triadic_first_half, trial<5)


xdata_t_r_cons_first_1half<-subset(xdata_triadic_first_half, offer_right!="na")
xdata_t_r_cons_first_1half<-subset(xdata_t_r_cons_first_1half, type_trial=="cons_right")

xdata_t_r_cons_first_1half$offer_right<-as.numeric(as.character(xdata_t_r_cons_first_1half$offer_right))

data_t_r_cons_first_1half<-xdata_t_r_cons_first_1half%>%group_by(dyad,proposer_right,type_trial,session)%>% 
  summarise(offer_right = ((sum(offer_right)/16)))












##transform to csv for dyadic_triadic
write.csv(data_d_l,"C:/Users/alex_sanchez/Nextcloud/Postdoc MPI EVA/Ultimatum altruistic comp/Stats/data_d_l.csv", row.names = FALSE)

write.csv(data_d_r,"C:/Users/alex_sanchez/Nextcloud/Postdoc MPI EVA/Ultimatum altruistic comp/Stats/data_d_r.csv", row.names = FALSE)

write.csv(data_t_l,"C:/Users/alex_sanchez/Nextcloud/Postdoc MPI EVA/Ultimatum altruistic comp/Stats/data_t_l.csv", row.names = FALSE)

write.csv(data_t_r,"C:/Users/alex_sanchez/Nextcloud/Postdoc MPI EVA/Ultimatum altruistic comp/Stats/data_t_r.csv", row.names = FALSE)


#transform to csv for triadic sim/cons

write.csv(data_t_l_sim,"C:/Users/alex_sanchez/Nextcloud/Postdoc MPI EVA/Ultimatum altruistic comp/Stats/data_t_l_sim.csv", row.names = FALSE)

write.csv(data_t_r_sim,"C:/Users/alex_sanchez/Nextcloud/Postdoc MPI EVA/Ultimatum altruistic comp/Stats/data_t_r_sim.csv", row.names = FALSE)

write.csv(data_t_l_cons_first,"C:/Users/alex_sanchez/Nextcloud/Postdoc MPI EVA/Ultimatum altruistic comp/Stats/data_t_l_cons_first.csv", row.names = FALSE)

write.csv(data_t_l_cons_sec,"C:/Users/alex_sanchez/Nextcloud/Postdoc MPI EVA/Ultimatum altruistic comp/Stats/data_t_l_cons_sec.csv", row.names = FALSE)

write.csv(data_t_r_cons_first,"C:/Users/alex_sanchez/Nextcloud/Postdoc MPI EVA/Ultimatum altruistic comp/Stats/data_t_r_cons_first.csv", row.names = FALSE)

write.csv(data_t_r_cons_sec,"C:/Users/alex_sanchez/Nextcloud/Postdoc MPI EVA/Ultimatum altruistic comp/Stats/data_t_r_cons_sec.csv", row.names = FALSE)

