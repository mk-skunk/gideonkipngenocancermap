# Load necessary libraries (assuming they're already installed)
library(leaflet)
library(sf)
library(dplyr)
library(htmlwidgets)

# Load the shapefile for London (you need the shapefile in your working directory)
london_shapefile <- st_read("path/to/london_shapefile.shp") 

# Generate sample data for breast cancer patients in London
set.seed(123)  
london_patients <- data.frame(
  longitude = runif(100, min = -0.5, max = 0.3),  # Longitude range for London (approx.)
  latitude = runif(100, min = 51.3, max = 51.7),    # Latitude range for London (approx.)
  intensity = runif(100, min = 1, max = 10) 
)

# Convert to a spatial data frame
london_patients_sf <- st_as_sf(london_patients, coords = c("longitude", "latitude"), crs = 4326)

# Prepare data for the heatmap
heat_data <- london_patients %>%
  select(latitude, longitude, intensity) %>%
  as.matrix()

# Create the leaflet map focused on London
london_map <- leaflet() %>%
  addTiles() %>%
  addPolygons(data = london_shapefile, color = "blue", weight = 2, fillOpacity = 0.2) %>% 
  addHeatmap(
    data = heat_data,
    radius = 15,  # Adjust radius as needed for London's scale
    blur = 10,    
    maxZoom = 15, 
    gradient = c('0.1' = 'black', '0.5' = '#4c4c4c', '1' = '#ffffff') 
  ) %>%
  setView(lng = -0.1278, lat = 51.5074, zoom = 12)  # Center the map on London

# Display the map
london_map

# Save the map to an HTML file
saveWidget(london_map, file = "london_breast_cancer_heatmap.html", selfcontained = TRUE)