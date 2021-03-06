context("test-train_test_acc_time")


# SAMPLE DATA

# models <- list('lm','rf','knn','svmLinearWeights')
# X_train <- data.frame(col1=sample(1:100,100, replace = TRUE ), 
#                       col2= sample(50:150,100, replace = TRUE ),
#                       col2= sample(500:750,100, replace = TRUE ))
# X_test <- data.frame(col1=sample(1:100,50, replace = TRUE ), col2= sample(50:150,50, replace = TRUE ))
# y_train <- runif(4,50,100)
# y_test <- runif(5,10,50)
# result <- data.frame(model = c('lm','rf','knn','svmLinearWeights'), 
#                       train_accuracy = runif(4,50,100),
#                       test_accuracy = runif(4,50,100),
#                       variance = runif(4,0,50),
#                       fit_time = runif(4,1,6),
#                       predict_time = runif(4,1,6),
#                       total_time = runif(4,2,12)
# )


index <- caret::createDataPartition(iris$Species,p = 0.75,list=FALSE)
(train_iris <- iris[index,])
(test_iris <- iris[-index,])
X_train <-train_iris[,names(iris)!='Species'] 
y_train <- train_iris[,names(iris)=='Species'] 
X_test <- test_iris[,names(iris)!='Species'] 
y_test <- test_iris[,names(iris)=='Species'] 

models <- c('svmPoly','knn','rf')

length(y_train)

# Sufficient inputs for the function tests

test_that("insufficient inputs for the function", {
  expect_error(train_test_acc_time(X_train, y_train, X_test, y_test))
  expect_error(train_test_acc_time(models,  y_train, X_test,y_test))
})


# Output should be a dataframe of 7 columns 
test_that("Output is a dataframe of 7 columns ", {
  res <- train_test_acc_time(models, X_train, y_train, X_test, y_test)
  expect_equal(length(res), 7)
})

# The inupt should be correct format
test_that("whether input models is a list ", {
  expect_error(train_test_acc_time(models, X_train, y_train, 'X_test', y_test),"Dear Friend: X_test is not a Data Frame")
  expect_error(train_test_acc_time(models, 123, y_train, X_test, y_test),"Dear Friend: X_train is not a Data Frame")
               
})

# Dimensions for Xtrain and ytrain should be consistent 
test_that("consistency of Xtrain and ytrain domensions", {
  expect_equal(dim(X_train)[1],length(y_train))
})

# Check if the y_train or y_test are not 1 D vectors we should expect errors
test_that("y_train or y_test are not 1 D vectors ", {
  expect_error(train_test_acc_time(models,X_train,X_train, X_test, y_test))
  expect_error(train_test_acc_time(models,X_train,y_train, X_test,X_test))
})

# Check for NULL input
test_that("NULL input", {
  expect_error(train_test_acc_time(NULL, NULL, NULL, NULL, NULL),"Dear Friend : Did you input all of these models, X_train, y_train, X_test, y_test")
})