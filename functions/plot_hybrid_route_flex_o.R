plot_hybrid_route_flex_o <- function (
  addresses, 
  how = c("car", "flight", "bike", "foot"), 
  colour = "black", 
  opacity = 1, 
  weight = 1, 
  radius = 2, 
  label_text = addresses, 
  popup_text = addresses,
  label_position = "bottom", 
  font = "Lucida Console", 
  font_weight = "bold", 
  font_size = "14px", 
  text_indent = "15px", 
  mapBoxTemplate = "//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
  nCurves = 100, 
  zoomControl = c(0.1, 0.1, -0.1, -0.1)
) {
  
  address_single <- tibble::tibble(singlelineaddress = addresses) |> 
    tidygeocoder::geocode(address = singlelineaddress, method = "arcgis") |> 
    dplyr::transmute(id = singlelineaddress, lon = long, lat = lat)
  
  trip <- matrix(nrow = 1, ncol = 2)
  
  for (i in 1:(nrow(address_single) - 1)) {
    if (how[i] == "flight") {
      trip <- rbind(
        trip, 
        geosphere::gcIntermediate(address_single[i, 2:3], address_single[i + 1, 2:3], n = 100, addStartEnd = TRUE)
      )
    } else {
      roadTrip <- osrm::osrmRoute(
        src = unlist(c(address_single[i, 2:3])), 
        dst = unlist(c(address_single[i + 1, 2:3])), 
        overview = "full", 
        osrm.profile = how[i]
      )
      
      roadTrip <- do.call(rbind, sf::st_geometry(roadTrip)) |> 
        tibble::as_tibble(.name_repair = "unique") |> 
        rlang::set_names(c("lon", "lat")) |> 
        as.data.frame() |> 
        as.matrix()
      
      trip <- rbind(trip, roadTrip)
    }
  }
  
  m <- leaflet::leaflet(
    trip, 
    options = leaflet::leafletOptions(zoomControl = TRUE, attributionControl = FALSE)
    ) |> 
    leaflet::fitBounds(
      lng1 = max(address_single$lon) + zoomControl[1], 
      lat1 = max(address_single$lat) + zoomControl[2], 
      lng2 = min(address_single$lon) + zoomControl[3], 
      lat2 = min(address_single$lat) + zoomControl[4]
    ) |>
    leaflet::addTiles(urlTemplate = mapBoxTemplate) |> 
    leaflet::addMarkers(
      lat = address_single$lat, 
      lng = address_single$lon,
      label = label_text,
      popup = popup_text
    ) |> 
    leaflet::addPolylines(
      lng = trip[, 1], 
      lat = trip[, 2], 
      color = colour, 
      opacity = opacity, 
      weight = weight
    )
  
  # for (i in 1:nrow(address_single)) {
  # 
  #   m <- m |>
  #     leaflet::addLabelOnlyMarkers(
  #     address_single$lon[i],
  #     address_single$lat[i],
  #     label = label_text[i],
  #     labelOptions = leaflet::labelOptions(
  #       noHide = TRUE,
  #       direction = label_position[i],
  #       textOnly = TRUE,
  #       style = list(
  #         `font-family` = font,
  #         `font-weight` = font_weight,
  #         `font-size` = font_size,
  #         padding = text_indent[i]
  #       )
  #     )
  #   )
  # }
  
  m
}
