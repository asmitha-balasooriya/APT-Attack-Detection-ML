# APT Attack Detection using Machine Learning

**Course**:  Machine Learning and Data Visualisation  


A robust **cybersecurity machine learning project** focused on detecting Advanced Persistent Threat (APT) attacks from network traffic data using multiple classification models.

---

## ✨ Project Highlights

- Conducted thorough **data preprocessing** including missing value handling, categorical simplification, and feature transformations (log & square-root) to prepare a clean dataset.
- Built and systematically tuned **three powerful models**:
  - Logistic LASSO Regression
  - Classification Tree
  - **Bagging Tree** (Ensemble method)
- Strong emphasis on **security-critical metrics**: Sensitivity (APT Detection Rate) and Specificity (Non-APT Detection Rate).
- Performed repeated 10-fold cross-validation and thorough test set evaluation.

### 🏆 Best Performing Model: Bagging Tree
- **Overall Accuracy**: **92.9%**
- **Sensitivity** (APT Detection): **92.7%**
- **Specificity** (Non-APT Detection): **93.1%**
- Lowest False Positive & False Negative rates among all models

The ensemble approach significantly outperformed single models by reducing variance while maintaining high detection capability — making it highly suitable for real-world security operations.

---

## 🛠 Tech Stack

- **Language**: R
- **Core Libraries**: `caret`, `glmnet`, `rpart`, `ipred`, `pROC`
- **Data Science**: `dplyr`, `ggplot2`
- **Focus**: Hyperparameter tuning, cross-validation, and domain-specific evaluation metrics

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

🚀 How to Run
Bash# Install required R packages
Rscript -e 'install.packages(c("caret", "glmnet", "rpart", "ipred", "pROC", "dplyr", "ggplot2"))'

# Run preprocessing
Rscript src/data_preprocessing.R

# Train and evaluate models
Rscript src/models/logistic_lasso.R
Rscript src/models/classification_tree.R
Rscript src/models/bagging_tree.R     # Best performing model


Full Detailed Report: reports/Report on The Analysis and Modelling of a Dataset.pdf

🔍 What This Project Demonstrates

End-to-end Machine Learning Pipeline in a high-stakes cybersecurity context.
Importance of ensemble methods (Bagging) for improving stability and performance.
Proper use of domain-relevant metrics (Sensitivity & Specificity) instead of relying only on accuracy.
Strong skills in data preprocessing, hyperparameter tuning, and model comparison.

This project showcases my ability to build reliable, well-evaluated ML solutions for real-world security challenges.

Feel free to explore the code and detailed report!
