
## Install Packages:
# install.packages("apexchartes")

## Load Packages: 
library(apexcharter)


### Exemplo 1: ----

# Quick Charts: Use apex function to quickly create visualizations

data("mpg", package = "ggplot2")
n_manufac <- dplyr::count(mpg, manufacturer)

apex(data = n_manufac, type = "bar", mapping = aes(x = manufacturer, y = n))


# With datetime

data("economics", package = "ggplot2")

apex(data = economics, type = "line", mapping = aes(x = date, y = uempmed)) %>% 
    ax_stroke(width = 1)

### Line + markers

n_manufac_year <- count(mpg, manufacturer, year)

apex(data = n_manufac_year, type = "line", mapping = aes(x = manufacturer, y = n, fill = year)) %>%
    ax_chart(stacked = TRUE) %>% 
    ax_stroke(width = 2) %>%
    ax_markers(size = 3)

### Bar chart

n_manufac_year <- count(mpg, manufacturer, year)

apex(data = n_manufac_year, type = "column", mapping = aes(x = manufacturer, y = n, fill = year)) %>%
    ax_chart(stacked = TRUE)


### Exemplo 2: ----

# All methods from ApexCharts are available with function like ax_* compatible with pipe from magrittr :

data(mpg, package = "ggplot2")
n_manufac <- dplyr::count(mpg, manufacturer)

apexchart() %>% 
    ax_chart(type = "bar") %>% 
    ax_plotOptions(bar = bar_opts(horizontal = FALSE,
                                  endingShape = "flat",
                                  columnWidth = "70%",
                                  dataLabels = list(position = "top"))) %>% 
    ax_grid(show = TRUE, position = "front", borderColor = "#FFF") %>% 
    ax_series(list(name = "Count", data = n_manufac$n)) %>% 
    ax_colors("#112446") %>% 
    ax_xaxis(categories = n_manufac$manufacturer) %>% 
    ax_title(text = "Number of models") %>% 
    ax_subtitle(text = "Data from ggplot2")


# Raw API
# Pass a list of parameters to the function: 

apexchart(ax_opts = list(
    chart = list(type = "line"),
    stroke = list(curve = "smooth"),
    grid = list(borderColor = "#e7e7e7", row = list(colors = c("#f3f3f3", "transparent"), opacity = 0.5)),
    
    dataLabels = list(enabled = TRUE),
    markers = list(style = "inverted", size = 4),
    
    series = list(
        list(name = "High",
             data = c(28, 29, 33, 36, 32, 32, 33)),
        list(name = "Low",
             data = c(12, 11, 14, 18, 17, 13, 13))),
    
    title = list(text = "Average High & Low Temperature", align = "left"),
    xaxis = list(categories = month.abb[1:7]),
    yaxis = list(title = list(text = "Temperature"),
                 labels = list(formatter = htmlwidgets::JS("function(value) {return value + '°C';}")))
))



apexchart() %>% 
    ax_chart(type = "line") %>% 
    ax_xaxis( categories = month.abb[1:7]) %>% 
    ax_series(list(name = "High", data = c(28, 29, 33, 36, 32, 32, 33))) 
    


