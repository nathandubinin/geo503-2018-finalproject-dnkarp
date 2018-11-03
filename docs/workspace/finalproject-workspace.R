  
library(tidycensus)
library(purrr)

# Un-comment below and set your API key
census_api_key("e7051ec917473383ba64a0c65d7090fa5cc10cf4")

us <- unique(fips_codes$state)[1:51]

totalpop <- map_df(us, function(x) {
  get_acs(geography = "tract", variables = "B01003_001", 
          state = x)
})

str(totalpop)


library(sf)
options(tigris_use_cache = TRUE)

totalpop_sf.2 <- reduce(
  map(us[1:2], function(x) {
    get_acs(geography = "tract", variables = "B01003_001", 
            state = x, geometry = TRUE)
  }), 
  rbind
)

str(totalpop_sf)




# USMAP -------------------------------------------------------------------

install.packages("usmap")
library(usmap)
state_map <- us_map(regions = "states")
plot_usmap("states")



# st_transform (albers) ---------------------------------------------------
usstates_sf.albers <- usstates_sf
usstates_sf.albers %>% st_transform(crs='+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs')

plot(st_geometry(usstates_sf.albers))

devtools::install_github("hrbrmstr/albersusa")
library(albersusa)
alb_usa <- albersusa::usa_sf('laea')
plot(alb_usa$geometry)
title(main = 'Albers')

function (proj = c("longlat", "laea", "lcc", "eqdc", "aeqd")) 
{
  us <- readRDS(system.file("extdata/states_sf.rda", package = "albersusa"))
  proj <- match.arg(proj, c("longlat", "laea", "lcc", "eqdc", 
                            "aeqd"))
  if (proj != "longlat") {
    proj <- switch(proj, laea = us_laea_proj, lcc = us_lcc_proj, 
                   eqdc = us_eqdc_proj, aeqd = us_aeqd_proj)
    us <- sf::st_transform(us, proj)
  }
  us
}

usstates_sf.albers <- st_transform(usstates_sf, us_laea_proj)

# ggplot maps -------------------------------------------------------------

usstates_sf.48.albers %>%
  ggplot(aes(fill = estimate, color = estimate)) + 
  geom_sf() + 
  scale_fill_viridis(option = "magma") + 
  scale_color_viridis(option = "magma")



# cowplots ----------------------------------------------------------------

install.packages('cowplot')
cowplot::plot_grid(
  tract.pop.map
  county.pop.map
  state.pop.map
  nrow = 1
)
