#Bagging Tree

# --- 1. SETUP: LOAD LIBRARIES ---

library(tidyverse) # For data manipulation and visualization
library(caret)     # For confusion matrix and data splitting
library(ipred)     # For the bagging algorithm
library(rpart)     # Required for the underlying decision trees in bagging

# --- 2. DATA IMPORT ---

tryCatch({
  training_set <- read.csv("training_set.csv")
  test_set     <- read.csv("test_set.csv")
  cat("--- Data loaded successfully. ---\n")
}, error = function(e) {
  stop("Error: Make sure 'training_set.csv' and 'test_set.csv' are in your working directory.")
})


# --- 3. DATA PREPARATION FOR MODELLING ---

outcome_col_name <- "APT"

# Verify the outcome variable exists in the datasets.
if (!outcome_col_name %in% names(training_set) || !outcome_col_name %in% names(test_set)) {
  stop(paste("Error: Outcome variable '", outcome_col_name, "' not found in the datasets.", sep=""))
}

# Convert the outcome variable to a factor for classification.
# Setting "Yes" as the first level ensures that 'caret' calculates Sensitivity
# for detecting actual APT attacks correctly.
training_set[[outcome_col_name]] <- factor(training_set[[outcome_col_name]], levels = c("Yes", "No"))
test_set[[outcome_col_name]]     <- factor(test_set[[outcome_col_name]],     levels = c("Yes", "No"))

cat("--- Data preparation complete. Outcome variable 'APT' is ready. ---\n\n")


# --- 4. HYPERPARAMETER TUNING STRATEGY ---


# Setting the randomisation seed using my student ID for reproducibility.
set.seed(10687611)

tuning_grid <- expand.grid(
  nbagg = c(50, 100, 150),
  cp = c(0, 0.001, 0.01),
  minsplit = c(5, 10, 20),
  OOB_error = NA # This column will store the OOB misclassification error
)

cat("--- Starting Manual Hyperparameter Tuning for Bagging ---\n")
cat("Total combinations to test:", nrow(tuning_grid), "\n\n")

# Loop through each row of the grid to train a model and get its OOB error.
for (i in 1:nrow(tuning_grid)) {
  # Set the seed inside the loop for consistency in each model build
  set.seed(10687611)
  
  # Train the bagging model using the hyperparameters from the current row
  bagging_model <- bagging(
    formula = as.formula(paste(outcome_col_name, "~ .")),
    data = training_set,
    nbagg = tuning_grid$nbagg[i],
    coob = TRUE, # CRITICAL: Calculate the Out-of-Bag error
    control = rpart.control(
      minsplit = tuning_grid$minsplit[i],
      cp = tuning_grid$cp[i]
    )
  )
  
  # Store the OOB misclassification error in the grid.
  # For classification, `bagging_model$err` is the OOB misclassification rate.
  tuning_grid$OOB_error[i] <- bagging_model$err
  
  # Print progress
  cat(sprintf("Run %d/%d: nbagg=%d, cp=%.3f, minsplit=%d, OOB Error=%.5f\n",
              i, nrow(tuning_grid), tuning_grid$nbagg[i], tuning_grid$cp[i],
              tuning_grid$minsplit[i], tuning_grid$OOB_error[i]))
}

cat("\n--- Hyperparameter Tuning Complete ---\n\n")


# --- 5. VIEW CROSS-VALIDATION (OOB) RESULTS ---

cat("--- CV Results (Sorted by OOB Error) ---\n")
# Sort the grid by OOB error to find the best models
sorted_results <- tuning_grid[order(tuning_grid$OOB_error), ]

# Display the top 5 hyperparameter combinations
print(head(sorted_results, 5))

optimal_params <- sorted_results[1, ]
cat("\n--- Optimal Hyperparameters Found ---\n")
print(optimal_params)


# --- 6. TRAIN FINAL MODEL & EVALUATE ON TEST SET ---

cat("\n--- Training Final Bagging Model with Optimal Hyperparameters ---\n")

set.seed(10687611)
final_bagging_model <- bagging(
  formula = as.formula(paste(outcome_col_name, "~ .")),
  data = training_set,
  nbagg = optimal_params$nbagg,
  coob = TRUE,
  control = rpart.control(
    minsplit = optimal_params$minsplit,
    cp = optimal_params$cp
  )
)

cat("Final Model OOB Misclassification Error:", final_bagging_model$err, "\n\n")

cat("--- Making Predictions on the Test Set ---\n")

predictions_bagging <- predict(final_bagging_model, newdata = test_set, type = "class")

# Ensuring the `predictions` factor has the same levels as the reference for the confusion matrix.
predictions_bagging <- factor(predictions_bagging, levels = levels(test_set[[outcome_col_name]]))

cat("\n--- Confusion Matrix and Performance Metrics for Bagging (Test Set) ---\n")

confusion_matrix_bagging <- confusionMatrix(
  data = predictions_bagging,
  reference = test_set[[outcome_col_name]],
  positive = "Yes" # Define the "positive" class for correct metric calculation
)
print(confusion_matrix_bagging)


