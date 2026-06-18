# Model 1- Logistic LASSO Regression 

# --- 1. SETUP: LOAD LIBRARIES ---
library(tidyverse)
library(caret)
library(glmnet)

# --- 2. DATA IMPORT ---
# Load the datasets created from your cleaning script
training_set <- read.csv("training_set.csv")
test_set     <- read.csv("test_set.csv")

# --- 3. DATA PREPARATION FOR MODELLING ---

outcome_col_name <- "APT"

training_set[[outcome_col_name]] <- factor(training_set[[outcome_col_name]], levels = c("Yes", "No"))
test_set[[outcome_col_name]]     <- factor(test_set[[outcome_col_name]], levels = c("Yes", "No"))


# --- 4. HYPERPARAMETER TUNING & MODEL TRAINING (LASSO) ---


set.seed(10687611) # for reproducibility
train_control <- trainControl(
  method = "repeatedcv",
  number = 10,      # k-fold CV
  repeats = 3,      # Number of repeats
  summaryFunction = twoClassSummary, # For binary classification metrics (AUC, Sens, Spec)
  classProbs = TRUE, # We need to predict probabilities
  verboseIter = FALSE # Suppress verbose output during training
)


# For LASSO, alpha is fixed at 1.

tune_grid <- expand.grid(alpha = 1, lambda = 10^seq(-4, 0, length = 100))


cat("--- Starting LASSO Model Training with Repeated Cross-Validation ---\n")
lasso_model <- train(
  as.formula(paste(outcome_col_name, "~ .")), # Creates the formula dynamically
  data = training_set,
  method = "glmnet",
  trControl = train_control,
  tuneGrid = tune_grid,
  metric = "ROC" # The metric to optimize for finding the best lambda
)

# --- 5. VIEW CROSS-VALIDATION RESULTS ---

# Print the results of the cross-validation.
# This will show performance metrics (ROC, Sens, Spec) for different lambda values
# and highlight the optimal lambda.
cat("\n\n--- Cross-Validation Results ---\n")
print(lasso_model)

# Plot the cross-validation results to visualise how performance changes with lambda.
cat("\n\n--- Plot of CV Results ---\n")
print(plot(lasso_model))


# --- 6. EVALUATE MODEL ON THE TEST SET ---

# Make predictions on the unseen test set using the final tuned model.
# We predict the class (e.g., "Yes" or "No") directly.
cat("\n\n--- Making Predictions on the Test Set ---\n")
predictions <- predict(lasso_model, newdata = test_set)

# Generate and display the confusion matrix and associated statistics.
# This will give us Accuracy, Sensitivity, Specificity, etc. on the test data.
cat("\n\n--- Confusion Matrix and Performance Metrics (Test Set) ---\n")

predictions <- factor(predictions, levels = levels(test_set[[outcome_col_name]]))

confusion_matrix_results <- confusionMatrix(
  data = predictions,
  reference = test_set[[outcome_col_name]],
  positive = "Yes" # Define the "positive" class for correct metric calculation
)
print(confusion_matrix_results)

# --- END OF SCRIPT ---