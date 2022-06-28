library(car)
library(ggedit)
library(rstudioapi)
library(dplyr)

rm(list=ls())
# Function to generate the R^2 equation and result to be written into the plot
# usage example: p1 = p + geom_text(aes(x = 25, y = 300, label = lm_eqn(lm(y ~ x, df))), parse = TRUE)
lm_eqn = function(m) {
  
  l <- list(a = format(coef(m)[1], digits = 2),
            b = format(abs(coef(m)[2]), digits = 2),
            r2 = format(summary(m)$r.squared, digits = 3));
  
  if (coef(m)[2] >= 0)  {
    eq <- substitute(italic(y) == a + b %.% italic(x)*","~~italic(r)^2~"="~r2,l)
  } else {
    eq <- substitute(italic(y) == a - b %.% italic(x)*","~~italic(r)^2~"="~r2,l)    
  }
  
  as.character(as.expression(eq));                 
}



# the following line is for getting the path of your current open file
current_path <- getActiveDocumentContext()$path 
# The next line set the working directory to the relevant one:
setwd(dirname(current_path ))

#load data file
# bool_group 1 Intervention group, 2 control group
flag_group<-2;
# bool_analysis:
# 1 GLM r4-r1
# 2 GLM r4-r1 CON
# 7 PPI analysis 
flag_analysis<-1

write_formula<-list(x=.2, y = .8)


if (1 == flag_group && 1 == flag_analysis){
  # for Intervention group contrast r4-r1
  data<-read.csv(file=file.path("Data_Figures_1_2_CognitiveControl_INT_r4-r1.csv"), header=TRUE, dec=".")
  
  data_r4<-read.csv(file=file.path("Data_Figure_2_CognitiveControl_INT_r4only.csv"), header=TRUE, dec=".")
  data_r1<-read.csv(file=file.path("Data_Figure_2_CognitiveControl_INT_r1only.csv"), header=TRUE, dec=".")
  
  # remove control group and cocaine users
  lines_to_remove<-which((data$control=="0" & data$intervention=="0") | (data$control=="1" & data$intervention=="0"))
  if (0 < length(lines_to_remove)){
    data<-data[-lines_to_remove,]
    data_r4<-data_r4[-lines_to_remove,]
    data_r1<-data_r1[-lines_to_remove,]
  }
  
  output_path<-file.path("analysis_pics")
  if (!dir.exists(output_path)) {dir.create(output_path)}
  write_formula<-list(x=.2, y = .8)
  data$Study<-as.factor(data$studyset)
} else if (2 == flag_group && 2 == flag_analysis){
  # for Control group contrast r4-r1
  data<-read.csv(file=file.path("Data_Figure_3_CognitiveControl_CON_r4-r1.csv"), header=TRUE, dec=".")
  
  lines_to_remove<-which(data$control!="1")
  if (0 < length(lines_to_remove)){
    data<-data[-lines_to_remove,]
  }
  output_path<-file.path("analysis_pics")
  write_formula<-list(x=-.1, y = .7)
} else if (1 == flag_group && 7 == flag_analysis) {
  # 
  data<-read.csv(file=file.path("Data_Figure_5_PPI.csv"), header=TRUE, dec=".")
  lines_to_remove<-which((data$control=="0" & data$intervention=="0") | (data$control=="1" & data$intervention=="0"))
  if (0 < length(lines_to_remove)){
    data<-data[-lines_to_remove,]
  }
  output_path<-file.path("analysis_pics")
  if (!dir.exists(output_path)) {dir.create(output_path)}
  write_formula<-list(x=.2, y = 2)
  data$Study<-as.factor(data$studyset)
}

data$studyInt <- interaction(data$studyset, data$intervention)
data$doflzall<-scale(data$dofl, center = TRUE, scale = TRUE)
data = data %>% group_by(studyInt) %>% mutate(doflzsingle = scale(dofl))

# extract all ROI variables
ROInames<-regmatches(colnames(data),regexpr("ROI.*mean", colnames(data)))

for (indROI in 1:length(ROInames)){
  # plot each of these ROIs
  ROItext<-paste("non-midbrain DRT in \n",unlist(strsplit(ROInames[indROI], split="_"))[2]) 
  
  # bootstrap
  frmla <- as.formula(paste("dofl", paste(as.name(ROInames[indROI])), sep = "~"))
  sample.model <- lm(frmla, data = data)
  sample_coef_intercept <- NULL
  sample_coef_x1 <- NULL
  
  for (i in 1:1000) {
    sample_d = data[sample(1:nrow(data), nrow(data), replace = TRUE), ]
    model_bootstrap <- lm(frmla, data = sample_d)
    sample_coef_intercept <- c(sample_coef_intercept, model_bootstrap$coefficients[1])
    sample_coef_x1 <- c(sample_coef_x1, model_bootstrap$coefficients[2])
  }
  coefs<-rbind(sample_coef_intercept, sample_coef_x1)
  means.boot = c(mean(sample_coef_intercept), mean(sample_coef_x1))
  
  a <-
    cbind(
      quantile(sample_coef_intercept, prob = 0.025),
      quantile(sample_coef_intercept, prob = 0.975))
  b <-
    cbind(quantile(sample_coef_x1, prob = 0.025),
          quantile(sample_coef_x1, prob = 0.975))
  c <-
    round(cbind(
      sample = confint(sample.model),
      boot = rbind(a, b)), 4)
  colnames(c) <- c("2.5 %", "97.5 %",
                   "2.5 %", "97.5 %")
  knitr::kable(rbind(
    c('full sample',
      'full sample',
      'bootstrap',
      'bootstrap'),c), "simple")
  
 
  # now plot it
  if (1 == flag_analysis){
    scatter_ROI<-eval(substitute(ggplot(data, aes(x=dofl, y=variable, color=Study)), list(variable = as.name(ROInames[indROI])))) + 
      geom_point(size=8) + geom_smooth(method=lm, aes(group=1)) +
      theme_minimal() + 
      labs(title="",x="midbrain \n degree of regulation transfer", y = ROItext)+
      theme(axis.text = element_text(colour="grey20",size=32,hjust=.5,vjust=.5,face="plain"), 
            axis.title = element_text(colour="grey40",size=32,hjust=.5,vjust=.5,face="plain")) +
      scale_color_manual(name="Study",values=c("#9ecae1", "#3282bd")) 
      
  }
  if (2 == flag_analysis){
    scatter_ROI<-eval(substitute(ggplot(data, aes(x=dofl, y=variable)), list(variable = as.name(ROInames[indROI])))) + 
      geom_point(size=8) + geom_smooth(method=lm) +
      theme_minimal() + 
      labs(title="",x="midbrain \n degree of regulation transfer", y = ROItext)+
      theme(axis.text = element_text(colour="grey20",size=32,hjust=.5,vjust=.5,face="plain"), 
            axis.title = element_text(colour="grey40",size=32,hjust=.5,vjust=.5,face="plain"))
        
  }
  
  if (7 == flag_analysis){
    scatter_ROI<-eval(substitute(ggplot(data, aes(x=dofl, y=variable, color=Study)), list(variable = as.name(ROInames[indROI])))) + 
      geom_point(size=8) + 
      theme_minimal() + 
      labs(title="",x="midbrain \n degree of regulation transfer", y = "dlPFC-SN/VTA \n connectivity")+
      theme(axis.text = element_text(colour="grey20",size=32,hjust=.5,vjust=.5,face="plain"), 
            axis.title = element_text(colour="grey40",size=32,hjust=.5,vjust=.5,face="plain")) +
      scale_color_manual(name="Study", values=c("#9ecae1", "#3282bd")) 
      
  }
  
  scatter_ROI 

  filename<-paste(as.name(ROInames[indROI]),"_NoFormula.png", sep="")
  ggsave(filename, plot = scatter_ROI, path = output_path,
         scale = 1, width = 8.3, height = 6.25, units = c("in"),
         dpi = 300, limitsize = TRUE)
  
  if (1 == flag_group && 1 == flag_analysis){
    scatter_ROI<-scatter_ROI + 
      theme(legend.position = "bottom") +
      eval(substitute(geom_point(data = data_r1, aes(x=dofl, y=variable, color = data$Study), size=8, shape=2), list(variable = as.name(ROInames[indROI]))))+
      geom_point(aes(shape="average signal in run 1"))+
      eval(substitute(geom_point(data = data_r4, aes(x=dofl, y=variable, color = data$Study), size=8, shape=4), list(variable = as.name(ROInames[indROI]))))+
      geom_point(aes(shape="average signal in run 4"))+
      scale_shape_manual(name="Shapes: ", values=c('average signal in run 1'=2,'average signal in run 4'=4))+
      scale_color_manual(values=c("#9ecae1", "#3282bd"))
     
      

    scatter_ROI 
    filename<-paste(as.name(ROInames[indROI]),"_AdditionalRunwiseValues.png", sep="")
    ggsave(filename, plot = scatter_ROI, path = output_path,
           scale = 1, width = 8.3, height = 6.25, units = c("in"),
           dpi = 300, limitsize = TRUE)
    
    
  }
}
