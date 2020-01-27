
#############################################################################                                                                  #
#                                                                           #
# Dygraphs for R:                                                           #
# https://rstudio.github.io/dygraphs/index.html                             #      
# http://dygraphs.com/options.html                                          #   
#                                                                           #
#############################################################################

# Load packages
library(dygraphs)


# Exemplo 1 

lungDeaths <- cbind(mdeaths, fdeaths)

dygraph(lungDeaths) %>% 
    dySeries("mdeaths", label = "Male") %>%
    dySeries("fdeaths", label = "Female") %>%
    dyOptions(stackedGraph = TRUE) %>%
    dyRangeSelector(height = 20)


# Exemplo 2

lungDeaths <- cbind(ldeaths, mdeaths, fdeaths)

dygraph(lungDeaths) %>%
    dyOptions(colors = RColorBrewer::brewer.pal(3, "Set2"))


# Exemplo 3

dygraph(nhtemp, main = "New Haven Temperatures") %>%
    dySeries(label = "Temp (F)", color = "black") %>%
    dyShading(from = "1920-1-1", to = "1930-1-1", color = "#FFE6E6") %>%
    dyShading(from = "1940-1-1", to = "1950-1-1", color = "#CCEBD6")


# Exemplo 4

hw <- HoltWinters(ldeaths)
predicted <- predict(hw, n.ahead = 72, prediction.interval = TRUE)

dygraph(predicted, main = "Predicted Lung Deaths (UK)") %>% 
    # dyAxis("x", drawGrid = FALSE) %>%
    dySeries(c("lwr", "fit", "upr"), label = "Deaths") %>%
    dyOptions(colors = RColorBrewer::brewer.pal(3, "Set1"))


