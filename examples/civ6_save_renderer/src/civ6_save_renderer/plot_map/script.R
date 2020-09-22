library(tidyverse)
library(ggforce)
library(civ6saves)

# read header information
map_data <- 
  readr::read_lines(par$yaml) %>%
  gsub("`([^']*)'(.*)`", "`\\1\\2`", .) %>% # small workaround because the yaml package does not support backticks
  gsub("`([^']*)'(.*)`", "`\\1\\2`", .) %>%
  gsub("`([^']*)'(.*)`", "`\\1\\2`", .) %>%
  gsub("`([^']*)'(.*)`", "`\\1\\2`", .) %>%
  gsub("`([^']*)'(.*)`", "`\\1\\2`", .) %>%
  gsub("`([^']*)'(.*)`", "`\\1\\2`", .) %>%
  gsub("`([^']*)'(.*)`", "`\\1\\2`", .) %>%
  gsub("`([^']*)'(.*)`", "`\\1\\2`", .) %>%
  gsub("`([^']*)`", "'\\1'", .) %>%
  yaml::yaml.load(handlers = list(int = identity))

# transform some objects to data frames (a table)
for (nam in c("ACTORS", "CIVS", "MOD_BLOCK_1", "MOD_BLOCK_2", "MOD_BLOCK_3")) {
  map_data[[nam]] <- map_data[[nam]] %>% map_df(data.frame) %>% as_tibble()
}

# read map information
map_data$MAP <- read_tsv(par$tsv, col_types = cols(.default = "c")) %>%
  mutate_at(vars(-starts_with("buffer")), function(x) {
    y <- bit64::as.integer64(x)
    if (max(y, na.rm = TRUE) <= .Machine$integer.max) {
      as.integer(y)
    } else {
      y
    }
  })

# fetch static part of the map
tab_static <- map_data$MAP %>%
  add_coordinates() %>%
  left_join(terrains, by = "terrain") %>%
  left_join(features, by = "feature")

rivers <- get_river_coordinates(tab_static)

# plot static part of the map
alpha <- 0.25

g <-
  plot_empty_map(tab_static) +
  ggforce::geom_regon(aes(fill = terrain_name), alpha = alpha) +
  geom_text(aes(label = "^"), tab_static %>% filter(terrain_form == "Hill"), alpha = alpha) +
  geom_text(aes(label = "^"), tab_static %>% filter(terrain_form == "Mountain"), fontface = "bold", alpha = alpha) +
  geom_segment(aes(x = xa, xend = xb, y = ya, yend = yb), colour = feature_palette[["River"]], rivers, size = 1, alpha = alpha) +
  scale_fill_manual(values = terrain_palette) +
  theme(legend.position = "right")

# save map to file
ggsave(par$output, g, width = 24, height = 13)
