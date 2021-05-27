library(dplyr)
library(tidyr)
library(rNOMADS)

############ Data Download ###############################

url <- "https://www.ncei.noaa.gov/data/rapid-refresh/access/rap-252-20km/forecast/202105/20210501/rap_252_20210501_0000_005.grb2"

tempFile <- "C:/Users/Public/DAEN690/myRAP.grb2" # !!!! Change this to your local drive for a file download
download.file(url, tempFile, mode="wb")

# Description: https://rapidrefresh.noaa.gov/GRIB2Table_NCEPrap_prs.txt

milliBars <- c("100 mb","125 mb","150 mb","175 mb","200 mb",
               "225 mb","250 mb","275 mb","300 mb","325 mb",
               "350 mb","375 mb","400 mb","425 mb","450 mb",
               "475 mb","500 mb","525 mb","550 mb","575 mb",
               "600 mb","625 mb","650 mb","675 mb","700 mb",
               "725 mb","750 mb","775 mb","800 mb","825 mb",
               "850 mb","875 mb","900 mb","925 mb","950 mb",
               "975 mb","1000 mb")

# https://confluence.ecmwf.int/pages/viewpage.action?pageId=111155337#:~:text=The%20meteorological%20convention%20for%20winds,north%20flow%20(northward%20wind).
vars <- c("TMP", "RH", "UGRD", "VGRD", "VVEL") # https://rapidrefresh.noaa.gov/GRIB2Table_NCEPrap_prs.txt

############ Reading and Processing ###############################

#GribInfo(grib.file= tempFile, file.type = "grib2")

grbs <- ReadGrib(file.names= tempFile,
                 variables= vars,
                 file.type= "grib2",
                 levels= milliBars,
                 missing.data= NULL)

print(Sys.time())
df <- data.frame(dateTime = grbs$forecast.date, 
                 lat = grbs$lat,
                 lon = grbs$lon,
                 lev = grbs$levels,
                 cat = grbs$variables,
                 val = grbs$value)

df_wide = spread(df, key= cat, value= val)
df_wide = df_wide %>% distinct(dateTime,lat,lon,lev, .keep_all = TRUE)

df_wide <- df_wide %>% separate(lev, c("mb", "alt_ft"), " ")
df_wide$mb = as.integer(df_wide$mb)
# https://www.weather.gov/media/epz/wxcalc/pressureAltitude.pdf
df_wide$alt_ft = (1 - (df_wide$mb/1013.25)**0.190284) * 145366.45 * 0.3048

df_wide$RHice = df_wide$RH * exp((17.2693882*(df_wide$TMP-273.16)/(df_wide$TMP-35.86))-(21.8745584*(df_wide$TMP-273.16)/(df_wide$TMP-7.66)))
df_wide$isISSR = (df_wide$RHice > 100) & (df_wide$TMP < 233)

summary <- df_wide %>% group_by(mb, isISSR) %>% summarize(
  ct = n()
)

only_ISSR = df_wide %>% filter(isISSR == TRUE)
