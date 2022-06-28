
library(car)
library(ggedit)
library(rstudioapi)
library(plyr)
library(readr)
library(dplyr)
library(ggplot2)
library(ggpubr)

dcm_INT = read.csv(file=file.path("Data_SupplementaryFigure_8_DCM_INT.csv"), header=TRUE, dec=".")

drt_INT = read.csv(file=file.path("Data_SupplementaryFigure_8_DCM_DRT.csv"), header=TRUE, dec=".")

df1 = data.frame(drt_INT, dcm_INT)

my_graph1 <- ggplot(df1, aes(x = drt_INT, y = dcm_INT)) +
  geom_point() + xlab("midbrain degree of regulation transfer") + ylab("modulatory effect on \n effective connectivity \n by IMAGINE_REWARD") + 
  
  #ggtitle("Inverted feedback group") + 
  theme(text = element_text(size = 48)) +
  theme_minimal() +
  theme(axis.text = element_text(colour="grey20",size=30,hjust=.5,vjust=.5,face="plain"), 
        axis.title = element_text(colour="grey40",size=30,hjust=.5,vjust=.5,face="plain")) + 
  stat_smooth(method = "lm",
              col = "#C42126",
              se = TRUE,
              size = 1)
my_graph1



# bootstrap
frmla <- as.formula(paste("drt_INT", "dcm_INT", sep = "~"))
sample.model <- lm(frmla, data = df1)
sample_coef_intercept <- NULL
sample_coef_x1 <- NULL

for (i in 1:1000) {
  sample_d = df1[sample(1:nrow(df1), nrow(df1), replace = TRUE), ]
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