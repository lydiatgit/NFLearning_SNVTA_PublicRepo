library(ggplot2)
library(ggedit)
library(dplyr)
library(reshape)


# the following line is for getting the path of your current open file
current_path <- getActiveDocumentContext()$path 
# The next line set the working directory to the relevant one:
setwd(dirname(current_path ))

output_path<-file.path("analysis_pics")
if (!dir.exists(output_path)) {dir.create(output_path)}

#load data file
data_UP<-read.csv(file=file.path("Data_SupplementaryFigure_9_UP.csv"), header=TRUE, dec=".")
data_DOWN<-read.csv(file=file.path("Data_SupplementaryFigure_9_DOWN.csv"), header=TRUE, dec=".")
data_DOWN<-data_DOWN %>% mutate(condition = 'REST')
data_UP<-data_UP %>% mutate(condition = 'IMAGINE REWARD')
data_DOWN <- melt(data_DOWN)
data_UP <- melt(data_UP)

data<-rbind(data_UP, data_DOWN)

data <- data %>% mutate(variable = recode(variable, run1 = "Baseline", 
                                          run2 = "Training 1",
                                          run3 = "Training 2",
                                          run4 = "Training 3",
                                          run5 = "Transfer"))



my_plot<-ggplot(data, aes(x=variable, y=value, fill = condition)) + 
  geom_boxplot() + geom_jitter(color="black", size = 0.4) +
  scale_fill_manual(values=c("#666666", "grey")) +
  xlab("") + ylab("% signal change SN/VTA") +
  theme(text = element_text(size = 14)) + theme(legend.position = "bottom")


my_plot
ggsave("boxplot_SignalChangeSNVTA_conditionWise.png", plot = my_plot, path = output_path,
       scale = 1, width = 8.3, height = 6.25, units = c("in"),
       dpi = 300, limitsize = TRUE)




