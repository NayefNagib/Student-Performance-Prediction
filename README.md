# 📊 Student Performance Prediction System

An end-to-end Machine Learning project that predicts student academic performance and pass/fail status using behavioral, social, and academic features.

Built using R, Shiny, and multiple ML models including LightGBM and Random Forest.

---

## 🚀 Features

- Data preprocessing & cleaning
- Exploratory Data Analysis (EDA)
- Feature engineering
- Regression models for grade prediction
- Classification model for PASS/FAIL
- Model comparison (RMSE & R²)
- Hyperparameter tuning
- Feature importance analysis
- Interactive Shiny web app
- Real-time predictions

---

## 🧠 Dataset

The dataset includes student academic and behavioral data:

- Study time
- Past grades (G1, G2)
- Absences
- Alcohol consumption
- Family education level
- Social factors
- Subject (Math / Portuguese)

---

## 🏗️ Machine Learning Pipeline

Data Collection → Cleaning → Feature Engineering → Encoding → Model Training → Evaluation → Deployment

---

## 📊 Models Used

### Regression
- Linear Regression
- Decision Tree Regressor
- Random Forest Regressor
- LightGBM Regressor (Best Model)

### Classification
- Random Forest (PASS / FAIL prediction)

---

## 📈 Evaluation Metrics

- RMSE (Root Mean Squared Error)
- R² Score
- Accuracy (Classification)

---

## 🧪 Feature Engineering

- Total alcohol consumption
- Parent education score
- Log transformation of absences
- One-hot encoding for categorical features

---

## 🌐 Shiny App

The project includes an interactive web app built with **R Shiny**.

### Features:
- Input student data
- Predict final grade instantly
- PASS / FAIL classification
- Powered by LightGBM model

### Run locally:

```r
shiny::runApp("app/app.R")