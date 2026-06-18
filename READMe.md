# APT Attack Detection using Machine Learning

**Course**: MAT3120.3 Machine Learning and Data Visualisation  
**Student**: Asmitha Darani Balasooriya (10687611)

A comparative study of multiple classification models for detecting Advanced Persistent Threat (APT) attacks from network traffic data.

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
(See folder structure above)

---

## 🚀 How to Run

```bash
pip install -r requirements.txt

# Run preprocessing
python src/data_preprocessing.py

# Train and evaluate models
python src/train.py