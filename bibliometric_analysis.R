###############################################################

#Natural history societies as stewards of biodiversity data: 
#lessons from arachnology for improving quality, access and trust 

#Bach et al. 2026, Ecological Informatics


###############################################################

# R code to reproduce results

# Author: Alexander Bach
# Last update: 27.02.2026

###############################################################

# ---- Packages ----
library(here)       # robust project-root file paths
library(dplyr)      # data wrangling
library(ggplot2)    # plotting
library(patchwork)  # combine multiple ggplots
library(scales)     # number formatting (e.g., comma separators)

# ---- Read data ----
# AraGes Atlas data
df_atlas <- read.delim(here("atlas_citations.csv"), stringsAsFactors = FALSE)

# ARAMOB citations exported from/related to GBIF
df_aramob <- read.delim(here("gbif_aramob_citations.csv"), stringsAsFactors = FALSE)

# ---- Derive year from `published` ----
# Extract the first 4 characters (YYYY) and cast to integer.
df_aramob$Year <- as.integer(substr(df_aramob$published, 1, 4))

# ---- Aggregate yearly counts ----
# ARAMOB: one row per record -> count records per year
year_counts_aramob <- df_aramob %>%
  count(Year, name = "n") %>%
  arrange(Year)

# Atlas: one row per record -> count records per year
year_counts_atlas <- df_atlas %>%
  count(Year, name = "n") %>%
  arrange(Year)

# ---- Totals for subtitles ----
n_atlas  <- sum(year_counts_atlas$n, na.rm = TRUE)
n_aramob <- sum(year_counts_aramob$n, na.rm = TRUE)

# ---- Plot: AraGes Atlas ----
p_atlas <- ggplot(year_counts_atlas, aes(x = Year, y = n)) +
  geom_col(width = 0.85, fill = "#d19600") +
  # LOESS trend line to visualize overall trajectory
  geom_smooth(
    method = "loess",
    se = FALSE,
    color = "black",
    linewidth = 1,
    span = 0.7
  ) +
  scale_y_continuous(expand = c(0, 0)) +  
  labs(x = "", y = "AraGes Atlas citations") +
  theme_classic(base_size = 12) +
  theme(
    axis.line = element_line(),
    axis.ticks.length = unit(3, "pt"),
    plot.margin = margin(5, 5, 5, 5),
    strip.background = element_blank()
  )

# ---- Plot: ARAMOB (GBIF) ----
p_gbif <- ggplot(year_counts_aramob, aes(x = Year, y = n)) +
  geom_col(width = 0.85, fill = "#6ec5ff") +
  geom_smooth(
    method = "loess",
    se = FALSE,
    color = "black",
    linewidth = 1,
    span = 0.7
  ) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x = "", y = "ARAMOB GBIF citations") +
  theme_classic(base_size = 12) +
  theme(
    axis.line = element_line(),
    axis.ticks.length = unit(3, "pt"),
    plot.margin = margin(5, 5, 5, 5)
  )

# ---- Add subtitles with total counts ----
p_atlas <- p_atlas +
  labs(subtitle = paste0("n = ", comma(n_atlas))) +
  theme(
    plot.title.position = "plot",
    plot.subtitle = element_text(hjust = 1)  
  )

p_gbif <- p_gbif +
  labs(subtitle = paste0("n = ", comma(n_aramob))) +
  theme(
    plot.title.position = "plot",
    plot.subtitle = element_text(hjust = 1)
  )

# ---- Combine into one figure ----
# `tag_levels = "a"` adds panel tags a, b
print_version <- p_atlas + p_gbif + plot_annotation(tag_levels = "a")

# Print to the active graphics device (e.g., RStudio)
print_version

# ---- Export settings ----
# Convert target pixel dimensions to inches at 300 dpi.
w_in <- 535 / 300
h_in <- 303 / 300

# Export at 300 dpi
ggplot2::ggsave(
  filename = "plot_scale3_300dpi.png",
  plot     = print_version,
  width    = w_in,
  height   = h_in,
  units    = "in",
  dpi      = 300,
  scale    = 3
)
