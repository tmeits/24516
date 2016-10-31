### Summary table on climate stations
#### Iljin Victor, 13.10.2016

```r
source("http://tmeits.github.io/24516/transect/setdw.R")
source("http://tmeits.github.io/24516/transect/clifiles.R") 

st.names <- c("Station_Code", "Station_Name", "Latitude", "Longitude", "Elevation", "Start_Y", 
    "End_Y", "FIT_Y")
#st.names.alt <- c("wmo_id", "city", "lat_prp", "lon_prp", "elev_baro", "start_year", "end_year", "fit_years", "path")
st.names.alt <- c("wmo_id", "city", "lat_prp", "lon_prp", "elev_baro", "start_year", "end_year", "path")
# http://meteocenter.net/_world_weather_stations.htm
st <- read.csv("master-location-identifier-database-20130801.csv", header = TRUE, sep = ",", 
    dec = ".")
#
getStationCode <- function(listFiles) {
    codes <- c(1:length(listFiles))
    for (i in 1:length(listFiles)) {
        listFiles.ss <- substr(listFiles[i], 1, 5)
        codes[i] <- as.numeric(listFiles.ss)
        cat(listFiles.ss, '\n')
    }
    return(codes)
}

#altai.code <- c(29998, 36229, 36231, 36246)
#altai.names <- c("ORLIK", "UST-KOKSA", "ONGUDAJ", "UST-ULAGAN")
#altai.code  <- getStationCode(altai.files)
# Work with weather data <http://aisori.meteo.ru/ClimateR> [R]
altai.aisori.files <- c("NA", "1", "NA", "NA")

#lena.code <- c("24051", "24261", "24643", "24652", "24668", "24768", "24859")
#lena.code <- getStationCode(lena.files)

#north.code <- getStationCode(north.files)

#yenisei.code <- getStationCode(yenisei.files)

#
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
#all.code <- c(altai.code, lena.code, north.code, yenisei.code)
all.code <- as.numeric(all.code)
all.code
```

```
##  [1] 29998 36229 36231 36246 24051 24261 24643 24652 24668 24768 24859
## [12] 20973 20982 21908 21921 23077 23078 23179 23376 24125 24136 24143
## [23] 24152 38401 23066 23078 23179 23365 23445 23453 23657 23788 29998
```

```r
ML <- matrix(c(1:(length(all.code) * 8)), nrow = length(all.code), ncol = 8, byrow = TRUE)
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
    ml.df[i, 8] <- NA
    ml.df[i, 9] <- NA
    
    # missing values, fill from other sources
    if(all.code[i] == 24152){  # 
    ml.df[i, 5] <- 900
       ml.df[i, 2] <- "Verkhoyansk Range"
    }
    if(all.code[i] == 38401)  ml.df[i, 5] <- 25 # Ivan xlsx
    if(all.code[i] == 23077)  ml.df[i, 5] <- 197 # Norilsk http://www.weatherbase.com/weather/weather.php3?refer=&s=592273&cityname=Noril%27sk-Krasnoyarsk&refer=&cityname=Noril%27sk-Krasnoyarsk
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
## 24125 Olenëk|Olenek 68.5 112.43 207 
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
## 29998 Orlik 52.5 99.82 1374.8
```

```r
str(ml.df)
```

```
## 'data.frame':	33 obs. of  9 variables:
##  $ wmo_id    : int  29998 36229 36231 36246 24051 24261 24643 24652 24668 24768 ...
##  $ city      : chr  "Orlik" "Ust’-Koksa|Ust-Koksa|Ust'-Koksa" "Onguday|Ongudaj" "Ust’-Ulagan|Ust-Ulagan|Ust'-Ulagan" ...
##  $ lat_prp   : num  52.5 50.3 50.8 50.6 69.9 ...
##  $ lon_prp   : num  99.8 85.6 86.1 87.9 125.2 ...
##  $ elev_baro : num  1375 978 833 1937 38 ...
##  $ start_year: int  NA NA NA NA NA NA NA NA NA NA ...
##  $ end_year  : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ path      : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ V9        : logi  NA NA NA NA NA NA ...
```

```r
ml.df.backup <- ml.df
```
#### Read the files at the stations and determination of years

```r
addPeriod <- function(dfTransect, path, listFiles, cliPath) {
    for (i in 1:length(listFiles)) {
        cliSt <- read.csv(paste0(path, listFiles[i]), header = FALSE, sep = "", 
            dec = ".")
        cat("\nRead (", i, ")", listFiles[i], "\n")
        stCode <- as.numeric(substr(listFiles[i], 1, 5))
        beginY <- cliSt[1, 3]
        endY <- cliSt[length(cliSt[, 3]), 3]
        cat(stCode,beginY, endY,cliPath, "\n")
        dfTransect[dfTransect$wmo_id == stCode, ]$end_year <- endY
        dfTransect[dfTransect$wmo_id == stCode, ]$start_year <- beginY 
        dfTransect[dfTransect$wmo_id == stCode, ]$path <- as.character(cliPath)
    }
    return(dfTransect)
}

ml.df <- ml.df.backup
ml.df <- addPeriod(ml.df, paste0(mm_path, "/", alati.path,"/"), altai.files, alati.path)
```

```
## 
## Read ( 1 ) 29998099999 ORLIK.txt 
## 29998 1997 2015 cli/altai 
## 
## Read ( 2 ) 36229099999 UST'- KOKSA.txt 
## 36229 2009 2015 cli/altai 
## 
## Read ( 3 ) 36231099999 ONGUDAJ.txt 
## 36231 1958 1995 cli/altai 
## 
## Read ( 4 ) 36246099999 UST-ULAGAN.txt 
## 36246 1969 1988 cli/altai
```

```r
ml.df <- addPeriod(ml.df, paste0(mm_path, "/cli/lena/"), lena.files, lena.path)
```

```
## 
## Read ( 1 ) 24051099999 SIKTJAH.txt 
## 24051 1969 1990 cli/lena 
## 
## Read ( 2 ) 24261099999 BATAGAJ-ALYTA.txt 
## 24261 1959 2015 cli/lena 
## 
## Read ( 3 ) 24643099999 HATYAYK-HOMO.txt 
## 24643 1959 2015 cli/lena 
## 
## Read ( 4 ) 24652099999 SANGARY.txt 
## 24652 1948 2015 cli/lena 
## 
## Read ( 5 ) 24668099999 VERHOJANSK PEREVOZ.txt 
## 24668 1959 2015 cli/lena 
## 
## Read ( 6 ) 24768099999 CURAPCA.txt 
## 24768 1948 2016 cli/lena 
## 
## Read ( 7 ) 24859099999 BROLOGYAKHATAT.txt 
## 24859 1959 1988 cli/lena
```

```r
ml.df <- addPeriod(ml.df, paste0(mm_path, "/cli/north/"), north.files, north.path)
```

```
## 
## Read ( 1 ) 20973099999 KRESTI.txt 
## 20973 1955 2001 cli/north 
## 
## Read ( 2 ) 20982099999 VOLOCHANKA.txt 
## 20982 1937 2015 cli/north 
## 
## Read ( 3 ) 21908099999 DZALINDA.txt 
## 21908 1959 2013 cli/north 
## 
## Read ( 4 ) 21921099999 KJUSJUR.txt 
## 21921 1948 2008 cli/north 
## 
## Read ( 5 ) 23077099999 NORILSK.txt 
## 23077 1959 1975 cli/north 
## 
## Read ( 6 ) 23078099999 NORIL'SK.txt 
## 23078 1975 2015 cli/north 
## 
## Read ( 7 ) 23179099999 SNEZHNOGORSK.txt 
## 23179 1973 2015 cli/north 
## 
## Read ( 8 ) 23376099999 SVETLOGORSK.txt 
## 23376 2012 2015 cli/north 
## 
## Read ( 9 ) 24125099999 OLENEK.txt 
## 24125 1962 2000 cli/north 
## 
## Read ( 10 ) 24136099999 SUHANA.txt 
## 24136 1959 2015 cli/north 
## 
## Read ( 11 ) 24143099999 DZARDZAN.txt 
## 24143 1948 1996 cli/north 
## 
## Read ( 12 ) 24152099999 VERKHOYANSK RANGE.txt 
## 24152 1959 1963 cli/north 
## 
## Read ( 13 ) 38401099999 IGARKA.txt 
## 38401 2004 2013 cli/north
```

```r
ml.df <- addPeriod(ml.df, paste0(mm_path, "/cli/yenisei/"), yenisei.files, yenisei.path)
```

```
## 
## Read ( 1 ) 23066099999 UST PORT UST ENISEISK.txt 
## 23066 1948 1955 cli/yenisei 
## 
## Read ( 2 ) 23078099999 NORIL'SK.txt 
## 23078 1975 2015 cli/yenisei 
## 
## Read ( 3 ) 23179099999 SNEZHNOGORSK.txt 
## 23179 1973 2015 cli/yenisei 
## 
## Read ( 4 ) 23365099999 SIDOROVSK.txt 
## 23365 1961 1994 cli/yenisei 
## 
## Read ( 5 ) 23445099999 NADYM.txt 
## 23445 1956 2015 cli/yenisei 
## 
## Read ( 6 ) 23453099999 URENGOJ.txt 
## 23453 1955 2015 cli/yenisei 
## 
## Read ( 7 ) 23657099999 NOYABR' SK.txt 
## 23657 2012 2015 cli/yenisei 
## 
## Read ( 8 ) 23788099999 KUZ' MOVKA.txt 
## 23788 1958 2015 cli/yenisei
```

```r
ml.df <- addPeriod(ml.df, paste0(mm_path, "/cli/aisori/"), aisori.files, aisori.path)
```

```
## 
## Read ( 1 ) 29998_Orlik(WS).txt 
## 29998 1948 1995 cli/aisori
```

```r
head(ml.df) 
```

```
##   wmo_id                               city lat_prp lon_prp elev_baro
## 1  29998                              Orlik   52.50   99.82    1374.8
## 2  36229    Ust’-Koksa|Ust-Koksa|Ust'-Koksa   50.27   85.62     977.6
## 3  36231                    Onguday|Ongudaj   50.75   86.14     833.0
## 4  36246 Ust’-Ulagan|Ust-Ulagan|Ust'-Ulagan   50.63   87.93    1937.0
## 5  24051                   Siktyakh|Siktjah   69.92  125.17      38.0
## 6  24261              Batagay-Alyta|Batagay   67.80  130.38     491.2
##   start_year end_year       path V9
## 1       1948     1995 cli/aisori NA
## 2       2009     2015  cli/altai NA
## 3       1958     1995  cli/altai NA
## 4       1969     1988  cli/altai NA
## 5       1969     1990   cli/lena NA
## 6       1959     2015   cli/lena NA
```

```r
print("Read done...")
```

```
## [1] "Read done..."
```
#### writeXLSX

```r
Sys.setenv(R_ZIPCMD = paste0(mm_path, "/bin/zip.exe"))  ## path to zip.exe
require(openxlsx)
openxlsx::write.xlsx(ml.df, file = "master_location.xlsx")
```

```
## Warning in file.create(to[okay]): cannot create file
## 'master_location.xlsx', reason 'Permission denied'
```

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
# runAllChunks("master_location.Rmd")
# Rmd2R("master_location.Rmd", "master_location.R")
# source("master_location.R")
print("End.")
```

```
## [1] "End."
```



















