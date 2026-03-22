# Set work directory
setwd("/media/joel/Lab/CIBiG_2025/stage_yam/R_analysis")
output_dir  <- "Distribution_map"
dir.create(output_dir, showWarnings = FALSE)

library(sf) #Handle spatial vector data (points, polygons, shapefiles)
library(ggplot2) # create maps and statistical graphics.
library(rnaturalearth) # Provides world map datasets.
library(readr) # Used for fast data import.
library(dplyr) # Data manipulation
library(ggspatial) # Adds map elements like scale bar, north arrow, annotations
library(RColorBrewer) # color palettes for maps and plots

# Load coordinate file
data <- read_delim("Input_dir/africrop_rename_SRA.csv", delim = ";", 
                   show_col_types = FALSE)
data$Longitude <- as.numeric(data$Longitude)
data$Latitude  <- as.numeric(data$Latitude)

colnames(data) <- c("Name", "GenBank_ID", "Field_identification", "Country",
                    "Longitude", "Latitude", "Population_assignment")

# Convert to spatial object
data_sf <- st_as_sf(data, coords = c("Longitude", "Latitude"), crs = 4326)

# Load world map
world <- ne_countries(scale = "medium", returnclass = "sf")

# Buffer setting
buffer <- 7  # degrees
xlim <- c(min(data$Longitude) - buffer, max(data$Longitude) + buffer)
ylim <- c(min(data$Latitude) - buffer, max(data$Latitude) + buffer)

# Color palette
n_pop <- length(unique(data$Field_identification))
n_pop2 <- length(unique(data$Population_assignment))
palette1 <- brewer.pal(min(8, n_pop), "Set1")
palette2 <- brewer.pal(min(8, n_pop2), "Set2")

# Assign shapes
shapes1 <- seq(0, n_pop - 1)
shapes2 <- seq(0, n_pop2 - 1)

# Plot map
map_plot_1 <- ggplot() +
  geom_sf(data = world, fill = "white", color = "gray60", size = 0.2) +
  geom_sf(data = data_sf,
          aes(color = Field_identification, shape = Field_identification),
          size = 2, alpha = 0.9) +
  scale_color_manual(values = palette1) +
  scale_shape_manual(values = shapes1) +
  coord_sf(xlim = xlim, ylim = ylim, expand = FALSE) +
  theme_classic(base_size = 12) +
  theme(
    panel.background = element_rect(fill = "aliceblue"),
    legend.position = "right") +
  annotation_north_arrow(location = "tr", 
                         which_north = "true",
                         style = north_arrow_fancy_orienteering) +
  annotation_scale(location = "bl",
                   width_hint = 0.2,
                   text_cex = 1.2,       
                   line_width = 0.7,       
                   bar_cols = c("black", "white"))+
  labs(title = "Sampling Locations",
       color = "Field identification",
       shape = "Field identification")

map_plot_2 <- ggplot() +
  geom_sf(data = world, fill = "white", color = "gray60", size = 0.2) +
  geom_sf(data = data_sf,
          aes(color = Population_assignment, shape = Population_assignment),
          size = 2, alpha = 0.9) +
  scale_color_manual(values = palette2) +
  scale_shape_manual(values = shapes2) +
  coord_sf(xlim = xlim, ylim = ylim, expand = FALSE) +
  theme_classic(base_size = 12) +
  theme(
    panel.background = element_rect(fill = "aliceblue"),
    legend.position = "right") +
  annotation_north_arrow(location = "tr", 
                         which_north = "true",
                         style = north_arrow_fancy_orienteering) +
  annotation_scale(location = "bl",
                   width_hint = 0.2,
                   text_cex = 1.2,      
                   line_width = 0.7,    
                   bar_cols = c("black", "white"))+
  labs(title = "Sampling Locations",
       color = "Population assignment",
       shape = "Population assignment")

# Save maps
ggsave(paste0(output_dir,"/Sampling_Map_1.png"),
       plot = map_plot_1, width = 10, height = 6, dpi = 300)

ggsave(paste0(output_dir,"/Sampling_Map_2.png"),
       plot = map_plot_2, width = 10, height = 6, dpi = 300)




