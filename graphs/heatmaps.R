


data.t <- mtcars

#############################################################################
# Package 'd3heatmap': interativo                                           #
#############################################################################

library(d3heatmap)

d3heatmap(data.t,
          Rowv = FALSE, Colv = FALSE, scale = "column", 
          colors = "RdBu", na_color = "#fff",
          xaxis_font_size = 12, yaxis_font_size = 12,
          yaxis_width = 150)

# Git hub klaukb: devtools::install_github("klaukh/d3heatmap")

library(magrittr)

d3heatmap(data.t, scale = "column", dendrogram = "none", key = TRUE, #srtCol = 90,
          yaxis_width = 180, col = "RdBu", na.color = "#ffffff") %>% 
    
    hmAxis("x", location = 'top') %>%
    hmCells(cellnotes = data.t)



#############################################################################
# Package 'heatmaply': baseado em plotly                                    #
#############################################################################

library(heatmaply)

heatmaply_cor(data.t, Rowv = FALSE, Colv = FALSE, scale = "column", 
              na.value = "white", 
              column_text_angle = 0, 
              xlab = "Modelos", ylab = "Variáveis")



#############################################################################
# Package 'stats'                                                           #
#############################################################################

heatmap(scale(mtcars), Rowv = FALSE, Colv = FALSE, scale = "column")



#############################################################################
# Package 'iheatmapr'                                                       #
#############################################################################

library(iheatmapr)

iheatmap(as.matrix(data.t), scale = "cols", 
         colors = "RdBu") %>%

    add_col_labels(ticktext = colnames(data.t), textangle = 0) %>%
    add_row_labels(ticktext = rownames(data.t), side = "right") %>%
    add_row_title("Variáveis") %>%
    add_col_title("Modelos", side = "top")



#############################################################################
# Package 'plotly'                                                          #
#############################################################################

library(plotly)

plot_ly(z = data.t, x = colnames(data.t), y = rownames(data.t),
        type = "heatmap", colors = "RdBu")



#############################################################################
# Package 'ggplot2'                                                         #
#############################################################################

library(ggplot2)
library(dplyr)
library(tidyr)

view <- diamonds %>% 
    select(-carat, -color, -clarity) %>% 
    distinct(cut, .keep_all = TRUE) %>% 
    gather(variavel, valor, -cut)

teste <- ggplot(view, aes(variavel, cut, fill = valor)) + 
    geom_tile() + 
    scale_y_discrete(position = "right") + 
    geom_text(aes(label = round(valor, 3))) + 
    
    scale_fill_gradientn(colours = RColorBrewer::brewer.pal(11, "RdBu")) #+ 
    # theme(axis.title.x = element_blank(), axis.title.y = element_blank()) 

teste %>% ggplotly()


