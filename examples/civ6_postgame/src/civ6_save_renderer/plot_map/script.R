library(tidyverse)
library(ggforce)
library(civ6saves)
library(bit64)
library(cowplot)
library(yaml)
library(ggnewscale)

# setwd("/home/rcannood/workspace/di/viash_docs/examples/civ6_save_renderer")
# par <- list(
#   yaml = "output/AutoSave_0160.yaml",
#   tsv = "output/AutoSave_0160.tsv"
# )

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

# get leader info
owner_ids <- map_data$MAP$owner %>% unique() %>% sort()

# assign colours to civs
leader_colours <- bind_rows(
  map_data$CIVS %>%
    transmute(owner = row_number() - 1L, leader = LEADER_NAME) %>%
    left_join(leaders, by = "leader") %>%
    rename(leader_inner_colour = leader_outer_colour, leader_outer_colour = leader_inner_colour),
  tibble(
    owner = setdiff(owner_ids, c(seq_len(nrow(map_data$CIVS)) - 1, 62L, 255L))
  ) %>% mutate(
    leader = NA_character_,
    leader_name = paste0("City State ", seq_along(owner)),
    leader_inner_colour = rainbow(length(owner)),
    leader_outer_colour = "#111111"
  ),
  tribble(
    ~owner, ~leader, ~leader_name, ~leader_inner_colour, ~leader_outer_colour,
    62L, "BARBARIAN", "Barbarian", "black", "black",
    255L, "LEADER_FREE_CITIES", "Free Cities", "red", "black"
  )
)
owner_outer_palette <- leader_colours %>% select(leader_name, leader_outer_colour) %>% deframe()
owner_inner_palette <- leader_colours %>% select(leader_name, leader_inner_colour) %>% deframe()

# fetch static part of the map
tab_static <- map_data$MAP %>%
  add_coordinates() %>%
  left_join(terrains, by = "terrain") %>%
  left_join(features, by = "feature")

rivers <- get_river_coordinates(tab_static)

# plot static part of the map
alpha <- 0.25

g0 <-
  plot_empty_map(tab_static) +
  ggforce::geom_regon(aes(fill = terrain_name), alpha = alpha) +
  geom_text(aes(label = "^"), tab_static %>% filter(terrain_form == "Hill"), alpha = alpha) +
  geom_text(aes(label = "^"), tab_static %>% filter(terrain_form == "Mountain"), fontface = "bold", alpha = alpha) +
  geom_segment(aes(x = xa, xend = xb, y = ya, yend = yb), colour = feature_palette[["River"]], rivers, size = 1, alpha = alpha) +
  scale_fill_manual(values = terrain_palette) +
  theme(legend.position = "right")

# plot dynamic part of the map
tab <- map_data$MAP %>%
  add_coordinates() %>%
  left_join(features, by = "feature") %>%
  left_join(improvements, by = "improvement") %>%
  left_join(world_wonders, by = "world_wonder") %>%
  left_join(roads, by = "road") %>%
  left_join(leader_colours %>% select(owner, leader, leader_name), by = "owner") %>%
  mutate(leader_name = factor(leader_name, levels = leader_colours$leader_name))


civ_borders <- get_border_coordinates(tab)
road_coords <- get_road_coordinates(tab)

cities <- tab %>% group_by(owner, city_1) %>% filter(district == min(district)) %>% ungroup()

players <- map_data$ACTORS %>% filter(ACTOR_TYPE == "CIVILIZATION_LEVEL_FULL_CIV") %>% select(leader = LEADER_NAME) %>% left_join(leaders, by = "leader")

g <- g0 +
  ggforce::geom_regon(aes(r = civ6saves:::xy_ratio * .9), tab %>% filter(feature_name == "Ice"), fill = feature_palette[["Ice"]], alpha = .4) +
  labs(
    title = paste0("Turn ", map_data$GAME_TURN, " - ", tolower(gsub("MAPSIZE_", "", map_data$MAP_SIZE))),
    subtitle = paste0(players$leader_name, collapse = ", "),
    fill = "Terrain"
  )

if (nrow(road_coords) > 0) {
  g <- g +
    geom_segment(aes(x = xa, xend = xb, y = ya, yend = yb, colour = road_name), road_coords %>% mutate(x0 = xa, y0 = ya), size = 1.5, alpha = .4) +
    scale_colour_manual(values = c("Ancient Road" = "#8e712b", "Railroad" = "darkgray", "Classical Road" = "#a2a2a2", "Industrial Road" = "#6e6e6e", "Modern Road" = "#424242")) +
    labs(colour = "Road")
}

if (nrow(tab %>% filter(!is.na(owner))) > 0) {
  g <- g +
    ggnewscale::new_scale_fill() +
    ggnewscale::new_scale_color() +
    ggforce::geom_regon(aes(fill = leader_name), tab %>% filter(!is.na(leader_name)), alpha = .6) +
    geom_segment(aes(x = xa, xend = xb, y = ya, yend = yb, colour = leader_name), civ_borders %>% filter(!is.na(leader_name)), size = 1) +
    geom_point(aes(x = x0, y = y0, colour = leader_name), cities %>% filter(!is.na(leader_name)), size = 3) +
    scale_fill_manual(values = owner_outer_palette) +
    scale_colour_manual(values = owner_inner_palette) +
    labs(colour = "Leader", fill = "Leader")
}

# save map to file
gleg <- cowplot::get_legend(g)
gnoleg <- g + theme(legend.position = "none")
gout <- cowplot::plot_grid(gnoleg, gleg, rel_widths = c(8, 1))
ggsave(par$output, gout, width = 24, height = 13)
