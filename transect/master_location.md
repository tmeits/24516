### Summary table on climate stations
#### Iljin Victor, 13.10.2016

```r
st.names <- c("Station_Code", "Station_Name", "Latitude", "Longitude", "Elevation", "Start_Y", 
    " End_Y")
st.names.alt <- c("wmo_xref", "city", "lat_prp", "lon_prp", "elev_baro", "start_year", "end_year")
# http://meteocenter.net/_world_weather_stations.htm
st <- read.csv("master-location-identifier-database-20130801.csv", header = TRUE, sep = ",", 
    dec = ".")
altai.code <- c(29998, 36229, 36231, 36246)
altai.names <- c("ORLIK", "UST-KOKSA", "ONGUDAJ", "UST-ULAGAN")
sort(altai.code)
```

```
## [1] 29998 36229 36231 36246
```

```r
# Work with weather data <http://aisori.meteo.ru/ClimateR> [R]
altai.aisori.files <- c("NA", "1", "NA", "NA")
altai.files <- list.files(path = "cli/altai")

lena.files <- list.files(path = "cli/lena")
lena.code <- c("24051", "24261", "24643", "24652", "24668", "24768", "24859")
sort(lena.code)
```

```
## [1] "24051" "24261" "24643" "24652" "24668" "24768" "24859"
```

```r
lf <- list.files(path = "cli/north")
north.files <- list.files(path = "cli/north")
north.code <- c(1:length(lf))
for (i in 1:length(lf)) {
    lf.ss <- substr(lf[i], 1, 5)
    north.code[i] <- as.numeric(lf.ss)
    cat(lf.ss, "\n")
}
```

```
## 20973 
## 20982 
## 21908 
## 21921 
## 23077 
## 23078 
## 23179 
## 23376 
## 24125 
## 24136 
## 24143 
## 24152 
## 38401
```

```r
sort(north.code)
```

```
##  [1] 20973 20982 21908 21921 23077 23078 23179 23376 24125 24136 24143
## [12] 24152 38401
```

```r
lf <- list.files(path = "cli/yenisei")
yenisei.files <- list.files(path = "cli/yenisei")
yenisei.code <- c(1:length(lf))
for (i in 1:length(lf)) {
    lf.ss <- substr(lf[i], 1, 5)
    yenisei.code[i] <- as.numeric(lf.ss)
    cat(lf.ss, "\n")
}
```

```
## 23066 
## 23078 
## 23179 
## 23365 
## 23445 
## 23453 
## 23657 
## 23788
```

```r
sort(yenisei.code)
```

```
## [1] 23066 23078 23179 23365 23445 23453 23657 23788
```

```r
getStationInfo <- function(stDF, stCode) {
    L <- length(stDF[, 1])
    for (i in 1:L) {
        if (!is.na(stDF[i, 12])) {
            # stDF$wmo_xref[i]
            if (stDF[i, "wmo_xref"] == stCode) 
                return(stDF[i, ])
        }
    }
}
# http://www.latlong.ru/
# http://www.sur-base.ru/?p=map
# http://meteoclub.ru/index.php?action=vthread&forum=16&topic=4021
all.code <- c(altai.code, lena.code, north.code, yenisei.code)
all.code <- sort(as.numeric(all.code))
all.code
```

```
##  [1] 20973 20982 21908 21921 23066 23077 23078 23078 23179 23179 23365
## [12] 23376 23445 23453 23657 23788 24051 24125 24136 24143 24152 24261
## [23] 24643 24652 24668 24768 24859 29998 36229 36231 36246 38401
```

```r
length(all.code)
```

```
## [1] 32
```

```r
ML <- matrix(c(1:(length(all.code) * 7)), nrow = length(all.code), ncol = 7, byrow = TRUE)
ml.df <- as.data.frame(ML)  #  converted to dataframe
ml.df <- setNames(ml.df, st.names)
ml.df <- setNames(ml.df, st.names.alt)  # assign names to the columns
str(ml.df)
```

```
## 'data.frame':	32 obs. of  7 variables:
##  $ wmo_xref  : int  1 8 15 22 29 36 43 50 57 64 ...
##  $ city      : int  2 9 16 23 30 37 44 51 58 65 ...
##  $ lat_prp   : int  3 10 17 24 31 38 45 52 59 66 ...
##  $ lon_prp   : int  4 11 18 25 32 39 46 53 60 67 ...
##  $ elev_baro : int  5 12 19 26 33 40 47 54 61 68 ...
##  $ start_year: int  6 13 20 27 34 41 48 55 62 69 ...
##  $ end_year  : int  7 14 21 28 35 42 49 56 63 70 ...
```

```r
for (i in 1:length(all.code)) {
    si <- getStationInfo(st, all.code[i])
    cat(si$wmo, as.character(si$city), round(si$lat_prp, 2), round(si$lon_prp, 2), si$elev_baro, 
        "\n")
    ml.df[i, 1] <- si$wmo
    ml.df[i, 2] <- as.character(si$city)
    ml.df[i, 3] <- round(si$lat_prp, 2)
    ml.df[i, 4] <- round(si$lon_prp, 2)
    ml.df[i, 5] <- si$elev_baro
    ml.df[i, 6] <- NA
    ml.df[i, 7] <- NA
    if(all.code[i] == 24152){
    ml.df[i, 5] <- 3
       ml.df[i, 2] <- "XZ}"
    }
    if(all.code[i] == 38401)  ml.df[i, 5] <- 3
    if(all.code[i] == 23077)  ml.df[i, 5] <- 2
}
```

```
## 20973 Kresty|Kresti 70.85 89.88 29 
## 20982 Volochanka 70.97 94.5 40.2 
## 21908 Zhilinda|Dzalinda 70.13 113.97 61.9 
## 21921 Kyusyur|Kjusjur 70.68 127.4 33 
## 23066 Ust'-Port|Ust-Port | Ust Port 69.67 84.4 25 
## 23077 Noril'sk 69.35 88.25 NA 
## 23078 Ugol'nyy|Norilsk|Noril'sk 69.35 88.26 64.6 
## 23078 Ugol'nyy|Norilsk|Noril'sk 69.35 88.26 64.6 
## 23179 Taymyr|Taymur|Tajmur|Snezhnogorsk 68.1 87.77 93.8 
## 23179 Taymyr|Taymur|Tajmur|Snezhnogorsk 68.1 87.77 93.8 
## 23365 Sidorovsk 66.6 82.5 34 
## 23376 Svetlogorsk 66.94 88.37 100.8 
## 23445 Staryy Nadym|Nadym 65.47 72.67 18.8 
## 23453 Urengoy 65.95 78.4 23.7 
## 23657 Noyabr' Sk|Noyabr'sk 63.12 75.28 131 
## 23788 Kuz'movka|Kuzmovka 62.31 92.12 61.9 
## 24051 Siktyakh|Siktjah 69.92 125.17 38 
## 24125 Olenлk|Olenek 68.5 112.43 207 
## 24136 Suhana|Sukhana 68.62 118.33 76.9 
## 24143 Dzhardzhan|Dzardzan 68.73 124 38.5 
## 24152  68.85 127.37 NA 
## 24261 Batagay-Alyta|Batagay 67.8 130.38 491.2 
## 24643 Khatyryk-Khoma|Khatyryk-Khomo 63.95 124.83 76.5 
## 24652 Sangary 63.97 127.47 95.7 
## 24668 Tayakh-Kyrdala|Verhojansk Perevoz 63.32 132.02 90.9 
## 24768 Khangas-Ebe|Curapca 62.03 132.6 185.7 
## 24859 Kachikattsy|Brologyakhatat 61.28 128.93 118 
## 29998 Orlik 52.5 99.82 1374.8 
## 36229 Ust’-Koksa|Ust-Koksa|Ust'-Koksa 50.27 85.62 977.6 
## 36231 Onguday|Ongudaj 50.75 86.14 833 
## 36246 Ust’-Ulagan|Ust-Ulagan|Ust'-Ulagan 50.63 87.93 1937 
## 38401 Igarka 67.47 86.57 NA
```

```r
str(ml.df)
```

```
## 'data.frame':	32 obs. of  7 variables:
##  $ wmo_xref  : int  20973 20982 21908 21921 23066 23077 23078 23078 23179 23179 ...
##  $ city      : chr  "Kresty|Kresti" "Volochanka" "Zhilinda|Dzalinda" "Kyusyur|Kjusjur" ...
##  $ lat_prp   : num  70.8 71 70.1 70.7 69.7 ...
##  $ lon_prp   : num  89.9 94.5 114 127.4 84.4 ...
##  $ elev_baro : num  29 40.2 61.9 33 25 2 64.6 64.6 93.8 93.8 ...
##  $ start_year: int  NA NA NA NA NA NA NA NA NA NA ...
##  $ end_year  : int  NA NA NA NA NA NA NA NA NA NA ...
```

```r
ml.df.backup <- ml.df
```
#### Read the files at the stations and determination of years
```{ read}

addPeriod <- function(dfPTransect, path, listFiles) {
    dfTransect <- dfPTransect
    for (i in 1:length(listFiles)) {
        Al <- read.csv(paste0(path,listFiles[i]), header = FALSE, sep = "", dec = ".")
        cat("\nRead (", i, ")", listFiles[i], "\n")
        cat(Al[length(Al[,3]), 3],  Al[1, 3], "\n")
        dfTransect[dfTransect$wmo_xref == as.numeric(substr(listFiles[i], 1, 5)), ]$end_year <- Al[length(Al[, 3]), 3]
        dfTransect[dfTransect$wmo_xref == as.numeric(substr(listFiles[i], 1, 5)), ]$start_year <- Al[1, 3]
    }
    return(dfTransect)
}
ml.df <- ml.df.backup
ml.df <- addPeriod(ml.df, paste0(getwd(), "/cli/altai/"), altai.files)
ml.df <- addPeriod(ml.df, paste0(getwd(), "/cli/lena/"), lena.files)
ml.df <- addPeriod(ml.df, paste0(getwd(), "/cli/north/"), north.files)
ml.df <- addPeriod(ml.df, paste0(getwd(), "/cli/yenisei/"), yenisei.files)
 
print("Read done...")
```
#### writeXLSX

```r
print("Write done...")
```

```
## [1] "Write done..."
```
To refer to the array: 

Bulygina O. N., Veselov V. M., Alexandrova, T. M., Korshunova N. N. "DESCRIPTION OF ARRAY DATA ON ATMOSPHERIC PHENOMENA AT THE METEOROLOGICAL STATIONS OF RUSSIA."
The certificate of state registration database No. 2015620081
<http://meteo.ru/data/345-atmosfernye-yavleniya-sroki>


```r
print("End.")
```

```
## [1] "End."
```
