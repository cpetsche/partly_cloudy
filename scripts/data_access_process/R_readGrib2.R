library(dplyr)
library(tidyr)
library(rNOMADS)

yr = 2021
mo = 3
dy = 26
hr = 20

convert_to_text <- function(num) {
  if (num < 10) {
    result <- paste("0", as.character(num), sep="")
  } else {
    result <- as.character(num)
  }
  return (result)
}

mo = convert_to_text(mo)
dy = convert_to_text(dy)
hr = convert_to_text(hr)

url <- paste("https://www.ncei.noaa.gov/data/rapid-refresh/access/rap-252-20km/analysis/", 
             yr, mo, "/", yr, mo, dy,
             "/rap_252_", yr, mo, dy, "_", hr, "00_000.grb2", sep= "")

############ Data Download ###############################

#url <- "https://www.ncei.noaa.gov/data/rapid-refresh/access/rap-252-20km/analysis/202105/20210501/rap_252_20210501_0500_000.grb2"
#url <- "https://www.ncei.noaa.gov/data/rapid-refresh/access/rap-252-20km/analysis/202105/20210501/rap_252_20210501_1100_000.grb2"
#url <- "https://www.ncei.noaa.gov/data/rapid-refresh/access/rap-252-20km/analysis/202105/20210501/rap_252_20210501_1700_000.grb2"
#url <- "https://www.ncei.noaa.gov/data/rapid-refresh/access/rap-252-20km/analysis/202105/20210502/rap_252_20210502_0500_000.grb2"


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

milliBars <- c("150 mb","175 mb","200 mb",
               "225 mb","250 mb","275 mb","300 mb","325 mb",
               "350 mb","375 mb","400 mb","425 mb","450 mb")

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
df_wide = df_wide %>% distinct(.keep_all = TRUE)

df_wide <- df_wide %>% separate(lev, c("mb", "alt_ft"), " ")
df_wide$mb = as.integer(df_wide$mb)
# https://www.weather.gov/media/epz/wxcalc/pressureAltitude.pdf
df_wide$alt_ft = (1 - (df_wide$mb/1013.25)**0.190284) * 145366.45

df_wide$RHice = df_wide$RH * exp((17.2693882*(df_wide$TMP-273.16)/(df_wide$TMP-35.86))-(21.8745584*(df_wide$TMP-273.16)/(df_wide$TMP-7.66)))
df_wide$isISSR = (df_wide$RHice > 100.0) & (df_wide$TMP < 233.15)

df_wide$flLevel = as.integer(round(df_wide$alt_ft/100, digits= -1))

summary(df_wide)

table(df_wide$flLevel)
table(df_wide$mb)

summary <- df_wide %>% group_by(alt_ft, isISSR) %>% summarize(
  ct = n()
)

only_ISSR <- df_wide %>% filter(isISSR == TRUE)

summary_ISSR <- only_ISSR %>% group_by(alt_ft, mb) %>% summarize(
  ct = n()
)

outpath <- paste("C:/Users/Public/DAEN690/rap_252_", yr, mo, dy, "_", hr, "00_000.csv", sep= "")
outpathISSR <- paste("C:/Users/Public/DAEN690/ISSR_rap_252_", yr, mo, dy, "_", hr, "00_000.csv", sep= "")

write.csv(df_wide, outpath, row.names = FALSE)
write.csv(only_ISSR, outpathISSR, row.names = FALSE)

################################################################################
################################################################################
milliBars <- c("100 mb","125 mb","150 mb","175 mb","200 mb",
               "225 mb","250 mb","275 mb","300 mb","325 mb",
               "350 mb","375 mb","400 mb","425 mb","450 mb",
               "475 mb","500 mb","525 mb","550 mb","575 mb",
               "600 mb","625 mb","650 mb","675 mb","700 mb",
               "725 mb","750 mb","775 mb","800 mb","825 mb",
               "850 mb","875 mb","900 mb","925 mb","950 mb",
               "975 mb","1000 mb")

# https://confluence.ecmwf.int/pages/viewpage.action?pageId=111155337#:~:text=The%20meteorological%20convention%20for%20winds,north%20flow%20(northward%20wind).
vars <- c("HGT") # https://rapidrefresh.noaa.gov/GRIB2Table_NCEPrap_prs.txt

#GribInfo(grib.file= tempFile, file.type = "grib2")

grbs <- ReadGrib(file.names= tempFile,
                 variables= vars,
                 file.type= "grib2",
                 levels= milliBars,
                 missing.data= NULL)

df <- data.frame(dateTime = grbs$forecast.date, 
                 lat = grbs$lat,
                 lon = grbs$lon,
                 lev = grbs$levels,
                 cat = grbs$variables,
                 val = grbs$value)

df_wide = spread(df, key= cat, value= val)
df_wide = df_wide %>% distinct(.keep_all = TRUE)

df_wide <- df_wide %>% separate(lev, c("mb", "alt_ft"), " ")
df_wide$mb = as.integer(df_wide$mb)
# https://www.weather.gov/media/epz/wxcalc/pressureAltitude.pdf
df_wide$alt_ft = (1 - (df_wide$mb/1013.25)**0.190284) * 145366.45
df_wide$diff = df_wide$alt_ft - df_wide$HGT
df_wide$absdiff = abs(df_wide$alt_ft - df_wide$HGT)

summary(df_wide)
df_wide_summary = df_wide %>% group_by(mb) %>% summarize(
  mean_computed_alt = mean(alt_ft),
  mean_HGT = mean(HGT),
  mean_abs_diff = mean(absdiff)
)

df_wide_summary$perc = round(df_wide_summary$mean_abs_diff/df_wide_summary$mean_HGT*100, 2)

write.csv(df_wide,"C:/Users/Public/DAEN690/geopotentials.csv", row.names = FALSE)
write.csv(df_wide_summary,"C:/Users/Public/DAEN690/hgtVScomputedAltitude.csv", row.names = FALSE)
