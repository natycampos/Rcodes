
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Exemplo 1: 
# Gráficos feitos pelo Matt Herman 
# https://mattherman.info/blog/ppt-patchwork/
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

library(tidyverse)
library(gapminder)
library(scales)
library(gridExtra)
library(patchwork)

my_countries <- c("Zambia", "Malawi", "Mozambique", "Tanzania", "Kenya") 

east_africa <- gapminder %>% 
    filter(country %in% my_countries) %>%
    mutate(country = fct_reorder2(country, year, lifeExp)) # reorder for plotting

# Gráfico 1: Bar

bar <- east_africa %>% 
    filter(year == max(year)) %>%  # most recent year only
    ggplot(aes(x = country, y = lifeExp, fill = country)) +
    geom_col(width = 0.75, alpha = 0.9) +
    geom_text(
        aes(label = number(lifeExp, 0.1)),
        position = position_stack(vjust = 0.5),
        color = "white",
        fontface = "bold",
        size = 5
    ) +
    scale_fill_brewer(palette = "Dark2") +
    scale_y_continuous(expand = expand_scale(0.01, 0.05)) +  # remove extra space between bars and x-axis labels
    labs(y = "Life Expectancy (years)") +
    theme_minimal(base_size = 16) + 
    theme(
        legend.position = "none",
        axis.title.x = element_blank(),
        axis.title.y = element_text(size = 10),
        axis.title.y.left = element_text(margin = margin(r = 10)),
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank()
    )

ggplotly(bar)

# Gráfico 2: Line

line <- east_africa %>%
    ggplot(aes(x = year, y = lifeExp, color = country)) +
    geom_line(lwd = 1.25, key_glyph = "timeseries") +  # for those cute glyphs in the legend
    scale_color_brewer(palette = "Dark2") +
    labs(y = "Life Expectancy (years)") +
    theme_minimal(base_size = 16) +
    theme(
        legend.position = "bottom",
        legend.title = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_text(size = 10),
        axis.title.y.left = element_text(margin = margin(r = 10)),
        panel.grid.minor = element_blank(),
        plot.margin = margin(t = 30)
    )

line


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Exemplo 2: 
# Gráfico feito pelo Matt Herman 
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

library(tidyverse)
library(wbstats)
library(scales)

# define regions in the americas
americas <- tribble(
    ~iso3c, ~region,
    "CAN", "North America",
    "USA", "North America",
    "MEX", "North America",
    "GTM", "Central America",
    "BLZ", "Central America",
    "SLV", "Central America",
    "HND", "Central America",
    "NIC", "Central America",
    "CRI", "Central America",
    "PAN", "Central America",
    "COL", "South America",
    "VEN", "South America",
    "GUY", "South America",
    "SUR", "South America",
    "ECU", "South America",
    "BRA", "South America",
    "PER", "South America",
    "BOL", "South America",
    "PRY", "South America",
    "URY", "South America",
    "ARG", "South America",
    "CHL", "South America"
)

# get alcohol data from wold bank
alcohol_per_cap <- wb(
    country = americas$iso3c,
    indicator = "SH.ALC.PCAP.LI",
    mrv = 1
) %>% 
    left_join(americas, by = "iso3c") %>%
    select(country, value, region) %>% 
    arrange(desc(value)) %>% 
    as_tibble()

# Gráfico 1: 

alcohol_per_cap %>% 
    mutate(
        region = fct_relevel(region, "North America", "Central America"),
        country = fct_reorder(country, value)
    ) %>% 
    ggplot(aes(x = country, y = value, fill = region)) +
    geom_col(alpha = 0.8, width = 0.85) +
    scale_fill_brewer(palette = "Dark2") +
    scale_y_continuous(expand = c(0, 0.1)) +
    coord_flip() +
    facet_grid(rows = vars(region), scales = "free_y", switch = "y", space = "free_y") +
    labs(
        title = "Which country in the Americas parties (drinks) the hardest?",
        subtitle = "Total alcohol consumed per capita, 2016",
        caption = "Source: World Health Organization\nGlobal Health Observatory Data Repository",
        y = "Annual alcohol consumption per capita (liters)"
    ) +
    theme_minimal(base_family = "Roboto Condensed") +
    theme(
        plot.margin = margin(0.5, 0.5, 0.5, 0.5, unit = "cm"),
        plot.title = element_text(size = 15, face = "bold"),
        strip.text.y = element_text(angle = 270, face = "bold"),
        strip.placement = "outside",
        axis.title.x = element_text(margin = margin(t = 0.5, b = 0.5, unit = "cm")),
        axis.title.y = element_blank(),
        axis.text = element_text(size = 10),
        legend.position = "none",
        panel.grid.major.y = element_blank(),
    ) -> p1

ggplotly(p1)


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Exemplo 3: 
# https://rud.is/b/2019/09/27/100-stacked-chicklets/
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

# install.packages("ggchicklet", repos = "https://cinc.rud.is")

library(hrbrthemes) # CRAN or fav social coding site using hrbrmstr/pkgname
library(ggchicklet) # fav social coding site using hrbrmstr/pkgname
library(tidyverse)

f500_dmarc <- read_csv("https://rud.is/dl/f500-industry-dmarc.csv.gz", col_types = "cc")

# f500_dmarc

dmarc_levels <- c("No DMARC", "None", "Quarantine", "Reject")
dmarc_cols <- set_names(c(ft_cols$slate, "#a6dba0", "#5aae61", "#1b7837"), dmarc_levels)

(dmarc_summary <- count(f500_dmarc, industry, p))

(dmarc_summary %>% 
        filter(p != "No DMARC") %>% # we don't care abt this `p` value
        count(industry, wt=n, sort=TRUE) -> industry_levels)

# Gráfico 1: 

dmarc_summary %>% 
    mutate(p = factor(p, levels = rev(dmarc_levels))) %>% 
    mutate(industry = factor(industry, rev(industry_levels$industry))) %>% 
    ggplot(aes(industry, n)) +
    geom_chicklet(aes(fill = p)) +
    scale_fill_manual(name = NULL, values = dmarc_cols) +
    scale_y_continuous(expand = c(0,0), position = "right") +
    coord_flip() +
    labs(
        x = NULL, y = NULL,
        title = "DMARC Status of Fortune 500 (2017 List; 2018 Measurement) Primary Email Domains"
    ) +
    theme_ipsum_rc(grid = "X") +
    theme(legend.position = "top")

# Gráfico 2: 

dmarc_summary %>% 
    mutate(p = factor(p, levels = rev(dmarc_levels))) %>% 
    mutate(industry = factor(industry, rev(industry_levels$industry))) %>% 
    ggplot(aes(industry, n)) +
    geom_chicklet(aes(fill = p), position = position_fill()) +
    scale_fill_manual(name = NULL, values = dmarc_cols) +
    scale_y_continuous(expand = c(0,0), position = "right") +
    coord_flip() +
    labs(
        x = NULL, y = NULL,
        title = "DMARC Status of Fortune 500 (2017 List; 2018 Measurement) Primary Email Domains"
    ) +
    theme_ipsum_rc(grid = "X") +
    theme(legend.position = "top")

# Gráfico 3: 

(dmarc_summary %>% 
        group_by(industry) %>% 
        mutate(pct = n/sum(n)) %>% 
        ungroup() %>% 
        filter(p != "No DMARC") %>% 
        count(industry, wt=pct, sort=TRUE) -> industry_levels)

dmarc_summary %>% 
    mutate(p = factor(p, levels = rev(dmarc_levels))) %>% 
    mutate(industry = factor(industry, rev(industry_levels$industry))) %>% 
    ggplot(aes(industry, n)) +
    geom_chicklet(aes(fill = p), position = position_fill(reverse = TRUE)) +
    scale_fill_manual(name = NULL, values = dmarc_cols) +
    scale_y_percent(expand = c(0, 0.001), position = "right") +
    coord_flip() +
    labs(
        x = NULL, y = NULL,
        title = "DMARC Status of Fortune 500 (2017 List; 2018 Measurement) Primary Email Domains"
    ) +
    theme_ipsum_rc(grid = "X") +
    theme(legend.position = "top")


