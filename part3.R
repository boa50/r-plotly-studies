library(dplyr)
library(plotly)

### Creating subplots using a list
vars <- setdiff(names(economics), "date")
plots <- lapply(vars, function(var) {
  plot_ly(economics, x = ~date, y = as.formula(paste0("~", var))) %>%
    add_lines(name = var)
})
subplot(plots, nrows = length(plots), shareX = TRUE, titleX = FALSE)

# Using different kind of annotations
panel <- . %>%
  plot_ly(x = ~date, y = ~value) %>%
  add_lines() %>%
  add_annotations(
    text = ~unique(variable),
    x = 0.5,
    y = 1,
    yref = "paper",
    xref = "paper",
    yanchor = "bottom",
    showarrow = FALSE,
    font = list(size = 15)
  ) %>%
  layout(
    showlegend = FALSE,
    shapes = list(
      type = "rect",
      x0 = 0,
      x1 = 1,
      xref = "paper",
      y0 = 0,
      y1 = 16,
      yanchor = 1,
      yref = "paper",
      ysizemode = "pixel",
      fillcolor = toRGB("gray80"),
      line = list(color = "transparent")
    )
  )

economics_long %>%
  group_by(variable) %>%
  do(p = panel(.)) %>%
  subplot(nrows = NROW(.), shareX = TRUE)

### Creating a dendrogram
s <- matrix(c(1, 0.3, 0.3, 1), nrow = 2)
m <- mvtnorm::rmvnorm(1e5, sigma = s)
x <- m[, 1]
y <- m[, 2]
s <- subplot(
  plot_ly(x = x, color = I("black")),
  plotly_empty(),
  plot_ly(x = x, y = y, color = I("black")) %>%
    add_histogram2dcontour(colorscale = "Viridis"),
  plot_ly(y = y, color = I("black")),
  nrows = 2, heights = c(0.2, 0.8), widths = c(0.8, 0.2), margin = 0,
  shareX = TRUE, shareY = TRUE, titleX = FALSE, titleY = FALSE
)
layout(s, showlegend = FALSE)

### Use of recursive subplots
g <- list(
  scope = 'usa',
  projection = list(type = 'albers usa'),
  lakecolor = toRGB('white')
)
# create a map of population density
density <- state.x77[, "Population"] / state.x77[, "Area"]
map <- plot_geo(
  z = ~density, text = state.name,
  locations = state.abb, locationmode = 'USA-states'
) %>%
  layout(geo = g)
# create a bunch of horizontal bar charts
vars <- colnames(state.x77)
barcharts <- lapply(vars, function(var) {
  plot_ly(x = state.x77[, var], y = state.name) %>%
    add_bars(orientation = "h", name = var) %>%
    layout(showlegend = FALSE, hovermode = "y",
           yaxis = list(showticklabels = FALSE))
})
subplot(barcharts, margin = 0.01) %>%
  subplot(map, nrows = 2, heights = c(0.3, 0.7), margin = 0.1) %>%
  layout(legend = list(y = 1)) %>%
  colorbar(y = 0.5)

### Using flexbox to arrange plots
library(htmltools)
p <- plot_ly(x = rnorm(100))
# NOTE: you don't need browsable() in rmarkdown,
# but you do at the R prompt
browsable(div(
  style = "display: flex; flex-wrap: wrap; justify-content: center",
  div(p, style = "width: 40%; border: solid;"),
  div(p, style = "width: 40%; border: solid;"),
  div(p, style = "width: 100%; border: solid;")
))
