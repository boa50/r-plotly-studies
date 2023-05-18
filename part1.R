if (!require(remotes)) install.packages("remotes")
remotes::install_github("cpsievert/plotly_book")

library(plotly)

data("diamonds")

# Sample chart
plot_ly(diamonds, x = ~cut, color = ~clarity, colors = "Accent")

# Changing to specific values
diamonds %>%
  plot_ly(
    x = ~cut,
    color = I("red"),
    stroke = I("black"),
    span = I(3)
  ) %>%
  layout(title = "My chart title")
