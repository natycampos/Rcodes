
#############################################################################
#                                                                           #
# Colors in R:                                                              #
# http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf                     # 
#                                                                           #
#############################################################################


# Red - Yellow - Blue
palete1 <- colorRampPalette(c('#6B0C22', '#D9042B', '#EFC94C', '#588C8C', '#011C26'))
plot(rep(1,5), col = palete1(5), pch = 19, cex = 3)

# Blue - Green - Red - Black
palete2 <- c("darkblue", "lightblue", "darkgreen", "lightgreen", "darkred", "red", "black")
plot(rep(1,7), col = palete2, pch = 19, cex = 3)

palete3 <- colorRampPalette(brewer.pal(n = 7, 'RdYlBu'))
plot(rep(1,1), col = palete3(1), pch = 19, cex = 3)
plot(rep(1,7), col = palete3(7), pch = 19, cex = 3)

library(RColorBrewer)

# Display all palletes of RColorBrewer
RColorBrewer::display.brewer.all()
