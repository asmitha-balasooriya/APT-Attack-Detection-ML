# --- 1. SETUP: LOAD LIBRARIES ---
library(tidyverse)
library(forcats)

# --- 2. DATA IMPORT ---
wacy_data <- read.csv("WACY-COM.csv")
# glimpse(wacy_data)

# --- 3. DATA CLEANING & TRANSFORMATION ---

# Step-by-step cleaning pipeline
wacy_data_cleaned <- wacy_data %>%
  # 3a. Convert empty strings to NA in categorical variables
  mutate(
    Source.IP.Type.Detected = na_if(Source.IP.Type.Detected, ""),
    
    # New Transformation 1: Convert -1 in Attack.Source.IP.Address.Count to NA
    Attack.Source.IP.Address.Count = na_if(Attack.Source.IP.Address.Count, -1)
  ) %>%
  
  # 3b. Filter out invalid rows
  filter(
    Hits > 0,
    
    # New Transformation 2: Remove rows with 99999 in ping time
    Average.ping.to.attacking.IP.milliseconds != 99999
  ) %>%
  
  # 3c. Simplify categories using fct_collapse
  mutate(
    Source.OS.Detected = fct_collapse(Source.OS.Detected,
                                      Windows_All = c("Windows 10", "Windows Server 2008")),
    
    Target.Honeypot.Server.OS = fct_collapse(Target.Honeypot.Server.OS,
                                             Windows_DeskServ = c("Windows (Desktops)", "Windows (Servers)"),
                                             MacOS_Linux = c("Linux", "MacOS (All)"))
  ) %>%
  
  # 3d. Apply transformations to numeric columns
  mutate(
    Average.ping.variability = log(Average.ping.variability + 1),
    Hits = sqrt(Hits),
    Attack.Source.IP.Address.Count = sqrt(Attack.Source.IP.Address.Count),
    Average.ping.to.attacking.IP.milliseconds = sqrt(Average.ping.to.attacking.IP.milliseconds),
    Individual.URLs.requested = sqrt(Individual.URLs.requested)
  )

# 3e. Final cleanup: Remove any rows with NA remaining
WACY_COM_cleaned <- na.omit(wacy_data_cleaned)

# --- 4. DATA PARTITIONING (30% Training, 70% Test) ---
set.seed(10687611)
train_index <- sample(1:nrow(WACY_COM_cleaned), size = 0.3 * nrow(WACY_COM_cleaned))
training_set <- WACY_COM_cleaned[train_index, ]
test_set <- WACY_COM_cleaned[-train_index, ]

# --- 5. EXPORT DATASETS TO CSV ---
write.csv(training_set, "training_set.csv", row.names = FALSE)
write.csv(test_set, "test_set.csv", row.names = FALSE)

# --- 6. Selecting Models ---

# Define the available model options
models.list1 <- c("Logistic Ridge Regression",
                  "Logistic LASSO Regression",
                  "Logistic Elastic-Net Regression")

models.list2 <- c("Classification Tree",
                  "Bagging Tree",
                  "Random Forest")

# Randomly sample 1 from list1 and 2 from list2
myModels <- c(sample(models.list1, size = 1),
              sample(models.list2, size = 2))

# Display the selected models
myModels %>% data.frame()

