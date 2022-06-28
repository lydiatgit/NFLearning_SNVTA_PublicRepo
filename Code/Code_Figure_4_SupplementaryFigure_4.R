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

write_formula<-list(x=.2, y = .7)

# for Intervention group contrast r4-r1
  data_r3r2<-read.csv(file=file.path("Data_Figure_4_TempDiff_r3-r2.csv"), header=TRUE, dec=".")

  
  output_path<-file.path("analysis_pics")
  if (!dir.exists(output_path)) {dir.create(output_path)}
  

  # for single runs r2 and r3
  data_r2<-read.csv(file=file.path("Data_SupplementaryFigure_4_r2only.csv"), header=TRUE, dec=".")
  data_r3<-read.csv(file=file.path("Data_SupplementaryFigure_4_r3only.csv"), header=TRUE, dec=".")
  # z-trafos due to review request
  data_r3r2$studyInt <- interaction(data_r3r2$studyset, data_r3r2$intervention)
  data_r3r2$doflzall<-scale(data_r3r2$dofl, center = TRUE, scale = TRUE)
  data_r3r2 = data_r3r2 %>% group_by(studyInt) %>% mutate(doflzsingle = scale(dofl))
  
  
  
  data_merge<-data_r3r2
  data_merge$r2<-data_r2$ROI_dlPFC_predictionError_NFPmodDelata_r3r2_mean
  data_merge$r3<-data_r3$ROI_dlPFC_predictionError_NFPmodDelata_r3r2_mean

  # remove CON group
  lines_to_remove<-which((data_merge$control=="0" & data_merge$intervention=="0") | (data_merge$control=="1" & data_merge$intervention=="0"))
  if (0 < length(lines_to_remove)){
    data_merge<-data_merge[-lines_to_remove,]
  }
  
  
  
  # extract all ROI variables
  ROInames<-'ROI_dlPFC_predictionError_NFPmodDelata_r3r2_mean'
data_merge$Study<-as.factor(data_merge$studyset)
for (indROI in 1:length(ROInames)){
  # plot each of these ROIs
  ROItext<-paste("%signal change \n",unlist(strsplit(ROInames[indROI], split="_"))[2]) 
  
 
  
  scatter_ROI<-eval(substitute(ggplot(data_merge, aes(x=dofl, y=variable, color=Study)), list(variable = as.name(ROInames[indROI])))) + 
    geom_point(size=8) + geom_smooth(method=lm, aes(group=1)) + 
    theme_minimal()+ 
    labs(title="",x="midbrain \n degree of regulation transfer", y = "slope of temporal \n difference error coding \n over training runs") +
    theme(axis.text = element_text(colour="grey20",size=32,hjust=.5,vjust=.5,face="plain"), 
          axis.title = element_text(colour="grey40",size=32,hjust=.5,vjust=.5,face="plain")) +
    scale_color_manual(name="Study", values=c("#9ecae1", "#3282bd"))
    
  
  scatter_ROI
  filename<-paste(as.name(ROInames[indROI]),"_dofl_NoFormula.png", sep="")
  ggsave(filename, plot = scatter_ROI, path = output_path,
         scale = 1, width = 8.3, height = 6.25, units = c("in"),
         dpi = 300, limitsize = TRUE)
  scatter_ROI<-scatter_ROI + 
    geom_point(data = data_merge, aes(x=dofl, y=r2), size=4, color='grey40', shape=2) +
    geom_point(aes(shape="average signal in NF training run 1"))+
    geom_point(data = data_merge, aes(x=dofl, y=r3), size=4, color='grey40', shape=4)+
    geom_point(aes(shape="average signal in NF training run 2"))+
    scale_shape_manual(name="", values=c('average signal in \nNF training run 1'=2,'average signal in \nNF training run 2'=4))+
    theme(legend.position = "bottom", legend.text=element_text(size=14))
  scatter_ROI
  filename<-paste(as.name(ROInames[indROI]),"_dofl_AdditionalRunwiseValues.png", sep="")
  ggsave(filename, plot = scatter_ROI, path = output_path,
         scale = 1, width = 8.4, height = 6.25, units = c("in"),
         dpi = 300, limitsize = TRUE)
  
  
}

