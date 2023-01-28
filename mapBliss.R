
library(tidyverse)
library(mapBliss)


plot_route_flex(
  c("Cairo", "Luxor", "Aswan", "Abu Simbel", "Farafra", "Alexandria", "Sharm el-Sheikh"),
  rep("car", 6),
  label_position = c("top", "right", "right", "bottom", "left", "top", "right", "top"),
  # text_indent = "10px",
  mapBoxTemplate = "//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
) 
 