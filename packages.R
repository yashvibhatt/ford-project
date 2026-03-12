# packages.R
# ── FIN503 Final Project — Package Installation ────────────────────────────────
#
# Run this script once before knitting 10_22_class.Rmd.
# Only installs packages that are not already present.
#
# Usage:
#   source("packages.R")          # from RStudio or an R session
#   Rscript packages.R            # from the terminal
# ──────────────────────────────────────────────────────────────────────────────

required_packages <- c(
  "dplyr",       # Data manipulation and feature engineering
  "MASS",        # Stepwise AIC variable selection
  "leaps",       # Best-subset selection / Mallows' Cp
  "car",         # VIF computation and QQ plot
  "lmtest",      # Breusch-Pagan heteroskedasticity test
  "estimatr",    # HC robust standard errors (lm_robust)
  "ggplot2",     # Plotting (actual vs. predicted chart)
  "knitr",       # Table rendering inside R Markdown
  "kableExtra",  # Styled HTML table output
  "corrplot",    # Correlation heatmap
  "rmarkdown"    # R Markdown rendering
)

# Install only packages that are not already installed
missing_packages <- setdiff(required_packages, rownames(installed.packages()))

if (length(missing_packages) == 0) {
  message("All required packages are already installed.")
} else {
  message("Installing missing packages: ", paste(missing_packages, collapse = ", "))
  install.packages(missing_packages, repos = "https://cloud.r-project.org")
  message("Installation complete.")
}
