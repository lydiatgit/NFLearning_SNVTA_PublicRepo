library(car)
library(ggedit)
library(rstudioapi)
library(GeneNet)
library(dplyr)

rm(list=ls())
# the following line is for getting the path of your current open file
current_path <- getActiveDocumentContext()$path 
# The next line set the working directory to the relevant one:
setwd(dirname(current_path ))

output_path<-file.path("analysis_pics")
if (!dir.exists(output_path)) {dir.create(output_path)}

#load data file
data<-read.csv(file=file.path("Data_Figure_1_DRTs.csv"), header=TRUE, dec=".")
data_ordered<-data[order(data$group, data$DORT),]

data_INT <- data_ordered[data_ordered$group==1,]                                                 # Replicate original data
data_INT$x <- 1:length(data_INT$subject)

data_CON <- data_ordered[data_ordered$group==2,]                                                 # Replicate original data
data_CON$x <- 1:length(data_CON$subject)


my_plot_INT<-ggplot(data_INT, aes(x, DORT)) +                                    # Increasingly ordered barchart
  geom_bar(stat = "identity", fill = "#0072bd") + theme_minimal() +
  xlab("participant") + ylab("midbrain DRT") + 
  ggtitle("Standard feedback group") + theme(plot.title = element_text(color="#333333", size = 14, hjust = 0.5), 
                                             axis.title.x = element_text(color = "#666666"),
                                             axis.title.y = element_text(color = "#666666"))
  
  
  
my_plot_INT


my_plot_CON<-ggplot(data_CON, aes(x, DORT)) +                                    # Increasingly ordered barchart
  geom_bar(stat = "identity", fill = "#99CCFF") + theme_minimal() +
  xlab("participant") + ylab("midbrain DRT") +
  ggtitle("Inverted feedback group") + theme(plot.title = element_text(color="#333333", size = 14, hjust = 0.5), 
                                           axis.title.x = element_text(color = "#666666"),
                                           axis.title.y = element_text(color = "#666666")) +
  ylim(-1,1)

my_plot_CON


ggsave("DRTranking_INT.png", plot = my_plot_INT, path = output_path,
       scale = 1, width = 8.3, height = 6.25, units = c("in"),
       dpi = 300, limitsize = TRUE)
ggsave("DRTranking_CON.png", plot = my_plot_CON, path = output_path,
       scale = 1, width = 8.3, height = 6.25, units = c("in"),
       dpi = 300, limitsize = TRUE)
