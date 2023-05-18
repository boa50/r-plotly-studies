if (!require(remotes)) install.packages("remotes")
remotes::install_github("cpsievert/plotly_book")

data("diamonds")

plot_ly(diamonds, x = ~cut, color = ~clarity, colors = "Accent")
