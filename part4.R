library(plotly)
library(ggplot2)

### HIGHLIGHTING CHARTS
data(txhousing, package = "ggplot2")

tx <- highlight_key(txhousing, ~city)

base <- plot_ly(tx, color = I("black")) %>%
  group_by(city)

time_series <- base %>%
  group_by(city) %>%
  add_lines(x = ~date, y = ~median)

highlight(
  time_series,
  on = "plotly_click",
  selectize = TRUE,
  dynamic = TRUE,
  persistent = TRUE
)

# Highlighting between many plots
dot_plot <- base %>%
  summarise(miss = sum(is.na(median))) %>%
  filter(miss > 0) %>%
  add_markers(
    x = ~miss,
    y = ~forcats::fct_reorder(city, miss),
    hoverinfo = "x+y"
  ) %>%
  layout(
    xaxis = list(title = "Number of months missing"),
    yaxis = list(title = "")
  )

subplot(dot_plot, time_series, widths = c(.2, .8), titleX = TRUE) %>%
  layout(showlegend = FALSE) %>%
  highlight(on = "plotly_selected", dynamic = TRUE, selectize = TRUE)
