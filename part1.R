# if (!require(remotes)) install.packages("remotes")
# remotes::install_github("cpsievert/plotly_book")

library(plotly)
library(listviewer)

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

# Debugging created chart
p <- plot_ly(diamonds, x = ~cut, color = ~clarity, colors = "Accent")
plotly_build(p)
plotly_json(p)

# Manually defining Plotly attributes
set.seed(99)
plot_ly() %>%
  add_trace(
    type = "scatter",
    mode = "markers+lines+text",
    x = 4:6,
    y = 4:6,
    text = replicate(3, praise::praise("You are ${adjective}! 🙌")),
    textposition = "right",
    hoverinfo = "text",
    textfont = list(family = "Roboto Condensed", size = 16)
  ) %>%
  layout(xaxis = list(range = c(3, 8)))

# Documentation of plotly traces
schema()
