# Model 2- Classification Tree

library(tidyverse)
library(caret)
library(rpart)
library(rpart.plot)

# Load the datasets
training_set <- read.csv("training_set.csv")
test_set     <- read.csv("test_set.csv")

# Define the outcome variable and ensure it's a factor
outcome_col_name <- "APT"
training_set[[outcome_col_name]] <- factor(training_set[[outcome_col_name]], levels = c("Yes", "No"))
test_set[[outcome_col_name]]     <- factor(test_set[[outcome_col_name]], levels = c("Yes", "No"))


# --- 2. HYPERPARAMETER TUNING & MODEL TRAINING ---

# Set the random seed for reproducibility
set.seed(10687611)

# Set up the control parameters for repeated cross-validation (10-fold CV, 3 repeats)
train_control <- trainControl(
  method = "repeatedcv",
  number = 10,
  repeats = 3,
  summaryFunction = twoClassSummary, # Use for metrics like ROC, Sens, Spec
  classProbs = TRUE,
  verboseIter = FALSE
)


tree_grid <- expand.grid(cp = seq(from = 0, to = 0.1, length.out = 20))


# Train the Classification Tree model
cat("--- Starting Classification Tree (rpart) Model Training ---\n")
tree_model <- train(
  as.formula(paste(outcome_col_name, "~ .")),
  data = training_set,
  method = "rpart",
  trControl = train_control,
  tuneGrid = tree_grid,
  metric = "ROC" # Optimize for the ROC metric
)


# --- 3. VIEW CROSS-VALIDATION RESULTS ---

# Print the CV results, showing the performance for each 'cp' value
cat("\n\n--- Cross-Validation Results for Classification Tree ---\n")
print(tree_model)

# Plot the results to visualize how ROC changes with 'cp'
cat("\n\n--- Plot of CV Results ---\n")
print(plot(tree_model))

# Print the final, pruned tree structure
cat("\n\n--- Final Pruned Tree Structure ---\n")
print(tree_model$finalModel)

# Visualize the final tree
cat("\n\n--- Plot of Final Tree ---\n")
rpart.plot(tree_model$finalModel, extra = 101, box.palette = "BuGn", branch.lty = 3, shadow.col = "gray")


# --- 4. EVALUATE MODEL ON THE TEST SET ---

# Make predictions on the unseen test set
cat("\n\n--- Making Predictions on the Test Set ---\n")
tree_predictions <- predict(tree_model, newdata = test_set)


tree_predictions <- factor(tree_predictions, levels = levels(test_set[[outcome_col_name]]))

# Generate and display the confusion matrix
cat("\n\n--- Confusion Matrix and Performance Metrics (Test Set) ---\n")
tree_confusion_matrix <- confusionMatrix(
  data = tree_predictions,
  reference = test_set[[outcome_col_name]],
  positive = "Yes"
)
print(tree_confusion_matrix)

# --- END OF SCRIPT ---