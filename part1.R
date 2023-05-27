# if (!require(remotes)) install.packages("remotes")
# remotes::install_github("cpsievert/plotly_book")

library(dplyr)
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

# Creating scatter plots with error bars
# Fit a full-factorial linear model
m <- lm(
  Sepal.Length ~ Sepal.Width * Petal.Length * Petal.Width,
  data = iris
)

# (1) get a tidy() data structure of covariate-level info
# (e.g., point estimate, standard error, etc)
# (2) make sure term column is a factor ordered by the estimate
# (3) plot estimate by term with an error bar for the standard error
broom::tidy(m) %>%
  mutate(term = forcats::fct_reorder(term, estimate)) %>%
  plot_ly(x = ~estimate, y = ~term) %>%
  add_markers(
    error_x = ~list(value = std.error),
    color = I("black"),
    hoverinfo = "x"
  )

### CREATING MAPS
library(rnaturalearth)

world <- ne_countries(returnclass = "sf")
plot_ly(world, color = I("gray90"), stroke = I("black"), span = I(1))

canada <- ne_states(country = "Canada", returnclass = "sf")
plot_ly(canada, split = ~name, color = ~provnum_ne)

plot_ly(
  canada,
  split = ~name,
  color = I("gray90"),
  text = ~paste(name, "is \n province number", provnum_ne),
  hoveron = "fills",
  hoverinfo = "text",
  showlegend = FALSE
)

### PLOTING MULTIPLE NUMERIC DISTRIBUTIONS
plot_ly(diamonds, x = ~cut, color = ~clarity) %>%
  add_histogram()

### PLOTING MULTIPLE BOXPLOTS
p <- plot_ly(diamonds, y = ~price, color = I("black"),
             alpha = 0.1, boxpoints = "suspectedoutliers")
p1 <- p %>% add_boxplot(x = "Overall")
p2 <- p %>% add_boxplot(x = ~cut)
subplot(
  p1, p2, shareY = TRUE,
  widths = c(0.2, 0.8), margin = 0
) %>% hide_legend()

# Sorted boxplots
lvls <- diamonds %>%
  group_by(cut) %>%
  summarise(m = median(price)) %>%
  arrange(m) %>%
  pull(cut)

p %>%
  add_boxplot(x = ~factor(cut, lvls))
