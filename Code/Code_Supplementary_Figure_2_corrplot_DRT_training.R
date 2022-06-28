library(car)
library(ggedit)
library(rstudioapi)
library(plyr)
library(readr)
library(dplyr)
library(ggplot2)
library(ggpubr)

# for Intervention group
data_INT<-read.csv(file=file.path("Data_Supplementary_Figure_2_DRTslope_INT.csv"), header=TRUE, dec=".")

data_CON<-read.csv(file=file.path("Data_Supplementary_Figure_2_DRTslope_CON.csv"), header=TRUE, dec=".")


dort_CON <- data_CON$DORT

slope_CON <- data_CON$slope 

slope_INT <- data_INT$slope

dort_INT <- data_INT$DORT

df1 = data.frame(dort_CON, slope_CON)
df2 = data.frame(dort_INT, slope_INT)

my_graph1 <- ggplot(df1, aes(x = dort_CON, y = slope_CON)) +
  geom_point() + xlab("midbrain degree of regulation transfer") + ylab("slope during training") + 
  ggtitle("Inverted feedback group") + 
  theme(text = element_text(size = 20)) +
  stat_smooth(method = "lm",
              col = "#C42126",
              se = TRUE,
              size = 1)
my_graph1

my_graph2 <- ggplot(df2, aes(x = dort_INT, y = slope_INT)) +
  geom_point()  + xlab("midbrain degree of regulation transfer") + ylab("slope during training") + 
  ggtitle("Standard feedback group") + 
  theme(text = element_text(size = 20)) +
  stat_smooth(method = "lm",
              col = "#C42126",
              se = TRUE,
              size = 1)
my_graph2

