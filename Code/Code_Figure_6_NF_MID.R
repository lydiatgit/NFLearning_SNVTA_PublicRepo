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

write_formula<-list(x=.2, y = .8)

# for Intervention group contrast r4-r1
  data_merge<-read.csv(file=file.path("Data_Figure_6_NF_MID.csv"), header=TRUE, dec=".")

  
  output_path<-file.path("analysis_pics")
  if (!dir.exists(output_path)) {dir.create(output_path)}

# extract all ROI variables
  ROInames<-'ROI_NF_dlPFC_mean'
 
for (indROI in 1:length(ROInames)){
  # plot each of these ROIs
  ROItext<-paste("%signal change \n",unlist(strsplit(ROInames[indROI], split="_"))[2]) 
  
  # bootstrap
  frmla <- as.formula(paste("dofl", paste(as.name(ROInames[indROI])), sep = "~"))
  sample.model <- lm(frmla, data = data_merge)
  sample_coef_intercept <- NULL
  sample_coef_x1 <- NULL
  
  for (i in 1:1000) {
    sample_d = data_merge[sample(1:nrow(data_merge), nrow(data_merge), replace = TRUE), ]
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
  
  scatter_ROI<-ggplot(data_merge, aes(x=dofl, y=V1.x)) +
    geom_point(size=8) + geom_smooth(method=lm) +
    eval(substitute(geom_text(aes(x=-write_formula$x , y=write_formula$y, label=lm_eqn(lm(V1.x ~ variable, data_merge))), parse=TRUE, size=10), list(variable = as.name(ROInames[indROI])))) +
    theme_minimal() +
    theme(legend.position = "none")+
    labs(title="",x="midbrain \n degree of learning", y = "Learning related change \n in adaptive coding MID task")+
    theme(axis.text = element_text(colour="grey20",size=32,hjust=.5,vjust=.5,face="plain"),
          axis.title = element_text(colour="grey40",size=32,hjust=.5,vjust=.5,face="plain"))

  scatter_ROI
  filename<-paste(as.name(ROInames[indROI]),"_dofl_MIDAC.png", sep="")
  ggsave(filename, plot = scatter_ROI, path = output_path,
         scale = 1, width = 8.3, height = 6.25, units = c("in"),
         dpi = 300, limitsize = TRUE)
  
  scatter_ROI<-ggplot(data_merge, aes(x=dofl, y=V1.x)) +
    geom_point(size=8, shape=20, colour="green") + 
    geom_smooth(method=lm) +
    theme_minimal() +
    theme(legend.position = "none")  +
    labs(title="",x="midbrain degree of regulation \n transfer", y = "adaptive coding in \n dlPFC MID task")+
    theme(axis.text = element_text(colour="grey20",size=32,hjust=.5,vjust=.5,face="plain"),
          axis.title = element_text(colour="grey40",size=32,hjust=.5,vjust=.5,face="plain"))
  scatter_ROI
  filename<-paste(as.name(ROInames[indROI]),"_dofl_MIDcombined.png", sep="")
  ggsave(filename, plot = scatter_ROI, path = output_path,
         scale = 1, width = 8.3, height = 6.25, units = c("in"),
         dpi = 300, limitsize = TRUE)
  
  scatter_ROI<-eval(substitute(ggplot(data_merge, aes(x=dofl, y=variable)), list(variable = as.name(ROInames[indROI])))) +
    geom_point(size=8) + geom_smooth(method=lm) +
    eval(substitute(geom_text(aes(x=-write_formula$x , y=write_formula$y, label=lm_eqn(lm(V1.y ~ variable, data_merge))), parse=TRUE, size=10), list(variable = as.name(ROInames[indROI])))) +
    theme_minimal() +
    theme(legend.position = "none")+
    labs(title="",x="midbrain \n degree of regulation \n transfer", y = "Learning related change \n in dlPFC NF task")+
    theme(axis.text = element_text(colour="grey20",size=32,hjust=.5,vjust=.5,face="plain"),
          axis.title = element_text(colour="grey40",size=32,hjust=.5,vjust=.5,face="plain"))
   
  scatter_ROI
  filename<-paste(as.name(ROInames[indROI]),"_dofl_NF.png", sep="")
  ggsave(filename, plot = scatter_ROI, path = output_path,
         scale = 1, width = 8.3, height = 6.25, units = c("in"),
         dpi = 300, limitsize = TRUE)
  
}

