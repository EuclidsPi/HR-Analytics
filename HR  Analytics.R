library(writexl)
library(tidyverse)
library(gridExtra)
library(caret)
library(randomForest)
library(caTools)
library(MASS)
library(car)
library(pROC)
library(ggcorrplot)
library(mice)
library(VIM)
library(plyr)

setwd("C:/Users/ezeki/Dropbox/WGU Assessments/")

hire = read.csv("aug_train.csv", stringsAsFactors=TRUE, na.strings = "")



summary(hire)
pMiss <- function(x){sum(is.na(x))/length(x)*100}
apply(hire,2,pMiss)
apply(hire,1,pMiss)
md.pattern(hire)

na_rows = rowSums(is.na(hire))
which.max(na_rows)
which(na_rows>3)
hire <- hire[-c(which(na_rows>0)),]
hire[which(na_rows>5),]
aggr_plot <- aggr(hire, col=c('navyblue', 'red'), only.miss = TRUE, numbers=TRUE, sortVars=TRUE, labels=names(data), cex.axis=.5, cex.numbers = .5, ylab=c("Histogram of missing data", "Pattern"))



set.seed(818)
sample_size <- floor(.75 * nrow(hire))
part <- sample(seq_len(nrow(hire)), size = sample_size)
train <- hire[part,]
test <- hire[-part,]


model1 = glm(target ~., data = train, family = "binomial")
summary(model1)
model2 <- stepAIC(model1, direction = "both")
summary(model2)
vif(model2)

logitgof(model2$target, fitted(model2))

set.seed(818)
sample_size <- floor(.75 * nrow(hire))
part <- sample(seq_len(nrow(hire)), size = sample_size)
train_tree <- hire[part,]
test_tree <- hire[-part,]

rf = randomForest(target ~., data = train_tree)
rf
pred = predict(rf, newdata = test_tree[-20])
table(pred, test_tree$target)
confusionMatrix(test_tree$target, pred)
varImpPlot(rf) 
