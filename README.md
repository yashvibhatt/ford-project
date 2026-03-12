# FIN503 Final Project: Predicting Ford Motor Company Stock Returns

**Authors:** Vincent Ngai and Yashvi Bhatt
**Course:** FIN 503
**Date:** December 2025

---

## Overview

This project investigates whether Ford Motor Company's monthly stock returns can be systematically predicted using macroeconomic indicators, market-level variables, and commodity prices. We build and compare four linear regression models — including a full 11-variable specification, two variable-selected models (stepwise AIC and Mallows' Cp), and a CAPM benchmark — and evaluate each model's out-of-sample forecasting performance on a 23-month holdout period (January 2024 – November 2025).

---

## Dataset

| Property | Value |
|---|---|
| File | `FIN503_project_data.csv` |
| Frequency | Monthly |
| Coverage | January 2004 – November 2025 |
| Observations | 263 rows |
| Source | Bloomberg / public market data |

**Raw variables include:** S&P 500 index, Ford stock price, gold price, crude oil price, USD/EUR exchange rate, FIBOR (Frankfurt Interbank Offered Rate), Barron's Confidence Index, S&P 500 Price-to-Book ratio, S&P 500 dividend yield, S&P 500 EPS, VIX implied volatility, 10-year US Treasury yield, and risk-free rate.

**Engineered predictors used in models:**

| Variable | Description |
|---|---|
| `ford_return` | Monthly Ford stock return *(target variable)* |
| `excess_return` | S&P 500 return minus risk-free rate (market risk premium) |
| `div_to_price` | S&P 500 dividend yield as a decimal |
| `market_variance` | Squared VIX / 100 (implied variance) |
| `X10y_treasury` | 10-year Treasury yield as a decimal |
| `FIBOR` | Frankfurt Interbank Offered Rate as a decimal |
| `earnings_to_price` | S&P 500 earnings-to-price ratio |
| `book_to_market` | S&P 500 book-to-market ratio |
| `gold_return` | Monthly gold return |
| `oil_return` | Monthly crude oil return |
| `dol_eu_change` | Monthly USD/EUR exchange rate change |

---

## Methodology

### Train / Test Split
A **time-series aware split** is used to prevent look-ahead bias:
- **Training set:** February 2004 – December 2023 (239 months)
- **Holdout set:** January 2024 – November 2025 (23 months)

All model parameters are estimated on the training set only. Performance is evaluated on the genuinely unseen holdout period.

### Models Compared

| Model | Predictors | Selection Method |
|---|---|---|
| Full model | 11 variables | Kitchen sink (baseline) |
| AIC-selected | 4 variables | Stepwise AIC (both directions) |
| Cp-selected | 3 variables | Mallows' Cp best-subset |
| CAPM | 1 variable | Theory-driven benchmark |

The **AIC-selected 4-variable model** is recommended as the final specification based on highest Adjusted R² among parsimonious models and competitive out-of-sample performance.

### Evaluation Metrics
- **In-sample:** Adjusted R², AIC
- **Out-of-sample:** RMSE, MAE, OOS R² (relative to a naive mean forecast)

### Diagnostics Performed
- **Multicollinearity:** Pairwise scatter plots, correlation matrix, Variance Inflation Factors (VIF)
- **Normality of residuals:** QQ plot, Shapiro-Wilk test
- **Heteroskedasticity:** Residuals vs. fitted values plot, Breusch-Pagan test
- **Robust inference:** Heteroskedasticity-Consistent (HC/Huber-White) standard errors via `lm_robust`

---

## Key Results

- The AIC-selected model (dividend yield + market variance + 10-year yield + market excess return) achieves the best balance of in-sample fit and out-of-sample generalizability.
- Market excess return is the dominant and most statistically significant predictor, consistent with CAPM theory.
- Macro factors add meaningful explanatory power beyond the single-factor CAPM.
- Residuals are non-normal (fat tails, consistent with financial return data); the Breusch-Pagan test is used to separately assess heteroskedasticity.
- Robust (HC) standard errors are applied to ensure reliable inference under potential heteroskedasticity.

---

## Repository Structure

```
fin 503/
├── 10_22_class.Rmd          # Main R Markdown analysis file
├── 10_22_class.html         # Rendered HTML report (open in browser)
├── FIN503_project_data.csv  # Dataset
├── packages.R               # Package installation script
└── README.md                # This file
```

---

## How to Run

### Prerequisites
- R (version 4.0 or higher recommended)
- RStudio (optional, but recommended for Rmd rendering)

### Step 1 — Install required packages

Run the installation script once before knitting:

```r
source("packages.R")
```

### Step 2 — Knit the report

**In RStudio:** Open `10_22_class.Rmd` and click the **Knit** button, or run:

```r
rmarkdown::render("10_22_class.Rmd", output_file = "10_22_class.html")
```

**From the terminal:**

```bash
Rscript -e "rmarkdown::render('10_22_class.Rmd', output_file='10_22_class.html')"
```

### Step 3 — View the report

Open `10_22_class.html` in any browser. The report includes a floating table of contents, numbered sections, interactive-style tables, and all plots embedded inline.

### Notes
- The dataset file `FIN503_project_data.csv` must be in the **same directory** as the Rmd file when knitting.
- All file paths in the Rmd are relative — do not move the Rmd out of the project folder without also moving the CSV.
- Knit time is approximately 15–30 seconds depending on machine speed.

---

## Packages Used

| Package | Purpose |
|---|---|
| `dplyr` | Data manipulation and feature engineering |
| `MASS` | Stepwise AIC variable selection |
| `leaps` | Best-subset selection (Mallows' Cp) |
| `car` | VIF computation, QQ plot |
| `lmtest` | Breusch-Pagan heteroskedasticity test |
| `estimatr` | HC robust standard errors (`lm_robust`) |
| `ggplot2` | Actual vs. predicted time series plot |
| `knitr` | Table rendering |
| `kableExtra` | Styled HTML tables |
| `corrplot` | Correlation heatmap |
| `rmarkdown` | Report rendering |
