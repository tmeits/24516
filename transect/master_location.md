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
# Work with weather data <http://aisori.meteo.ru/ClimateR> [R]
altai.aisori.files <- c("NA", "1", "NA", "NA")
altai.files <- list.files(path = "cli/altai")

lena.files <- list.files(path = "cli/lena")
lena.code <- c("24051", "24261", "24643", "24652", "24668", "24768", "24859")

lf <- list.files(path = "cli/north")
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
all.code <- c(altai.code,lena.code,north.code,yenisei.code)
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
}
```

```
## 29998 Orlik 52.5 99.82 1374.8 
## 36229 Ust’-Koksa|Ust-Koksa|Ust'-Koksa 50.27 85.62 977.6 
## 36231 Onguday|Ongudaj 50.75 86.14 833 
## 36246 Ust’-Ulagan|Ust-Ulagan|Ust'-Ulagan 50.63 87.93 1937 
## 24051 Siktyakh|Siktjah 69.92 125.17 38 
## 24261 Batagay-Alyta|Batagay 67.8 130.38 491.2 
## 24643 Khatyryk-Khoma|Khatyryk-Khomo 63.95 124.83 76.5 
## 24652 Sangary 63.97 127.47 95.7 
## 24668 Tayakh-Kyrdala|Verhojansk Perevoz 63.32 132.02 90.9 
## 24768 Khangas-Ebe|Curapca 62.03 132.6 185.7 
## 24859 Kachikattsy|Brologyakhatat 61.28 128.93 118 
## 20973 Kresty|Kresti 70.85 89.88 29 
## 20982 Volochanka 70.97 94.5 40.2 
## 21908 Zhilinda|Dzalinda 70.13 113.97 61.9 
## 21921 Kyusyur|Kjusjur 70.68 127.4 33 
## 23077 Noril'sk 69.35 88.25 NA 
## 23078 Ugol'nyy|Norilsk|Noril'sk 69.35 88.26 64.6 
## 23179 Taymyr|Taymur|Tajmur|Snezhnogorsk 68.1 87.77 93.8 
## 23376 Svetlogorsk 66.94 88.37 100.8 
## 24125 Olenлk|Olenek 68.5 112.43 207 
## 24136 Suhana|Sukhana 68.62 118.33 76.9 
## 24143 Dzhardzhan|Dzardzan 68.73 124 38.5 
## 24152  68.85 127.37 NA 
## 38401 Igarka 67.47 86.57 NA 
## 23066 Ust'-Port|Ust-Port | Ust Port 69.67 84.4 25 
## 23078 Ugol'nyy|Norilsk|Noril'sk 69.35 88.26 64.6 
## 23179 Taymyr|Taymur|Tajmur|Snezhnogorsk 68.1 87.77 93.8 
## 23365 Sidorovsk 66.6 82.5 34 
## 23445 Staryy Nadym|Nadym 65.47 72.67 18.8 
## 23453 Urengoy 65.95 78.4 23.7 
## 23657 Noyabr' Sk|Noyabr'sk 63.12 75.28 131 
## 23788 Kuz'movka|Kuzmovka 62.31 92.12 61.9
```
```{ read}

```
To refer to the array: 

Bulygina O. N., Veselov V. M., Alexandrova, T. M., Korshunova N. N. "DESCRIPTION OF ARRAY DATA ON ATMOSPHERIC PHENOMENA AT THE METEOROLOGICAL STATIONS OF RUSSIA."
The certificate of state registration database No. 2015620081
<http://meteo.ru/data/345-atmosfernye-yavleniya-sroki>


