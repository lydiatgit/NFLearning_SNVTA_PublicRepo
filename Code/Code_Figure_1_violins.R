library(car)
library(ggedit)
library(rstudioapi)
library(GeneNet)
library(dplyr)


# the following line is for getting the path of your current open file
current_path <- getActiveDocumentContext()$path 
# The next line set the working directory to the relevant one:
setwd(dirname(current_path ))

#load data file
data<-read.csv(file=file.path("Data_Figure_1_DRTs.csv"), header=TRUE, dec=".")
data$studyInt <- interaction(data$studyset, data$intervention)
data$doflzall<-scale(data$dofl, center = TRUE, scale = TRUE)
data = data %>% group_by(studyInt) %>% mutate(doflzsingle = scale(dofl))

violins<-ggplot(data, aes(x = factor(studyInt,levels=c('1.0','1.1','2.1')) , y = dofl)) +
  geom_violin(aes(fill = studyInt))+
  geom_jitter()+
  scale_fill_brewer(palette="Blues")+
  theme_minimal() + 
  theme(legend.position = "none")+
  labs(title="",x="", y = "degree of \n regulation transfer (DRT)")+
  theme(axis.text = element_text(colour="grey20",size=20,hjust=.5,vjust=.5,face="plain"), 
        axis.title = element_text(colour="grey40",size=20,hjust=.5,vjust=.5,face="plain")) + 
  scale_x_discrete(breaks=c("1.0","1.1","2.1"),labels=c("inverted feedback \n group Study 1","veridical feedback\n group Study 1", "veridical feedback \n group Study 2"))
        
  
  
violins

# t-test to compare intervention groups
dofl_JSInt<-data$doflzall[data$studyInt=='1.1']
dofl_MKINT<-data$doflzall[data$studyInt=='2.1']
t.test(dofl_JSInt,dofl_MKINT)


dofl_JSControl<-data$dofl[data$studyInt=='1.0']
t.test(dofl_JSInt,dofl_JSControl)

res.aov <- aov(dofl ~ studyInt, data = data)
summary(res.aov)
