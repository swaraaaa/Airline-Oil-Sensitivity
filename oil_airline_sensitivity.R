# Sensitivity of Airline Stock Returns to Oil Price Changes: A Statistical Analysis
# Swara Dave | FE 511 - Introduction to Bloomberg & Thomson Reuters
# Stevens Institute of Technology

library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)

# ---- Load Data ----
crude_data  <- read_excel("Dataset/CrudeOilData.xlsx")
delta_data  <- read_excel("Dataset/Delta_Airlines.xlsx")
united_data <- read_excel("Dataset/United_Airlines.xlsx")

# ---- Clean and remove NAs for each dataset ----
clean_data <- function(data) {
  data <- data %>%
    drop_na() %>%                 # Remove rows with NA
    mutate(Date = as.Date(Date)) %>%
    arrange(Date)                 # Arrange by Date
  return(data)
}

crude_data  <- clean_data(crude_data)
delta_data  <- clean_data(delta_data)
united_data <- clean_data(united_data)

# ---- Function to compute weekly percentage change ----
compute_returns <- function(data, price_col) {
  data %>%
    mutate(Weekly_Return = (get(price_col) / lag(get(price_col)) - 1) * 100) %>%
    drop_na()  # Remove NA caused by lag
}

# Compute weekly returns
crude_data  <- compute_returns(crude_data, "PX_LAST")
delta_data  <- compute_returns(delta_data, "PX_LAST")
united_data <- compute_returns(united_data, "PX_LAST")

# Rename return columns for clarity
colnames(crude_data)[colnames(crude_data) == "Weekly_Return"]  <- "Crude_Return"
colnames(delta_data)[colnames(delta_data) == "Weekly_Return"]  <- "Delta_Return"
colnames(united_data)[colnames(united_data) == "Weekly_Return"] <- "United_Return"

# ---- Merge by Date ----
combined_data <- crude_data %>%
  select(Date, Crude_Return) %>%
  left_join(delta_data %>% select(Date, Delta_Return), by = "Date") %>%
  left_join(united_data %>% select(Date, United_Return), by = "Date")

# Remove rows with NA after merging
combined_data <- combined_data %>% drop_na()

# ---- Correlation Analysis ----
cor_crude_delta  <- cor(combined_data$Crude_Return, combined_data$Delta_Return)
cor_crude_united <- cor(combined_data$Crude_Return, combined_data$United_Return)

print(paste("Correlation between Crude Oil and Delta Airlines Returns: ", round(cor_crude_delta, 3)))
print(paste("Correlation between Crude Oil and United Airlines Returns: ", round(cor_crude_united, 3)))

# ---- Simple Linear Regression Models ----
model_delta  <- lm(Delta_Return ~ Crude_Return, data = combined_data)
model_united <- lm(United_Return ~ Crude_Return, data = combined_data)

print(summary(model_delta))
print(summary(model_united))

# ---- Plot function ----
plot_regression <- function(data, x_col, y_col, title, x_label, y_label) {
  ggplot(data, aes(x = {{x_col}}, y = {{y_col}})) +
    geom_point(color = "blue") +
    geom_smooth(method = "lm", color = "red", se = FALSE) +
    theme_minimal() +
    labs(title = title, x = x_label, y = y_label)
}

# Plot for Delta Airlines
plot_regression(combined_data, Crude_Return, Delta_Return,
                 "Crude Oil Returns vs Delta Airlines Returns",
                 "Crude Oil Returns (%)", "Delta Airlines Returns (%)")
ggsave("Plots/crude_vs_delta_returns.png", width = 8, height = 5, dpi = 150)

# Plot for United Airlines
plot_regression(combined_data, Crude_Return, United_Return,
                 "Crude Oil Returns vs United Airlines Returns",
                 "Crude Oil Returns (%)", "United Airlines Returns (%)")
ggsave("Plots/crude_vs_united_returns.png", width = 8, height = 5, dpi = 150)