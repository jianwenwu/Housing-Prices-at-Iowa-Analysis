
library(readr)
library(plyr)
library(ggplot2)
library(data.table)
library(forecast)
library(plotly)
library(car)
library(corrplot)
library(lmtest)
library(caret)
library(purrr)
library(tidyr)
library(ggplot2)
library(zoo)
library(corrplot)
library(tidyverse)
library(dplyr)
# read the data into R dataframe
df_train<- read.csv("C://Users//nitas//Desktop//Books//Stat 707//project//training.csv",header=TRUE)
str(df_train)

#plots


df_num<- df_train %>% select_if(is.numeric)
df_fac<- df_train %>% select_if(negate(is.numeric))


##df_num1<- df_train %>% keep(is.numeric) %>% head()
##df_fac1<- df_train %>% keep(is.factor) %>% head()
str(df_num)
str(df_fac)


##correlation between numerical variables
zv <- apply(df_num, 2, function(x) length(unique(x)) == 1)
dfr <- df_num[, !zv]
n=length(colnames(dfr))

##treating missing values and replacing it with mean value
dfr[] <- lapply(dfr, na.aggregate)

correlations <- cor(dfr)
corrplot(correlations, method="circle", type="lower",  sig.level = 10, insig = "blank", tl.srt = 90, tl.cex=.6)

##bar charts for catogorical data
n <- as.list(rep("", 43)) 
p <- as.list(rep("", 43)) 
for (i in 1:43)
    {
  n[[i]]<- print(colnames(df_fac[i]),quote=FALSE)
  p[[i]]<- ggplot(data=df_train, aes_string (x= n[[i]], y="SalePrice")) + geom_bar(stat="identity") 
      
}


cowplot::plot_grid(p[[1]], p[[2]], p[[3]], p[[4]],p[[5]], p[[6]], p[[7]], p[[8]], p[[9]], p[[10]],
                  ncol = 2)

cowplot::plot_grid(p[[11]], p[[12]], p[[13]], p[[14]],p[[15]], p[[16]], p[[17]], p[[18]], p[[19]], p[[20]],
                   ncol = 2)

cowplot::plot_grid(p[[21]], p[[22]], p[[23]], p[[24]],p[[25]], p[[26]], p[[27]], p[[28]], p[[29]], p[[30]], 
                   ncol = 2)

cowplot::plot_grid(p[[31]], p[[32]], p[[33]], p[[34]],p[[35]], p[[36]], p[[37]], p[[38]], p[[39]], p[[40]],
                   p[[41]], p[[42]], p[[43]],ncol = 2)

##bar charts of numeric categorical variable
p1<- ggplot(data=df_train, aes_string (x= "BsmtFullBath", y="SalePrice")) + geom_bar(stat="identity") 
p2<- ggplot(data=df_train, aes_string (x= "BsmtHalfBath", y="SalePrice")) + geom_bar(stat="identity") 
p3<- ggplot(data=df_train, aes_string (x= "FullBath", y="SalePrice")) + geom_bar(stat="identity") 
p4<- ggplot(data=df_train, aes_string (x= "HalfBath", y="SalePrice")) + geom_bar(stat="identity") 
p5<- ggplot(data=df_train, aes_string (x= "BedroomAbvGr", y="SalePrice")) + geom_bar(stat="identity") 
p6<- ggplot(data=df_train, aes_string (x= "Fireplaces", y="SalePrice")) + geom_bar(stat="identity") 
p7<- ggplot(data=df_train, aes_string (x= "GarageCars", y="SalePrice")) + geom_bar(stat="identity") 


cowplot::plot_grid(p1,p2,p3,p4,p5,p6,p7,ncol = 2)

##converting variables into factors
df_fac$f.Foundation <- factor(df_fac$Foundation)
df_fac1<- df_train %>% mutate_if(is.factor, as.numeric)

##model

lm1 <- lm(SalePrice ~ MSZoning	+
            Street	+
            LotShape	+
            LandContour	+
            LotConfig	+
            LandSlope	+
            Condition1	+
            Condition2	+
            BldgType	+
            HouseStyle	+
            RoofStyle	+
            RoofMatl	+
            Exterior1st	+
            Exterior2nd	+
            MasVnrType	+
            ExterQual	+
            ExterCond	+
            Foundation	+
            BsmtQual	+
            BsmtCond	+
            BsmtExposure	+
            BsmtFinType1	+
            BsmtFinType2	+
            Heating	+
            HeatingQC	+
            CentralAir	+
            Electrical	+
            KitchenQual	+
            Functional	+
            FireplaceQu	+
            GarageType	+
            GarageQual	+
            GarageCond	+
            PavedDrive	+
            SaleType	+
            SaleCondition	+
            BsmtFullBath	+
            BsmtHalfBath	+
            FullBath	+
            HalfBath	+
            BedroomAbvGr	+
            Fireplaces	+
            GarageCars
            , data = df_fac1)

summary(lm1)

library(forecast)
library(readr)
library(plyr)
library(ggplot2)
library(data.table)
library(forecast)
library(plotly)
library(TSA)
library(tseries)
library(ggfortify)
library(quantmod)
library(readxl)
library(corrplot)
library(expss)
library(MASS)
library(car)
lm2<- lm(SalePrice~., data=lm1$model)
Model1<- stepAIC(lm2)
summary(Model1)
