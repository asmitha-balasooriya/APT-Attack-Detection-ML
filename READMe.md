# APT Attack Detection using Machine Learning

**Course**: Machine Learning and Data Visualisation  


A comparative study of multiple classification models for detecting Advanced Persistent Threat (APT) attacks from network traffic data.
Programming Language used: R

---

## 📋 Project Overview

- Performed extensive **data cleaning**, handling missing values, and feature engineering.
- Built and tuned three models:
  - **Logistic LASSO Regression** (with hyperparameter tuning on Lambda)
  - **Classification Tree** (tuned on Complexity Parameter `cp`)
  - **Bagging Tree** (Ensemble method)
- Focused on **Sensitivity** (APT Detection Rate) and **Specificity** due to the security context.
- Conducted 10-fold cross-validation (repeated 3 times) and evaluated on hold-out test set.

### Best Model
**Classification Tree** achieved the highest performance:
- ROC AUC: **0.9519**
- Sensitivity: **0.9057**
- Specificity: **0.9054**

---

## 🛠 Tech Stack
- **Python**, pandas, numpy, scikit-learn
- matplotlib, seaborn (for visualization)

---

## 📂 Repository Structure

```bash
.
├── data
│   └── WACY-COM.csv
├── README.md
├── reports
│   ├── performance_summary.md
│   └── Report on The Analysis and Modelling of a Dataset.pdf
├── requirements.txt
└── src
    ├── data_preprocessing.R
    └── models
        ├── bagging_tree.R
        ├── classification_tree.R
        └── logistic_lasso.R
---

## 🚀 How to Run

```bash
pip install -r requirements.txt

# Run preprocessing
python src/data_preprocessing.py

# Train and evaluate models

#to run bagging tree model
python src/bagging_tree.py

#to run classification tree model
python src/classification_tree.py

#to run logistic lasso regression model
python src/logistic_lasso.py
