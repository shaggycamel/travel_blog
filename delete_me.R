library(purrr)
library(mapBliss)

library(usethis)

destinations <- list(
  "Cairo" = list(label="1: Cairo", transport=NA, label_pos="left", label_ind="0em"),
  "Luxor" = list(label="2: Luxor", transport="car", label_pos="right", label_ind="0em"), 
  "Aswan" = list(label="3: Aswan", transport="car", label_pos="bottom", label_ind="0em"), 
  "Kharga Oasis" = list(label="4: Kharga Oasis", transport="car", label_pos="left", label_ind="0em"), 
  "Alexandria" = list(label="5: Alexandria", transport="car", label_pos="left", label_ind="0em"), 
  "Sharm el-Sheikh" = list(label="6: Sharm el-Sheikh", transport="car", label_pos="bottom", label_ind="0em"), 
  "Aqaba" = list(label="7: Aqaba", transport="flight", label_pos="bottom", label_ind="0em"), 
  # "Wadi Rum" = list(label="Wadi Rum", transport="car", label_pos="right", label_ind="0em"), 
  "Wadi Musa" = list(label="8: Wadi Musa", transport="car", label_pos="right", label_ind="0em"), 
  "Amman" = list(label="9: Amman", transport="car", label_pos="left", label_ind="0em"), 
  "Antalya" = list(label="10: Antalya", transport="flight", label_pos="right", label_ind="0em"), 
  "Bodrum" = list(label="11: Bodrum", transport="car", label_pos="left", label_ind="0em"), 
  "Izmir" = list(label="12: Izmir", transport="car", label_pos="left", label_ind="0em"), 
  "Gelibolu" = list(label="13: Gallipoli", transport="car", label_pos="left", label_ind="0em"), 
  "Istanbul" = list(label="14: Istanbul", transport="car", label_pos="left", label_ind="0em")
)

m <- plot_hybrid_route_flex(
  names(destinations), 
  how = na.omit(map_chr(destinations, "transport")), 
  label_position = as.vector(map_chr(destinations, "label_pos"))
)
m$x$options$zoomControl <- TRUE
m
