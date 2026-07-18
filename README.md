# Sensitivity of Airline Stock Returns to Oil Price Changes

**Statistical Arbitrage Foundations · Correlation & Regression Analysis · Bloomberg Terminal · R**

> FE-511 Final Project — MS Financial Engineering, Stevens Institute of Technology 

> Author: Swara Dave

---

## 📌 Overview

Fuel costs are one of the largest operating expenses for airlines, so it's natural to assume airline stock returns move inversely to crude oil prices. This project tests that assumption directly using five years of weekly Bloomberg data (2019–2024) for two major U.S. carriers:

1. **Data acquisition** — weekly closing prices for WTI crude oil, Delta Air Lines (DAL), and United Airlines (UAL) pulled from the Bloomberg Terminal
2. **Return computation** — weekly percentage returns calculated and aligned by trading date
3. **Correlation analysis** — linear relationship between crude oil returns and each airline's returns
4. **Linear regression** — quantifies the sensitivity (β) of airline returns to crude oil returns
5. **Cross-validation** — R-generated results checked against Bloomberg's native regression tool for consistency

---

## 📊 Key Results

- **Hypothesis tested:** airline returns are inversely related to crude oil returns → **not supported**
- Crude Oil vs. Delta Airlines: correlation = **0.161**, regression slope = **0.177** (p = 0.009, significant)
- Crude Oil vs. United Airlines: correlation = **0.088**, regression slope = **0.119** (p = 0.157, not significant)
- Both relationships are **weak and positive** — the opposite sign from the hypothesis
- Bloomberg-native regression outputs matched the R-generated results, validating the analysis

---

## 🗂️ Data

Weekly closing prices (`PX_LAST`) from the Bloomberg Terminal, **12/13/2019 – 12/13/2024** (262 observations per series).

| File | Ticker | Description |
|---|---|---|
| `Dataset/CrudeOilData.xlsx` | CL1 Comdty | WTI crude oil futures |
| `Dataset/Delta_Airlines.xlsx` | DAL US Equity | Delta Air Lines |
| `Dataset/United_Airlines.xlsx` | UAL US Equity | United Airlines Holdings |

Each file contains `Date`, `PX_LAST`, and `PX_BID`.

---

## ⚙️ Methodology

### Pipeline Overview
```
Bloomberg Data Pull → Cleaning & Alignment → Weekly Returns → Correlation Analysis → Linear Regression → Bloomberg Cross-Validation
```

### 1. Data Cleaning and Transformation
- Removed rows with missing values
- Computed weekly percentage returns from `PX_LAST`
- Merged all three series by trading date into a single aligned dataset

### 2. Correlation Analysis
- Pearson correlation between crude oil returns and each airline's returns
- Tests the direction and strength of the linear relationship

### 3. Linear Regression
- Model: `Airline_Return_t = β₀ + β₁ × Crude_Oil_Return_t + ε_t`
- Dependent variable: weekly airline stock returns
- Independent variable: weekly crude oil returns
- Fit separately for Delta and United using OLS in R

### 4. Bloomberg Cross-Validation
- Regression slope, intercept, and R² reproduced using Bloomberg's terminal-native regression function
- Confirms the R analysis aligns with industry-standard Bloomberg calculations

---

## 📁 Repository Structure

```
Airline-Oil-Sensitivity/
├── oil_airline_sensitivity.R        # Full analysis script (cleaning, returns, correlation, regression, plots)
├── Dataset/
│   ├── CrudeOilData.xlsx
│   ├── Delta_Airlines.xlsx
│   └── United_Airlines.xlsx
├── Plots/
│   ├── crude_vs_delta_returns.png
│   └── crude_vs_united_returns.png
└── FE_511_Project_Report.pdf        # Full written report with Bloomberg screenshots
```

---

## 🚀 How to Run

1. Clone the repo
2. Install dependencies:
```r
install.packages(c("readxl", "dplyr", "tidyr", "ggplot2"))
```
3. Run `oil_airline_sensitivity.R` from the repo root — it reads the three files in `Dataset/`, computes returns, runs the correlation and regression analysis, and saves scatter plots to `Plots/`

---

## 💬 Discussion

The data does not support an inverse relationship between oil prices and airline stock returns. Likely explanations:

- **Fuel hedging** — airlines commonly hedge fuel costs, dampening short-term sensitivity to oil price moves
- **Broader market dynamics** — post-COVID recovery and macro conditions likely dominate airline stock performance over this window
- **Cost structure and fleet efficiency** differences between carriers

Future work could add more explanatory variables (e.g., broader market indices, jet fuel futures specifically) or use time-series methods that account for volatility clustering and lagged effects.

---

## 👤 Author

**Swara Dave** — MS Financial Engineering, Stevens Institute of Technology
[![LinkedIn](https://img.shields.io/badge/LinkedIn-swara--dave-blue?style=flat&logo=linkedin)](https://linkedin.com/in/swara-dave) [![GitHub](https://img.shields.io/badge/GitHub-swaraaaa-black?style=flat&logo=github)](https://github.com/swaraaaa)
