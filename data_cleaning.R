### data cleaning
train_df <- read_csv("data/training.csv")

test_df <- read_csv("data/validation.csv")

data_process_function_part1 <- function(train, test){
  #combine train and test ----
  #create factor ----
  
  df <- train %>%
    bind_rows(test) %>%
      mutate(MSSubClass = as.factor(MSSubClass),
             OverallCond = as.factor(OverallCond),
             YrSold = as.factor(YrSold), 
             MoSold = as.factor(MoSold))
  # fill na with none ----
  NA_cols_None <- c("PoolQC",
                    "MiscFeature",
                    "Alley",
                    "Fence",
                    "FireplaceQu",
                    "GarageType",
                    "GarageFinish",
                    "GarageQual",
                    "GarageCond",
                    "BsmtQual",
                    "BsmtCond",
                    "BsmtExposure",
                    "BsmtFinType1",
                    "BsmtFinType2",
                    "MasVnrType",
                    "MSSubClass")
  
  df[,NA_cols_None][is.na(df[,NA_cols_None])] <- "None"
  
  # fill na with median ----
  df <- df %>%
    group_by(Neighborhood) %>%
    mutate(LotFrontage = replace_na(LotFrontage, replace = median(LotFrontage, na.rm = T))) %>%
    ungroup()
  
  
  # fill na with 0 ----
  NA_cols_0 <- (c(
    "GarageYrBlt",
    "GarageArea",
    "GarageCars",
    "BsmtFinSF1",
    "BsmtFinSF2",
    "BsmtUnfSF",
    "TotalBsmtSF",
    "BsmtFullBath",
    "BsmtHalfBath",
    "MasVnrArea"
  ))
  
  df[,NA_cols_0][is.na(df[,NA_cols_0])] <- 0
  
  #fill na with most frequently ----
  df <- df %>%
    mutate(Electrical = str_replace_na(string = Electrical, replacement = "SBrkr"))
  
  #convert all the categorical variables into factors ----
  
  df_model <- df %>%
    mutate_if(base::is.character, base::as.factor)
  
  return(df_model)
}



data <- data_process_function_part1(train = train_df, test = test_df)

data %>%
  select_if(is.factor) %>%
  map(levels)

#run this above and fix the factor

#---------------------------

data_process_function_part2 <- function(data, train_data, train = TRUE, test = FALSE){
  
  index <- train_data$Id
  
  df_model_train <- data %>%
    filter(Id %in% index)
  
  df_model_test <- data %>%
    filter(Id %in% index == F)
  
  if(train){
    return(df_model_train %>%
             filter(GrLivArea < 4000))
  }
  
  if(test){
    return(df_model_test)
  }
}


train_data <- data_process_function_part2(data = data, train_data = train_df, train = T)


test_data <- data_process_function_part2(data = data, train_data = train_df, train = F, test = T)



