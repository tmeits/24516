***
###  The calculation of the sixteen climatic characteristics for all of the weather stations included in the transect
#### Iljin Victor, 13.10.2016
***
  + download scripts with calculation functions
  + reading climate data of the weather station
  + cleaning missing values 
  + The calculation of climatic parameters
  + Record results in a spreadsheet 


```r
source("http://tmeits.github.io/24516/transect/setdw.R")
#Rmd2R("transect.Rmd", "transect.R")
#source("transect.R", echo=FALSE, max.deparse.length=150)
# downloadable list of files containing climatic measurements
# http://stackoverflow.com/questions/4876813/using-r-to-list-all-files-with-a-specified-extension
altai.files <- list.files(pattern = "\\.txt$", path = "cli/altai", ignore.case=TRUE, recursive=FALSE, full.names = FALSE)
lena.files <- list.files(pattern = "\\.txt$", path = "cli/lena", ignore.case=TRUE)
north.files <- list.files(pattern = "\\.txt$", path = "cli/north", ignore.case=TRUE)
yenisei.files <- list.files(pattern = "\\.txt$", path = "cli/yenisei", ignore.case=TRUE)

all.files <- sort(c(altai.files, lena.files, north.files, yenisei.files))
all.files
```

```
##  [1] "20973099999 KRESTI.txt"               
##  [2] "20982099999 VOLOCHANKA.txt"           
##  [3] "21908099999 DZALINDA.txt"             
##  [4] "21921099999 KJUSJUR.txt"              
##  [5] "23066099999 UST PORT UST ENISEISK.txt"
##  [6] "23077099999 NORILSK.txt"              
##  [7] "23078099999 NORIL'SK.txt"             
##  [8] "23078099999 NORIL'SK.txt"             
##  [9] "23179099999 SNEZHNOGORSK.txt"         
## [10] "23179099999 SNEZHNOGORSK.txt"         
## [11] "23365099999 SIDOROVSK.txt"            
## [12] "23376099999 SVETLOGORSK.txt"          
## [13] "23445099999 NADYM.txt"                
## [14] "23453099999 URENGOJ.txt"              
## [15] "23657099999 NOYABR' SK.txt"           
## [16] "23788099999 KUZ' MOVKA.txt"           
## [17] "24051099999 SIKTJAH.txt"              
## [18] "24125099999 OLENEK.txt"               
## [19] "24136099999 SUHANA.txt"               
## [20] "24143099999 DZARDZAN.txt"             
## [21] "24152099999 VERKHOYANSK RANGE.txt"    
## [22] "24261099999 BATAGAJ-ALYTA.txt"        
## [23] "24643099999 HATYAYK-HOMO.txt"         
## [24] "24652099999 SANGARY.txt"              
## [25] "24668099999 VERHOJANSK PEREVOZ.txt"   
## [26] "24768099999 CURAPCA.txt"              
## [27] "24859099999 BROLOGYAKHATAT.txt"       
## [28] "29998_Orlik(WS).txt"                  
## [29] "29998099999 ORLIK.txt"                
## [30] "36229099999 UST'- KOKSA.txt"          
## [31] "36231099999 ONGUDAJ.txt"              
## [32] "36246099999 UST-ULAGAN.txt"           
## [33] "38401099999 IGARKA.txt"
```
### The calculation of the sixteen climatic characteristics


```r
cli2par <- function(path, listFiles, info = TRUE, methodNA = TRUE) {
    listE <- list(1:length(listFiles))
    for (i in 1:length(listFiles)) {
        D <- read.csv(paste0(path, listFiles[i]), header = FALSE, sep = "", dec = ".")
        # The names of each column assign
        D <- setNames(D, c("Day", "Month", "Year", "PRECIP", "TMEAN"))
        if (info == TRUE) {
        #todo created methodNA zoo packages
            print("+---------------------------------------------------------+")
            print(paste0(path, listFiles[i]))
            #cat("Delete/Replace the rows contains the number -9999\n")
            na <- abs(length(D[D$PRECIP != -9999, ][, 1]) - length(D[, 1]))
            cat("The number of del/rep rows by column precipitation=", na, "\n")
            D <- D[D$PRECIP != -9999, ]
            na <- abs(length(D[D$TMEAN != -9999, ][, 1]) - length(D[, 1]))
            cat("The number of del/rep rows by column temp=", na, "\n")
            D <- D[D$TMEAN != -9999, ]
            print("Tail")
            print(tail(D))
            print("Structure")
            print(str(D))
            print("Summary")
            print(summary(D[4:5]))
            #print(summary(D))
            print("+---------------------------------------------------------+")
        } else {
            # Delete the rows contains the number -9999
            na <- abs(length(D[D$PRECIP != -9999, ][, 1]) - length(D[, 1]))
            D <- D[D$PRECIP != -9999, ]
            na <- abs(length(D[D$TMEAN != -9999, ][, 1]) - length(D[, 1]))
            D <- D[D$TMEAN != -9999, ]
        }
        # get rid of all observations with missing data
        D <- na.omit(D)
        endYear <- D[length(D[, 3]), 3]
        startYear <- D[1, 3]
        if (info == TRUE) {
            require(pracma)
            tic()
            #todo insert real numStation
            E <- eval16CliPars("23365", D, D, startYear, endYear)
            toc()
        } else {
            E <- eval16CliPars("23365", D, D, startYear, endYear)
        }
        # Deleted row is marked as bad
        E <- E[E$StartSG != -9999, ]
        #todo add tryCatch
        print(str(E))
        print(head(E))
        print(summary(E[c(2,5,6,11,12,13,15,16,17,18,19,20,21,22)]))
        
        Sys.setenv(R_ZIPCMD = paste0(path, "/zip.exe"))  ## path to zip.exe
        require(openxlsx)  # # WriteXLSX
        openxlsx::write.xlsx(E, file = paste0(path, "/cli2par/", listFiles[i], ".xlsx"))
        # Save result to list listE[i] <- E
    }
    return(E)
}
```
###  For all of the weather stations included in the transect


```r
if (TRUE) {
    require(pracma)
    tic()
    par.alatai <- cli2par(paste0(mm_path, "/cli/altai/"), altai.files, 
        info = TRUE)
    par.lena <- cli2par(paste0(mm_path, "/cli/lena/"), lena.files, info = TRUE)
    par.north <- cli2par(paste0(mm_path, "/cli/north/"), north.files, 
        info = TRUE)
    par.yenisei <- cli2par(paste0(mm_path, "/cli/yenisei/"), yenisei.files, 
        info = TRUE)
    toc()
}
```

```
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/altai/29998_Orlik(WS).txt"
## The number of del/rep rows by column precipitation= 119 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##       Day Month Year PRECIP  TMEAN
## 14499  26    12 1995      0 -27.44
## 14500  27    12 1995      0 -25.61
## 14501  28    12 1995      0 -20.67
## 14502  29    12 1995      0  -9.17
## 14503  30    12 1995      0  -9.56
## 14504  31    12 1995      0  -7.39
## [1] "Structure"
## 'data.frame':	14385 obs. of  5 variables:
##  $ Day   : int  2 10 13 14 25 30 5 7 8 17 ...
##  $ Month : int  7 8 9 9 9 10 11 11 11 11 ...
##  $ Year  : int  1948 1948 1948 1948 1948 1948 1948 1948 1948 1948 ...
##  $ PRECIP: num  0 0.51 0 2.03 0 0 0 7.11 0 0 ...
##  $ TMEAN : num  13.33 11.78 4.61 5 2.5 ...
## NULL
## [1] "Summary"
##      PRECIP            TMEAN        
##  Min.   :  0.000   Min.   :-42.060  
##  1st Qu.:  0.000   1st Qu.:-16.940  
##  Median :  0.000   Median : -3.830  
##  Mean   :  1.312   Mean   : -5.029  
##  3rd Qu.:  0.000   3rd Qu.:  7.610  
##  Max.   :150.110   Max.   : 23.000  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1948
```

```
## ****** Year: 1948 
## #################### Skip a year!!!! 
## ****** Year: 1949 Observation: 122 Period: 7-1-1949 30-12-1949 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1950 Observation: 270 Period: 3-1-1950 30-12-1950 ******
## ****** Year: 1951 Observation: 234 Period: 2-1-1951 31-12-1951 ******
## ****** Year: 1952 Observation: 264 Period: 1-1-1952 31-12-1952 ******
## ****** Year: 1953 Observation: 117 Period: 1-1-1953 30-12-1953 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1954 Observation: 171 Period: 3-1-1954 31-12-1954 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1955 Observation: 188 Period: 1-1-1955 27-12-1955 ******
## ****** Year: 1956 Observation: 156 Period: 4-1-1956 31-12-1956 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1957 Observation: 157 Period: 2-1-1957 31-12-1957 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1958 Observation: 204 Period: 1-1-1958 31-12-1958 ******
## ****** Year: 1959 Observation: 354 Period: 1-1-1959 31-12-1959 ******
## ****** Year: 1960 Observation: 346 Period: 2-1-1960 31-12-1960 ******
## ****** Year: 1961 Observation: 355 Period: 1-1-1961 31-12-1961 ******
## ****** Year: 1962 Observation: 362 Period: 1-1-1962 31-12-1962 ******
## ****** Year: 1963 Observation: 360 Period: 1-1-1963 31-12-1963 ******
## ****** Year: 1964 Observation: 364 Period: 1-1-1964 31-12-1964 ******
## ****** Year: 1965 Observation: 323 Period: 1-1-1965 30-12-1965 ******
## ****** Year: 1966 Observation: 362 Period: 1-1-1966 31-12-1966 ******
## ****** Year: 1967 Observation: 361 Period: 1-1-1967 31-12-1967 ******
## ****** Year: 1968 Observation: 362 Period: 1-1-1968 31-12-1968 ******
## ****** Year: 1969 Observation: 352 Period: 1-1-1969 31-12-1969 ******
## ****** Year: 1970 Observation: 355 Period: 1-1-1970 31-12-1970 ******
## ****** Year: 1971 Observation: 175 Period: 1-1-1971 30-6-1971 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1972
```

```
## ****** Year: 1972 
## #################### Skip a year!!!! 
## ****** Year: 1973 Observation: 354 Period: 1-1-1973 31-12-1973 ******
## ****** Year: 1974 Observation: 352 Period: 1-1-1974 31-12-1974 ******
## ****** Year: 1975 Observation: 360 Period: 1-1-1975 31-12-1975 ******
## ****** Year: 1976 Observation: 364 Period: 1-1-1976 31-12-1976 ******
## ****** Year: 1977 Observation: 362 Period: 1-1-1977 31-12-1977 ******
## ****** Year: 1978 Observation: 363 Period: 1-1-1978 31-12-1978 ******
## ****** Year: 1979 Observation: 365 Period: 1-1-1979 31-12-1979 ******
## ****** Year: 1980 Observation: 359 Period: 1-1-1980 31-12-1980 ******
## ****** Year: 1981 Observation: 364 Period: 1-1-1981 31-12-1981 ******
## ****** Year: 1982 Observation: 357 Period: 1-1-1982 31-12-1982 ******
## ****** Year: 1983 Observation: 354 Period: 1-1-1983 31-12-1983 ******
## ****** Year: 1984 Observation: 355 Period: 1-1-1984 31-12-1984 ******
## ****** Year: 1985 Observation: 358 Period: 1-1-1985 31-12-1985 ******
## ****** Year: 1986 Observation: 350 Period: 1-1-1986 31-12-1986 ******
## ****** Year: 1987 Observation: 345 Period: 1-1-1987 31-12-1987 ******
## ****** Year: 1988 Observation: 356 Period: 1-1-1988 31-12-1988 ******
## ****** Year: 1989 Observation: 357 Period: 1-1-1989 31-12-1989 ******
## ****** Year: 1990 Observation: 353 Period: 1-1-1990 31-12-1990 ******
## ****** Year: 1991 Observation: 314 Period: 1-1-1991 31-12-1991 ******
## ****** Year: 1992 Observation: 305 Period: 1-1-1992 31-12-1992 ******
## ****** Year: 1993 Observation: 347 Period: 1-1-1993 31-12-1993 ******
## ****** Year: 1994 Observation: 320 Period: 1-1-1994 31-12-1994 ******
## ****** Year: 1995 Observation: 345 Period: 1-1-1995 31-12-1995 ******
## 
## elapsed time is 31.280000 seconds 
## 'data.frame':	46 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1949 1950 1951 1952 1953 1954 1955 1956 1957 1958 ...
##  $ ObsBeg      : chr  "7-1-1949" "3-1-1950" "2-1-1951" "1-1-1952" ...
##  $ ObsEnd      : chr  "30-12-1949" "30-12-1950" "31-12-1951" "31-12-1952" ...
##  $ StartSG     : num  31 117 105 109 51 68 94 76 56 74 ...
##  $ EndSG       : num  69 202 178 189 88 127 129 105 97 133 ...
##  $ STDAT0      : chr  "19-5-1949" "19-5-1950" "16-5-1951" "25-5-1952" ...
##  $ STDAT5      : chr  "4-6-1949" "26-5-1950" "23-5-1951" "3-6-1952" ...
##  $ FDAT0       : chr  "27-9-1949" "17-9-1950" "24-9-1951" "24-9-1952" ...
##  $ FDAT5       : chr  "11-9-1949" "10-9-1950" "21-9-1951" "15-9-1952" ...
##  $ INTER0      : num  131 121 131 122 147 126 113 131 82 130 ...
##  $ INTER5      : num  111 114 127 113 130 118 100 119 80 125 ...
##  $ MAXT        : num  16 20.6 20.2 17.5 19.2 ...
##  $ MDAT        : chr  "8-8-1949" "8-7-1950" "19-7-1951" "15-7-1952" ...
##  $ SUMT0       : num  334 1002 802 963 338 ...
##  $ SUMT5       : num  290 933 772 893 319 ...
##  $ T220        : num  334 714 780 862 338 ...
##  $ T225        : num  290 684 766 824 319 ...
##  $ FT220       : num  334.3 260.5 28.7 100.2 338.1 ...
##  $ FT225       : num  290.2 247.9 12.9 80.5 318.6 ...
##  $ SPEEDT      : num  -0.5421 0.1532 -0.0192 0.0414 -0.6282 ...
##  $ SUMPREC     : num  87.6 236.5 88.9 212.6 80.3 ...
## NULL
##   Station_Code Year   ObsBeg     ObsEnd StartSG EndSG    STDAT0    STDAT5
## 2        23365 1949 7-1-1949 30-12-1949      31    69 19-5-1949  4-6-1949
## 3        23365 1950 3-1-1950 30-12-1950     117   202 19-5-1950 26-5-1950
## 4        23365 1951 2-1-1951 31-12-1951     105   178 16-5-1951 23-5-1951
## 5        23365 1952 1-1-1952 31-12-1952     109   189 25-5-1952  3-6-1952
## 6        23365 1953 1-1-1953 30-12-1953      51    88 18-5-1953 25-5-1953
## 7        23365 1954 3-1-1954 31-12-1954      68   127 23-5-1954  7-6-1954
##        FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT   SUMT0  SUMT5   T220
## 2  27-9-1949 11-9-1949    131    111 16.00  8-8-1949  334.28 290.17 334.28
## 3  17-9-1950 10-9-1950    121    114 20.56  8-7-1950 1001.80 932.92 714.50
## 4  24-9-1951 21-9-1951    131    127 20.17 19-7-1951  801.50 771.61 779.88
## 5  24-9-1952 15-9-1952    122    113 17.50 15-7-1952  963.36 893.27 861.98
## 6 12-10-1953 1-10-1953    147    130 19.17 24-7-1953  338.05 318.60 338.05
## 7  26-9-1954 25-9-1954    126    118 21.22 28-6-1954  648.67 608.62 648.67
##     T225  FT220  FT225      SPEEDT SUMPREC
## 2 290.17 334.28 290.17 -0.54212074   87.64
## 3 684.17 260.48 247.92  0.15319720  236.51
## 4 766.05  28.73  12.95 -0.01920373   88.90
## 5 823.82 100.17  80.45  0.04143313  212.64
## 6 318.60 338.05 318.60 -0.62824607   80.28
## 7 608.62 648.67 608.62 -0.47248912  181.14
##       Year         StartSG          EndSG           INTER0     
##  Min.   :1949   Min.   : 31.0   Min.   : 69.0   Min.   : 22.0  
##  1st Qu.:1960   1st Qu.:118.8   1st Qu.:204.0   1st Qu.:115.0  
##  Median :1972   Median :135.0   Median :249.5   Median :122.0  
##  Mean   :1972   Mean   :124.8   Mean   :222.4   Mean   :117.1  
##  3rd Qu.:1984   3rd Qu.:144.0   3rd Qu.:257.0   3rd Qu.:127.8  
##  Max.   :1995   Max.   :155.0   Max.   :280.0   Max.   :147.0  
##      INTER5           MAXT           SUMT0            SUMT5       
##  Min.   : 17.0   Min.   :13.06   Min.   : 264.2   Min.   : 219.7  
##  1st Qu.:107.0   1st Qu.:17.86   1st Qu.:1171.1   1st Qu.:1038.7  
##  Median :115.0   Median :18.78   Median :1302.8   Median :1200.3  
##  Mean   :111.0   Mean   :18.89   Mean   :1161.3   Mean   :1071.3  
##  3rd Qu.:119.8   3rd Qu.:20.16   3rd Qu.:1391.9   3rd Qu.:1303.6  
##  Max.   :135.0   Max.   :23.00   Max.   :1477.8   Max.   :1393.4  
##       T220            T225           FT220             FT225       
##  Min.   :264.2   Min.   :219.7   Min.   :  12.61   Min.   :   0.0  
##  1st Qu.:387.2   1st Qu.:330.7   1st Qu.: 388.54   1st Qu.: 359.2  
##  Median :450.5   Median :398.2   Median : 855.33   Median : 820.1  
##  Mean   :478.7   Mean   :427.7   Mean   : 695.26   Mean   : 670.6  
##  3rd Qu.:504.9   3rd Qu.:456.1   3rd Qu.: 917.59   3rd Qu.: 893.4  
##  Max.   :901.4   Max.   :863.5   Max.   :1048.75   Max.   :1019.4  
##      SPEEDT            SUMPREC     
##  Min.   :-0.62825   Min.   : 16.0  
##  1st Qu.: 0.04923   1st Qu.:127.9  
##  Median : 0.14306   Median :200.3  
##  Mean   : 0.08591   Mean   :256.2  
##  3rd Qu.: 0.23823   3rd Qu.:303.6  
##  Max.   : 0.44224   Max.   :832.4  
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/altai/29998099999 ORLIK.txt"
## The number of del/rep rows by column precipitation= 46 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##      Day Month Year PRECIP  TMEAN
## 5275  23    12 2015      0 -33.83
## 5276  24    12 2015      0 -22.61
## 5277  25    12 2015      0 -15.78
## 5278  26    12 2015      0 -18.83
## 5279  27    12 2015      0 -20.06
## 5280  28    12 2015      0 -19.22
## [1] "Structure"
## 'data.frame':	5234 obs. of  5 variables:
##  $ Day   : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ Month : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Year  : int  1997 1997 1997 1997 1997 1997 1997 1997 1997 1997 ...
##  $ PRECIP: num  0 0 0 0 0 0 0 0 0 0 ...
##  $ TMEAN : num  -27.6 -27 -29.9 -30.2 -26.4 ...
## NULL
## [1] "Summary"
##      PRECIP            TMEAN        
##  Min.   : 0.0000   Min.   :-39.440  
##  1st Qu.: 0.0000   1st Qu.:-17.000  
##  Median : 0.0000   Median : -3.140  
##  Mean   : 0.7805   Mean   : -4.936  
##  3rd Qu.: 0.0000   3rd Qu.:  7.780  
##  Max.   :97.0300   Max.   : 23.000  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
## ****** Year: 1997 Observation: 331 Period: 1-1-1997 31-12-1997 ******
## ****** Year: 1998 Observation: 234 Period: 1-1-1998 31-12-1998 ******
## ****** Year: 1999 Observation: 137 Period: 3-1-1999 31-12-1999 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2000
```

```
## ****** Year: 2000 
## #################### Skip a year!!!! 
## ****** Year: 2001 Observation: 119 Period: 17-1-2001 30-12-2001 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 2002 Observation: 166 Period: 2-1-2002 29-12-2002 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 2003 Observation: 235 Period: 1-1-2003 31-12-2003 ******
## ****** Year: 2004 Observation: 267 Period: 1-1-2004 30-12-2004 ******
## ****** Year: 2005 Observation: 287 Period: 2-1-2005 30-12-2005 ******
## ****** Year: 2006 Observation: 281 Period: 2-1-2006 31-12-2006 ******
## ****** Year: 2007 Observation: 313 Period: 1-1-2007 31-12-2007 ******
## ****** Year: 2008 Observation: 333 Period: 1-1-2008 30-12-2008 ******
## ****** Year: 2009 Observation: 350 Period: 1-1-2009 31-12-2009 ******
## ****** Year: 2010 Observation: 347 Period: 1-1-2010 31-12-2010 ******
## ****** Year: 2011 Observation: 351 Period: 1-1-2011 31-12-2011 ******
## ****** Year: 2012 Observation: 359 Period: 1-1-2012 31-12-2012 ******
## ****** Year: 2013 Observation: 352 Period: 1-1-2013 31-12-2013 ******
## ****** Year: 2014 Observation: 357 Period: 1-1-2014 31-12-2014 ******
## ****** Year: 2015 Observation: 356 Period: 1-1-2015 28-12-2015 ******
## 
## elapsed time is 18.340000 seconds 
## 'data.frame':	18 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1997 1998 1999 2001 2002 2003 2004 2005 2006 2007 ...
##  $ ObsBeg      : chr  "1-1-1997" "1-1-1998" "3-1-1999" "17-1-2001" ...
##  $ ObsEnd      : chr  "31-12-1997" "31-12-1998" "31-12-1999" "30-12-2001" ...
##  $ StartSG     : num  125 129 73 48 74 98 101 128 118 127 ...
##  $ EndSG       : num  230 183 98 76 119 183 193 211 214 228 ...
##  $ STDAT0      : chr  "15-5-1997" "22-5-1998" "2-5-1999" "4-5-2001" ...
##  $ STDAT5      : chr  "16-5-1997" "29-5-1998" "27-5-1999" "28-5-2001" ...
##  $ FDAT0       : chr  "14-9-1997" "27-9-1998" "22-9-1999" "8-10-2001" ...
##  $ FDAT5       : chr  "14-9-1997" "27-9-1998" "21-9-1999" "24-9-2001" ...
##  $ INTER0      : num  122 128 143 157 135 136 137 111 126 128 ...
##  $ INTER5      : num  122 127 142 128 128 132 130 107 109 119 ...
##  $ MAXT        : num  21.9 17.6 17.4 16.4 18.3 ...
##  $ MDAT        : chr  "25-6-1997" "30-6-1998" "11-7-1999" "1-6-2001" ...
##  $ SUMT0       : num  1435 686 212 245 497 ...
##  $ SUMT5       : num  1326 619 184 223 459 ...
##  $ T220        : num  672 626 212 245 497 ...
##  $ T225        : num  620 577 184 223 459 ...
##  $ FT220       : num  666.2 56.4 211.8 244.8 497 ...
##  $ FT225       : num  642 46.2 184.1 222.6 458.8 ...
##  $ SPEEDT      : num  0.171 0.102 -0.594 -0.615 -0.533 ...
##  $ SUMPREC     : num  214.65 49.3 9.15 43.93 67.06 ...
## NULL
##   Station_Code Year    ObsBeg     ObsEnd StartSG EndSG    STDAT0    STDAT5
## 1        23365 1997  1-1-1997 31-12-1997     125   230 15-5-1997 16-5-1997
## 2        23365 1998  1-1-1998 31-12-1998     129   183 22-5-1998 29-5-1998
## 3        23365 1999  3-1-1999 31-12-1999      73    98  2-5-1999 27-5-1999
## 5        23365 2001 17-1-2001 30-12-2001      48    76  4-5-2001 28-5-2001
## 6        23365 2002  2-1-2002 29-12-2002      74   119  8-5-2002 15-5-2002
## 7        23365 2003  1-1-2003 31-12-2003      98   183 15-5-2003 31-5-2003
##       FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT   SUMT0   SUMT5   T220
## 1 14-9-1997 14-9-1997    122    122 21.94 25-6-1997 1435.24 1325.83 672.30
## 2 27-9-1998 27-9-1998    128    127 17.61 30-6-1998  685.91  619.22 626.13
## 3 22-9-1999 21-9-1999    143    142 17.44 11-7-1999  211.79  184.14 211.79
## 5 8-10-2001 24-9-2001    157    128 16.39  1-6-2001  244.79  222.62 244.79
## 6 20-9-2002 13-9-2002    135    128 18.28 24-6-2002  497.01  458.78 497.01
## 7 28-9-2003 24-9-2003    136    132 21.22 10-7-2003 1012.14  962.52 961.97
##     T225  FT220  FT225      SPEEDT SUMPREC
## 1 620.07 666.21 642.04  0.17111105  214.65
## 2 576.61  56.45  46.17  0.10222692   49.30
## 3 184.14 211.79 184.14 -0.59448252    9.15
## 5 222.62 244.79 222.62 -0.61523731   43.93
## 6 458.78 497.01 458.78 -0.53336128   67.06
## 7 934.19  54.66  36.27 -0.01313883  147.58
##       Year         StartSG          EndSG           INTER0     
##  Min.   :1997   Min.   : 48.0   Min.   : 76.0   Min.   :104.0  
##  1st Qu.:2002   1st Qu.:105.2   1st Qu.:185.5   1st Qu.:119.2  
##  Median :2006   Median :128.5   Median :229.0   Median :124.0  
##  Mean   :2006   Mean   :118.5   Mean   :207.6   Mean   :125.9  
##  3rd Qu.:2011   3rd Qu.:136.8   3rd Qu.:248.8   3rd Qu.:133.8  
##  Max.   :2015   Max.   :152.0   Max.   :263.0   Max.   :157.0  
##      INTER5           MAXT           SUMT0            SUMT5       
##  Min.   : 99.0   Min.   :16.33   Min.   : 211.8   Min.   : 184.1  
##  1st Qu.:113.0   1st Qu.:18.07   1st Qu.:1020.1   1st Qu.: 963.3  
##  Median :118.5   Median :19.67   Median :1315.7   Median :1199.0  
##  Mean   :119.4   Mean   :19.65   Mean   :1123.2   Mean   :1038.3  
##  3rd Qu.:127.8   3rd Qu.:21.39   3rd Qu.:1411.7   3rd Qu.:1286.6  
##  Max.   :142.0   Max.   :23.00   Max.   :1652.7   Max.   :1576.9  
##       T220            T225           FT220             FT225        
##  Min.   :211.8   Min.   :184.1   Min.   :  54.66   Min.   :  36.27  
##  1st Qu.:493.9   1st Qu.:433.1   1st Qu.: 255.54   1st Qu.: 227.72  
##  Median :529.0   Median :488.4   Median : 659.75   Median : 632.70  
##  Mean   :581.2   Mean   :532.2   Mean   : 571.54   Mean   : 548.26  
##  3rd Qu.:724.6   3rd Qu.:662.1   3rd Qu.: 865.42   3rd Qu.: 839.45  
##  Max.   :962.0   Max.   :934.2   Max.   :1109.81   Max.   :1089.41  
##      SPEEDT            SUMPREC      
##  Min.   :-0.61524   Min.   :  9.15  
##  1st Qu.: 0.06199   1st Qu.:122.31  
##  Median : 0.14239   Median :172.47  
##  Mean   : 0.04513   Mean   :183.52  
##  3rd Qu.: 0.20723   3rd Qu.:262.99  
##  Max.   : 0.33005   Max.   :374.89  
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/altai/36229099999 UST'- KOKSA.txt"
## The number of del/rep rows by column precipitation= 119 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##      Day Month Year PRECIP TMEAN
## 2494  26    12 2015   0.00 -5.44
## 2495  27    12 2015   4.32 -4.44
## 2496  28    12 2015   0.25 -5.72
## 2497  29    12 2015   5.08 -5.83
## 2498  30    12 2015   0.76 -8.11
## 2499  31    12 2015   2.54 -8.56
## [1] "Structure"
## 'data.frame':	2380 obs. of  5 variables:
##  $ Day   : int  25 26 27 28 1 2 3 4 5 6 ...
##  $ Month : int  2 2 2 2 3 3 3 3 3 3 ...
##  $ Year  : int  2009 2009 2009 2009 2009 2009 2009 2009 2009 2009 ...
##  $ PRECIP: num  0 0 0 0 0 0 0 0 0 0 ...
##  $ TMEAN : num  -18.1 -16.4 -14.3 -13.3 -14.3 ...
## NULL
## [1] "Summary"
##      PRECIP           TMEAN         
##  Min.   : 0.000   Min.   :-37.1100  
##  1st Qu.: 0.000   1st Qu.: -9.7925  
##  Median : 0.000   Median :  3.8300  
##  Mean   : 1.384   Mean   :  0.5372  
##  3rd Qu.: 0.760   3rd Qu.: 12.1100  
##  Max.   :39.880   Max.   : 23.5600  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
## ****** Year: 2009 Observation: 290 Period: 25-2-2009 31-12-2009 ******
## ****** Year: 2010 Observation: 343 Period: 1-1-2010 31-12-2010 ******
## ****** Year: 2011 Observation: 350 Period: 1-1-2011 31-12-2011 ******
## ****** Year: 2012 Observation: 348 Period: 1-1-2012 31-12-2012 ******
## ****** Year: 2013 Observation: 345 Period: 1-1-2013 31-12-2013 ******
## ****** Year: 2014 Observation: 341 Period: 1-1-2014 31-12-2014 ******
## ****** Year: 2015 Observation: 363 Period: 1-1-2015 31-12-2015 ******
## 
## elapsed time is 7.420000 seconds 
## 'data.frame':	7 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  2009 2010 2011 2012 2013 2014 2015
##  $ ObsBeg      : chr  "25-2-2009" "1-1-2010" "1-1-2011" "1-1-2012" ...
##  $ ObsEnd      : chr  "31-12-2009" "31-12-2010" "31-12-2011" "31-12-2012" ...
##  $ StartSG     : num  56 104 92 107 110 111 103
##  $ EndSG       : num  218 267 274 269 259 265 269
##  $ STDAT0      : chr  "21-4-2009" "21-4-2010" "8-4-2011" "23-4-2012" ...
##  $ STDAT5      : chr  "22-4-2009" "27-4-2010" "16-4-2011" "26-4-2012" ...
##  $ FDAT0       : chr  "13-10-2009" "12-10-2010" "13-10-2011" "12-10-2012" ...
##  $ FDAT5       : chr  "10-10-2009" "5-10-2010" "7-10-2011" "10-10-2012" ...
##  $ INTER0      : num  175 174 188 172 156 161 164
##  $ INTER5      : num  172 167 180 169 150 153 159
##  $ MAXT        : num  19.4 22.2 22.8 23.6 19.2 ...
##  $ MDAT        : chr  "7-7-2009" "18-6-2010" "13-7-2011" "21-7-2012" ...
##  $ SUMT0       : num  1906 1962 2238 2319 2006 ...
##  $ SUMT5       : num  1805 1896 2147 2235 1875 ...
##  $ T220        : num  1533 831 953 1040 727 ...
##  $ T225        : num  1491 797 916 1008 669 ...
##  $ FT220       : num  353 1128 1277 1277 1154 ...
##  $ FT225       : num  308 1118 1249 1242 1141 ...
##  $ SPEEDT      : num  0.0542 0.1799 0.1359 0.213 0.1229 ...
##  $ SUMPREC     : num  438 329 279 295 428 ...
## NULL
##   Station_Code Year    ObsBeg     ObsEnd StartSG EndSG    STDAT0    STDAT5
## 1        23365 2009 25-2-2009 31-12-2009      56   218 21-4-2009 22-4-2009
## 2        23365 2010  1-1-2010 31-12-2010     104   267 21-4-2010 27-4-2010
## 3        23365 2011  1-1-2011 31-12-2011      92   274  8-4-2011 16-4-2011
## 4        23365 2012  1-1-2012 31-12-2012     107   269 23-4-2012 26-4-2012
## 5        23365 2013  1-1-2013 31-12-2013     110   259 20-4-2013 24-4-2013
## 6        23365 2014  1-1-2014 31-12-2014     111   265 29-4-2014  3-5-2014
##        FDAT0      FDAT5 INTER0 INTER5  MAXT      MDAT   SUMT0   SUMT5
## 1 13-10-2009 10-10-2009    175    172 19.44  7-7-2009 1905.61 1805.00
## 2 12-10-2010  5-10-2010    174    167 22.22 18-6-2010 1961.72 1896.23
## 3 13-10-2011  7-10-2011    188    180 22.83 13-7-2011 2237.88 2147.44
## 4 12-10-2012 10-10-2012    172    169 23.56 21-7-2012 2319.07 2235.06
## 5  23-9-2013  19-9-2013    156    150 19.22 14-7-2013 2005.91 1875.44
## 6  7-10-2014  1-10-2014    161    153 20.72 12-7-2014 2049.65 1929.67
##      T220    T225   FT220   FT225    SPEEDT SUMPREC
## 1 1532.86 1491.19  352.70  307.76 0.0541700  438.11
## 2  831.36  796.82 1128.24 1117.52 0.1798648  329.42
## 3  953.39  915.56 1277.05 1249.10 0.1359465  278.91
## 4 1040.01 1008.29 1276.55 1242.05 0.2130258  295.38
## 5  727.31  668.51 1153.93 1140.76 0.1229138  427.76
## 6  883.54  820.16 1129.08 1088.41 0.1927894  286.51
##       Year         StartSG           EndSG           INTER0     
##  Min.   :2009   Min.   : 56.00   Min.   :218.0   Min.   :156.0  
##  1st Qu.:2010   1st Qu.: 97.50   1st Qu.:262.0   1st Qu.:162.5  
##  Median :2012   Median :104.00   Median :267.0   Median :172.0  
##  Mean   :2012   Mean   : 97.57   Mean   :260.1   Mean   :170.0  
##  3rd Qu.:2014   3rd Qu.:108.50   3rd Qu.:269.0   3rd Qu.:174.5  
##  Max.   :2015   Max.   :111.00   Max.   :274.0   Max.   :188.0  
##      INTER5           MAXT           SUMT0          SUMT5     
##  Min.   :150.0   Min.   :19.22   Min.   :1906   Min.   :1805  
##  1st Qu.:156.0   1st Qu.:20.08   1st Qu.:1984   1st Qu.:1886  
##  Median :167.0   Median :22.22   Median :2050   Median :1930  
##  Mean   :164.3   Mean   :21.63   Mean   :2112   Mean   :2016  
##  3rd Qu.:170.5   3rd Qu.:23.14   3rd Qu.:2270   3rd Qu.:2185  
##  Max.   :180.0   Max.   :23.56   Max.   :2319   Max.   :2235  
##       T220             T225            FT220            FT225       
##  Min.   : 727.3   Min.   : 668.5   Min.   : 352.7   Min.   : 307.8  
##  1st Qu.: 855.1   1st Qu.: 808.5   1st Qu.:1128.7   1st Qu.:1103.0  
##  Median : 883.5   Median : 840.9   Median :1153.9   Median :1140.8  
##  Mean   : 978.2   Mean   : 934.5   Mean   :1095.3   Mean   :1068.9  
##  3rd Qu.: 996.7   3rd Qu.: 961.9   3rd Qu.:1276.8   3rd Qu.:1245.6  
##  Max.   :1532.9   Max.   :1491.2   Max.   :1349.7   Max.   :1336.9  
##      SPEEDT           SUMPREC     
##  Min.   :0.05417   Min.   :278.9  
##  1st Qu.:0.12424   1st Qu.:290.9  
##  Median :0.13595   Median :329.4  
##  Mean   :0.14633   Mean   :347.2  
##  3rd Qu.:0.18633   3rd Qu.:400.9  
##  Max.   :0.21303   Max.   :438.1  
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/altai/36231099999 ONGUDAJ.txt"
## The number of del/rep rows by column precipitation= 206 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##       Day Month Year PRECIP TMEAN
## 11106   7     5 1995   0.00  7.33
## 11107   8     5 1995   0.00 11.28
## 11108   9     5 1995   2.03 10.78
## 11109  10     5 1995  12.95 10.33
## 11110  14     5 1995   2.03  8.50
## 11111  26     5 1995   5.08 13.28
## [1] "Structure"
## 'data.frame':	10905 obs. of  5 variables:
##  $ Day   : int  26 6 13 15 20 24 1 2 9 11 ...
##  $ Month : int  1 2 2 2 2 2 3 3 3 3 ...
##  $ Year  : int  1958 1958 1958 1958 1958 1958 1958 1958 1958 1958 ...
##  $ PRECIP: num  0 1.02 0 1.27 0 0.51 0 0 0 2.03 ...
##  $ TMEAN : num  -12.06 -17.39 -8.22 -16.5 -2.06 ...
## NULL
## [1] "Summary"
##      PRECIP            TMEAN          
##  Min.   :  0.000   Min.   :-41.06000  
##  1st Qu.:  0.000   1st Qu.:-11.17000  
##  Median :  0.000   Median :  2.44000  
##  Mean   :  1.515   Mean   : -0.00222  
##  3rd Qu.:  0.000   3rd Qu.: 12.17000  
##  Max.   :299.720   Max.   : 28.11000  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
## ****** Year: 1958 
## #################### Skip a year!!!! 
## ****** Year: 1959 Observation: 77 Period: 3-1-1959 31-12-1959 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1960 Observation: 138 Period: 1-1-1960 31-12-1960 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1961 Observation: 238 Period: 1-1-1961 30-12-1961 ******
## ****** Year: 1962 Observation: 199 Period: 6-1-1962 31-12-1962 ******
## ****** Year: 1963 Observation: 107 Period: 1-1-1963 14-12-1963 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1964 Observation: 251 Period: 22-1-1964 31-12-1964 ******
## ****** Year: 1965 Observation: 300 Period: 2-1-1965 31-12-1965 ******
## ****** Year: 1966 Observation: 364 Period: 1-1-1966 31-12-1966 ******
## ****** Year: 1967 Observation: 364 Period: 1-1-1967 31-12-1967 ******
## ****** Year: 1968 Observation: 362 Period: 1-1-1968 31-12-1968 ******
## ****** Year: 1969 Observation: 361 Period: 1-1-1969 31-12-1969 ******
## ****** Year: 1970 Observation: 364 Period: 1-1-1970 31-12-1970 ******
## ****** Year: 1971 Observation: 181 Period: 1-1-1971 30-6-1971 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1972
```

```
## ****** Year: 1972 
## #################### Skip a year!!!! 
## ****** Year: 1973 Observation: 356 Period: 1-1-1973 31-12-1973 ******
## ****** Year: 1974 Observation: 362 Period: 1-1-1974 31-12-1974 ******
## ****** Year: 1975 Observation: 359 Period: 1-1-1975 31-12-1975 ******
## ****** Year: 1976 Observation: 349 Period: 1-1-1976 31-12-1976 ******
## ****** Year: 1977 Observation: 346 Period: 1-1-1977 31-12-1977 ******
## ****** Year: 1978 Observation: 352 Period: 1-1-1978 31-12-1978 ******
## ****** Year: 1979 Observation: 336 Period: 1-1-1979 30-12-1979 ******
## ****** Year: 1980 Observation: 342 Period: 1-1-1980 31-12-1980 ******
## ****** Year: 1981 Observation: 358 Period: 1-1-1981 31-12-1981 ******
## ****** Year: 1982 Observation: 356 Period: 1-1-1982 31-12-1982 ******
## ****** Year: 1983 Observation: 348 Period: 1-1-1983 31-12-1983 ******
## ****** Year: 1984 Observation: 350 Period: 1-1-1984 31-12-1984 ******
## ****** Year: 1985 Observation: 360 Period: 1-1-1985 31-12-1985 ******
## ****** Year: 1986 Observation: 359 Period: 1-1-1986 31-12-1986 ******
## ****** Year: 1987 Observation: 362 Period: 1-1-1987 31-12-1987 ******
## ****** Year: 1988 Observation: 364 Period: 1-1-1988 31-12-1988 ******
## ****** Year: 1989 Observation: 362 Period: 1-1-1989 31-12-1989 ******
## ****** Year: 1990 Observation: 364 Period: 1-1-1990 31-12-1990 ******
## ****** Year: 1991 Observation: 227 Period: 1-1-1991 31-12-1991 ******
## ****** Year: 1992 Observation: 186 Period: 2-1-1992 31-12-1992 ******
## ****** Year: 1993 Observation: 347 Period: 1-1-1993 30-12-1993 ******
## ****** Year: 1994 Observation: 337 Period: 1-1-1994 31-12-1994 ******
## ****** Year: 1995 
## #################### Skip a year!!!! 
## 
## elapsed time is 23.710000 seconds 
## 'data.frame':	35 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1959 1960 1961 1962 1963 1964 1965 1966 1967 1968 ...
##  $ ObsBeg      : chr  "3-1-1959" "1-1-1960" "1-1-1961" "6-1-1962" ...
##  $ ObsEnd      : chr  "31-12-1959" "31-12-1960" "30-12-1961" "31-12-1962" ...
##  $ StartSG     : num  22 60 84 60 80 46 73 117 104 119 ...
##  $ EndSG       : num  53 111 182 154 106 183 220 284 284 262 ...
##  $ STDAT0      : chr  "29-3-1959" "19-4-1960" "15-5-1961" "27-4-1962" ...
##  $ STDAT5      : chr  "11-5-1959" "23-5-1960" "26-5-1961" "10-5-1962" ...
##  $ FDAT0       : chr  "26-10-1959" "15-10-1960" "30-9-1961" "5-10-1962" ...
##  $ FDAT5       : chr  "3-10-1959" "9-10-1960" "29-9-1961" "28-9-1962" ...
##  $ INTER0      : num  211 179 138 161 185 152 170 168 180 143 ...
##  $ INTER5      : num  145 173 137 154 185 149 161 162 171 141 ...
##  $ MAXT        : num  18.5 17.9 19.6 20.6 21.2 ...
##  $ MDAT        : chr  "8-9-1959" "11-8-1960" "6-7-1961" "30-7-1962" ...
##  $ SUMT0       : num  280 571 1269 1256 278 ...
##  $ SUMT5       : num  269 547 1167 1211 256 ...
##  $ T220        : num  280 571 1199 1256 278 ...
##  $ T225        : num  269 547 1123 1211 256 ...
##  $ FT220       : num  280.3 571.1 50.7 40.8 278.4 ...
##  $ FT225       : num  268.8 546.9 34.8 23.9 255.7 ...
##  $ SPEEDT      : num  -0.80835 -0.43245 0.00213 -0.17047 -0.58767 ...
##  $ SUMPREC     : num  92.7 169.2 631.4 553 22.1 ...
## NULL
##   Station_Code Year    ObsBeg     ObsEnd StartSG EndSG    STDAT0    STDAT5
## 2        23365 1959  3-1-1959 31-12-1959      22    53 29-3-1959 11-5-1959
## 3        23365 1960  1-1-1960 31-12-1960      60   111 19-4-1960 23-5-1960
## 4        23365 1961  1-1-1961 30-12-1961      84   182 15-5-1961 26-5-1961
## 5        23365 1962  6-1-1962 31-12-1962      60   154 27-4-1962 10-5-1962
## 6        23365 1963  1-1-1963 14-12-1963      80   106 30-4-1963 13-5-1963
## 7        23365 1964 22-1-1964 31-12-1964      46   183  1-5-1964  3-5-1964
##        FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT   SUMT0   SUMT5
## 2 26-10-1959 3-10-1959    211    145 18.50  8-9-1959  280.26  268.76
## 3 15-10-1960 9-10-1960    179    173 17.94 11-8-1960  571.14  546.87
## 4  30-9-1961 29-9-1961    138    137 19.56  6-7-1961 1268.95 1166.70
## 5  5-10-1962 28-9-1962    161    154 20.56 30-7-1962 1255.96 1211.29
## 6  1-11-1963 1-11-1963    185    185 21.22 23-6-1963  278.39  255.67
## 7  30-9-1964 28-9-1964    152    149 21.67 28-6-1964 1751.59 1683.28
##      T220    T225  FT220  FT225       SPEEDT SUMPREC
## 2  280.26  268.76 280.26 268.76 -0.808350991   92.73
## 3  571.14  546.87 571.14 546.87 -0.432454722  169.18
## 4 1199.06 1123.14  50.73  34.78  0.002129043  631.44
## 5 1255.96 1211.29  40.77  23.89 -0.170471172  552.97
## 6  278.39  255.67 278.39 255.67 -0.587668309   22.10
## 7 1672.59 1627.24  52.61  42.94  0.010549207  621.03
##       Year         StartSG           EndSG           INTER0     
##  Min.   :1959   Min.   :  7.00   Min.   : 53.0   Min.   : 66.0  
##  1st Qu.:1968   1st Qu.: 93.00   1st Qu.:207.5   1st Qu.:155.0  
##  Median :1977   Median :110.00   Median :267.0   Median :168.0  
##  Mean   :1977   Mean   : 99.31   Mean   :238.3   Mean   :163.7  
##  3rd Qu.:1986   3rd Qu.:115.00   3rd Qu.:280.5   3rd Qu.:175.5  
##  Max.   :1994   Max.   :135.00   Max.   :289.0   Max.   :211.0  
##      INTER5         MAXT           SUMT0            SUMT5       
##  Min.   : 66   Min.   :17.94   Min.   : 278.4   Min.   : 255.7  
##  1st Qu.:148   1st Qu.:21.16   1st Qu.:1854.0   1st Qu.:1768.2  
##  Median :162   Median :21.83   Median :2122.4   Median :2017.7  
##  Mean   :158   Mean   :22.32   Mean   :1869.3   Mean   :1784.4  
##  3rd Qu.:169   3rd Qu.:23.14   3rd Qu.:2213.2   3rd Qu.:2148.1  
##  Max.   :196   Max.   :28.11   Max.   :2415.0   Max.   :2334.5  
##       T220             T225            FT220             FT225        
##  Min.   : 278.4   Min.   : 255.7   Min.   :  40.77   Min.   :  23.89  
##  1st Qu.: 757.2   1st Qu.: 709.9   1st Qu.: 496.38   1st Qu.: 470.44  
##  Median : 861.4   Median : 810.2   Median :1270.48   Median :1224.38  
##  Mean   : 885.0   Mean   : 839.6   Mean   : 997.93   Mean   : 973.92  
##  3rd Qu.: 940.5   3rd Qu.: 882.2   3rd Qu.:1365.22   3rd Qu.:1336.47  
##  Max.   :1672.6   Max.   :1627.2   Max.   :1522.46   Max.   :1514.02  
##      SPEEDT            SUMPREC     
##  Min.   :-0.80835   Min.   : 22.1  
##  1st Qu.: 0.08591   1st Qu.:181.4  
##  Median : 0.15262   Median :255.2  
##  Mean   : 0.06335   Mean   :324.2  
##  3rd Qu.: 0.17405   3rd Qu.:438.9  
##  Max.   : 0.22591   Max.   :824.5  
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/altai/36246099999 UST-ULAGAN.txt"
## The number of del/rep rows by column precipitation= 164 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##      Day Month Year PRECIP  TMEAN
## 6210  26    12 1988      0 -19.61
## 6211  27    12 1988      0 -24.83
## 6212  28    12 1988      0 -30.22
## 6213  29    12 1988      0 -23.89
## 6214  30    12 1988      0 -22.06
## 6215  31    12 1988      0 -23.56
## [1] "Structure"
## 'data.frame':	6051 obs. of  5 variables:
##  $ Day   : int  8 9 10 11 12 13 14 15 16 17 ...
##  $ Month : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Year  : int  1969 1969 1969 1969 1969 1969 1969 1969 1969 1969 ...
##  $ PRECIP: num  7.11 0 0 0 7.87 0 0 0 0 0 ...
##  $ TMEAN : num  -22.6 -33.2 -24.3 -20 -30.7 ...
## NULL
## [1] "Summary"
##      PRECIP            TMEAN        
##  Min.   :  0.000   Min.   :-42.500  
##  1st Qu.:  0.000   1st Qu.:-15.940  
##  Median :  0.000   Median : -1.110  
##  Mean   :  1.683   Mean   : -3.531  
##  3rd Qu.:  0.000   3rd Qu.:  9.560  
##  Max.   :150.110   Max.   : 26.500  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
## ****** Year: 1969 Observation: 338 Period: 8-1-1969 31-12-1969 ******
## ****** Year: 1970 Observation: 358 Period: 1-1-1970 31-12-1970 ******
## ****** Year: 1971 Observation: 175 Period: 1-1-1971 30-6-1971 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1972
```

```
## ****** Year: 1972 
## #################### Skip a year!!!! 
## ****** Year: 1973 Observation: 323 Period: 1-1-1973 31-12-1973 ******
## ****** Year: 1974 Observation: 336 Period: 1-1-1974 31-12-1974 ******
## ****** Year: 1975 Observation: 362 Period: 1-1-1975 31-12-1975 ******
## ****** Year: 1976 Observation: 338 Period: 1-1-1976 31-12-1976 ******
## ****** Year: 1977 Observation: 326 Period: 1-1-1977 31-12-1977 ******
## ****** Year: 1978 Observation: 335 Period: 1-1-1978 31-12-1978 ******
## ****** Year: 1979 Observation: 325 Period: 1-1-1979 31-12-1979 ******
## ****** Year: 1980 Observation: 338 Period: 2-1-1980 31-12-1980 ******
## ****** Year: 1981 Observation: 335 Period: 1-1-1981 31-12-1981 ******
## ****** Year: 1982 Observation: 284 Period: 3-1-1982 31-12-1982 ******
## ****** Year: 1983 Observation: 318 Period: 1-1-1983 31-12-1983 ******
## ****** Year: 1984 Observation: 261 Period: 1-1-1984 31-12-1984 ******
## ****** Year: 1985 Observation: 315 Period: 1-1-1985 31-12-1985 ******
## ****** Year: 1986 Observation: 296 Period: 1-1-1986 31-12-1986 ******
## ****** Year: 1987 Observation: 339 Period: 1-1-1987 31-12-1987 ******
## ****** Year: 1988 Observation: 349 Period: 1-1-1988 31-12-1988 ******
## 
## elapsed time is 17.280000 seconds 
## 'data.frame':	19 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1969 1970 1971 1973 1974 1975 1976 1977 1978 1979 ...
##  $ ObsBeg      : chr  "8-1-1969" "1-1-1970" "1-1-1971" "1-1-1973" ...
##  $ ObsEnd      : chr  "31-12-1969" "31-12-1970" "30-6-1971" "31-12-1973" ...
##  $ StartSG     : num  121 128 135 113 126 141 109 123 133 129 ...
##  $ EndSG       : num  242 273 175 234 237 267 255 248 250 257 ...
##  $ STDAT0      : chr  "13-5-1969" "9-5-1970" "16-5-1971" "20-5-1973" ...
##  $ STDAT5      : chr  "16-5-1969" "18-5-1970" "17-5-1971" "20-5-1973" ...
##  $ FDAT0       : chr  "22-9-1969" "4-10-1970" "30-6-1971" "28-9-1973" ...
##  $ FDAT5       : chr  "17-9-1969" "2-10-1970" "30-6-1971" "27-9-1973" ...
##  $ INTER0      : num  132 148 45 131 131 127 163 148 139 148 ...
##  $ INTER5      : num  124 144 45 130 129 127 163 146 136 148 ...
##  $ MAXT        : num  19.4 24.2 23.1 19.8 21.8 ...
##  $ MDAT        : chr  "10-7-1969" "17-7-1970" "24-6-1971" "19-6-1973" ...
##  $ SUMT0       : num  1488 1659 655 1479 1514 ...
##  $ SUMT5       : num  1383 1558 589 1417 1404 ...
##  $ T220        : num  731 587 608 862 720 ...
##  $ T225        : num  674 538 542 818 644 ...
##  $ FT220       : num  744.4 1074.3 61.8 616.6 767.1 ...
##  $ FT225       : num  717.6 1035.9 61.8 608.5 756 ...
##  $ SPEEDT      : num  0.2164 0.2103 0.2771 0.0894 0.1873 ...
##  $ SUMPREC     : num  901.5 1619.5 258.1 238 96.3 ...
## NULL
##   Station_Code Year   ObsBeg     ObsEnd StartSG EndSG    STDAT0    STDAT5
## 1        23365 1969 8-1-1969 31-12-1969     121   242 13-5-1969 16-5-1969
## 2        23365 1970 1-1-1970 31-12-1970     128   273  9-5-1970 18-5-1970
## 3        23365 1971 1-1-1971  30-6-1971     135   175 16-5-1971 17-5-1971
## 5        23365 1973 1-1-1973 31-12-1973     113   234 20-5-1973 20-5-1973
## 6        23365 1974 1-1-1974 31-12-1974     126   237 12-5-1974 14-5-1974
## 7        23365 1975 1-1-1975 31-12-1975     141   267 21-5-1975 27-5-1975
##       FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT   SUMT0   SUMT5   T220
## 1 22-9-1969 17-9-1969    132    124 19.39 10-7-1969 1488.15 1382.99 731.29
## 2 4-10-1970 2-10-1970    148    144 24.17 17-7-1970 1659.13 1558.16 587.24
## 3 30-6-1971 30-6-1971     45     45 23.11 24-6-1971  654.94  589.49 607.77
## 5 28-9-1973 27-9-1973    131    130 19.83 19-6-1973 1478.61 1417.48 862.37
## 6 20-9-1974 20-9-1974    131    129 21.83  6-7-1974 1514.24 1403.67 720.43
## 7 25-9-1975 25-9-1975    127    127 18.50  2-7-1975 1533.48 1411.00 437.51
##     T225   FT220   FT225     SPEEDT SUMPREC
## 1 673.85  744.36  717.64 0.21642662  901.47
## 2 538.48 1074.33 1035.90 0.21027404 1619.49
## 3 542.32   61.78   61.78 0.27710143  258.08
## 5 818.42  616.57  608.51 0.08941567  238.02
## 6 643.86  767.10  755.98 0.18728030   96.28
## 7 381.85 1058.71 1026.43 0.24503116  155.71
##       Year         StartSG          EndSG           INTER0     
##  Min.   :1969   Min.   : 93.0   Min.   :175.0   Min.   : 45.0  
##  1st Qu.:1974   1st Qu.:114.0   1st Qu.:230.5   1st Qu.:131.5  
##  Median :1979   Median :121.0   Median :248.0   Median :148.0  
##  Mean   :1979   Mean   :120.2   Mean   :240.4   Mean   :141.1  
##  3rd Qu.:1984   3rd Qu.:127.0   3rd Qu.:254.0   3rd Qu.:152.0  
##  Max.   :1988   Max.   :141.0   Max.   :273.0   Max.   :170.0  
##      INTER5           MAXT           SUMT0            SUMT5       
##  Min.   : 45.0   Min.   :17.83   Min.   : 654.9   Min.   : 589.5  
##  1st Qu.:129.5   1st Qu.:19.75   1st Qu.:1460.6   1st Qu.:1346.0  
##  Median :143.0   Median :21.17   Median :1536.7   Median :1436.5  
##  Mean   :137.9   Mean   :21.55   Mean   :1474.0   Mean   :1387.3  
##  3rd Qu.:148.5   3rd Qu.:23.11   3rd Qu.:1621.8   3rd Qu.:1534.7  
##  Max.   :168.0   Max.   :26.50   Max.   :1752.2   Max.   :1671.1  
##       T220             T225            FT220             FT225        
##  Min.   : 437.5   Min.   : 381.9   Min.   :  61.78   Min.   :  61.78  
##  1st Qu.: 634.5   1st Qu.: 570.3   1st Qu.: 587.81   1st Qu.: 575.53  
##  Median : 710.2   Median : 657.2   Median : 814.88   Median : 788.32  
##  Mean   : 721.9   Mean   : 674.3   Mean   : 735.81   Mean   : 712.41  
##  3rd Qu.: 783.5   3rd Qu.: 748.7   3rd Qu.: 897.06   3rd Qu.: 868.71  
##  Max.   :1055.5   Max.   :1024.4   Max.   :1074.33   Max.   :1035.90  
##      SPEEDT           SUMPREC       
##  Min.   :0.08942   Min.   :  92.22  
##  1st Qu.:0.12320   1st Qu.: 157.76  
##  Median :0.14309   Median : 186.47  
##  Mean   :0.16516   Mean   : 332.54  
##  3rd Qu.:0.21335   3rd Qu.: 290.56  
##  Max.   :0.27710   Max.   :1619.49  
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/lena/24051099999 SIKTJAH.txt"
## The number of del/rep rows by column precipitation= 86 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##      Day Month Year PRECIP  TMEAN
## 6552  22    12 1990   1.02 -42.78
## 6553  25    12 1990   0.25 -46.44
## 6554  27    12 1990   0.00 -45.72
## 6555  28    12 1990   0.00 -46.06
## 6556  29    12 1990   0.25 -41.50
## 6557  30    12 1990   1.02 -42.33
## [1] "Structure"
## 'data.frame':	6471 obs. of  5 variables:
##  $ Day   : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ Month : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Year  : int  1969 1969 1969 1969 1969 1969 1969 1969 1969 1969 ...
##  $ PRECIP: num  0.25 0 0 0 0.25 1.27 0.76 0.25 0 0 ...
##  $ TMEAN : num  -27.8 -28.5 -33.7 -38.1 -33 ...
## NULL
## [1] "Summary"
##      PRECIP             TMEAN       
##  Min.   :  0.0000   Min.   :-57.33  
##  1st Qu.:  0.0000   1st Qu.:-30.22  
##  Median :  0.0000   Median :-12.56  
##  Mean   :  0.9301   Mean   :-13.17  
##  3rd Qu.:  0.5100   3rd Qu.:  4.56  
##  Max.   :150.1100   Max.   : 26.33  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
## ****** Year: 1969 Observation: 335 Period: 1-1-1969 31-12-1969 ******
## ****** Year: 1970 Observation: 340 Period: 2-1-1970 31-12-1970 ******
## ****** Year: 1971 Observation: 152 Period: 1-1-1971 30-6-1971 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1972
```

```
## ****** Year: 1972 
## #################### Skip a year!!!! 
## ****** Year: 1973 Observation: 346 Period: 1-1-1973 31-12-1973 ******
## ****** Year: 1974 Observation: 321 Period: 1-1-1974 31-12-1974 ******
## ****** Year: 1975 Observation: 331 Period: 1-1-1975 31-12-1975 ******
## ****** Year: 1976 Observation: 324 Period: 1-1-1976 31-12-1976 ******
## ****** Year: 1977 Observation: 237 Period: 3-1-1977 30-12-1977 ******
## ****** Year: 1978 Observation: 316 Period: 4-1-1978 30-12-1978 ******
## ****** Year: 1979 Observation: 346 Period: 1-1-1979 31-12-1979 ******
## ****** Year: 1980 Observation: 304 Period: 1-1-1980 31-12-1980 ******
## ****** Year: 1981 Observation: 277 Period: 1-1-1981 31-12-1981 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1982
```

```
## ****** Year: 1982 
## #################### Skip a year!!!! 
## ****** Year: 1983 Observation: 281 Period: 2-1-1983 31-12-1983 ******
## ****** Year: 1984 Observation: 358 Period: 1-1-1984 31-12-1984 ******
## ****** Year: 1985 Observation: 363 Period: 1-1-1985 31-12-1985 ******
## ****** Year: 1986 Observation: 363 Period: 1-1-1986 31-12-1986 ******
## ****** Year: 1987 Observation: 361 Period: 1-1-1987 31-12-1987 ******
## ****** Year: 1988 Observation: 363 Period: 1-1-1988 31-12-1988 ******
## ****** Year: 1989 Observation: 364 Period: 1-1-1989 31-12-1989 ******
## ****** Year: 1990 Observation: 351 Period: 1-1-1990 30-12-1990 ******
## 
## elapsed time is 22.530000 seconds 
## 'data.frame':	20 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1969 1970 1971 1973 1974 1975 1976 1977 1978 1979 ...
##  $ ObsBeg      : chr  "1-1-1969" "2-1-1970" "1-1-1971" "1-1-1973" ...
##  $ ObsEnd      : chr  "31-12-1969" "31-12-1970" "30-6-1971" "31-12-1973" ...
##  $ StartSG     : num  124 145 130 147 145 139 163 108 122 152 ...
##  $ EndSG       : num  223 240 152 257 225 233 249 178 203 230 ...
##  $ STDAT0      : chr  "25-5-1969" "4-6-1970" "1-6-1971" "2-6-1973" ...
##  $ STDAT5      : chr  "1-6-1969" "9-6-1970" "13-6-1971" "9-6-1973" ...
##  $ FDAT0       : chr  "6-9-1969" "16-9-1970" "30-6-1971" "22-9-1973" ...
##  $ FDAT5       : chr  "1-9-1969" "16-9-1970" "30-6-1971" "19-9-1973" ...
##  $ INTER0      : num  104 104 29 112 94 97 98 97 98 86 ...
##  $ INTER5      : num  96 101 28 106 85 95 91 95 85 81 ...
##  $ MAXT        : num  23.8 24.1 16.8 25.3 20.3 ...
##  $ MDAT        : chr  "29-7-1969" "7-7-1970" "13-6-1971" "18-7-1973" ...
##  $ SUMT0       : num  1213 1040 210 1295 936 ...
##  $ SUMT5       : num  1162 962 182 1204 864 ...
##  $ T220        : num  564 302 210 316 387 ...
##  $ T225        : num  538 282 182 263 345 ...
##  $ FT220       : num  642 738 210 988 548 ...
##  $ FT225       : num  632 690 182 950 529 ...
##  $ SPEEDT      : num  0.1338 0.2483 0.0541 0.0882 0.3118 ...
##  $ SUMPREC     : num  457.7 280.2 55.4 180.6 128 ...
## NULL
##   Station_Code Year   ObsBeg     ObsEnd StartSG EndSG    STDAT0    STDAT5
## 1        23365 1969 1-1-1969 31-12-1969     124   223 25-5-1969  1-6-1969
## 2        23365 1970 2-1-1970 31-12-1970     145   240  4-6-1970  9-6-1970
## 3        23365 1971 1-1-1971  30-6-1971     130   152  1-6-1971 13-6-1971
## 5        23365 1973 1-1-1973 31-12-1973     147   257  2-6-1973  9-6-1973
## 6        23365 1974 1-1-1974 31-12-1974     145   225 13-6-1974 21-6-1974
## 7        23365 1975 1-1-1975 31-12-1975     139   233 30-5-1975  2-6-1975
##       FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT   SUMT0   SUMT5   T220
## 1  6-9-1969  1-9-1969    104     96 23.78 29-7-1969 1212.57 1162.08 564.40
## 2 16-9-1970 16-9-1970    104    101 24.06  7-7-1970 1039.91  962.22 302.02
## 3 30-6-1971 30-6-1971     29     28 16.78 13-6-1971  209.75  182.16 209.75
## 5 22-9-1973 19-9-1973    112    106 25.28 18-7-1973 1294.96 1203.61 316.39
## 6 15-9-1974 12-9-1974     94     85 20.33 30-6-1974  936.11  863.62 386.95
## 7  4-9-1975  4-9-1975     97     95 21.61 27-6-1975 1207.72 1115.12 540.41
##     T225  FT220  FT225     SPEEDT SUMPREC
## 1 537.68 642.22 632.17 0.13379184  457.70
## 2 281.95 737.89 690.49 0.24829776  280.19
## 3 182.16 209.75 182.16 0.05412055   55.37
## 5 262.89 987.79 950.22 0.08815385  180.61
## 6 345.00 547.78 529.23 0.31181171  127.99
## 7 506.65 633.42 586.97 0.33340107   93.97
##       Year         StartSG          EndSG           INTER0      
##  Min.   :1969   Min.   : 93.0   Min.   :152.0   Min.   : 29.00  
##  1st Qu.:1975   1st Qu.:128.5   1st Qu.:217.2   1st Qu.: 93.25  
##  Median :1980   Median :147.0   Median :236.5   Median : 98.00  
##  Mean   :1980   Mean   :141.9   Mean   :227.4   Mean   : 94.55  
##  3rd Qu.:1985   3rd Qu.:154.5   3rd Qu.:252.2   3rd Qu.:102.50  
##  Max.   :1990   Max.   :168.0   Max.   :257.0   Max.   :112.00  
##      INTER5            MAXT           SUMT0            SUMT5       
##  Min.   : 28.00   Min.   :16.78   Min.   : 209.8   Min.   : 182.2  
##  1st Qu.: 85.75   1st Qu.:20.38   1st Qu.: 908.7   1st Qu.: 820.8  
##  Median : 94.00   Median :23.45   Median : 981.6   Median : 902.7  
##  Mean   : 89.80   Mean   :22.54   Mean   : 978.9   Mean   : 899.2  
##  3rd Qu.: 96.50   3rd Qu.:24.90   3rd Qu.:1123.0   3rd Qu.:1022.8  
##  Max.   :106.00   Max.   :26.33   Max.   :1295.0   Max.   :1214.6  
##       T220            T225            FT220            FT225      
##  Min.   :110.2   Min.   : 75.89   Min.   : 19.71   Min.   :  6.5  
##  1st Qu.:208.8   1st Qu.:176.24   1st Qu.:491.57   1st Qu.:467.7  
##  Median :325.6   Median :295.00   Median :651.03   Median :624.3  
##  Mean   :376.8   Mean   :340.73   Mean   :600.53   Mean   :569.0  
##  3rd Qu.:542.9   3rd Qu.:509.50   3rd Qu.:786.04   3rd Qu.:747.8  
##  Max.   :877.7   Max.   :841.36   Max.   :987.79   Max.   :950.2  
##      SPEEDT            SUMPREC      
##  Min.   :-0.26200   Min.   : 37.35  
##  1st Qu.: 0.04256   1st Qu.: 61.09  
##  Median : 0.20582   Median : 88.89  
##  Mean   : 0.29878   Mean   :123.33  
##  3rd Qu.: 0.34461   3rd Qu.:141.69  
##  Max.   : 1.56591   Max.   :457.70  
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/lena/24261099999 BATAGAJ-ALYTA.txt"
## The number of del/rep rows by column precipitation= 98 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##      Day Month Year PRECIP  TMEAN
## 2004  26    12 2015   0.25 -35.50
## 2005  27    12 2015   0.00 -33.78
## 2006  28    12 2015   0.00 -36.06
## 2007  29    12 2015   0.00 -33.83
## 2008  30    12 2015   0.25 -27.11
## 2009  31    12 2015   0.25 -31.39
## [1] "Structure"
## 'data.frame':	1911 obs. of  5 variables:
##  $ Day   : int  3 5 7 9 11 19 21 22 28 29 ...
##  $ Month : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Year  : int  1959 1959 1959 1959 1959 1959 1959 1959 1959 1959 ...
##  $ PRECIP: num  0 1.52 0.25 0 0 0.25 0.51 0 0 0 ...
##  $ TMEAN : num  -34.3 -33.1 -34.4 -46.1 -42.8 ...
## NULL
## [1] "Summary"
##      PRECIP            TMEAN       
##  Min.   :  0.000   Min.   :-53.06  
##  1st Qu.:  0.000   1st Qu.:-32.61  
##  Median :  0.000   Median :-14.00  
##  Mean   :  1.056   Mean   :-14.10  
##  3rd Qu.:  0.000   3rd Qu.:  4.33  
##  Max.   :150.110   Max.   : 22.94  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1959
```

```
## ****** Year: 1959 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1960
```

```
## ****** Year: 1960 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1961
```

```
## ****** Year: 1961 
## #################### Skip a year!!!! 
## ****** Year: 1962 Observation: 314 Period: 1-1-1962 31-12-1962 ******
## ****** Year: 1963 Observation: 262 Period: 1-1-1963 27-12-1963 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1964
```

```
## ****** Year: 1964 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1965
```

```
## ****** Year: 1965 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1966
```

```
## ****** Year: 1966 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1967
```

```
## ****** Year: 1967 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1968
```

```
## ****** Year: 1968 
## #################### Skip a year!!!! 
## ****** Year: 1969 Observation: 85 Period: 4-3-1969 29-12-1969 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1970
```

```
## ****** Year: 1970 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1971
```

```
## ****** Year: 1971 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1972
```

```
## ****** Year: 1972 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1973
```

```
## ****** Year: 1973 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1974
```

```
## ****** Year: 1974 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1975
```

```
## ****** Year: 1975 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1976
```

```
## ****** Year: 1976 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1977
```

```
## ****** Year: 1977 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1978
```

```
## ****** Year: 1978 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1979
```

```
## ****** Year: 1979 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1980
```

```
## ****** Year: 1980 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1981
```

```
## ****** Year: 1981 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1982
```

```
## ****** Year: 1982 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1983
```

```
## ****** Year: 1983 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1984
```

```
## ****** Year: 1984 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1985
```

```
## ****** Year: 1985 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1986
```

```
## ****** Year: 1986 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1987
```

```
## ****** Year: 1987 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1988
```

```
## ****** Year: 1988 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1989
```

```
## ****** Year: 1989 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1990
```

```
## ****** Year: 1990 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1991
```

```
## ****** Year: 1991 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1992
```

```
## ****** Year: 1992 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1993
```

```
## ****** Year: 1993 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1994
```

```
## ****** Year: 1994 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1995
```

```
## ****** Year: 1995 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1996
```

```
## ****** Year: 1996 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1997
```

```
## ****** Year: 1997 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1998
```

```
## ****** Year: 1998 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1999
```

```
## ****** Year: 1999 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2000
```

```
## ****** Year: 2000 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2001
```

```
## ****** Year: 2001 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2002
```

```
## ****** Year: 2002 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2003
```

```
## ****** Year: 2003 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2004
```

```
## ****** Year: 2004 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2005
```

```
## ****** Year: 2005 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2006
```

```
## ****** Year: 2006 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2007
```

```
## ****** Year: 2007 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2008
```

```
## ****** Year: 2008 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2009
```

```
## ****** Year: 2009 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2010
```

```
## ****** Year: 2010 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2011
```

```
## ****** Year: 2011 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2012
```

```
## ****** Year: 2012 
## #################### Skip a year!!!! 
## ****** Year: 2013 Observation: 340 Period: 1-1-2013 31-12-2013 ******
## ****** Year: 2014 Observation: 327 Period: 1-1-2014 31-12-2014 ******
## ****** Year: 2015 Observation: 363 Period: 1-1-2015 31-12-2015 ******
## 
## elapsed time is 7.020000 seconds 
## 'data.frame':	6 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1962 1963 1969 2013 2014 2015
##  $ ObsBeg      : chr  "1-1-1962" "1-1-1963" "4-3-1969" "1-1-2013" ...
##  $ ObsEnd      : chr  "31-12-1962" "27-12-1963" "29-12-1969" "31-12-2013" ...
##  $ StartSG     : num  123 138 14 139 134 146
##  $ EndSG       : num  144 207 51 242 225 261
##  $ STDAT0      : chr  "26-5-1962" "16-6-1963" "24-5-1969" "24-5-2013" ...
##  $ STDAT5      : chr  "31-5-1962" "19-6-1963" "12-6-1969" "28-5-2013" ...
##  $ FDAT0       : chr  "15-6-1962" "9-9-1963" "16-9-1969" "11-9-2013" ...
##  $ FDAT5       : chr  "14-6-1962" "2-9-1963" "19-8-1969" "3-9-2013" ...
##  $ INTER0      : num  20 85 115 110 103 116
##  $ INTER5      : num  17 76 87 102 98 110
##  $ MAXT        : num  18.6 22.9 20.4 20.9 21.6 ...
##  $ MDAT        : chr  "5-8-1962" "22-7-1963" "6-8-1969" "18-6-2013" ...
##  $ SUMT0       : num  848 798 365 1059 1112 ...
##  $ SUMT5       : num  774 714 354 983 1043 ...
##  $ T220        : num  407 436 365 394 507 ...
##  $ T225        : num  358 401 354 360 476 ...
##  $ FT220       : num  252 345 365 663 597 ...
##  $ FT225       : num  225 312 354 623 572 ...
##  $ SPEEDT      : num  0.0824 0.2516 -0.9067 0.1542 0.1431 ...
##  $ SUMPREC     : num  19.3 120.7 111.3 123.7 122.7 ...
## NULL
##    Station_Code Year   ObsBeg     ObsEnd StartSG EndSG    STDAT0    STDAT5
## 4         23365 1962 1-1-1962 31-12-1962     123   144 26-5-1962 31-5-1962
## 5         23365 1963 1-1-1963 27-12-1963     138   207 16-6-1963 19-6-1963
## 11        23365 1969 4-3-1969 29-12-1969      14    51 24-5-1969 12-6-1969
## 55        23365 2013 1-1-2013 31-12-2013     139   242 24-5-2013 28-5-2013
## 56        23365 2014 1-1-2014 31-12-2014     134   225 29-5-2014  5-6-2014
## 57        23365 2015 1-1-2015 31-12-2015     146   261 26-5-2015  1-6-2015
##        FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT   SUMT0   SUMT5
## 4  15-6-1962 14-6-1962     20     17 18.56  5-8-1962  847.52  773.63
## 5   9-9-1963  2-9-1963     85     76 22.94 22-7-1963  798.04  714.37
## 11 16-9-1969 19-8-1969    115     87 20.44  6-8-1969  365.21  354.50
## 55 11-9-2013  3-9-2013    110    102 20.94 18-6-2013 1058.74  982.62
## 56  9-9-2014  4-9-2014    103     98 21.56 11-6-2014 1112.49 1042.72
## 57 19-9-2015 13-9-2015    116    110 22.17 12-7-2015 1206.06 1100.97
##      T220   T225  FT220  FT225      SPEEDT SUMPREC
## 4  406.86 358.13 252.33 224.83  0.08235054   19.31
## 5  436.06 401.49 344.99 312.27  0.25158824  120.65
## 11 365.21 354.50 365.21 354.50 -0.90673532  111.26
## 55 394.39 359.51 662.85 623.11  0.15421238  123.69
## 56 507.05 475.60 596.50 572.29  0.14310526  122.68
## 57 286.11 238.45 926.78 872.24  0.13968254   42.93
##       Year         StartSG          EndSG           INTER0     
##  Min.   :1962   Min.   : 14.0   Min.   : 51.0   Min.   : 20.0  
##  1st Qu.:1964   1st Qu.:125.8   1st Qu.:159.8   1st Qu.: 89.5  
##  Median :1991   Median :136.0   Median :216.0   Median :106.5  
##  Mean   :1989   Mean   :115.7   Mean   :188.3   Mean   : 91.5  
##  3rd Qu.:2014   3rd Qu.:138.8   3rd Qu.:237.8   3rd Qu.:113.8  
##  Max.   :2015   Max.   :146.0   Max.   :261.0   Max.   :116.0  
##      INTER5            MAXT           SUMT0            SUMT5       
##  Min.   : 17.00   Min.   :18.56   Min.   : 365.2   Min.   : 354.5  
##  1st Qu.: 78.75   1st Qu.:20.57   1st Qu.: 810.4   1st Qu.: 729.2  
##  Median : 92.50   Median :21.25   Median : 953.1   Median : 878.1  
##  Mean   : 81.67   Mean   :21.10   Mean   : 898.0   Mean   : 828.1  
##  3rd Qu.:101.00   3rd Qu.:22.02   3rd Qu.:1099.1   3rd Qu.:1027.7  
##  Max.   :110.00   Max.   :22.94   Max.   :1206.1   Max.   :1101.0  
##       T220            T225           FT220           FT225      
##  Min.   :286.1   Min.   :238.4   Min.   :252.3   Min.   :224.8  
##  1st Qu.:372.5   1st Qu.:355.4   1st Qu.:350.0   1st Qu.:322.8  
##  Median :400.6   Median :358.8   Median :480.9   Median :463.4  
##  Mean   :399.3   Mean   :364.6   Mean   :524.8   Mean   :493.2  
##  3rd Qu.:428.8   3rd Qu.:391.0   3rd Qu.:646.3   3rd Qu.:610.4  
##  Max.   :507.1   Max.   :475.6   Max.   :926.8   Max.   :872.2  
##      SPEEDT            SUMPREC      
##  Min.   :-0.90674   Min.   : 19.31  
##  1st Qu.: 0.09668   1st Qu.: 60.01  
##  Median : 0.14139   Median :115.95  
##  Mean   :-0.02263   Mean   : 90.09  
##  3rd Qu.: 0.15144   3rd Qu.:122.17  
##  Max.   : 0.25159   Max.   :123.69  
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/lena/24643099999 HATYAYK-HOMO.txt"
## The number of del/rep rows by column precipitation= 287 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##      Day Month Year PRECIP  TMEAN
## 3473  26    12 2015      0 -44.06
## 3474  27    12 2015      0 -32.00
## 3475  28    12 2015      0 -40.17
## 3476  29    12 2015      0 -41.67
## 3477  30    12 2015      0 -35.44
## 3478  31    12 2015      0 -41.22
## [1] "Structure"
## 'data.frame':	3191 obs. of  5 variables:
##  $ Day   : int  3 4 5 8 11 12 13 14 15 17 ...
##  $ Month : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Year  : int  1959 1959 1959 1959 1959 1959 1959 1959 1959 1959 ...
##  $ PRECIP: num  0 0 0 0 0.51 0 0 0.25 0 0.76 ...
##  $ TMEAN : num  -42.9 -43.9 -42.7 -51.3 -46 ...
## NULL
## [1] "Summary"
##      PRECIP           TMEAN        
##  Min.   :  0.00   Min.   :-51.780  
##  1st Qu.:  0.00   1st Qu.:-27.390  
##  Median :  0.00   Median : -4.170  
##  Mean   :  2.02   Mean   : -8.341  
##  3rd Qu.:  0.25   3rd Qu.: 10.440  
##  Max.   :150.11   Max.   : 26.330  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1959
```

```
## ****** Year: 1959 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1960
```

```
## ****** Year: 1960 
## #################### Skip a year!!!! 
## ****** Year: 1961 Observation: 304 Period: 2-1-1961 31-12-1961 ******
## ****** Year: 1962 Observation: 332 Period: 1-1-1962 31-12-1962 ******
## ****** Year: 1963 Observation: 337 Period: 1-1-1963 31-12-1963 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1964
```

```
## ****** Year: 1964 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1965
```

```
## ****** Year: 1965 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1966
```

```
## ****** Year: 1966 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1967
```

```
## ****** Year: 1967 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1968
```

```
## ****** Year: 1968 
## #################### Skip a year!!!! 
## ****** Year: 1969 Observation: 181 Period: 1-3-1969 28-12-1969 ******
## ****** Year: 1970 Observation: 170 Period: 2-1-1970 25-12-1970 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1971
```

```
## ****** Year: 1971 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1972
```

```
## ****** Year: 1972 
## #################### Skip a year!!!! 
## ****** Year: 1973 Observation: 123 Period: 1-1-1973 20-12-1973 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1974 
## #################### Skip a year!!!! 
## ****** Year: 1975 Observation: 221 Period: 3-1-1975 31-12-1975 ******
## ****** Year: 1976 Observation: 173 Period: 3-1-1976 18-12-1976 ******
## ****** Year: 1977 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1978
```

```
## ****** Year: 1978 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1979
```

```
## ****** Year: 1979 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1980
```

```
## ****** Year: 1980 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1981
```

```
## ****** Year: 1981 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1982
```

```
## ****** Year: 1982 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1983
```

```
## ****** Year: 1983 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1984
```

```
## ****** Year: 1984 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1985
```

```
## ****** Year: 1985 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1986
```

```
## ****** Year: 1986 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1987
```

```
## ****** Year: 1987 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1988
```

```
## ****** Year: 1988 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1989
```

```
## ****** Year: 1989 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1990
```

```
## ****** Year: 1990 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1991
```

```
## ****** Year: 1991 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1992
```

```
## ****** Year: 1992 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1993
```

```
## ****** Year: 1993 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1994
```

```
## ****** Year: 1994 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1995
```

```
## ****** Year: 1995 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1996
```

```
## ****** Year: 1996 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1997
```

```
## ****** Year: 1997 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1998
```

```
## ****** Year: 1998 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1999
```

```
## ****** Year: 1999 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2000
```

```
## ****** Year: 2000 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2001
```

```
## ****** Year: 2001 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2002
```

```
## ****** Year: 2002 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2003
```

```
## ****** Year: 2003 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2004
```

```
## ****** Year: 2004 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2005
```

```
## ****** Year: 2005 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2006
```

```
## ****** Year: 2006 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2007
```

```
## ****** Year: 2007 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2008
```

```
## ****** Year: 2008 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2009
```

```
## ****** Year: 2009 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2010
```

```
## ****** Year: 2010 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2011
```

```
## ****** Year: 2011 
## #################### Skip a year!!!! 
## ****** Year: 2012 Observation: 123 Period: 29-8-2012 31-12-2012 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 2013 Observation: 352 Period: 1-1-2013 31-12-2013 ******
## ****** Year: 2014 Observation: 364 Period: 1-1-2014 31-12-2014 ******
## ****** Year: 2015 Observation: 364 Period: 1-1-2015 31-12-2015 ******
## 
## elapsed time is 15.190000 seconds 
## 'data.frame':	12 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1961 1962 1963 1969 1970 1973 1975 1976 2012 2013 ...
##  $ ObsBeg      : chr  "2-1-1961" "1-1-1962" "1-1-1963" "1-3-1969" ...
##  $ ObsEnd      : chr  "31-12-1961" "31-12-1962" "31-12-1963" "28-12-1969" ...
##  $ StartSG     : num  104 130 128 34 82 39 57 95 1 116 ...
##  $ EndSG       : num  221 249 242 116 130 109 160 170 25 254 ...
##  $ STDAT0      : chr  "27-5-1961" "23-5-1962" "26-5-1963" "14-5-1969" ...
##  $ STDAT5      : chr  "28-5-1961" "29-5-1962" "3-6-1963" "21-5-1969" ...
##  $ FDAT0       : chr  "28-9-1961" "16-9-1962" "18-9-1963" "13-9-1969" ...
##  $ FDAT5       : chr  "22-9-1961" "13-9-1962" "12-9-1963" "9-9-1969" ...
##  $ INTER0      : num  124 116 115 122 125 150 133 123 25 139 ...
##  $ INTER5      : num  118 110 107 111 102 130 124 121 21 132 ...
##  $ MAXT        : num  24.6 24.3 23.2 23.1 26.3 ...
##  $ MDAT        : chr  "1-8-1961" "1-8-1962" "8-8-1963" "3-8-1969" ...
##  $ SUMT0       : num  1598 1585 1512 1158 616 ...
##  $ SUMT5       : num  1510 1513 1452 1119 589 ...
##  $ T220        : num  1146 545 563 1158 616 ...
##  $ T225        : num  1094 491 528 1119 589 ...
##  $ FT220       : num  455.5 1049 921.3 24.2 615.9 ...
##  $ FT225       : num  424.11 1037.38 913.79 5.83 588.62 ...
##  $ SPEEDT      : num  0.15 0.214 0.182 -0.398 -0.723 ...
##  $ SUMPREC     : num  630 213 322 463 279 ...
## NULL
##    Station_Code Year   ObsBeg     ObsEnd StartSG EndSG    STDAT0    STDAT5
## 3         23365 1961 2-1-1961 31-12-1961     104   221 27-5-1961 28-5-1961
## 4         23365 1962 1-1-1962 31-12-1962     130   249 23-5-1962 29-5-1962
## 5         23365 1963 1-1-1963 31-12-1963     128   242 26-5-1963  3-6-1963
## 11        23365 1969 1-3-1969 28-12-1969      34   116 14-5-1969 21-5-1969
## 12        23365 1970 2-1-1970 25-12-1970      82   130 27-5-1970  7-6-1970
## 15        23365 1973 1-1-1973 20-12-1973      39   109 12-5-1973 13-5-1973
##        FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT   SUMT0   SUMT5
## 3  28-9-1961 22-9-1961    124    118 24.56  1-8-1961 1597.76 1510.01
## 4  16-9-1962 13-9-1962    116    110 24.28  1-8-1962 1585.20 1513.09
## 5  18-9-1963 12-9-1963    115    107 23.17  8-8-1963 1512.18 1451.57
## 11 13-9-1969  9-9-1969    122    111 23.06  3-8-1969 1158.17 1118.96
## 12 29-9-1970 11-9-1970    125    102 26.33 17-7-1970  615.91  588.62
## 15 9-10-1973 19-9-1973    150    130 24.50 17-7-1973  997.56  973.90
##       T220    T225   FT220   FT225     SPEEDT SUMPREC
## 3  1145.58 1094.01  455.45  424.11  0.1501425  630.38
## 4   545.26  490.71 1049.05 1037.38  0.2139142  213.35
## 5   562.95  527.73  921.34  913.79  0.1820264  321.60
## 11 1158.17 1118.96   24.21    5.83 -0.3980864  463.30
## 12  615.91  588.62  615.91  588.62 -0.7225053  279.15
## 15  997.56  973.90  997.56  973.90 -0.4923623    0.00
##       Year         StartSG           EndSG           INTER0     
##  Min.   :1961   Min.   :  1.00   Min.   : 25.0   Min.   : 25.0  
##  1st Qu.:1968   1st Qu.: 52.50   1st Qu.:126.5   1st Qu.:120.5  
##  Median :1974   Median : 99.50   Median :195.5   Median :123.5  
##  Mean   :1984   Mean   : 88.42   Mean   :183.7   Mean   :118.8  
##  3rd Qu.:2012   3rd Qu.:128.50   3rd Qu.:250.2   3rd Qu.:132.2  
##  Max.   :2015   Max.   :141.00   Max.   :265.0   Max.   :150.0  
##      INTER5           MAXT           SUMT0            SUMT5       
##  Min.   : 21.0   Min.   :13.11   Min.   : 195.6   Min.   : 164.0  
##  1st Qu.:109.2   1st Qu.:23.42   1st Qu.: 991.8   1st Qu.: 962.1  
##  Median :117.5   Median :24.39   Median :1459.5   Median :1387.7  
##  Mean   :110.1   Mean   :23.59   Mean   :1300.8   Mean   :1242.4  
##  3rd Qu.:125.0   3rd Qu.:24.94   3rd Qu.:1641.9   3rd Qu.:1560.4  
##  Max.   :132.0   Max.   :26.33   Max.   :1895.8   Max.   :1834.8  
##       T220             T225            FT220            FT225       
##  Min.   : 195.6   Min.   : 164.0   Min.   :   0.0   Min.   :   0.0  
##  1st Qu.: 558.5   1st Qu.: 518.5   1st Qu.: 152.8   1st Qu.: 124.5  
##  Median : 708.6   Median : 676.1   Median : 768.6   Median : 751.2  
##  Mean   : 792.9   Mean   : 748.3   Mean   : 664.3   Mean   : 644.1  
##  3rd Qu.:1034.6   3rd Qu.:1003.9   3rd Qu.:1061.8   3rd Qu.:1048.9  
##  Max.   :1399.8   Max.   :1323.8   Max.   :1302.7   Max.   :1272.3  
##      SPEEDT            SUMPREC      
##  Min.   :-0.72251   Min.   :  0.00  
##  1st Qu.:-0.42094   1st Qu.: 86.94  
##  Median : 0.01774   Median :162.46  
##  Mean   :-0.06852   Mean   :209.26  
##  3rd Qu.: 0.22832   3rd Qu.:289.76  
##  Max.   : 0.38131   Max.   :630.38  
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/lena/24652099999 SANGARY.txt"
## The number of del/rep rows by column precipitation= 413 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##       Day Month Year PRECIP  TMEAN
## 17346  26    12 2015   0.25 -44.11
## 17347  27    12 2015   0.00 -41.61
## 17348  28    12 2015   0.00 -41.67
## 17349  29    12 2015   0.00 -40.17
## 17350  30    12 2015   0.00 -39.72
## 17351  31    12 2015   0.00 -41.17
## [1] "Structure"
## 'data.frame':	16938 obs. of  5 variables:
##  $ Day   : int  10 9 12 17 2 13 17 7 23 13 ...
##  $ Month : int  1 3 3 3 4 4 4 6 6 7 ...
##  $ Year  : int  1948 1948 1948 1948 1948 1948 1948 1948 1948 1948 ...
##  $ PRECIP: num  0 0 0 0.51 0.25 0 0 0 2.03 0 ...
##  $ TMEAN : num  -33.06 -12.61 -23.89 -15.72 -5.28 ...
## NULL
## [1] "Summary"
##      PRECIP            TMEAN        
##  Min.   :  0.000   Min.   :-54.500  
##  1st Qu.:  0.000   1st Qu.:-29.280  
##  Median :  0.000   Median : -6.440  
##  Mean   :  1.135   Mean   : -9.226  
##  3rd Qu.:  0.510   3rd Qu.: 10.330  
##  Max.   :150.110   Max.   : 26.610  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1948
```

```
## ****** Year: 1948 
## #################### Skip a year!!!! 
## ****** Year: 1949 Observation: 132 Period: 4-1-1949 31-12-1949 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1950 Observation: 227 Period: 4-1-1950 10-12-1950 ******
## ****** Year: 1951 
## #################### Skip a year!!!! 
## ****** Year: 1952 Observation: 147 Period: 6-1-1952 31-12-1952 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1953
```

```
## ****** Year: 1953 
## #################### Skip a year!!!! 
## ****** Year: 1954 Observation: 97 Period: 3-1-1954 16-12-1954 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1955 Observation: 133 Period: 2-1-1955 30-12-1955 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1956
```

```
## ****** Year: 1956 
## #################### Skip a year!!!! 
## ****** Year: 1957 
## #################### Skip a year!!!! 
## ****** Year: 1958 
## #################### Skip a year!!!! 
## ****** Year: 1959 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1960
```

```
## ****** Year: 1960 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1961
```

```
## ****** Year: 1961 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1962
```

```
## ****** Year: 1962 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1963
```

```
## ****** Year: 1963 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1964
```

```
## ****** Year: 1964 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1965
```

```
## ****** Year: 1965 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1966
```

```
## ****** Year: 1966 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1967
```

```
## ****** Year: 1967 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1968
```

```
## ****** Year: 1968 
## #################### Skip a year!!!! 
## ****** Year: 1969 Observation: 329 Period: 1-1-1969 31-12-1969 ******
## ****** Year: 1970 Observation: 320 Period: 2-1-1970 31-12-1970 ******
## ****** Year: 1971 Observation: 148 Period: 1-1-1971 30-6-1971 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1972
```

```
## ****** Year: 1972 
## #################### Skip a year!!!! 
## ****** Year: 1973 Observation: 350 Period: 1-1-1973 31-12-1973 ******
## ****** Year: 1974 Observation: 336 Period: 1-1-1974 31-12-1974 ******
## ****** Year: 1975 Observation: 362 Period: 1-1-1975 31-12-1975 ******
## ****** Year: 1976 Observation: 352 Period: 2-1-1976 29-12-1976 ******
## ****** Year: 1977 Observation: 352 Period: 1-1-1977 31-12-1977 ******
## ****** Year: 1978 Observation: 364 Period: 1-1-1978 31-12-1978 ******
## ****** Year: 1979 Observation: 363 Period: 1-1-1979 31-12-1979 ******
## ****** Year: 1980 Observation: 361 Period: 1-1-1980 31-12-1980 ******
## ****** Year: 1981 Observation: 360 Period: 1-1-1981 31-12-1981 ******
## ****** Year: 1982 Observation: 361 Period: 1-1-1982 31-12-1982 ******
## ****** Year: 1983 Observation: 361 Period: 1-1-1983 31-12-1983 ******
## ****** Year: 1984 Observation: 361 Period: 1-1-1984 31-12-1984 ******
## ****** Year: 1985 Observation: 365 Period: 1-1-1985 31-12-1985 ******
## ****** Year: 1986 Observation: 361 Period: 1-1-1986 31-12-1986 ******
## ****** Year: 1987 Observation: 363 Period: 1-1-1987 31-12-1987 ******
## ****** Year: 1988 Observation: 356 Period: 1-1-1988 31-12-1988 ******
## ****** Year: 1989 Observation: 361 Period: 1-1-1989 31-12-1989 ******
## ****** Year: 1990 Observation: 364 Period: 1-1-1990 31-12-1990 ******
## ****** Year: 1991 Observation: 360 Period: 1-1-1991 31-12-1991 ******
## ****** Year: 1992 Observation: 364 Period: 1-1-1992 31-12-1992 ******
## ****** Year: 1993 Observation: 363 Period: 1-1-1993 31-12-1993 ******
## ****** Year: 1994 Observation: 364 Period: 1-1-1994 31-12-1994 ******
## ****** Year: 1995 Observation: 365 Period: 1-1-1995 31-12-1995 ******
## ****** Year: 1996 Observation: 363 Period: 1-1-1996 31-12-1996 ******
## ****** Year: 1997 Observation: 365 Period: 1-1-1997 31-12-1997 ******
## ****** Year: 1998 Observation: 354 Period: 1-1-1998 31-12-1998 ******
## ****** Year: 1999 Observation: 362 Period: 1-1-1999 31-12-1999 ******
## ****** Year: 2000 Observation: 210 Period: 1-1-2000 16-12-2000 ******
## ****** Year: 2001 Observation: 306 Period: 2-1-2001 30-12-2001 ******
## ****** Year: 2002 Observation: 354 Period: 1-1-2002 31-12-2002 ******
## ****** Year: 2003 Observation: 362 Period: 1-1-2003 31-12-2003 ******
## ****** Year: 2004 Observation: 366 Period: 1-1-2004 31-12-2004 ******
## ****** Year: 2005 Observation: 360 Period: 1-1-2005 31-12-2005 ******
## ****** Year: 2006 Observation: 337 Period: 1-1-2006 31-12-2006 ******
## ****** Year: 2007 Observation: 347 Period: 1-1-2007 31-12-2007 ******
## ****** Year: 2008 Observation: 346 Period: 1-1-2008 31-12-2008 ******
## ****** Year: 2009 Observation: 348 Period: 1-1-2009 31-12-2009 ******
## ****** Year: 2010 Observation: 345 Period: 1-1-2010 31-12-2010 ******
## ****** Year: 2011 Observation: 341 Period: 1-1-2011 31-12-2011 ******
## ****** Year: 2012 Observation: 350 Period: 1-1-2012 31-12-2012 ******
## ****** Year: 2013 Observation: 364 Period: 1-1-2013 31-12-2013 ******
## ****** Year: 2014 Observation: 364 Period: 1-1-2014 31-12-2014 ******
## ****** Year: 2015 Observation: 365 Period: 1-1-2015 31-12-2015 ******
## 
## elapsed time is 44.690000 seconds 
## 'data.frame':	51 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1949 1950 1952 1954 1955 1969 1970 1971 1973 1974 ...
##  $ ObsBeg      : chr  "4-1-1949" "4-1-1950" "6-1-1952" "3-1-1954" ...
##  $ ObsEnd      : chr  "31-12-1949" "10-12-1950" "31-12-1952" "16-12-1954" ...
##  $ StartSG     : num  41 113 12 32 54 114 131 118 123 133 ...
##  $ EndSG       : num  106 193 85 86 106 230 240 148 260 254 ...
##  $ STDAT0      : chr  "10-5-1949" "26-5-1950" "20-5-1952" "17-5-1954" ...
##  $ STDAT5      : chr  "21-5-1949" "30-5-1950" "4-6-1952" "26-5-1954" ...
##  $ FDAT0       : chr  "12-10-1949" "16-9-1950" "27-9-1952" "12-9-1954" ...
##  $ FDAT5       : chr  "25-9-1949" "8-9-1950" "20-9-1952" "23-8-1954" ...
##  $ INTER0      : num  155 113 130 118 122 120 123 45 140 129 ...
##  $ INTER5      : num  134 102 122 91 111 114 115 44 137 123 ...
##  $ MAXT        : num  25.6 24.9 25.6 22.9 22.4 ...
##  $ MDAT        : chr  "11-8-1949" "24-6-1950" "29-7-1952" "14-7-1954" ...
##  $ SUMT0       : num  819 1115 888 703 649 ...
##  $ SUMT5       : num  799 1016 868 686 631 ...
##  $ T220        : num  819 913 888 703 649 ...
##  $ T225        : num  799 846 868 686 631 ...
##  $ FT220       : num  819 186 888 703 649 ...
##  $ FT225       : num  799 172 868 686 631 ...
##  $ SPEEDT      : num  -0.6859 0.0875 -0.539 -0.535 -0.7826 ...
##  $ SUMPREC     : num  66.3 79.3 41.9 57.9 41.2 ...
## NULL
##    Station_Code Year   ObsBeg     ObsEnd StartSG EndSG    STDAT0    STDAT5
## 2         23365 1949 4-1-1949 31-12-1949      41   106 10-5-1949 21-5-1949
## 3         23365 1950 4-1-1950 10-12-1950     113   193 26-5-1950 30-5-1950
## 5         23365 1952 6-1-1952 31-12-1952      12    85 20-5-1952  4-6-1952
## 7         23365 1954 3-1-1954 16-12-1954      32    86 17-5-1954 26-5-1954
## 8         23365 1955 2-1-1955 30-12-1955      54   106 25-5-1955 25-5-1955
## 22        23365 1969 1-1-1969 31-12-1969     114   230 16-5-1969 21-5-1969
##         FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT   SUMT0   SUMT5
## 2  12-10-1949 25-9-1949    155    134 25.56 11-8-1949  819.46  799.41
## 3   16-9-1950  8-9-1950    113    102 24.89 24-6-1950 1114.58 1016.39
## 5   27-9-1952 20-9-1952    130    122 25.56 29-7-1952  887.84  867.73
## 7   12-9-1954 23-8-1954    118     91 22.94 14-7-1954  703.23  686.28
## 8   24-9-1955 13-9-1955    122    111 22.39 25-6-1955  649.08  631.03
## 22  13-9-1969  9-9-1969    120    114 26.28  5-8-1969 1717.59 1658.41
##      T220   T225  FT220  FT225      SPEEDT SUMPREC
## 2  819.46 799.41 819.46 799.41 -0.68592859   66.30
## 3  913.08 845.84 185.68 171.67  0.08745957   79.29
## 5  887.84 867.73 887.84 867.73 -0.53895892   41.93
## 7  703.23 686.28 703.23 686.28 -0.53504373   57.92
## 8  649.08 631.03 649.08 631.03 -0.78259025   41.17
## 22 830.16 808.81 889.44 868.21  0.16282642  938.79
##       Year         StartSG          EndSG           INTER0     
##  Min.   :1949   Min.   : 12.0   Min.   : 85.0   Min.   : 24.0  
##  1st Qu.:1978   1st Qu.:123.5   1st Qu.:244.0   1st Qu.:120.0  
##  Median :1990   Median :133.0   Median :259.0   Median :125.0  
##  Mean   :1988   Mean   :125.6   Mean   :238.8   Mean   :123.2  
##  3rd Qu.:2002   3rd Qu.:141.5   3rd Qu.:266.0   3rd Qu.:131.5  
##  Max.   :2015   Max.   :152.0   Max.   :274.0   Max.   :155.0  
##      INTER5           MAXT           SUMT0            SUMT5       
##  Min.   : 21.0   Min.   :22.39   Min.   : 444.4   Min.   : 392.7  
##  1st Qu.:114.5   1st Qu.:24.00   1st Qu.:1638.0   1st Qu.:1576.5  
##  Median :119.0   Median :24.89   Median :1769.9   Median :1687.5  
##  Mean   :117.0   Mean   :24.82   Mean   :1642.1   Mean   :1575.6  
##  3rd Qu.:126.0   3rd Qu.:25.67   3rd Qu.:1826.0   3rd Qu.:1762.6  
##  Max.   :142.0   Max.   :26.61   Max.   :2007.0   Max.   :1969.8  
##       T220             T225            FT220             FT225        
##  Min.   : 328.0   Min.   : 263.2   Min.   :  65.06   Min.   :  34.23  
##  1st Qu.: 447.9   1st Qu.: 406.3   1st Qu.:1040.64   1st Qu.:1016.23  
##  Median : 584.8   Median : 526.9   Median :1200.73   Median :1186.89  
##  Mean   : 591.6   Mean   : 553.1   Mean   :1103.83   Mean   :1081.61  
##  3rd Qu.: 663.8   3rd Qu.: 638.0   3rd Qu.:1313.62   3rd Qu.:1291.57  
##  Max.   :1452.2   Max.   :1410.1   Max.   :1470.34   Max.   :1466.78  
##      SPEEDT           SUMPREC      
##  Min.   :-0.7826   Min.   : 35.31  
##  1st Qu.: 0.1925   1st Qu.:112.14  
##  Median : 0.2590   Median :168.10  
##  Mean   : 0.2220   Mean   :187.87  
##  3rd Qu.: 0.3354   3rd Qu.:227.34  
##  Max.   : 0.6555   Max.   :938.79  
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/lena/24668099999 VERHOJANSK PEREVOZ.txt"
## The number of del/rep rows by column precipitation= 133 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##      Day Month Year PRECIP  TMEAN
## 9407  26    12 2015      0 -48.61
## 9408  27    12 2015      0 -46.00
## 9409  28    12 2015      0 -41.33
## 9410  29    12 2015      0 -41.72
## 9411  30    12 2015      0 -43.78
## 9412  31    12 2015      0 -42.72
## [1] "Structure"
## 'data.frame':	9279 obs. of  5 variables:
##  $ Day   : int  2 3 6 8 11 17 18 19 22 24 ...
##  $ Month : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Year  : int  1959 1959 1959 1959 1959 1959 1959 1959 1959 1959 ...
##  $ PRECIP: num  0 0 0 0 0 0 0 0 0 0 ...
##  $ TMEAN : num  -44.6 -42.4 -50.4 -53.6 -44.2 ...
## NULL
## [1] "Summary"
##      PRECIP            TMEAN       
##  Min.   :  0.000   Min.   :-58.94  
##  1st Qu.:  0.000   1st Qu.:-33.11  
##  Median :  0.000   Median : -7.00  
##  Mean   :  1.065   Mean   :-11.36  
##  3rd Qu.:  0.250   3rd Qu.: 10.00  
##  Max.   :150.110   Max.   : 26.44  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
## ****** Year: 1959 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1960
```

```
## ****** Year: 1960 
## #################### Skip a year!!!! 
## ****** Year: 1961 Observation: 345 Period: 2-1-1961 31-12-1961 ******
## ****** Year: 1962 Observation: 335 Period: 1-1-1962 31-12-1962 ******
## ****** Year: 1963 Observation: 342 Period: 1-1-1963 31-12-1963 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1964
```

```
## ****** Year: 1964 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1965
```

```
## ****** Year: 1965 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1966
```

```
## ****** Year: 1966 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1967
```

```
## ****** Year: 1967 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1968
```

```
## ****** Year: 1968 
## #################### Skip a year!!!! 
## ****** Year: 1969 Observation: 352 Period: 1-1-1969 31-12-1969 ******
## ****** Year: 1970 Observation: 357 Period: 1-1-1970 31-12-1970 ******
## ****** Year: 1971 Observation: 166 Period: 1-1-1971 30-6-1971 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1972
```

```
## ****** Year: 1972 
## #################### Skip a year!!!! 
## ****** Year: 1973 Observation: 347 Period: 1-1-1973 31-12-1973 ******
## ****** Year: 1974 Observation: 318 Period: 1-1-1974 31-12-1974 ******
## ****** Year: 1975 Observation: 355 Period: 1-1-1975 31-12-1975 ******
## ****** Year: 1976 Observation: 338 Period: 1-1-1976 31-12-1976 ******
## ****** Year: 1977 Observation: 267 Period: 6-1-1977 29-12-1977 ******
## ****** Year: 1978 Observation: 329 Period: 5-1-1978 29-12-1978 ******
## ****** Year: 1979 Observation: 359 Period: 1-1-1979 31-12-1979 ******
## ****** Year: 1980 Observation: 364 Period: 1-1-1980 31-12-1980 ******
## ****** Year: 1981 Observation: 361 Period: 1-1-1981 31-12-1981 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1982
```

```
## ****** Year: 1982 
## #################### Skip a year!!!! 
## ****** Year: 1983 Observation: 273 Period: 1-1-1983 31-12-1983 ******
## ****** Year: 1984 Observation: 360 Period: 1-1-1984 31-12-1984 ******
## ****** Year: 1985 Observation: 364 Period: 1-1-1985 31-12-1985 ******
## ****** Year: 1986 Observation: 365 Period: 1-1-1986 31-12-1986 ******
## ****** Year: 1987 Observation: 363 Period: 1-1-1987 31-12-1987 ******
## ****** Year: 1988 Observation: 363 Period: 1-1-1988 31-12-1988 ******
## ****** Year: 1989 Observation: 363 Period: 1-1-1989 31-12-1989 ******
## ****** Year: 1990 Observation: 360 Period: 1-1-1990 31-12-1990 ******
## ****** Year: 1991 Observation: 224 Period: 1-1-1991 15-8-1991 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1992
```

```
## ****** Year: 1992 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1993
```

```
## ****** Year: 1993 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1994
```

```
## ****** Year: 1994 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1995
```

```
## ****** Year: 1995 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1996
```

```
## ****** Year: 1996 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1997
```

```
## ****** Year: 1997 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1998
```

```
## ****** Year: 1998 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1999
```

```
## ****** Year: 1999 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2000
```

```
## ****** Year: 2000 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2001
```

```
## ****** Year: 2001 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2002
```

```
## ****** Year: 2002 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2003
```

```
## ****** Year: 2003 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2004
```

```
## ****** Year: 2004 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2005
```

```
## ****** Year: 2005 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2006
```

```
## ****** Year: 2006 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2007
```

```
## ****** Year: 2007 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2008
```

```
## ****** Year: 2008 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2009
```

```
## ****** Year: 2009 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2010
```

```
## ****** Year: 2010 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2011
```

```
## ****** Year: 2011 
## #################### Skip a year!!!! 
## ****** Year: 2012 Observation: 123 Period: 29-8-2012 31-12-2012 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 2013 Observation: 364 Period: 1-1-2013 31-12-2013 ******
## ****** Year: 2014 Observation: 361 Period: 1-1-2014 31-12-2014 ******
## ****** Year: 2015 Observation: 365 Period: 1-1-2015 31-12-2015 ******
## 
## elapsed time is 21.090000 seconds 
## 'data.frame':	28 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1961 1962 1963 1969 1970 1971 1973 1974 1975 1976 ...
##  $ ObsBeg      : chr  "2-1-1961" "1-1-1962" "1-1-1963" "1-1-1969" ...
##  $ ObsEnd      : chr  "31-12-1961" "31-12-1962" "31-12-1963" "31-12-1969" ...
##  $ StartSG     : num  137 129 130 127 147 123 128 122 124 135 ...
##  $ EndSG       : num  260 249 243 247 267 166 268 235 254 260 ...
##  $ STDAT0      : chr  "27-5-1961" "23-5-1962" "25-5-1963" "15-5-1969" ...
##  $ STDAT5      : chr  "28-5-1961" "29-5-1962" "31-5-1963" "21-5-1969" ...
##  $ FDAT0       : chr  "28-9-1961" "22-9-1962" "17-9-1963" "13-9-1969" ...
##  $ FDAT5       : chr  "26-9-1961" "16-9-1962" "13-9-1963" "11-9-1969" ...
##  $ INTER0      : num  124 122 115 121 121 52 140 126 132 131 ...
##  $ INTER5      : num  122 115 111 117 115 52 135 123 126 124 ...
##  $ MAXT        : num  24.7 24.4 23.2 25.2 25.8 ...
##  $ MDAT        : chr  "31-7-1961" "24-7-1962" "29-7-1963" "5-8-1969" ...
##  $ SUMT0       : num  1782 1689 1613 1732 1698 ...
##  $ SUMT5       : num  1732 1622 1528 1672 1625 ...
##  $ T220        : num  618 619 642 580 404 ...
##  $ T225        : num  595 558 592 556 348 ...
##  $ FT220       : num  1177 1083 946 1149 1300 ...
##  $ FT225       : num  1158 1077 932 1129 1287 ...
##  $ SPEEDT      : num  0.33 0.197 0.25 0.145 0.293 ...
##  $ SUMPREC     : num  355 422 411 264 174 ...
## NULL
##    Station_Code Year   ObsBeg     ObsEnd StartSG EndSG    STDAT0    STDAT5
## 3         23365 1961 2-1-1961 31-12-1961     137   260 27-5-1961 28-5-1961
## 4         23365 1962 1-1-1962 31-12-1962     129   249 23-5-1962 29-5-1962
## 5         23365 1963 1-1-1963 31-12-1963     130   243 25-5-1963 31-5-1963
## 11        23365 1969 1-1-1969 31-12-1969     127   247 15-5-1969 21-5-1969
## 12        23365 1970 1-1-1970 31-12-1970     147   267 29-5-1970  7-6-1970
## 13        23365 1971 1-1-1971  30-6-1971     123   166  9-5-1971 18-5-1971
##        FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT   SUMT0   SUMT5
## 3  28-9-1961 26-9-1961    124    122 24.72 31-7-1961 1782.47 1732.25
## 4  22-9-1962 16-9-1962    122    115 24.44 24-7-1962 1689.48 1622.42
## 5  17-9-1963 13-9-1963    115    111 23.17 29-7-1963 1613.11 1528.40
## 11 13-9-1969 11-9-1969    121    117 25.22  5-8-1969 1732.40 1671.91
## 12 27-9-1970 21-9-1970    121    115 25.83  5-7-1970 1697.61 1625.40
## 13 30-6-1971 30-6-1971     52     52 20.28  6-6-1971  581.59  548.60
##      T220   T225   FT220   FT225    SPEEDT SUMPREC
## 3  618.47 594.87 1177.27 1158.21 0.3300978  355.34
## 4  618.55 557.71 1082.87 1076.65 0.1974877  421.87
## 5  641.88 592.33  946.24  931.57 0.2496179  411.45
## 11 579.97 555.91 1149.16 1129.00 0.1454332  263.94
## 12 403.83 348.44 1299.95 1287.07 0.2934120  174.24
## 13 581.59 548.60  581.59  548.60 0.1652065   10.42
##       Year         StartSG          EndSG           INTER0     
##  Min.   :1961   Min.   :  1.0   Min.   : 25.0   Min.   : 24.0  
##  1st Qu.:1974   1st Qu.:123.8   1st Qu.:246.0   1st Qu.:121.0  
##  Median :1980   Median :133.0   Median :257.5   Median :124.5  
##  Mean   :1983   Mean   :125.8   Mean   :240.5   Mean   :119.8  
##  3rd Qu.:1988   3rd Qu.:138.2   3rd Qu.:263.5   3rd Qu.:132.2  
##  Max.   :2015   Max.   :149.0   Max.   :271.0   Max.   :144.0  
##      INTER5           MAXT           SUMT0            SUMT5       
##  Min.   : 19.0   Min.   :11.50   Min.   : 200.8   Min.   : 158.5  
##  1st Qu.:115.0   1st Qu.:23.42   1st Qu.:1589.9   1st Qu.:1527.9  
##  Median :120.5   Median :24.53   Median :1693.5   Median :1623.9  
##  Mean   :115.0   Mean   :23.85   Mean   :1586.6   Mean   :1525.4  
##  3rd Qu.:126.8   3rd Qu.:25.10   3rd Qu.:1771.8   3rd Qu.:1716.4  
##  Max.   :141.0   Max.   :26.44   Max.   :1969.8   Max.   :1904.9  
##       T220             T225            FT220            FT225       
##  Min.   : 200.8   Min.   : 158.5   Min.   : 135.8   Min.   : 126.9  
##  1st Qu.: 481.9   1st Qu.: 437.6   1st Qu.: 980.8   1st Qu.: 977.1  
##  Median : 588.2   Median : 555.9   Median :1151.0   Median :1130.3  
##  Mean   : 586.3   Mean   : 550.8   Mean   :1031.4   Mean   :1010.9  
##  3rd Qu.: 630.4   3rd Qu.: 599.2   3rd Qu.:1265.4   3rd Qu.:1236.8  
##  Max.   :1104.6   Max.   :1089.4   Max.   :1375.2   Max.   :1349.0  
##      SPEEDT           SUMPREC      
##  Min.   :-0.5321   Min.   : 10.42  
##  1st Qu.: 0.1966   1st Qu.:112.16  
##  Median : 0.2422   Median :170.07  
##  Mean   : 0.2112   Mean   :174.15  
##  3rd Qu.: 0.2903   3rd Qu.:208.82  
##  Max.   : 0.4323   Max.   :421.87  
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/lena/24768099999 CURAPCA.txt"
## The number of del/rep rows by column precipitation= 530 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##       Day Month Year PRECIP TMEAN
## 21035  26     6 2016   3.05 13.11
## 21036  27     6 2016   0.00 15.33
## 21037  28     6 2016   2.03 12.39
## 21038  29     6 2016   0.00 18.33
## 21039  30     6 2016   0.00 22.33
## 21040   1     7 2016   0.00 24.83
## [1] "Structure"
## 'data.frame':	20510 obs. of  5 variables:
##  $ Day   : int  2 3 5 6 8 9 10 12 13 14 ...
##  $ Month : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Year  : int  1948 1948 1948 1948 1948 1948 1948 1948 1948 1948 ...
##  $ PRECIP: num  2.03 0.51 0.25 0.51 0 0 0.51 0 0 0 ...
##  $ TMEAN : num  -28.4 -24.3 -36.4 -38.1 -46.1 ...
## NULL
## [1] "Summary"
##      PRECIP             TMEAN       
##  Min.   :  0.0000   Min.   :-60.28  
##  1st Qu.:  0.0000   1st Qu.:-32.50  
##  Median :  0.0000   Median : -6.00  
##  Mean   :  0.9418   Mean   :-10.44  
##  3rd Qu.:  0.2500   3rd Qu.: 10.56  
##  Max.   :184.9100   Max.   : 26.61  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
## ****** Year: 1948 Observation: 206 Period: 2-1-1948 30-12-1948 ******
## ****** Year: 1949 Observation: 337 Period: 1-1-1949 31-12-1949 ******
## ****** Year: 1950 Observation: 329 Period: 3-1-1950 31-12-1950 ******
## ****** Year: 1951 Observation: 264 Period: 1-1-1951 30-12-1951 ******
## ****** Year: 1952 Observation: 318 Period: 1-1-1952 31-12-1952 ******
## ****** Year: 1953 Observation: 127 Period: 1-1-1953 31-12-1953 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1954 Observation: 127 Period: 4-1-1954 30-12-1954 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1955 Observation: 259 Period: 1-1-1955 31-12-1955 ******
## ****** Year: 1956 Observation: 277 Period: 1-1-1956 31-12-1956 ******
## ****** Year: 1957 Observation: 279 Period: 1-1-1957 31-12-1957 ******
## ****** Year: 1958 Observation: 234 Period: 4-1-1958 31-12-1958 ******
## ****** Year: 1959 Observation: 142 Period: 2-1-1959 17-10-1959 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1960 Observation: 327 Period: 1-1-1960 31-12-1960 ******
## ****** Year: 1961 Observation: 358 Period: 1-1-1961 31-12-1961 ******
## ****** Year: 1962 Observation: 351 Period: 1-1-1962 31-12-1962 ******
## ****** Year: 1963 Observation: 343 Period: 1-1-1963 31-12-1963 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1964
```

```
## ****** Year: 1964 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1965
```

```
## ****** Year: 1965 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1966
```

```
## ****** Year: 1966 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1967
```

```
## ****** Year: 1967 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1968
```

```
## ****** Year: 1968 
## #################### Skip a year!!!! 
## ****** Year: 1969 Observation: 348 Period: 1-1-1969 31-12-1969 ******
## ****** Year: 1970 Observation: 357 Period: 1-1-1970 31-12-1970 ******
## ****** Year: 1971 Observation: 179 Period: 1-1-1971 30-6-1971 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1972
```

```
## ****** Year: 1972 
## #################### Skip a year!!!! 
## ****** Year: 1973 Observation: 345 Period: 1-1-1973 31-12-1973 ******
## ****** Year: 1974 Observation: 336 Period: 1-1-1974 31-12-1974 ******
## ****** Year: 1975 Observation: 359 Period: 2-1-1975 31-12-1975 ******
## ****** Year: 1976 Observation: 364 Period: 1-1-1976 31-12-1976 ******
## ****** Year: 1977 Observation: 360 Period: 1-1-1977 31-12-1977 ******
## ****** Year: 1978 Observation: 355 Period: 1-1-1978 31-12-1978 ******
## ****** Year: 1979 Observation: 364 Period: 1-1-1979 31-12-1979 ******
## ****** Year: 1980 Observation: 365 Period: 1-1-1980 31-12-1980 ******
## ****** Year: 1981 Observation: 363 Period: 1-1-1981 31-12-1981 ******
## ****** Year: 1982 Observation: 364 Period: 1-1-1982 31-12-1982 ******
## ****** Year: 1983 Observation: 364 Period: 1-1-1983 31-12-1983 ******
## ****** Year: 1984 Observation: 366 Period: 1-1-1984 31-12-1984 ******
## ****** Year: 1985 Observation: 365 Period: 1-1-1985 31-12-1985 ******
## ****** Year: 1986 Observation: 364 Period: 1-1-1986 31-12-1986 ******
## ****** Year: 1987 Observation: 364 Period: 1-1-1987 31-12-1987 ******
## ****** Year: 1988 Observation: 361 Period: 1-1-1988 30-12-1988 ******
## ****** Year: 1989 Observation: 365 Period: 1-1-1989 31-12-1989 ******
## ****** Year: 1990 Observation: 365 Period: 1-1-1990 31-12-1990 ******
## ****** Year: 1991 Observation: 364 Period: 1-1-1991 31-12-1991 ******
## ****** Year: 1992 Observation: 365 Period: 1-1-1992 31-12-1992 ******
## ****** Year: 1993 Observation: 364 Period: 1-1-1993 31-12-1993 ******
## ****** Year: 1994 Observation: 364 Period: 1-1-1994 31-12-1994 ******
## ****** Year: 1995 Observation: 364 Period: 1-1-1995 31-12-1995 ******
## ****** Year: 1996 Observation: 365 Period: 1-1-1996 31-12-1996 ******
## ****** Year: 1997 Observation: 365 Period: 1-1-1997 31-12-1997 ******
## ****** Year: 1998 Observation: 361 Period: 1-1-1998 31-12-1998 ******
## ****** Year: 1999 Observation: 364 Period: 1-1-1999 31-12-1999 ******
## ****** Year: 2000 Observation: 175 Period: 1-1-2000 8-12-2000 ******
## ****** Year: 2001 Observation: 312 Period: 1-2-2001 31-12-2001 ******
## ****** Year: 2002 Observation: 353 Period: 1-1-2002 31-12-2002 ******
## ****** Year: 2003 Observation: 364 Period: 1-1-2003 31-12-2003 ******
## ****** Year: 2004 Observation: 365 Period: 1-1-2004 31-12-2004 ******
## ****** Year: 2005 Observation: 349 Period: 1-1-2005 31-12-2005 ******
## ****** Year: 2006 Observation: 338 Period: 1-1-2006 31-12-2006 ******
## ****** Year: 2007 Observation: 338 Period: 1-1-2007 31-12-2007 ******
## ****** Year: 2008 Observation: 340 Period: 1-1-2008 31-12-2008 ******
## ****** Year: 2009 Observation: 334 Period: 1-1-2009 30-12-2009 ******
## ****** Year: 2010 Observation: 339 Period: 1-1-2010 31-12-2010 ******
## ****** Year: 2011 Observation: 341 Period: 1-1-2011 31-12-2011 ******
## ****** Year: 2012 Observation: 359 Period: 1-1-2012 31-12-2012 ******
## ****** Year: 2013 Observation: 364 Period: 1-1-2013 31-12-2013 ******
## ****** Year: 2014 Observation: 364 Period: 1-1-2014 31-12-2014 ******
## ****** Year: 2015 Observation: 365 Period: 1-1-2015 31-12-2015 ******
## ****** Year: 2016 Observation: 183 Period: 1-1-2016 1-7-2016 ******
## 
## elapsed time is 45.300000 seconds 
## 'data.frame':	63 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1948 1949 1950 1951 1952 1953 1954 1955 1956 1957 ...
##  $ ObsBeg      : chr  "2-1-1948" "1-1-1949" "3-1-1950" "1-1-1951" ...
##  $ ObsEnd      : chr  "30-12-1948" "31-12-1949" "31-12-1950" "30-12-1951" ...
##  $ StartSG     : num  82 124 133 115 122 58 40 91 109 102 ...
##  $ EndSG       : num  155 254 235 197 228 104 98 184 204 192 ...
##  $ STDAT0      : chr  "12-5-1948" "10-5-1949" "22-5-1950" "24-5-1951" ...
##  $ STDAT5      : chr  "29-5-1948" "17-5-1949" "22-5-1950" "4-6-1951" ...
##  $ FDAT0       : chr  "26-9-1948" "3-10-1949" "16-9-1950" "26-9-1951" ...
##  $ FDAT5       : chr  "23-9-1948" "25-9-1949" "9-9-1950" "26-9-1951" ...
##  $ INTER0      : num  137 146 117 125 123 142 129 130 126 123 ...
##  $ INTER5      : num  134 132 110 123 122 138 114 123 122 116 ...
##  $ MAXT        : num  23.9 24.4 22.2 22.8 26.1 ...
##  $ MDAT        : chr  "9-7-1948" "28-7-1949" "22-6-1950" "10-7-1951" ...
##  $ SUMT0       : num  994 1816 1323 1134 1544 ...
##  $ SUMT5       : num  940 1754 1203 1076 1488 ...
##  $ T220        : num  994 756 584 895 812 ...
##  $ T225        : num  940 730 519 861 768 ...
##  $ FT220       : num  16.7 1075.2 723.3 241 739.6 ...
##  $ FT225       : num  8.78 1043.99 695.49 221.72 737.54 ...
##  $ SPEEDT      : num  -0.269 0.314 0.295 0.15 0.284 ...
##  $ SUMPREC     : num  3.06 64.32 95.28 118.38 102.38 ...
## NULL
##   Station_Code Year   ObsBeg     ObsEnd StartSG EndSG    STDAT0    STDAT5
## 1        23365 1948 2-1-1948 30-12-1948      82   155 12-5-1948 29-5-1948
## 2        23365 1949 1-1-1949 31-12-1949     124   254 10-5-1949 17-5-1949
## 3        23365 1950 3-1-1950 31-12-1950     133   235 22-5-1950 22-5-1950
## 4        23365 1951 1-1-1951 30-12-1951     115   197 24-5-1951  4-6-1951
## 5        23365 1952 1-1-1952 31-12-1952     122   228 21-5-1952 21-5-1952
## 6        23365 1953 1-1-1953 31-12-1953      58   104  5-5-1953 24-5-1953
##       FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT   SUMT0   SUMT5   T220
## 1 26-9-1948 23-9-1948    137    134 23.89  9-7-1948  994.28  939.69 994.28
## 2 3-10-1949 25-9-1949    146    132 24.44 28-7-1949 1815.80 1754.25 755.81
## 3 16-9-1950  9-9-1950    117    110 22.22 22-6-1950 1323.46 1203.40 584.20
## 4 26-9-1951 26-9-1951    125    123 22.78 10-7-1951 1134.30 1075.64 894.64
## 5 21-9-1952 20-9-1952    123    122 26.11 16-7-1952 1544.47 1487.97 811.60
## 6 24-9-1953 24-9-1953    142    138 19.28  6-6-1953  509.74  494.47 509.74
##     T225   FT220   FT225     SPEEDT SUMPREC
## 1 939.69   16.66    8.78 -0.2688444    3.06
## 2 730.15 1075.21 1043.99  0.3139633   64.32
## 3 519.13  723.33  695.49  0.2945863   95.28
## 4 861.14  241.05  221.72  0.1499354  118.38
## 5 767.93  739.65  737.54  0.2836660  102.38
## 6 494.47  509.74  494.47 -0.9026267   24.39
##       Year         StartSG          EndSG           INTER0     
##  Min.   :1948   Min.   : 40.0   Min.   : 98.0   Min.   : 44.0  
##  1st Qu.:1966   1st Qu.:118.0   1st Qu.:239.5   1st Qu.:126.0  
##  Median :1985   Median :128.0   Median :259.0   Median :130.0  
##  Mean   :1983   Mean   :122.6   Mean   :240.5   Mean   :129.6  
##  3rd Qu.:2000   3rd Qu.:135.5   3rd Qu.:266.0   3rd Qu.:138.0  
##  Max.   :2016   Max.   :149.0   Max.   :275.0   Max.   :159.0  
##      INTER5           MAXT           SUMT0            SUMT5       
##  Min.   : 44.0   Min.   :19.28   Min.   : 509.7   Min.   : 494.5  
##  1st Qu.:121.5   1st Qu.:24.28   1st Qu.:1701.8   1st Qu.:1638.6  
##  Median :126.0   Median :25.56   Median :1806.2   Median :1742.3  
##  Mean   :124.5   Mean   :25.00   Mean   :1689.5   Mean   :1625.2  
##  3rd Qu.:134.0   3rd Qu.:26.11   3rd Qu.:1906.7   3rd Qu.:1840.7  
##  Max.   :150.0   Max.   :26.61   Max.   :2176.9   Max.   :2117.4  
##       T220             T225            FT220             FT225     
##  Min.   : 412.2   Min.   : 367.1   Min.   :   1.83   Min.   :   0  
##  1st Qu.: 540.2   1st Qu.: 497.8   1st Qu.:1042.46   1st Qu.:1015  
##  Median : 624.6   Median : 587.9   Median :1215.96   Median :1202  
##  Mean   : 688.2   Mean   : 650.6   Mean   :1045.99   Mean   :1026  
##  3rd Qu.: 776.3   3rd Qu.: 753.5   3rd Qu.:1313.04   3rd Qu.:1291  
##  Max.   :1317.1   Max.   :1287.3   Max.   :1502.66   Max.   :1488  
##      SPEEDT           SUMPREC      
##  Min.   :-0.9026   Min.   :  3.06  
##  1st Qu.: 0.1718   1st Qu.: 88.67  
##  Median : 0.2682   Median :171.70  
##  Mean   : 0.1971   Mean   :168.32  
##  3rd Qu.: 0.2956   3rd Qu.:222.09  
##  Max.   : 0.5719   Max.   :477.00  
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/lena/24859099999 BROLOGYAKHATAT.txt"
## The number of del/rep rows by column precipitation= 394 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##      Day Month Year PRECIP TMEAN
## 5186  27     5 1988   0.00 13.22
## 5187  28     5 1988   0.00 12.39
## 5188  29     5 1988   4.06 13.11
## 5189  30     5 1988   0.00 11.44
## 5190  31     5 1988   0.00 15.50
## 5191   1     6 1988   0.00 12.89
## [1] "Structure"
## 'data.frame':	4797 obs. of  5 variables:
##  $ Day   : int  1 2 3 4 5 6 8 9 12 18 ...
##  $ Month : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Year  : int  1959 1959 1959 1959 1959 1959 1959 1959 1959 1959 ...
##  $ PRECIP: num  0 0.25 2.03 0.51 1.52 0.51 0 0 0 2.03 ...
##  $ TMEAN : num  -41.1 -39.3 -35.7 -35.4 -40.7 ...
## NULL
## [1] "Summary"
##      PRECIP             TMEAN        
##  Min.   :  0.0000   Min.   :-57.780  
##  1st Qu.:  0.0000   1st Qu.:-29.940  
##  Median :  0.0000   Median : -5.830  
##  Mean   :  0.9752   Mean   : -9.914  
##  3rd Qu.:  0.2500   3rd Qu.:  9.780  
##  Max.   :150.1100   Max.   : 26.440  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1959
```

```
## ****** Year: 1959 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1960
```

```
## ****** Year: 1960 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1961
```

```
## ****** Year: 1961 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1962
```

```
## ****** Year: 1962 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1963
```

```
## ****** Year: 1963 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1964
```

```
## ****** Year: 1964 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1965
```

```
## ****** Year: 1965 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1966
```

```
## ****** Year: 1966 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1967
```

```
## ****** Year: 1967 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1968
```

```
## ****** Year: 1968 
## #################### Skip a year!!!! 
## ****** Year: 1969 Observation: 186 Period: 1-3-1969 31-12-1969 ******
## ****** Year: 1970 Observation: 177 Period: 1-1-1970 26-12-1970 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1971
```

```
## ****** Year: 1971 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1972
```

```
## ****** Year: 1972 
## #################### Skip a year!!!! 
## ****** Year: 1973 Observation: 122 Period: 9-1-1973 22-12-1973 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1974 Observation: 167 Period: 5-1-1974 9-12-1974 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1975 Observation: 256 Period: 6-1-1975 31-12-1975 ******
## ****** Year: 1976 Observation: 279 Period: 1-1-1976 30-12-1976 ******
## ****** Year: 1977 Observation: 202 Period: 1-1-1977 27-12-1977 ******
## ****** Year: 1978 Observation: 335 Period: 1-1-1978 31-12-1978 ******
## ****** Year: 1979 Observation: 361 Period: 1-1-1979 31-12-1979 ******
## ****** Year: 1980 Observation: 360 Period: 1-1-1980 31-12-1980 ******
## ****** Year: 1981 Observation: 355 Period: 1-1-1981 30-12-1981 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1982
```

```
## ****** Year: 1982 
## #################### Skip a year!!!! 
## ****** Year: 1983 Observation: 282 Period: 2-1-1983 31-12-1983 ******
## ****** Year: 1984 Observation: 355 Period: 1-1-1984 31-12-1984 ******
## ****** Year: 1985 Observation: 359 Period: 1-1-1985 31-12-1985 ******
## ****** Year: 1986 Observation: 362 Period: 1-1-1986 31-12-1986 ******
## ****** Year: 1987 Observation: 359 Period: 1-1-1987 31-12-1987 ******
## ****** Year: 1988 Observation: 152 Period: 1-1-1988 1-6-1988 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## 
## elapsed time is 10.860000 seconds 
## 'data.frame':	17 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1969 1970 1973 1974 1975 1976 1977 1978 1979 1980 ...
##  $ ObsBeg      : chr  "1-3-1969" "1-1-1970" "9-1-1973" "5-1-1974" ...
##  $ ObsEnd      : chr  "31-12-1969" "26-12-1970" "22-12-1973" "9-12-1974" ...
##  $ StartSG     : num  38 83 38 73 70 108 83 126 129 144 ...
##  $ EndSG       : num  121 126 104 139 189 221 169 236 253 261 ...
##  $ STDAT0      : chr  "14-5-1969" "19-5-1970" "4-5-1973" "6-5-1974" ...
##  $ STDAT5      : chr  "22-5-1969" "20-5-1970" "10-5-1973" "11-5-1974" ...
##  $ FDAT0       : chr  "18-9-1969" "28-9-1970" "10-10-1973" "30-9-1974" ...
##  $ FDAT5       : chr  "10-9-1969" "12-9-1970" "21-9-1973" "17-9-1974" ...
##  $ INTER0      : num  127 132 159 147 140 133 145 120 128 120 ...
##  $ INTER5      : num  116 115 140 130 135 130 127 118 124 112 ...
##  $ MAXT        : num  23.5 21.8 23.5 24.3 25.8 ...
##  $ MDAT        : chr  "2-8-1969" "26-6-1970" "4-8-1973" "22-7-1974" ...
##  $ SUMT0       : num  1113 530 830 859 1652 ...
##  $ SUMT5       : num  1074 484 816 799 1584 ...
##  $ T220        : num  1113 530 830 859 1499 ...
##  $ T225        : num  1074 484 816 799 1466 ...
##  $ FT220       : num  4 0 830 859 113 ...
##  $ FT225       : num  0 0 816 799 105 ...
##  $ SPEEDT      : num  -0.41657 -0.69569 -0.56441 -0.50535 -0.00178 ...
##  $ SUMPREC     : num  226.82 363.22 0 1.53 82.83 ...
## NULL
##    Station_Code Year   ObsBeg     ObsEnd StartSG EndSG    STDAT0    STDAT5
## 11        23365 1969 1-3-1969 31-12-1969      38   121 14-5-1969 22-5-1969
## 12        23365 1970 1-1-1970 26-12-1970      83   126 19-5-1970 20-5-1970
## 15        23365 1973 9-1-1973 22-12-1973      38   104  4-5-1973 10-5-1973
## 16        23365 1974 5-1-1974  9-12-1974      73   139  6-5-1974 11-5-1974
## 17        23365 1975 6-1-1975 31-12-1975      70   189  6-5-1975 16-5-1975
## 18        23365 1976 1-1-1976 30-12-1976     108   221 16-5-1976 30-5-1976
##         FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT   SUMT0   SUMT5
## 11  18-9-1969 10-9-1969    127    116 23.50  2-8-1969 1113.03 1073.69
## 12  28-9-1970 12-9-1970    132    115 21.78 26-6-1970  530.49  484.33
## 15 10-10-1973 21-9-1973    159    140 23.50  4-8-1973  829.83  816.05
## 16  30-9-1974 17-9-1974    147    130 24.28 22-7-1974  858.53  799.25
## 17  23-9-1975 18-9-1975    140    135 25.78  7-8-1975 1652.30 1583.74
## 18  26-9-1976 23-9-1976    133    130 23.00  1-7-1976 1517.71 1453.37
##       T220    T225  FT220  FT225       SPEEDT SUMPREC
## 11 1113.03 1073.69   4.00   0.00 -0.416573700  226.82
## 12  530.49  484.33   0.00   0.00 -0.695687863  363.22
## 15  829.83  816.05 829.83 816.05 -0.564414892    0.00
## 16  858.53  799.25 858.53 799.25 -0.505349244    1.53
## 17 1499.42 1466.08 113.44 104.77 -0.001777226   82.83
## 18  921.82  876.77 601.44 587.32  0.109675817   27.70
##       Year         StartSG          EndSG           INTER0     
##  Min.   :1969   Min.   : 38.0   Min.   :104.0   Min.   : 18.0  
##  1st Qu.:1975   1st Qu.: 83.0   1st Qu.:152.0   1st Qu.:120.0  
##  Median :1979   Median :126.0   Median :221.0   Median :128.0  
##  Mean   :1979   Mean   :106.8   Mean   :203.4   Mean   :124.8  
##  3rd Qu.:1984   3rd Qu.:134.0   3rd Qu.:256.0   3rd Qu.:138.0  
##  Max.   :1988   Max.   :148.0   Max.   :268.0   Max.   :159.0  
##      INTER5           MAXT           SUMT0          SUMT5       
##  Min.   : 17.0   Min.   :15.50   Min.   : 267   Min.   : 218.3  
##  1st Qu.:115.0   1st Qu.:23.50   1st Qu.:1062   1st Qu.:1038.6  
##  Median :124.0   Median :23.72   Median :1540   Median :1459.4  
##  Mean   :117.2   Mean   :23.68   Mean   :1331   Mean   :1272.8  
##  3rd Qu.:130.0   3rd Qu.:25.00   3rd Qu.:1681   3rd Qu.:1622.8  
##  Max.   :140.0   Max.   :26.44   Max.   :1912   Max.   :1833.2  
##       T220             T225            FT220            FT225       
##  Min.   : 267.0   Min.   : 218.3   Min.   :   0.0   Min.   :   0.0  
##  1st Qu.: 536.7   1st Qu.: 498.5   1st Qu.: 186.9   1st Qu.: 177.9  
##  Median : 643.6   Median : 600.5   Median : 858.5   Median : 816.0  
##  Mean   : 732.1   Mean   : 695.9   Mean   : 707.2   Mean   : 688.4  
##  3rd Qu.: 899.4   3rd Qu.: 876.8   3rd Qu.:1155.8   3rd Qu.:1143.1  
##  Max.   :1499.4   Max.   :1466.1   Max.   :1368.6   Max.   :1341.3  
##      SPEEDT            SUMPREC     
##  Min.   :-0.69569   Min.   :  0.0  
##  1st Qu.:-0.08367   1st Qu.: 27.7  
##  Median : 0.10968   Median :125.8  
##  Mean   : 0.02167   Mean   :119.6  
##  3rd Qu.: 0.25419   3rd Qu.:176.8  
##  Max.   : 0.53781   Max.   :363.2  
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/north/20973099999 KRESTI.txt"
## The number of del/rep rows by column precipitation= 751 
## The number of del/rep rows by column temp= 151 
## [1] "Tail"
##       Day Month Year PRECIP  TMEAN
## 10340  28     2 2001   0.00 -49.00
## 10341   6     3 2001   0.00 -37.56
## 10342  15     3 2001   0.00 -36.33
## 10343  16     3 2001   0.00 -38.00
## 10346  25     4 2001   0.00 -25.22
## 10347  27     4 2001   0.76 -19.39
## [1] "Structure"
## 'data.frame':	9445 obs. of  5 variables:
##  $ Day   : int  16 18 19 21 23 24 1 3 10 23 ...
##  $ Month : int  4 4 4 4 4 4 5 5 5 5 ...
##  $ Year  : int  1955 1955 1955 1955 1955 1955 1955 1955 1955 1955 ...
##  $ PRECIP: num  1.52 0.76 1.02 4.06 1.52 1.02 0.25 0 0.51 0.51 ...
##  $ TMEAN : num  -5.28 -1.67 -6 -1 -14.28 ...
## NULL
## [1] "Summary"
##      PRECIP            TMEAN       
##  Min.   :  0.000   Min.   :-55.06  
##  1st Qu.:  0.000   1st Qu.:-29.00  
##  Median :  0.000   Median :-14.61  
##  Mean   :  3.174   Mean   :-15.10  
##  3rd Qu.:  1.020   3rd Qu.:  0.39  
##  Max.   :150.110   Max.   : 18.50  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
## ****** Year: 1955 Observation: 72 Period: 16-4-1955 31-12-1955 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1956
```

```
## ****** Year: 1956 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1957
```

```
## ****** Year: 1957 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1958
```

```
## ****** Year: 1958 
## #################### Skip a year!!!! 
## ****** Year: 1959 Observation: 124 Period: 7-1-1959 31-12-1959 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1960
```

```
## ****** Year: 1960 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1961
```

```
## ****** Year: 1961 
## #################### Skip a year!!!! 
## ****** Year: 1962 Observation: 260 Period: 3-1-1962 31-12-1962 ******
## ****** Year: 1963 Observation: 274 Period: 3-1-1963 31-12-1963 ******
## ****** Year: 1964 Observation: 279 Period: 3-1-1964 31-12-1964 ******
## ****** Year: 1965 Observation: 257 Period: 1-1-1965 31-12-1965 ******
## ****** Year: 1966 Observation: 339 Period: 1-1-1966 31-12-1966 ******
## ****** Year: 1967 Observation: 330 Period: 1-1-1967 29-12-1967 ******
## ****** Year: 1968 Observation: 315 Period: 3-1-1968 31-12-1968 ******
## ****** Year: 1969 Observation: 331 Period: 1-1-1969 31-12-1969 ******
## ****** Year: 1970 Observation: 331 Period: 1-1-1970 31-12-1970 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1971
```

```
## ****** Year: 1971 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1972
```

```
## ****** Year: 1972 
## #################### Skip a year!!!! 
## ****** Year: 1973 Observation: 281 Period: 1-1-1973 31-12-1973 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1974
```

```
## ****** Year: 1974 
## #################### Skip a year!!!! 
## ****** Year: 1975 Observation: 342 Period: 1-1-1975 31-12-1975 ******
## ****** Year: 1976 Observation: 308 Period: 1-1-1976 31-12-1976 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1977
```

```
## ****** Year: 1977 
## #################### Skip a year!!!! 
## ****** Year: 1978 Observation: 218 Period: 1-1-1978 4-10-1978 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1979
```

```
## ****** Year: 1979 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1980
```

```
## ****** Year: 1980 
## #################### Skip a year!!!! 
## ****** Year: 1981 Observation: 307 Period: 1-1-1981 31-12-1981 ******
## ****** Year: 1982 Observation: 265 Period: 1-1-1982 31-12-1982 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1983
```

```
## ****** Year: 1983 
## #################### Skip a year!!!! 
## ****** Year: 1984 Observation: 278 Period: 1-1-1984 31-12-1984 ******
## ****** Year: 1985 Observation: 346 Period: 1-1-1985 31-12-1985 ******
## ****** Year: 1986 Observation: 340 Period: 1-1-1986 31-12-1986 ******
## ****** Year: 1987 Observation: 355 Period: 1-1-1987 31-12-1987 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1988
```

```
## ****** Year: 1988 
## #################### Skip a year!!!! 
## ****** Year: 1989 Observation: 359 Period: 1-1-1989 31-12-1989 ******
## ****** Year: 1990 Observation: 358 Period: 1-1-1990 31-12-1990 ******
## ****** Year: 1991 Observation: 282 Period: 1-1-1991 31-12-1991 ******
## ****** Year: 1992 Observation: 141 Period: 4-1-1992 7-12-1992 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1993 Observation: 168 Period: 30-1-1993 31-12-1993 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1994
```

```
## ****** Year: 1994 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1995
```

```
## ****** Year: 1995 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1996
```

```
## ****** Year: 1996 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1997
```

```
## ****** Year: 1997 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1998
```

```
## ****** Year: 1998 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1999
```

```
## ****** Year: 1999 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2000
```

```
## ****** Year: 2000 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2001
```

```
## ****** Year: 2001 
## #################### Skip a year!!!! 
## 
## elapsed time is 17.840000 seconds 
## 'data.frame':	26 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1955 1959 1962 1963 1964 1965 1966 1967 1968 1969 ...
##  $ ObsBeg      : chr  "16-4-1955" "7-1-1959" "3-1-1962" "3-1-1963" ...
##  $ ObsEnd      : chr  "31-12-1955" "31-12-1959" "31-12-1962" "31-12-1963" ...
##  $ StartSG     : num  14 34 123 162 127 95 181 165 163 150 ...
##  $ EndSG       : num  38 57 159 200 193 146 208 222 184 191 ...
##  $ STDAT0      : chr  "19-6-1955" "3-7-1959" "16-7-1962" "17-7-1963" ...
##  $ STDAT5      : chr  "26-6-1955" "8-8-1959" "18-7-1962" "20-7-1963" ...
##  $ FDAT0       : chr  "30-8-1955" "14-9-1959" "28-8-1962" "26-8-1963" ...
##  $ FDAT5       : chr  "30-8-1955" "8-9-1959" "23-8-1962" "23-8-1963" ...
##  $ INTER0      : num  72 73 43 40 75 50 27 66 21 43 ...
##  $ INTER5      : num  69 44 36 35 66 41 27 55 21 41 ...
##  $ MAXT        : num  13.8 12.8 16.8 13.9 14 ...
##  $ MDAT        : chr  "28-6-1955" "8-8-1959" "29-7-1962" "12-8-1963" ...
##  $ SUMT0       : num  165 187 482 445 463 ...
##  $ SUMT5       : num  129 144 394 335 367 ...
##  $ T220        : num  165 187 468 210 330 ...
##  $ T225        : num  129 144 394 140 289 ...
##  $ FT220       : num  165.4 186.8 93 217.1 99.1 ...
##  $ FT225       : num  129.2 144.4 88.7 199.7 67.6 ...
##  $ SPEEDT      : num  -0.8196 -0.597 -0.0946 0.6185 -0.0147 ...
##  $ SUMPREC     : num  79.8 76.7 352 478 708.4 ...
## NULL
##    Station_Code Year    ObsBeg     ObsEnd StartSG EndSG    STDAT0
## 1         23365 1955 16-4-1955 31-12-1955      14    38 19-6-1955
## 5         23365 1959  7-1-1959 31-12-1959      34    57  3-7-1959
## 8         23365 1962  3-1-1962 31-12-1962     123   159 16-7-1962
## 9         23365 1963  3-1-1963 31-12-1963     162   200 17-7-1963
## 10        23365 1964  3-1-1964 31-12-1964     127   193 27-6-1964
## 11        23365 1965  1-1-1965 31-12-1965      95   146  9-7-1965
##       STDAT5     FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT  SUMT0
## 1  26-6-1955 30-8-1955 30-8-1955     72     69 13.78 28-6-1955 165.42
## 5   8-8-1959 14-9-1959  8-9-1959     73     44 12.78  8-8-1959 186.78
## 8  18-7-1962 28-8-1962 23-8-1962     43     36 16.78 29-7-1962 482.29
## 9  20-7-1963 26-8-1963 23-8-1963     40     35 13.89 12-8-1963 445.41
## 10  8-7-1964 10-9-1964  9-9-1964     75     66 14.00 10-7-1964 463.37
## 11 15-7-1965 28-8-1965 21-8-1965     50     41 15.44  9-8-1965 581.01
##     SUMT5   T220   T225  FT220  FT225      SPEEDT SUMPREC
## 1  129.18 165.42 129.18 165.42 129.18 -0.81955815   79.77
## 5  144.39 186.78 144.39 186.78 144.39 -0.59696082   76.71
## 8  393.68 467.58 393.68  93.01  88.68 -0.09457575  352.04
## 9  334.61 210.31 140.16 217.05 199.67  0.61854545  478.03
## 10 366.91 330.00 288.68  99.07  67.61 -0.01470513  708.41
## 11 486.00 580.62 486.00  24.06   0.00 -0.18380796  353.30
##       Year         StartSG          EndSG           INTER0     
##  Min.   :1955   Min.   : 14.0   Min.   : 38.0   Min.   :19.00  
##  1st Qu.:1966   1st Qu.:129.5   1st Qu.:179.5   1st Qu.:31.25  
##  Median :1976   Median :161.0   Median :195.0   Median :43.50  
##  Mean   :1976   Mean   :145.1   Mean   :182.2   Mean   :45.88  
##  3rd Qu.:1986   3rd Qu.:173.5   3rd Qu.:211.0   3rd Qu.:64.00  
##  Max.   :1993   Max.   :223.0   Max.   :247.0   Max.   :75.00  
##                                                                
##      INTER5           MAXT           SUMT0           SUMT5      
##  Min.   :12.00   Min.   :11.33   Min.   :165.4   Min.   :129.2  
##  1st Qu.:26.25   1st Qu.:13.43   1st Qu.:339.6   1st Qu.:238.9  
##  Median :41.00   Median :14.34   Median :433.6   Median :326.7  
##  Mean   :39.46   Mean   :14.68   Mean   :411.9   Mean   :315.3  
##  3rd Qu.:47.75   3rd Qu.:16.45   3rd Qu.:497.2   3rd Qu.:392.4  
##  Max.   :69.00   Max.   :18.50   Max.   :609.9   Max.   :486.0  
##                                                                 
##       T220            T225            FT220            FT225      
##  Min.   :  0.0   Min.   :  0.00   Min.   : 24.06   Min.   :  0.0  
##  1st Qu.:103.4   1st Qu.: 58.53   1st Qu.:111.52   1st Qu.: 94.5  
##  Median :165.8   Median :119.22   Median :194.76   Median :140.6  
##  Mean   :194.2   Mean   :148.46   Mean   :213.90   Mean   :177.0  
##  3rd Qu.:264.5   3rd Qu.:232.41   3rd Qu.:310.27   3rd Qu.:214.0  
##  Max.   :580.6   Max.   :486.00   Max.   :487.19   Max.   :421.7  
##                                                                   
##      SPEEDT           SUMPREC      
##  Min.   :-0.9473   Min.   :  4.31  
##  1st Qu.:-0.0965   1st Qu.: 22.18  
##  Median : 0.3377   Median : 78.24  
##  Mean   : 0.3695   Mean   :161.63  
##  3rd Qu.: 0.6532   3rd Qu.:307.09  
##  Max.   : 2.5000   Max.   :708.41  
##  NA's   :1                         
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/north/20982099999 VOLOCHANKA.txt"
## The number of del/rep rows by column precipitation= 491 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##      Day Month Year PRECIP  TMEAN
## 4958  26    12 2015   0.00 -31.89
## 4959  27    12 2015   0.00 -35.72
## 4960  28    12 2015   0.00 -35.11
## 4961  29    12 2015   0.00 -36.00
## 4962  30    12 2015   0.00 -33.06
## 4963  31    12 2015   0.25 -35.17
## [1] "Structure"
## 'data.frame':	4472 obs. of  5 variables:
##  $ Day   : int  3 5 10 1 25 31 11 18 15 17 ...
##  $ Month : int  1 1 1 5 5 5 6 6 7 7 ...
##  $ Year  : int  1937 1937 1937 1937 1937 1937 1937 1937 1937 1937 ...
##  $ PRECIP: num  0 0 0 0 0 0 0 0 0 0 ...
##  $ TMEAN : num  -32.06 -39.28 -7.67 1.78 -9.44 ...
## NULL
## [1] "Summary"
##      PRECIP            TMEAN        
##  Min.   :  0.000   Min.   :-52.220  
##  1st Qu.:  0.000   1st Qu.:-27.500  
##  Median :  0.000   Median :-12.415  
##  Mean   :  3.302   Mean   :-12.524  
##  3rd Qu.:  1.020   3rd Qu.:  3.292  
##  Max.   :150.110   Max.   : 26.440  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1937
```

```
## ****** Year: 1937 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1938
```

```
## ****** Year: 1938 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1939
```

```
## ****** Year: 1939 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1940
```

```
## ****** Year: 1940 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1941
```

```
## ****** Year: 1941 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1942
```

```
## ****** Year: 1942 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1943
```

```
## ****** Year: 1943 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1944
```

```
## ****** Year: 1944 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1945
```

```
## ****** Year: 1945 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1946
```

```
## ****** Year: 1946 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1947
```

```
## ****** Year: 1947 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1948
```

```
## ****** Year: 1948 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1949
```

```
## ****** Year: 1949 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1950
```

```
## ****** Year: 1950 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1951
```

```
## ****** Year: 1951 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1952
```

```
## ****** Year: 1952 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1953
```

```
## ****** Year: 1953 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1954
```

```
## ****** Year: 1954 
## #################### Skip a year!!!! 
## ****** Year: 1955 Observation: 114 Period: 14-4-1955 28-12-1955 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1956 Observation: 195 Period: 1-1-1956 31-12-1956 ******
## ****** Year: 1957 Observation: 145 Period: 1-1-1957 31-12-1957 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1958 Observation: 150 Period: 2-1-1958 27-12-1958 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1959 Observation: 154 Period: 2-1-1959 31-12-1959 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1960 Observation: 241 Period: 2-1-1960 29-12-1960 ******
## ****** Year: 1961 Observation: 279 Period: 2-1-1961 30-12-1961 ******
## ****** Year: 1962 Observation: 271 Period: 4-1-1962 31-12-1962 ******
## ****** Year: 1963 Observation: 278 Period: 2-1-1963 31-12-1963 ******
## ****** Year: 1964 Observation: 304 Period: 2-1-1964 31-12-1964 ******
## ****** Year: 1965 Observation: 253 Period: 2-1-1965 31-12-1965 ******
## ****** Year: 1966 Observation: 333 Period: 1-1-1966 31-12-1966 ******
## ****** Year: 1967 Observation: 255 Period: 1-1-1967 29-12-1967 ******
## ****** Year: 1968 Observation: 183 Period: 2-1-1968 24-12-1968 ******
## ****** Year: 1969 Observation: 203 Period: 1-1-1969 28-12-1969 ******
## ****** Year: 1970 Observation: 170 Period: 2-1-1970 31-12-1970 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1971
```

```
## ****** Year: 1971 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1972
```

```
## ****** Year: 1972 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1973
```

```
## ****** Year: 1973 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1974
```

```
## ****** Year: 1974 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1975
```

```
## ****** Year: 1975 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1976
```

```
## ****** Year: 1976 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1977
```

```
## ****** Year: 1977 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1978
```

```
## ****** Year: 1978 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1979
```

```
## ****** Year: 1979 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1980
```

```
## ****** Year: 1980 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1981
```

```
## ****** Year: 1981 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1982
```

```
## ****** Year: 1982 
## #################### Skip a year!!!! 
## ****** Year: 1983 
## #################### Skip a year!!!! 
## ****** Year: 1984 Observation: 79 Period: 1-1-1984 21-12-1984 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1985
```

```
## ****** Year: 1985 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1986
```

```
## ****** Year: 1986 
## #################### Skip a year!!!! 
## ****** Year: 1987 Observation: 164 Period: 1-1-1987 29-12-1987 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1988
```

```
## ****** Year: 1988 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1989
```

```
## ****** Year: 1989 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1990
```

```
## ****** Year: 1990 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1991
```

```
## ****** Year: 1991 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1992
```

```
## ****** Year: 1992 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1993
```

```
## ****** Year: 1993 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1994
```

```
## ****** Year: 1994 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1995
```

```
## ****** Year: 1995 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1996
```

```
## ****** Year: 1996 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1997
```

```
## ****** Year: 1997 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1998
```

```
## ****** Year: 1998 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1999
```

```
## ****** Year: 1999 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2000
```

```
## ****** Year: 2000 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2001
```

```
## ****** Year: 2001 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2002
```

```
## ****** Year: 2002 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2003
```

```
## ****** Year: 2003 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2004
```

```
## ****** Year: 2004 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2005
```

```
## ****** Year: 2005 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2006
```

```
## ****** Year: 2006 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2007
```

```
## ****** Year: 2007 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2008
```

```
## ****** Year: 2008 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2009
```

```
## ****** Year: 2009 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2010
```

```
## ****** Year: 2010 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2011
```

```
## ****** Year: 2011 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2012
```

```
## ****** Year: 2012 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2013
```

```
## ****** Year: 2013 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2014
```

```
## ****** Year: 2014 
## #################### Skip a year!!!! 
## ****** Year: 2015 Observation: 212 Period: 27-5-2015 31-12-2015 ******
## 
## elapsed time is 9.250000 seconds 
## 'data.frame':	19 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1955 1956 1957 1958 1959 1960 1961 1962 1963 1964 ...
##  $ ObsBeg      : chr  "14-4-1955" "1-1-1956" "1-1-1957" "2-1-1958" ...
##  $ ObsEnd      : chr  "28-12-1955" "31-12-1956" "31-12-1957" "27-12-1958" ...
##  $ StartSG     : num  12 93 70 70 43 94 133 111 151 141 ...
##  $ EndSG       : num  66 137 109 98 83 180 209 196 212 221 ...
##  $ STDAT0      : chr  "9-6-1955" "10-6-1956" "31-5-1957" "14-6-1958" ...
##  $ STDAT5      : chr  "22-6-1955" "28-6-1956" "21-6-1957" "14-6-1958" ...
##  $ FDAT0       : chr  "19-9-1955" "15-9-1956" "8-9-1957" "5-9-1958" ...
##  $ FDAT5       : chr  "12-9-1955" "8-9-1956" "28-8-1957" "13-8-1958" ...
##  $ INTER0      : num  102 97 100 83 121 120 94 97 79 91 ...
##  $ INTER5      : num  87 87 84 60 115 115 86 93 77 90 ...
##  $ MAXT        : num  22.4 22.5 21.2 23.8 21.9 ...
##  $ MDAT        : chr  "25-6-1955" "15-7-1956" "29-6-1957" "13-7-1958" ...
##  $ SUMT0       : num  538 481 401 270 435 ...
##  $ SUMT5       : num  524 442 371 235 410 ...
##  $ T220        : num  538 481 401 270 435 ...
##  $ T225        : num  524 442 371 235 410 ...
##  $ FT220       : num  537.95 0.28 401.28 270.26 435.16 ...
##  $ FT225       : num  524 0 371 235 410 ...
##  $ SPEEDT      : num  -0.577 -0.588 -0.818 -0.854 -0.537 ...
##  $ SUMPREC     : num  34.8 39.6 11.4 29 385.8 ...
## NULL
##    Station_Code Year    ObsBeg     ObsEnd StartSG EndSG    STDAT0
## 19        23365 1955 14-4-1955 28-12-1955      12    66  9-6-1955
## 20        23365 1956  1-1-1956 31-12-1956      93   137 10-6-1956
## 21        23365 1957  1-1-1957 31-12-1957      70   109 31-5-1957
## 22        23365 1958  2-1-1958 27-12-1958      70    98 14-6-1958
## 23        23365 1959  2-1-1959 31-12-1959      43    83 27-5-1959
## 24        23365 1960  2-1-1960 29-12-1960      94   180 23-5-1960
##       STDAT5     FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT  SUMT0
## 19 22-6-1955 19-9-1955 12-9-1955    102     87 22.39 25-6-1955 537.95
## 20 28-6-1956 15-9-1956  8-9-1956     97     87 22.50 15-7-1956 480.63
## 21 21-6-1957  8-9-1957 28-8-1957    100     84 21.22 29-6-1957 401.28
## 22 14-6-1958  5-9-1958 13-8-1958     83     60 23.78 13-7-1958 270.26
## 23 22-6-1959 25-9-1959 22-9-1959    121    115 21.89 10-8-1959 435.16
## 24 29-5-1960 20-9-1960 15-9-1960    120    115 19.17 18-7-1960 793.67
##     SUMT5   T220   T225  FT220  FT225      SPEEDT SUMPREC
## 19 524.33 537.95 524.33 537.95 524.33 -0.57665971   34.82
## 20 441.59 480.63 441.59   0.28   0.00 -0.58846251   39.64
## 21 371.05 401.28 371.05 401.28 371.05 -0.81809146   11.44
## 22 234.94 270.26 234.94 270.26 234.94 -0.85420348   28.96
## 23 410.38 435.16 410.38 435.16 410.38 -0.53724096  385.82
## 24 756.12 781.22 749.23  15.78   6.89 -0.01562436  300.71
##       Year         StartSG        EndSG           INTER0      
##  Min.   :1955   Min.   :  4   Min.   : 66.0   Min.   : 72.00  
##  1st Qu.:1960   1st Qu.: 70   1st Qu.:108.0   1st Qu.: 85.00  
##  Median :1964   Median : 93   Median :138.0   Median : 94.00  
##  Mean   :1968   Mean   : 90   Mean   :146.5   Mean   : 95.32  
##  3rd Qu.:1968   3rd Qu.:122   3rd Qu.:188.0   3rd Qu.:104.50  
##  Max.   :2015   Max.   :167   Max.   :235.0   Max.   :121.00  
##      INTER5            MAXT           SUMT0            SUMT5      
##  Min.   : 59.00   Min.   :17.94   Min.   : 176.6   Min.   :162.3  
##  1st Qu.: 73.50   1st Qu.:21.14   1st Qu.: 429.9   1st Qu.:386.7  
##  Median : 86.00   Median :22.50   Median : 538.0   Median :524.3  
##  Mean   : 83.63   Mean   :22.49   Mean   : 609.1   Mean   :560.5  
##  3rd Qu.: 91.50   3rd Qu.:23.95   3rd Qu.: 785.4   3rd Qu.:747.0  
##  Max.   :115.00   Max.   :26.44   Max.   :1062.1   Max.   :990.9  
##       T220             T225            FT220            FT225        
##  Min.   : 127.6   Min.   : 81.16   Min.   :  0.28   Min.   :  0.000  
##  1st Qu.: 375.8   1st Qu.:349.12   1st Qu.: 21.96   1st Qu.:  3.445  
##  Median : 445.1   Median :410.38   Median :246.93   Median :202.530  
##  Mean   : 505.8   Mean   :466.74   Mean   :242.29   Mean   :219.930  
##  3rd Qu.: 621.2   3rd Qu.:583.34   3rd Qu.:428.81   3rd Qu.:394.665  
##  Max.   :1062.1   Max.   :990.91   Max.   :606.95   Max.   :583.840  
##      SPEEDT             SUMPREC      
##  Min.   :-0.854204   Min.   : 11.44  
##  1st Qu.:-0.582561   1st Qu.: 37.56  
##  Median :-0.239554   Median :188.23  
##  Mean   :-0.311701   Mean   :216.29  
##  3rd Qu.:-0.004669   3rd Qu.:297.30  
##  Max.   : 0.250107   Max.   :664.21  
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/north/21908099999 DZALINDA.txt"
## The number of del/rep rows by column precipitation= 332 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##       Day Month Year PRECIP  TMEAN
## 14709  15     4 2013      0 -21.56
## 14710  16     4 2013      0 -13.83
## 14711  17     4 2013      0  -8.28
## 14712  18     4 2013      0  -2.50
## 14713  19     4 2013      0  -4.39
## 14714  20     4 2013      0  -1.33
## [1] "Structure"
## 'data.frame':	14382 obs. of  5 variables:
##  $ Day   : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ Month : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Year  : int  1959 1959 1959 1959 1959 1959 1959 1959 1959 1959 ...
##  $ PRECIP: num  0 0 0 0 0 0.51 0.25 0 0 0 ...
##  $ TMEAN : num  -59.6 -57.1 -55 -47.6 -34.8 ...
## NULL
## [1] "Summary"
##      PRECIP             TMEAN        
##  Min.   :  0.0000   Min.   :-62.280  
##  1st Qu.:  0.0000   1st Qu.:-30.280  
##  Median :  0.0000   Median :-10.940  
##  Mean   :  0.8173   Mean   :-12.717  
##  3rd Qu.:  0.5100   3rd Qu.:  5.428  
##  Max.   :150.1100   Max.   : 26.610  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
## ****** Year: 1959 Observation: 286 Period: 1-1-1959 31-12-1959 ******
## ****** Year: 1960 Observation: 279 Period: 1-1-1960 31-12-1960 ******
## ****** Year: 1961 Observation: 338 Period: 1-1-1961 31-12-1961 ******
## ****** Year: 1962 Observation: 352 Period: 1-1-1962 31-12-1962 ******
## ****** Year: 1963 Observation: 343 Period: 1-1-1963 31-12-1963 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1964
```

```
## ****** Year: 1964 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1965
```

```
## ****** Year: 1965 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1966
```

```
## ****** Year: 1966 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1967
```

```
## ****** Year: 1967 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1968
```

```
## ****** Year: 1968 
## #################### Skip a year!!!! 
## ****** Year: 1969 Observation: 342 Period: 1-1-1969 31-12-1969 ******
## ****** Year: 1970 Observation: 355 Period: 1-1-1970 31-12-1970 ******
## ****** Year: 1971 Observation: 170 Period: 1-1-1971 30-6-1971 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1972
```

```
## ****** Year: 1972 
## #################### Skip a year!!!! 
## ****** Year: 1973 Observation: 321 Period: 1-1-1973 31-12-1973 ******
## ****** Year: 1974 Observation: 308 Period: 2-1-1974 31-12-1974 ******
## ****** Year: 1975 Observation: 329 Period: 1-1-1975 31-12-1975 ******
## ****** Year: 1976 Observation: 332 Period: 1-1-1976 31-12-1976 ******
## ****** Year: 1977 Observation: 342 Period: 1-1-1977 31-12-1977 ******
## ****** Year: 1978 Observation: 322 Period: 1-1-1978 31-12-1978 ******
## ****** Year: 1979 Observation: 359 Period: 1-1-1979 31-12-1979 ******
## ****** Year: 1980 Observation: 363 Period: 1-1-1980 31-12-1980 ******
## ****** Year: 1981 Observation: 336 Period: 1-1-1981 31-12-1981 ******
## ****** Year: 1982 Observation: 340 Period: 1-1-1982 31-12-1982 ******
## ****** Year: 1983 Observation: 330 Period: 1-1-1983 29-12-1983 ******
## ****** Year: 1984 Observation: 308 Period: 2-1-1984 29-12-1984 ******
## ****** Year: 1985 Observation: 334 Period: 4-1-1985 31-12-1985 ******
## ****** Year: 1986 Observation: 334 Period: 1-1-1986 31-12-1986 ******
## ****** Year: 1987 Observation: 349 Period: 1-1-1987 31-12-1987 ******
## ****** Year: 1988 Observation: 341 Period: 1-1-1988 31-12-1988 ******
## ****** Year: 1989 Observation: 338 Period: 1-1-1989 31-12-1989 ******
## ****** Year: 1990 Observation: 350 Period: 1-1-1990 31-12-1990 ******
## ****** Year: 1991 Observation: 309 Period: 1-1-1991 31-12-1991 ******
## ****** Year: 1992 Observation: 305 Period: 2-1-1992 31-12-1992 ******
## ****** Year: 1993 Observation: 189 Period: 1-1-1993 15-12-1993 ******
## ****** Year: 1994 Observation: 135 Period: 5-1-1994 27-12-1994 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1995 Observation: 166 Period: 5-1-1995 20-12-1995 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1996 Observation: 172 Period: 5-1-1996 30-12-1996 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1997 Observation: 222 Period: 4-1-1997 31-12-1997 ******
## ****** Year: 1998 Observation: 241 Period: 1-1-1998 29-12-1998 ******
## ****** Year: 1999 Observation: 237 Period: 2-1-1999 30-12-1999 ******
## ****** Year: 2000 Observation: 122 Period: 2-1-2000 31-12-2000 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 2001 Observation: 261 Period: 2-1-2001 31-12-2001 ******
## ****** Year: 2002 Observation: 292 Period: 1-1-2002 31-12-2002 ******
## ****** Year: 2003 Observation: 219 Period: 1-1-2003 31-12-2003 ******
## ****** Year: 2004 Observation: 268 Period: 2-1-2004 9-12-2004 ******
## ****** Year: 2005 Observation: 261 Period: 15-1-2005 31-12-2005 ******
## ****** Year: 2006 Observation: 302 Period: 2-1-2006 31-12-2006 ******
## ****** Year: 2007 Observation: 342 Period: 1-1-2007 31-12-2007 ******
## ****** Year: 2008 Observation: 347 Period: 1-1-2008 31-12-2008 ******
## ****** Year: 2009 Observation: 353 Period: 1-1-2009 31-12-2009 ******
## ****** Year: 2010 Observation: 345 Period: 1-1-2010 31-12-2010 ******
## ****** Year: 2011 Observation: 332 Period: 2-1-2011 31-12-2011 ******
## ****** Year: 2012 Observation: 351 Period: 1-1-2012 31-12-2012 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2013
```

```
## ****** Year: 2013 
## #################### Skip a year!!!! 
## 
## elapsed time is 29.860000 seconds 
## 'data.frame':	48 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1959 1960 1961 1962 1963 1969 1970 1971 1973 1974 ...
##  $ ObsBeg      : chr  "1-1-1959" "1-1-1960" "1-1-1961" "1-1-1962" ...
##  $ ObsEnd      : chr  "31-12-1959" "31-12-1960" "31-12-1961" "31-12-1962" ...
##  $ StartSG     : num  116 124 151 164 172 131 152 160 133 137 ...
##  $ EndSG       : num  191 215 215 251 248 229 249 170 233 224 ...
##  $ STDAT0      : chr  "26-5-1959" "24-5-1960" "10-6-1961" "16-6-1962" ...
##  $ STDAT5      : chr  "30-5-1959" "1-6-1960" "12-6-1961" "22-6-1962" ...
##  $ FDAT0       : chr  "18-9-1959" "8-9-1960" "20-8-1961" "15-9-1962" ...
##  $ FDAT5       : chr  "10-9-1959" "6-9-1960" "16-8-1961" "12-9-1962" ...
##  $ INTER0      : num  115 107 71 91 80 101 100 10 107 94 ...
##  $ INTER5      : num  105 103 67 87 73 98 95 9 99 85 ...
##  $ MAXT        : num  23.3 21.1 22.8 24.8 22.8 ...
##  $ MDAT        : chr  "25-6-1959" "7-7-1960" "2-7-1961" "4-8-1962" ...
##  $ SUMT0       : num  808 993 941 980 930 ...
##  $ SUMT5       : num  750 944 858 905 853 ...
##  $ T220        : num  690 606 323 110 121 ...
##  $ T225        : num  673.5 575.8 298.8 84.5 86.3 ...
##  $ FT220       : num  119 371 430 875 797 ...
##  $ FT225       : num  91.4 354.2 398.8 836.3 756.4 ...
##  $ SPEEDT      : num  0.09 0.132 0.472 2.132 NA ...
##  $ SUMPREC     : num  26.4 253 75.2 77 59.7 ...
## NULL
##    Station_Code Year   ObsBeg     ObsEnd StartSG EndSG    STDAT0    STDAT5
## 1         23365 1959 1-1-1959 31-12-1959     116   191 26-5-1959 30-5-1959
## 2         23365 1960 1-1-1960 31-12-1960     124   215 24-5-1960  1-6-1960
## 3         23365 1961 1-1-1961 31-12-1961     151   215 10-6-1961 12-6-1961
## 4         23365 1962 1-1-1962 31-12-1962     164   251 16-6-1962 22-6-1962
## 5         23365 1963 1-1-1963 31-12-1963     172   248 22-6-1963 24-6-1963
## 11        23365 1969 1-1-1969 31-12-1969     131   229 23-5-1969 30-5-1969
##        FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT   SUMT0   SUMT5
## 1  18-9-1959 10-9-1959    115    105 23.33 25-6-1959  807.52  749.91
## 2   8-9-1960  6-9-1960    107    103 21.11  7-7-1960  992.61  943.99
## 3  20-8-1961 16-8-1961     71     67 22.83  2-7-1961  940.99  857.64
## 4  15-9-1962 12-9-1962     91     87 24.83  4-8-1962  980.24  904.67
## 5  10-9-1963  3-9-1963     80     73 22.78 30-7-1963  930.07  853.24
## 11  1-9-1969 31-8-1969    101     98 24.00 28-7-1969 1134.10 1090.04
##      T220   T225  FT220  FT225     SPEEDT SUMPREC
## 1  690.25 673.52 118.83  91.39 0.09003111   26.41
## 2  605.89 575.77 371.23 354.17 0.13167107  253.00
## 3  323.23 298.84 429.70 398.75 0.47217956   75.18
## 4  109.50  84.49 875.46 836.29 2.13233333   76.96
## 5  120.84  86.29 796.68 756.40         NA   59.69
## 11 416.82 388.49 715.05 711.27 0.09411960  363.47
##       Year         StartSG          EndSG           INTER0      
##  Min.   :1959   Min.   : 55.0   Min.   :112.0   Min.   : 10.00  
##  1st Qu.:1977   1st Qu.:116.8   1st Qu.:196.2   1st Qu.: 87.75  
##  Median :1988   Median :133.5   Median :227.0   Median : 96.00  
##  Mean   :1988   Mean   :128.9   Mean   :211.7   Mean   : 94.69  
##  3rd Qu.:2000   3rd Qu.:152.0   3rd Qu.:235.5   3rd Qu.:106.25  
##  Max.   :2012   Max.   :176.0   Max.   :256.0   Max.   :129.00  
##                                                                 
##      INTER5            MAXT           SUMT0            SUMT5       
##  Min.   :  9.00   Min.   :12.89   Min.   : 207.0   Min.   : 172.6  
##  1st Qu.: 81.00   1st Qu.:22.77   1st Qu.: 901.1   1st Qu.: 809.1  
##  Median : 90.50   Median :24.27   Median :1001.5   Median : 930.4  
##  Mean   : 88.06   Mean   :23.66   Mean   : 993.8   Mean   : 920.8  
##  3rd Qu.: 98.25   3rd Qu.:25.32   3rd Qu.:1137.8   3rd Qu.:1068.2  
##  Max.   :114.00   Max.   :26.61   Max.   :1387.9   Max.   :1323.2  
##                                                                    
##       T220             T225             FT220            FT225       
##  Min.   : 109.5   Min.   :  75.77   Min.   :   0.0   Min.   :   0.0  
##  1st Qu.: 316.9   1st Qu.: 287.53   1st Qu.: 335.8   1st Qu.: 309.8  
##  Median : 483.6   Median : 450.14   Median : 588.4   Median : 540.9  
##  Mean   : 506.7   Mean   : 472.01   Mean   : 523.7   Mean   : 496.0  
##  3rd Qu.: 684.5   3rd Qu.: 659.98   3rd Qu.: 734.9   3rd Qu.: 710.7  
##  Max.   :1045.1   Max.   :1006.26   Max.   :1029.0   Max.   :1006.0  
##                                                                      
##      SPEEDT            SUMPREC      
##  Min.   :-0.58714   Min.   : 26.41  
##  1st Qu.: 0.04671   1st Qu.: 63.00  
##  Median : 0.13167   Median : 97.93  
##  Mean   : 0.21072   Mean   :121.99  
##  3rd Qu.: 0.34317   3rd Qu.:136.02  
##  Max.   : 2.13233   Max.   :610.36  
##  NA's   :1                          
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/north/21921099999 KJUSJUR.txt"
## The number of del/rep rows by column precipitation= 318 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##       Day Month Year PRECIP  TMEAN
## 12343  17     4 2008      0 -17.94
## 12344  18     4 2008      0 -16.61
## 12345  19     4 2008      0 -14.83
## 12346  20     4 2008      0 -15.06
## 12347  21     4 2008      0 -14.22
## 12348  22     4 2008      0 -15.33
## [1] "Structure"
## 'data.frame':	12030 obs. of  5 variables:
##  $ Day   : int  8 10 11 17 18 20 21 22 1 4 ...
##  $ Month : int  1 1 1 1 1 1 1 1 2 2 ...
##  $ Year  : int  1948 1948 1948 1948 1948 1948 1948 1948 1948 1948 ...
##  $ PRECIP: num  0.03 0 0.05 0.1 0.05 0.1 0.05 0.05 0 0.03 ...
##  $ TMEAN : num  -30.4 -37.9 -38.5 -33.1 -43.2 ...
## NULL
## [1] "Summary"
##      PRECIP            TMEAN       
##  Min.   : 0.0000   Min.   :-58.89  
##  1st Qu.: 0.0000   1st Qu.:-30.28  
##  Median : 0.0000   Median :-13.39  
##  Mean   : 0.1272   Mean   :-13.59  
##  3rd Qu.: 0.0800   3rd Qu.:  4.00  
##  Max.   :15.0100   Max.   : 26.61  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1948
```

```
## ****** Year: 1948 
## #################### Skip a year!!!! 
## ****** Year: 1949 Observation: 159 Period: 2-1-1949 30-12-1949 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1950
```

```
## ****** Year: 1950 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1951
```

```
## ****** Year: 1951 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1952
```

```
## ****** Year: 1952 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1953
```

```
## ****** Year: 1953 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1954
```

```
## ****** Year: 1954 
## #################### Skip a year!!!! 
## ****** Year: 1955 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1956
```

```
## ****** Year: 1956 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1957
```

```
## ****** Year: 1957 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1958
```

```
## ****** Year: 1958 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1959
```

```
## ****** Year: 1959 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1960
```

```
## ****** Year: 1960 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1961
```

```
## ****** Year: 1961 
## #################### Skip a year!!!! 
## ****** Year: 1962 Observation: 111 Period: 4-1-1962 29-12-1962 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1963 Observation: 124 Period: 9-1-1963 29-12-1963 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1964
```

```
## ****** Year: 1964 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1965
```

```
## ****** Year: 1965 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1966
```

```
## ****** Year: 1966 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1967
```

```
## ****** Year: 1967 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1968
```

```
## ****** Year: 1968 
## #################### Skip a year!!!! 
## ****** Year: 1969 Observation: 335 Period: 1-1-1969 31-12-1969 ******
## ****** Year: 1970 Observation: 354 Period: 1-1-1970 31-12-1970 ******
## ****** Year: 1971 Observation: 170 Period: 1-1-1971 30-6-1971 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1972
```

```
## ****** Year: 1972 
## #################### Skip a year!!!! 
## ****** Year: 1973 Observation: 351 Period: 2-1-1973 28-12-1973 ******
## ****** Year: 1974 Observation: 351 Period: 1-1-1974 31-12-1974 ******
## ****** Year: 1975 Observation: 349 Period: 1-1-1975 31-12-1975 ******
## ****** Year: 1976 Observation: 321 Period: 1-1-1976 31-12-1976 ******
## ****** Year: 1977 Observation: 256 Period: 1-1-1977 29-12-1977 ******
## ****** Year: 1978 Observation: 247 Period: 1-1-1978 28-12-1978 ******
## ****** Year: 1979 Observation: 169 Period: 1-1-1979 29-12-1979 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1980 Observation: 302 Period: 1-1-1980 31-12-1980 ******
## ****** Year: 1981 Observation: 323 Period: 1-1-1981 31-12-1981 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1982
```

```
## ****** Year: 1982 
## #################### Skip a year!!!! 
## ****** Year: 1983 Observation: 240 Period: 2-1-1983 31-12-1983 ******
## ****** Year: 1984 Observation: 343 Period: 1-1-1984 31-12-1984 ******
## ****** Year: 1985 Observation: 344 Period: 1-1-1985 31-12-1985 ******
## ****** Year: 1986 Observation: 364 Period: 1-1-1986 31-12-1986 ******
## ****** Year: 1987 Observation: 362 Period: 1-1-1987 31-12-1987 ******
## ****** Year: 1988 Observation: 364 Period: 1-1-1988 31-12-1988 ******
## ****** Year: 1989 Observation: 361 Period: 1-1-1989 31-12-1989 ******
## ****** Year: 1990 Observation: 340 Period: 1-1-1990 31-12-1990 ******
## ****** Year: 1991 Observation: 361 Period: 1-1-1991 30-12-1991 ******
## ****** Year: 1992 Observation: 329 Period: 1-1-1992 31-12-1992 ******
## ****** Year: 1993 Observation: 352 Period: 1-1-1993 31-12-1993 ******
## ****** Year: 1994 Observation: 343 Period: 1-1-1994 31-12-1994 ******
## ****** Year: 1995 Observation: 350 Period: 1-1-1995 31-12-1995 ******
## ****** Year: 1996 Observation: 297 Period: 1-1-1996 31-12-1996 ******
## ****** Year: 1997 Observation: 349 Period: 1-1-1997 31-12-1997 ******
## ****** Year: 1998 Observation: 299 Period: 1-1-1998 31-12-1998 ******
## ****** Year: 1999 Observation: 300 Period: 1-1-1999 31-12-1999 ******
## ****** Year: 2000 Observation: 224 Period: 1-1-2000 26-9-2000 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2001
```

```
## ****** Year: 2001 
## #################### Skip a year!!!! 
## ****** Year: 2002 Observation: 141 Period: 1-6-2002 31-12-2002 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 2003 Observation: 347 Period: 1-1-2003 31-12-2003 ******
## ****** Year: 2004 Observation: 359 Period: 1-1-2004 31-12-2004 ******
## ****** Year: 2005 Observation: 346 Period: 1-1-2005 31-12-2005 ******
## ****** Year: 2006 Observation: 336 Period: 1-1-2006 31-12-2006 ******
## ****** Year: 2007 Observation: 341 Period: 2-1-2007 31-12-2007 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2008
```

```
## ****** Year: 2008 
## #################### Skip a year!!!! 
## 
## elapsed time is 23.810000 seconds 
## 'data.frame':	39 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1949 1962 1963 1969 1970 1971 1973 1974 1975 1976 ...
##  $ ObsBeg      : chr  "2-1-1949" "4-1-1962" "9-1-1963" "1-1-1969" ...
##  $ ObsEnd      : chr  "30-12-1949" "29-12-1962" "29-12-1963" "31-12-1969" ...
##  $ StartSG     : num  80 95 85 134 151 144 151 156 151 156 ...
##  $ EndSG       : num  133 108 111 231 250 170 256 248 251 247 ...
##  $ STDAT0      : chr  "29-6-1949" "3-6-1962" "12-6-1963" "27-5-1969" ...
##  $ STDAT5      : chr  "7-7-1949" "10-7-1962" "3-7-1963" "4-6-1969" ...
##  $ FDAT0       : chr  "9-10-1949" "20-8-1962" "10-9-1963" "4-9-1969" ...
##  $ FDAT5       : chr  "17-9-1949" "20-8-1962" "10-9-1963" "27-8-1969" ...
##  $ INTER0      : num  102 78 90 100 100 26 104 93 100 104 ...
##  $ INTER5      : num  80 75 84 90 96 26 96 78 94 104 ...
##  $ MAXT        : num  19 18.5 20.7 23.8 23.8 ...
##  $ MDAT        : chr  "12-7-1949" "11-7-1962" "13-7-1963" "29-7-1969" ...
##  $ SUMT0       : num  524 142 248 1119 1025 ...
##  $ SUMT5       : num  471 120 208 1046 915 ...
##  $ T220        : num  524 142 248 419 213 ...
##  $ T225        : num  471 120 208 385 190 ...
##  $ FT220       : num  524 142 248 697 788 ...
##  $ FT225       : num  471 120 208 673 725 ...
##  $ SPEEDT      : num  -0.65254 -3.27275 -1.44886 0.14973 -0.00215 ...
##  $ SUMPREC     : num  11.93 0.51 2.61 51.29 57.83 ...
## NULL
##    Station_Code Year   ObsBeg     ObsEnd StartSG EndSG    STDAT0    STDAT5
## 2         23365 1949 2-1-1949 30-12-1949      80   133 29-6-1949  7-7-1949
## 15        23365 1962 4-1-1962 29-12-1962      95   108  3-6-1962 10-7-1962
## 16        23365 1963 9-1-1963 29-12-1963      85   111 12-6-1963  3-7-1963
## 22        23365 1969 1-1-1969 31-12-1969     134   231 27-5-1969  4-6-1969
## 23        23365 1970 1-1-1970 31-12-1970     151   250  6-6-1970  8-6-1970
## 24        23365 1971 1-1-1971  30-6-1971     144   170  4-6-1971 12-6-1971
##        FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT   SUMT0   SUMT5
## 2  9-10-1949 17-9-1949    102     80 19.00 12-7-1949  524.49  471.49
## 15 20-8-1962 20-8-1962     78     75 18.50 11-7-1962  142.39  119.57
## 16 10-9-1963 10-9-1963     90     84 20.72 13-7-1963  248.11  208.17
## 22  4-9-1969 27-8-1969    100     90 23.83 29-7-1969 1118.55 1045.70
## 23 14-9-1970 10-9-1970    100     96 23.78  8-7-1970 1024.71  915.43
## 24 30-6-1971 30-6-1971     26     26 16.06 13-6-1971  244.41  199.71
##      T220   T225  FT220  FT225      SPEEDT SUMPREC
## 2  524.49 471.49 524.49 471.49 -0.65253504   11.93
## 15 142.39 119.57 142.39 119.57 -3.27274510    0.51
## 16 248.11 208.17 248.11 208.17 -1.44886023    2.61
## 22 419.28 385.44 696.76 673.09  0.14972672   51.29
## 23 212.63 189.95 787.97 725.48 -0.00214568   57.83
## 24 244.41 199.71 244.41 199.71  0.05783883   12.06
##       Year         StartSG          EndSG           INTER0      
##  Min.   :1949   Min.   :  2.0   Min.   : 42.0   Min.   : 26.00  
##  1st Qu.:1976   1st Qu.:132.5   1st Qu.:199.5   1st Qu.: 86.50  
##  Median :1987   Median :147.0   Median :238.0   Median : 98.00  
##  Mean   :1986   Mean   :137.3   Mean   :214.6   Mean   : 92.64  
##  3rd Qu.:1996   3rd Qu.:158.5   3rd Qu.:247.5   3rd Qu.:100.50  
##  Max.   :2007   Max.   :171.0   Max.   :264.0   Max.   :108.00  
##      INTER5            MAXT           SUMT0            SUMT5       
##  Min.   : 26.00   Min.   :16.06   Min.   : 142.4   Min.   : 119.6  
##  1st Qu.: 80.00   1st Qu.:21.34   1st Qu.: 726.9   1st Qu.: 634.4  
##  Median : 89.00   Median :23.00   Median : 874.0   Median : 798.6  
##  Mean   : 86.18   Mean   :22.65   Mean   : 853.6   Mean   : 771.5  
##  3rd Qu.: 93.50   3rd Qu.:24.09   3rd Qu.:1043.2   3rd Qu.: 950.4  
##  Max.   :104.00   Max.   :26.61   Max.   :1238.0   Max.   :1163.4  
##       T220             T225           FT220             FT225       
##  Min.   : 81.22   Min.   : 41.0   Min.   :   8.05   Min.   :   0.0  
##  1st Qu.:218.97   1st Qu.:170.1   1st Qu.: 428.40   1st Qu.: 398.2  
##  Median :265.59   Median :236.1   Median : 651.93   Median : 612.0  
##  Mean   :314.13   Mean   :272.0   Mean   : 580.48   Mean   : 545.1  
##  3rd Qu.:409.25   3rd Qu.:379.4   3rd Qu.: 762.38   3rd Qu.: 723.6  
##  Max.   :679.57   Max.   :638.3   Max.   :1154.48   Max.   :1122.4  
##      SPEEDT            SUMPREC     
##  Min.   :-3.27275   Min.   : 0.51  
##  1st Qu.:-0.01803   1st Qu.:10.23  
##  Median : 0.16622   Median :13.92  
##  Mean   : 0.11376   Mean   :16.16  
##  3rd Qu.: 0.64193   3rd Qu.:18.57  
##  Max.   : 1.44813   Max.   :57.83  
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/north/23077099999 NORILSK.txt"
## The number of del/rep rows by column precipitation= 86 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##      Day Month Year PRECIP TMEAN
## 2278  14     9 1975   9.91  5.28
## 2279  20     9 1975   0.00  9.22
## 2280  21     9 1975   1.02  6.22
## 2281  22     9 1975   0.00  3.78
## 2282  23     9 1975   0.00  0.78
## 2283  24     9 1975   0.00  0.50
## [1] "Structure"
## 'data.frame':	2197 obs. of  5 variables:
##  $ Day   : int  2 4 13 27 28 29 14 22 8 10 ...
##  $ Month : int  1 1 1 1 1 1 10 10 11 11 ...
##  $ Year  : int  1959 1959 1959 1959 1959 1959 1959 1959 1959 1959 ...
##  $ PRECIP: num  0.25 0.51 1.52 0 1.52 ...
##  $ TMEAN : num  -28.9 -25.3 -30.2 -31.8 -22.9 ...
## NULL
## [1] "Summary"
##      PRECIP            TMEAN       
##  Min.   :  0.000   Min.   :-50.28  
##  1st Qu.:  0.000   1st Qu.:-22.78  
##  Median :  0.250   Median :-10.89  
##  Mean   :  4.965   Mean   :-10.18  
##  3rd Qu.:  1.520   3rd Qu.:  4.17  
##  Max.   :150.110   Max.   : 25.28  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1959
```

```
## ****** Year: 1959 
## #################### Skip a year!!!! 
## ****** Year: 1960 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1961
```

```
## ****** Year: 1961 
## #################### Skip a year!!!! 
## ****** Year: 1962 Observation: 76 Period: 27-5-1962 31-12-1962 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1963 Observation: 216 Period: 1-1-1963 26-12-1963 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1964
```

```
## ****** Year: 1964 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1965
```

```
## ****** Year: 1965 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1966
```

```
## ****** Year: 1966 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1967
```

```
## ****** Year: 1967 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1968
```

```
## ****** Year: 1968 
## #################### Skip a year!!!! 
## ****** Year: 1969 Observation: 350 Period: 1-1-1969 31-12-1969 ******
## ****** Year: 1970 Observation: 349 Period: 1-1-1970 31-12-1970 ******
## ****** Year: 1971 Observation: 176 Period: 1-1-1971 30-6-1971 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1972
```

```
## ****** Year: 1972 
## #################### Skip a year!!!! 
## ****** Year: 1973 Observation: 350 Period: 1-1-1973 31-12-1973 ******
## ****** Year: 1974 Observation: 361 Period: 1-1-1974 31-12-1974 ******
## ****** Year: 1975 Observation: 248 Period: 1-1-1975 24-9-1975 ******
## 
## elapsed time is 4.450000 seconds 
## 'data.frame':	8 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1962 1963 1969 1970 1971 1973 1974 1975
##  $ ObsBeg      : chr  "27-5-1962" "1-1-1963" "1-1-1969" "1-1-1970" ...
##  $ ObsEnd      : chr  "31-12-1962" "26-12-1963" "31-12-1969" "31-12-1970" ...
##  $ StartSG     : num  1 119 158 167 162 173 188 150
##  $ EndSG       : num  41 177 245 257 176 252 258 248
##  $ STDAT0      : chr  "2-7-1962" "23-6-1963" "17-6-1969" "26-6-1970" ...
##  $ STDAT5      : chr  "2-7-1962" "1-7-1963" "23-6-1969" "4-7-1970" ...
##  $ FDAT0       : chr  "23-9-1962" "5-9-1963" "13-9-1969" "24-9-1970" ...
##  $ FDAT5       : chr  "21-9-1962" "5-9-1963" "9-9-1969" "22-9-1970" ...
##  $ INTER0      : num  83 74 88 90 14 80 70 113
##  $ INTER5      : num  81 74 80 86 8 73 66 109
##  $ MAXT        : num  23.4 20.7 25.3 24 15.4 ...
##  $ MDAT        : chr  "28-7-1962" "12-8-1963" "20-7-1969" "13-7-1970" ...
##  $ SUMT0       : num  382 728 1108 948 170 ...
##  $ SUMT5       : num  358.8 660.7 1024.9 831.8 98.2 ...
##  $ T220        : num  382 706 251 108 152 ...
##  $ T225        : num  358.8 642.2 202.9 54.3 92.9 ...
##  $ FT220       : num  381.9 22.7 849.7 840.2 30.2 ...
##  $ FT225       : num  358.8 18.4 832.1 787.4 17.1 ...
##  $ SPEEDT      : num  -0.6677 0.0284 0.8192 1.1691 1.1839 ...
##  $ SUMPREC     : num  246 1137 759 1041 526 ...
## NULL
##    Station_Code Year    ObsBeg     ObsEnd StartSG EndSG    STDAT0
## 4         23365 1962 27-5-1962 31-12-1962       1    41  2-7-1962
## 5         23365 1963  1-1-1963 26-12-1963     119   177 23-6-1963
## 11        23365 1969  1-1-1969 31-12-1969     158   245 17-6-1969
## 12        23365 1970  1-1-1970 31-12-1970     167   257 26-6-1970
## 13        23365 1971  1-1-1971  30-6-1971     162   176 16-6-1971
## 15        23365 1973  1-1-1973 31-12-1973     173   252  2-7-1973
##       STDAT5     FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT   SUMT0
## 4   2-7-1962 23-9-1962 21-9-1962     83     81 23.44 28-7-1962  381.85
## 5   1-7-1963  5-9-1963  5-9-1963     74     74 20.72 12-8-1963  727.87
## 11 23-6-1969 13-9-1969  9-9-1969     88     80 25.28 20-7-1969 1108.36
## 12  4-7-1970 24-9-1970 22-9-1970     90     86 24.00 13-7-1970  948.10
## 13 21-6-1971 30-6-1971 28-6-1971     14      8 15.39 22-6-1971  169.95
## 15 10-7-1973 20-9-1973 13-9-1973     80     73 22.50 14-7-1973 1064.20
##      SUMT5   T220   T225  FT220  FT225     SPEEDT SUMPREC
## 4   358.79 381.85 358.79 381.85 358.79 -0.6676686  246.40
## 5   660.70 705.74 642.25  22.67  18.45  0.0283987 1136.63
## 11 1024.89 250.99 202.91 849.70 832.09  0.8191786  758.69
## 12  831.76 108.17  54.33 840.15 787.43  1.1691429 1041.14
## 13   98.17 151.56  92.89  30.22  17.11  1.1839091  525.77
## 15  984.21 122.89  65.72 937.48 918.49  5.8300000  228.61
##       Year         StartSG          EndSG           INTER0     
##  Min.   :1962   Min.   :  1.0   Min.   : 41.0   Min.   : 14.0  
##  1st Qu.:1968   1st Qu.:142.2   1st Qu.:176.8   1st Qu.: 73.0  
##  Median :1970   Median :160.0   Median :246.5   Median : 81.5  
##  Mean   :1970   Mean   :139.8   Mean   :206.8   Mean   : 76.5  
##  3rd Qu.:1973   3rd Qu.:168.5   3rd Qu.:253.2   3rd Qu.: 88.5  
##  Max.   :1975   Max.   :188.0   Max.   :258.0   Max.   :113.0  
##      INTER5            MAXT           SUMT0            SUMT5        
##  Min.   :  8.00   Min.   :15.39   Min.   : 169.9   Min.   :  98.17  
##  1st Qu.: 71.25   1st Qu.:21.06   1st Qu.: 641.4   1st Qu.: 585.22  
##  Median : 77.00   Median :22.75   Median : 901.3   Median : 793.33  
##  Mean   : 72.12   Mean   :21.94   Mean   : 795.2   Mean   : 721.68  
##  3rd Qu.: 82.25   3rd Qu.:23.58   3rd Qu.:1074.9   3rd Qu.: 994.38  
##  Max.   :109.00   Max.   :25.28   Max.   :1108.4   Max.   :1060.02  
##       T220             T225            FT220            FT225       
##  Min.   : 56.82   Min.   : 16.50   Min.   : 22.67   Min.   : 17.11  
##  1st Qu.:119.21   1st Qu.: 62.87   1st Qu.:293.94   1st Qu.:273.70  
##  Median :181.03   Median :135.72   Median :819.77   Median :762.91  
##  Mean   :248.56   Mean   :201.49   Mean   :596.10   Mean   :570.40  
##  3rd Qu.:283.70   3rd Qu.:241.88   3rd Qu.:864.12   3rd Qu.:847.18  
##  Max.   :705.74   Max.   :642.25   Max.   :937.48   Max.   :918.49  
##      SPEEDT           SUMPREC       
##  Min.   :-0.6677   Min.   :  82.28  
##  1st Qu.: 0.0222   1st Qu.: 204.62  
##  Median : 0.4474   Median : 386.08  
##  Mean   : 1.0553   Mean   : 519.02  
##  3rd Qu.: 1.1728   3rd Qu.: 829.30  
##  Max.   : 5.8300   Max.   :1136.63  
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/north/23078099999 NORIL'SK.txt"
## The number of del/rep rows by column precipitation= 426 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##      Day Month Year PRECIP  TMEAN
## 8377  26    12 2015   0.00 -28.56
## 8378  27    12 2015   0.00 -26.61
## 8379  28    12 2015   0.25 -26.78
## 8380  29    12 2015   0.00 -29.00
## 8381  30    12 2015   0.00 -26.39
## 8382  31    12 2015   0.00 -24.11
## [1] "Structure"
## 'data.frame':	7956 obs. of  5 variables:
##  $ Day   : int  4 22 23 25 26 27 28 29 30 31 ...
##  $ Month : int  10 10 10 10 10 10 10 10 10 10 ...
##  $ Year  : int  1975 1975 1975 1975 1975 1975 1975 1975 1975 1975 ...
##  $ PRECIP: num  0 0.76 0 0 0 0.25 2.03 0.25 0.51 0 ...
##  $ TMEAN : num  -3.78 -16.89 -21.39 -27.83 -17.28 ...
## NULL
## [1] "Summary"
##      PRECIP           TMEAN       
##  Min.   :  0.00   Min.   :-52.50  
##  1st Qu.:  0.00   1st Qu.:-22.22  
##  Median :  0.00   Median : -8.78  
##  Mean   :  1.19   Mean   : -9.06  
##  3rd Qu.:  1.02   3rd Qu.:  5.17  
##  Max.   :141.99   Max.   : 26.61  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1975
```

```
## ****** Year: 1975 
## #################### Skip a year!!!! 
## ****** Year: 1976 Observation: 343 Period: 2-1-1976 31-12-1976 ******
## ****** Year: 1977 Observation: 325 Period: 1-1-1977 30-12-1977 ******
## ****** Year: 1978 Observation: 319 Period: 1-1-1978 31-12-1978 ******
## ****** Year: 1979 Observation: 332 Period: 1-1-1979 31-12-1979 ******
## ****** Year: 1980 Observation: 342 Period: 1-1-1980 31-12-1980 ******
## ****** Year: 1981 Observation: 350 Period: 1-1-1981 31-12-1981 ******
## ****** Year: 1982 Observation: 316 Period: 1-1-1982 31-12-1982 ******
## ****** Year: 1983 Observation: 336 Period: 1-1-1983 31-12-1983 ******
## ****** Year: 1984 Observation: 303 Period: 1-1-1984 31-12-1984 ******
## ****** Year: 1985 Observation: 351 Period: 2-1-1985 31-12-1985 ******
## ****** Year: 1986 Observation: 347 Period: 1-1-1986 31-12-1986 ******
## ****** Year: 1987 Observation: 359 Period: 1-1-1987 31-12-1987 ******
## ****** Year: 1988 Observation: 365 Period: 1-1-1988 31-12-1988 ******
## ****** Year: 1989 Observation: 358 Period: 1-1-1989 31-12-1989 ******
## ****** Year: 1990 Observation: 358 Period: 1-1-1990 31-12-1990 ******
## ****** Year: 1991 Observation: 307 Period: 1-1-1991 31-12-1991 ******
## ****** Year: 1992 Observation: 236 Period: 2-1-1992 31-12-1992 ******
## ****** Year: 1993 Observation: 351 Period: 1-1-1993 31-12-1993 ******
## ****** Year: 1994 Observation: 347 Period: 1-1-1994 31-12-1994 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1995
```

```
## ****** Year: 1995 
## #################### Skip a year!!!! 
## ****** Year: 1996 Observation: 87 Period: 20-5-1996 31-12-1996 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1997 Observation: 132 Period: 8-1-1997 31-12-1997 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1998
```

```
## ****** Year: 1998 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1999
```

```
## ****** Year: 1999 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2000
```

```
## ****** Year: 2000 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2001
```

```
## ****** Year: 2001 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2002
```

```
## ****** Year: 2002 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2003
```

```
## ****** Year: 2003 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2004
```

```
## ****** Year: 2004 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2005
```

```
## ****** Year: 2005 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2006
```

```
## ****** Year: 2006 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2007
```

```
## ****** Year: 2007 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2008
```

```
## ****** Year: 2008 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2009
```

```
## ****** Year: 2009 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2010
```

```
## ****** Year: 2010 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2011
```

```
## ****** Year: 2011 
## #################### Skip a year!!!! 
## ****** Year: 2012 Observation: 298 Period: 29-2-2012 31-12-2012 ******
## ****** Year: 2013 Observation: 319 Period: 1-1-2013 31-12-2013 ******
## ****** Year: 2014 Observation: 278 Period: 1-1-2014 31-12-2014 ******
## ****** Year: 2015 Observation: 348 Period: 1-1-2015 31-12-2015 ******
## 
## elapsed time is 15.920000 seconds 
## 'data.frame':	25 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 ...
##  $ ObsBeg      : chr  "2-1-1976" "1-1-1977" "1-1-1978" "1-1-1979" ...
##  $ ObsEnd      : chr  "31-12-1976" "30-12-1977" "31-12-1978" "31-12-1979" ...
##  $ StartSG     : num  160 146 146 151 158 157 144 151 146 140 ...
##  $ EndSG       : num  253 239 218 242 236 256 226 255 236 239 ...
##  $ STDAT0      : chr  "14-6-1976" "15-6-1977" "20-6-1978" "7-6-1979" ...
##  $ STDAT5      : chr  "21-6-1976" "22-6-1977" "26-6-1978" "12-6-1979" ...
##  $ FDAT0       : chr  "22-9-1976" "23-9-1977" "13-9-1978" "14-9-1979" ...
##  $ FDAT5       : chr  "13-9-1976" "20-9-1977" "9-9-1978" "9-9-1979" ...
##  $ INTER0      : num  100 100 85 99 81 98 95 114 112 101 ...
##  $ INTER5      : num  91 97 77 94 73 95 94 109 97 96 ...
##  $ MAXT        : num  22 22.6 23.8 26.6 20.7 ...
##  $ MDAT        : chr  "27-6-1976" "28-6-1977" "14-7-1978" "5-7-1979" ...
##  $ SUMT0       : num  1069 1071 963 1169 1056 ...
##  $ SUMT5       : num  988 963 875 1101 949 ...
##  $ T220        : num  220 427 457 269 242 ...
##  $ T225        : num  176 354 411 232 183 ...
##  $ FT220       : num  861 658 505 878 760 ...
##  $ FT225       : num  828 623 482 861 734 ...
##  $ SPEEDT      : num  1.285 0.202 0.537 0.424 0.883 ...
##  $ SUMPREC     : num  185 112 50 233 102 ...
## NULL
##   Station_Code Year   ObsBeg     ObsEnd StartSG EndSG    STDAT0    STDAT5
## 2        23365 1976 2-1-1976 31-12-1976     160   253 14-6-1976 21-6-1976
## 3        23365 1977 1-1-1977 30-12-1977     146   239 15-6-1977 22-6-1977
## 4        23365 1978 1-1-1978 31-12-1978     146   218 20-6-1978 26-6-1978
## 5        23365 1979 1-1-1979 31-12-1979     151   242  7-6-1979 12-6-1979
## 6        23365 1980 1-1-1980 31-12-1980     158   236 25-6-1980  1-7-1980
## 7        23365 1981 1-1-1981 31-12-1981     157   256 13-6-1981 18-6-1981
##       FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT   SUMT0   SUMT5   T220
## 2 22-9-1976 13-9-1976    100     91 22.00 27-6-1976 1069.42  988.04 219.79
## 3 23-9-1977 20-9-1977    100     97 22.61 28-6-1977 1071.17  962.78 426.93
## 4 13-9-1978  9-9-1978     85     77 23.83 14-7-1978  962.97  875.41 456.58
## 5 14-9-1979  9-9-1979     99     94 26.61  5-7-1979 1168.70 1100.59 269.40
## 6 14-9-1980  8-9-1980     81     73 20.72 14-7-1980 1056.20  949.42 242.35
## 7 19-9-1981 16-9-1981     98     95 21.61  8-7-1981 1141.78 1076.68 167.88
##     T225  FT220  FT225     SPEEDT SUMPREC
## 2 175.79 861.07 827.69  1.2846593  184.92
## 3 353.60 658.41 623.35  0.2024481  111.75
## 4 410.62 505.47 482.02  0.5373993   50.03
## 5 232.28 878.36 861.25  0.4243478  232.93
## 6 183.45 759.74 733.69  0.8826618  102.14
## 7 135.67 980.51 947.62 -0.1419853  192.28
##       Year         StartSG          EndSG         INTER0     
##  Min.   :1976   Min.   : 17.0   Min.   : 61   Min.   : 69.0  
##  1st Qu.:1982   1st Qu.:140.0   1st Qu.:226   1st Qu.: 90.0  
##  Median :1988   Median :151.0   Median :239   Median :100.0  
##  Mean   :1990   Mean   :136.8   Mean   :223   Mean   : 98.8  
##  3rd Qu.:1994   3rd Qu.:157.0   3rd Qu.:252   3rd Qu.:110.0  
##  Max.   :2015   Max.   :183.0   Max.   :264   Max.   :117.0  
##      INTER5            MAXT           SUMT0            SUMT5       
##  Min.   : 67.00   Min.   :17.72   Min.   : 473.4   Min.   : 398.2  
##  1st Qu.: 83.00   1st Qu.:21.78   1st Qu.: 963.0   1st Qu.: 875.4  
##  Median : 94.00   Median :23.67   Median :1098.6   Median : 988.0  
##  Mean   : 90.68   Mean   :23.02   Mean   :1047.0   Mean   : 969.6  
##  3rd Qu.: 97.00   3rd Qu.:24.50   3rd Qu.:1175.2   3rd Qu.:1100.6  
##  Max.   :109.00   Max.   :26.61   Max.   :1328.7   Max.   :1294.2  
##       T220              T225             FT220            FT225      
##  Min.   :  40.05   Min.   :  10.83   Min.   :  3.17   Min.   :  0.0  
##  1st Qu.: 198.03   1st Qu.: 156.07   1st Qu.:606.19   1st Qu.:578.5  
##  Median : 308.44   Median : 277.94   Median :769.63   Median :758.5  
##  Mean   : 362.78   Mean   : 322.82   Mean   :704.11   Mean   :674.2  
##  3rd Qu.: 456.58   3rd Qu.: 398.19   3rd Qu.:864.69   3rd Qu.:835.2  
##  Max.   :1084.06   Max.   :1059.96   Max.   :999.59   Max.   :958.8  
##      SPEEDT             SUMPREC      
##  Min.   :-0.757776   Min.   : 28.46  
##  1st Qu.:-0.008013   1st Qu.: 68.32  
##  Median : 0.202448   Median :124.46  
##  Mean   : 0.319531   Mean   :142.40  
##  3rd Qu.: 0.537399   3rd Qu.:200.67  
##  Max.   : 1.583727   Max.   :335.76  
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/north/23179099999 SNEZHNOGORSK.txt"
## The number of del/rep rows by column precipitation= 289 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##      Day Month Year PRECIP  TMEAN
## 8461  26    12 2015   0.00 -26.39
## 8462  27    12 2015   0.00 -26.56
## 8463  28    12 2015   0.00 -24.83
## 8464  29    12 2015   2.29 -20.39
## 8465  30    12 2015   0.51 -20.17
## 8466  31    12 2015   0.00 -28.61
## [1] "Structure"
## 'data.frame':	8177 obs. of  5 variables:
##  $ Day   : int  1 2 5 6 7 8 9 10 12 14 ...
##  $ Month : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Year  : int  1973 1973 1973 1973 1973 1973 1973 1973 1973 1973 ...
##  $ PRECIP: num  2.03 3.05 1.27 1.02 2.29 1.52 1.02 2.54 0.25 2.03 ...
##  $ TMEAN : num  -15 -16 -13.8 -22.8 -22 ...
## NULL
## [1] "Summary"
##      PRECIP          TMEAN        
##  Min.   : 0.00   Min.   :-52.830  
##  1st Qu.: 0.00   1st Qu.:-21.330  
##  Median : 0.25   Median : -7.220  
##  Mean   : 1.38   Mean   : -8.241  
##  3rd Qu.: 1.52   3rd Qu.:  5.780  
##  Max.   :99.06   Max.   : 26.170  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
## ****** Year: 1973 Observation: 318 Period: 1-1-1973 31-12-1973 ******
## ****** Year: 1974 Observation: 338 Period: 1-1-1974 31-12-1974 ******
## ****** Year: 1975 Observation: 358 Period: 1-1-1975 30-12-1975 ******
## ****** Year: 1976 Observation: 339 Period: 1-1-1976 31-12-1976 ******
## ****** Year: 1977 Observation: 318 Period: 1-1-1977 31-12-1977 ******
## ****** Year: 1978 Observation: 338 Period: 1-1-1978 31-12-1978 ******
## ****** Year: 1979 Observation: 334 Period: 1-1-1979 31-12-1979 ******
## ****** Year: 1980 Observation: 335 Period: 1-1-1980 31-12-1980 ******
## ****** Year: 1981 Observation: 340 Period: 1-1-1981 31-12-1981 ******
## ****** Year: 1982 Observation: 298 Period: 6-1-1982 31-12-1982 ******
## ****** Year: 1983 Observation: 335 Period: 1-1-1983 31-12-1983 ******
## ****** Year: 1984 Observation: 306 Period: 2-1-1984 31-12-1984 ******
## ****** Year: 1985 Observation: 349 Period: 1-1-1985 31-12-1985 ******
## ****** Year: 1986 Observation: 345 Period: 1-1-1986 31-12-1986 ******
## ****** Year: 1987 Observation: 358 Period: 1-1-1987 31-12-1987 ******
## ****** Year: 1988 Observation: 359 Period: 1-1-1988 31-12-1988 ******
## ****** Year: 1989 Observation: 356 Period: 1-1-1989 31-12-1989 ******
## ****** Year: 1990 Observation: 359 Period: 1-1-1990 31-12-1990 ******
## ****** Year: 1991 Observation: 305 Period: 1-1-1991 30-12-1991 ******
## ****** Year: 1992 Observation: 114 Period: 2-1-1992 31-12-1992 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1993 Observation: 192 Period: 2-1-1993 31-12-1993 ******
## ****** Year: 1994 Observation: 174 Period: 1-1-1994 31-12-1994 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1995
```

```
## ****** Year: 1995 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1996
```

```
## ****** Year: 1996 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1997
```

```
## ****** Year: 1997 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1998
```

```
## ****** Year: 1998 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1999
```

```
## ****** Year: 1999 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2000
```

```
## ****** Year: 2000 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2001
```

```
## ****** Year: 2001 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2002
```

```
## ****** Year: 2002 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2003
```

```
## ****** Year: 2003 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2004
```

```
## ****** Year: 2004 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2005
```

```
## ****** Year: 2005 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2006
```

```
## ****** Year: 2006 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2007
```

```
## ****** Year: 2007 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2008
```

```
## ****** Year: 2008 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2009
```

```
## ****** Year: 2009 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2010
```

```
## ****** Year: 2010 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2011
```

```
## ****** Year: 2011 
## #################### Skip a year!!!! 
## ****** Year: 2012 Observation: 269 Period: 28-3-2012 31-12-2012 ******
## ****** Year: 2013 Observation: 345 Period: 1-1-2013 30-12-2013 ******
## ****** Year: 2014 Observation: 334 Period: 1-1-2014 31-12-2014 ******
## ****** Year: 2015 Observation: 361 Period: 1-1-2015 31-12-2015 ******
## 
## elapsed time is 16.100000 seconds 
## 'data.frame':	26 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 ...
##  $ ObsBeg      : chr  "1-1-1973" "1-1-1974" "1-1-1975" "1-1-1976" ...
##  $ ObsEnd      : chr  "31-12-1973" "31-12-1974" "30-12-1975" "31-12-1976" ...
##  $ StartSG     : num  144 163 164 155 141 157 154 157 150 128 ...
##  $ EndSG       : num  219 239 267 252 231 236 250 230 251 209 ...
##  $ STDAT0      : chr  "2-7-1973" "1-7-1974" "16-6-1975" "14-6-1976" ...
##  $ STDAT5      : chr  "11-7-1973" "7-7-1974" "17-6-1975" "22-6-1976" ...
##  $ FDAT0       : chr  "20-9-1973" "18-9-1974" "29-9-1975" "23-9-1976" ...
##  $ FDAT5       : chr  "13-9-1973" "15-9-1974" "22-9-1975" "21-9-1976" ...
##  $ INTER0      : num  80 79 105 101 100 85 101 82 102 98 ...
##  $ INTER5      : num  73 76 98 98 98 76 91 74 94 92 ...
##  $ MAXT        : num  21.6 18.7 22.8 23.6 23.2 ...
##  $ MDAT        : chr  "27-7-1973" "28-7-1974" "22-7-1975" "29-6-1976" ...
##  $ SUMT0       : num  1050 920 1224 1159 1023 ...
##  $ SUMT5       : num  958 843 1147 1063 929 ...
##  $ T220        : num  568 217 190 310 445 ...
##  $ T225        : num  508 159 151 252 387 ...
##  $ FT220       : num  479 707 1036 855 590 ...
##  $ FT225       : num  459 694 1005 827 554 ...
##  $ SPEEDT      : num  0.477 0.492 -0.352 0.784 0.109 ...
##  $ SUMPREC     : num  148.6 91.9 173 71.6 126 ...
## NULL
##   Station_Code Year   ObsBeg     ObsEnd StartSG EndSG    STDAT0    STDAT5
## 1        23365 1973 1-1-1973 31-12-1973     144   219  2-7-1973 11-7-1973
## 2        23365 1974 1-1-1974 31-12-1974     163   239  1-7-1974  7-7-1974
## 3        23365 1975 1-1-1975 30-12-1975     164   267 16-6-1975 17-6-1975
## 4        23365 1976 1-1-1976 31-12-1976     155   252 14-6-1976 22-6-1976
## 5        23365 1977 1-1-1977 31-12-1977     141   231 15-6-1977 23-6-1977
## 6        23365 1978 1-1-1978 31-12-1978     157   236 19-6-1978 28-6-1978
##       FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT   SUMT0   SUMT5   T220
## 1 20-9-1973 13-9-1973     80     73 21.61 27-7-1973 1049.78  958.07 567.82
## 2 18-9-1974 15-9-1974     79     76 18.67 28-7-1974  920.12  843.04 217.25
## 3 29-9-1975 22-9-1975    105     98 22.83 22-7-1975 1224.14 1147.42 190.45
## 4 23-9-1976 21-9-1976    101     98 23.61 29-6-1976 1158.84 1063.27 310.44
## 5 23-9-1977 21-9-1977    100     98 23.17 29-6-1977 1023.17  928.73 444.60
## 6 12-9-1978  8-9-1978     85     76 21.39 14-7-1978 1020.88  893.08 249.79
##     T225   FT220   FT225     SPEEDT SUMPREC
## 1 507.77  478.79  458.80  0.4768571  148.62
## 2 158.77  707.37  693.99  0.4924242   91.94
## 3 151.33 1035.80 1004.92 -0.3518333  172.99
## 4 251.88  854.84  826.56  0.7837368   71.63
## 5 386.89  590.35  553.62  0.1088105  126.00
## 6 183.61  745.36  717.80  0.9989559   47.52
##       Year         StartSG          EndSG           INTER0     
##  Min.   :1973   Min.   : 37.0   Min.   : 70.0   Min.   : 74.0  
##  1st Qu.:1979   1st Qu.:141.0   1st Qu.:230.2   1st Qu.: 96.5  
##  Median :1986   Median :150.0   Median :240.5   Median :101.0  
##  Mean   :1988   Mean   :138.9   Mean   :226.3   Mean   :100.8  
##  3rd Qu.:1992   3rd Qu.:156.5   3rd Qu.:251.0   3rd Qu.:111.0  
##  Max.   :2015   Max.   :177.0   Max.   :267.0   Max.   :122.0  
##      INTER5            MAXT           SUMT0            SUMT5       
##  Min.   : 70.00   Min.   :18.17   Min.   : 315.7   Min.   : 303.4  
##  1st Qu.: 88.25   1st Qu.:20.11   1st Qu.: 974.5   1st Qu.: 872.2  
##  Median : 94.50   Median :21.70   Median :1132.5   Median :1034.8  
##  Mean   : 92.77   Mean   :21.79   Mean   :1057.6   Mean   : 978.9  
##  3rd Qu.:100.25   3rd Qu.:23.21   3rd Qu.:1225.3   3rd Qu.:1154.7  
##  Max.   :115.00   Max.   :26.17   Max.   :1420.2   Max.   :1368.8  
##       T220              T225             FT220             FT225       
##  Min.   :  71.24   Min.   :  24.56   Min.   :   0.11   Min.   :   0.0  
##  1st Qu.: 221.26   1st Qu.: 164.98   1st Qu.: 605.71   1st Qu.: 569.7  
##  Median : 300.71   Median : 251.03   Median : 748.73   Median : 718.5  
##  Mean   : 355.41   Mean   : 309.25   Mean   : 700.59   Mean   : 677.9  
##  3rd Qu.: 413.07   3rd Qu.: 368.40   3rd Qu.: 957.77   3rd Qu.: 947.1  
##  Max.   :1360.16   Max.   :1318.77   Max.   :1053.07   Max.   :1032.3  
##      SPEEDT            SUMPREC      
##  Min.   :-0.65126   Min.   : 44.21  
##  1st Qu.: 0.01744   1st Qu.: 84.08  
##  Median : 0.23674   Median :124.09  
##  Mean   : 0.22223   Mean   :133.67  
##  3rd Qu.: 0.47590   3rd Qu.:189.55  
##  Max.   : 1.00000   Max.   :276.33  
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/north/23376099999 SVETLOGORSK.txt"
## The number of del/rep rows by column precipitation= 39 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##      Day Month Year PRECIP  TMEAN
## 1163  25    12 2015      0 -30.67
## 1164  26    12 2015      0 -24.78
## 1165  28    12 2015      0 -19.44
## 1166  29    12 2015      0 -18.22
## 1167  30    12 2015      0 -16.39
## 1168  31    12 2015      0 -25.28
## [1] "Structure"
## 'data.frame':	1129 obs. of  5 variables:
##  $ Day   : int  28 30 31 1 2 3 4 5 6 7 ...
##  $ Month : int  3 3 3 4 4 4 4 4 4 4 ...
##  $ Year  : int  2012 2012 2012 2012 2012 2012 2012 2012 2012 2012 ...
##  $ PRECIP: num  0 0.51 0.25 1.52 0 2.03 0 0.76 0.51 0.51 ...
##  $ TMEAN : num  -12 -2.56 -2 -3.11 -8.67 -0.44 2.33 -4.44 -7.83 -7.78 ...
## NULL
## [1] "Summary"
##      PRECIP            TMEAN        
##  Min.   : 0.0000   Min.   :-51.110  
##  1st Qu.: 0.0000   1st Qu.:-18.830  
##  Median : 0.0000   Median : -3.390  
##  Mean   : 0.8574   Mean   : -5.642  
##  3rd Qu.: 0.2500   3rd Qu.:  8.560  
##  Max.   :24.8900   Max.   : 26.280  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
## ****** Year: 2012 Observation: 269 Period: 28-3-2012 31-12-2012 ******
## ****** Year: 2013 Observation: 331 Period: 1-1-2013 31-12-2013 ******
## ****** Year: 2014 Observation: 260 Period: 1-1-2014 31-12-2014 ******
## ****** Year: 2015 Observation: 269 Period: 1-1-2015 31-12-2015 ******
## 
## elapsed time is 2.400000 seconds 
## 'data.frame':	4 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365"
##  $ Year        : int  2012 2013 2014 2015
##  $ ObsBeg      : chr  "28-3-2012" "1-1-2013" "1-1-2014" "1-1-2015"
##  $ ObsEnd      : chr  "31-12-2012" "31-12-2013" "31-12-2014" "31-12-2015"
##  $ StartSG     : num  60 141 105 69
##  $ EndSG       : num  178 246 180 168
##  $ STDAT0      : chr  "29-5-2012" "25-5-2013" "4-6-2014" "8-6-2015"
##  $ STDAT5      : chr  "1-6-2012" "28-5-2013" "12-6-2014" "8-6-2015"
##  $ FDAT0       : chr  "1-10-2012" "19-9-2013" "21-9-2014" "20-9-2015"
##  $ FDAT5       : chr  "23-9-2012" "17-9-2013" "9-9-2014" "17-9-2015"
##  $ INTER0      : num  125 117 109 104
##  $ INTER5      : num  117 114 95 101
##  $ MAXT        : num  26.3 25.8 25.5 21
##  $ MDAT        : chr  "22-7-2012" "22-7-2013" "17-6-2014" "9-6-2015"
##  $ SUMT0       : num  1446 1457 880 1217
##  $ SUMT5       : num  1402 1392 781 1168
##  $ T220        : num  1434 423 828 1207
##  $ T225        : num  1402 377 757 1168
##  $ FT220       : num  13.5 1046.7 40.2 18.3
##  $ FT225       : num  0 1029 29.6 0
##  $ SPEEDT      : num  -0.0575 0.1558 -0.0908 -0.0701
##  $ SUMPREC     : num  274.33 160.54 4.57 7.87
## NULL
##   Station_Code Year    ObsBeg     ObsEnd StartSG EndSG    STDAT0    STDAT5
## 1        23365 2012 28-3-2012 31-12-2012      60   178 29-5-2012  1-6-2012
## 2        23365 2013  1-1-2013 31-12-2013     141   246 25-5-2013 28-5-2013
## 3        23365 2014  1-1-2014 31-12-2014     105   180  4-6-2014 12-6-2014
## 4        23365 2015  1-1-2015 31-12-2015      69   168  8-6-2015  8-6-2015
##       FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT  SUMT0   SUMT5    T220
## 1 1-10-2012 23-9-2012    125    117 26.28 22-7-2012 1445.9 1402.45 1434.01
## 2 19-9-2013 17-9-2013    117    114 25.78 22-7-2013 1457.5 1392.35  423.37
## 3 21-9-2014  9-9-2014    109     95 25.50 17-6-2014  880.3  780.84  828.29
## 4 20-9-2015 17-9-2015    104    101 21.00  9-6-2015 1217.5 1167.90 1207.29
##      T225   FT220   FT225      SPEEDT SUMPREC
## 1 1402.45   13.50    0.00 -0.05754756  274.33
## 2  377.22 1046.74 1029.02  0.15578262  160.54
## 3  757.34   40.23   29.61 -0.09081250    4.57
## 4 1167.90   18.33    0.00 -0.07011939    7.87
##       Year         StartSG           EndSG           INTER0     
##  Min.   :2012   Min.   : 60.00   Min.   :168.0   Min.   :104.0  
##  1st Qu.:2013   1st Qu.: 66.75   1st Qu.:175.5   1st Qu.:107.8  
##  Median :2014   Median : 87.00   Median :179.0   Median :113.0  
##  Mean   :2014   Mean   : 93.75   Mean   :193.0   Mean   :113.8  
##  3rd Qu.:2014   3rd Qu.:114.00   3rd Qu.:196.5   3rd Qu.:119.0  
##  Max.   :2015   Max.   :141.00   Max.   :246.0   Max.   :125.0  
##      INTER5           MAXT           SUMT0            SUMT5       
##  Min.   : 95.0   Min.   :21.00   Min.   : 880.3   Min.   : 780.8  
##  1st Qu.: 99.5   1st Qu.:24.38   1st Qu.:1133.2   1st Qu.:1071.1  
##  Median :107.5   Median :25.64   Median :1331.7   Median :1280.1  
##  Mean   :106.8   Mean   :24.64   Mean   :1250.3   Mean   :1185.9  
##  3rd Qu.:114.8   3rd Qu.:25.91   3rd Qu.:1448.8   3rd Qu.:1394.9  
##  Max.   :117.0   Max.   :26.28   Max.   :1457.5   Max.   :1402.5  
##       T220             T225            FT220             FT225       
##  Min.   : 423.4   Min.   : 377.2   Min.   :  13.50   Min.   :   0.0  
##  1st Qu.: 727.1   1st Qu.: 662.3   1st Qu.:  17.12   1st Qu.:   0.0  
##  Median :1017.8   Median : 962.6   Median :  29.28   Median :  14.8  
##  Mean   : 973.2   Mean   : 926.2   Mean   : 279.70   Mean   : 264.7  
##  3rd Qu.:1264.0   3rd Qu.:1226.5   3rd Qu.: 291.86   3rd Qu.: 279.5  
##  Max.   :1434.0   Max.   :1402.5   Max.   :1046.74   Max.   :1029.0  
##      SPEEDT             SUMPREC       
##  Min.   :-0.090813   Min.   :  4.570  
##  1st Qu.:-0.075293   1st Qu.:  7.045  
##  Median :-0.063833   Median : 84.205  
##  Mean   :-0.015674   Mean   :111.828  
##  3rd Qu.:-0.004215   3rd Qu.:188.988  
##  Max.   : 0.155783   Max.   :274.330  
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/north/24125099999 OLENEK.txt"
## The number of del/rep rows by column precipitation= 369 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##       Day Month Year PRECIP  TMEAN
## 11900   3    11 2000   0.51 -22.56
## 11901   4    11 2000   1.52 -26.83
## 11902   5    11 2000   0.76 -25.89
## 11903   6    11 2000   0.76 -25.39
## 11904   7    11 2000   0.76 -20.78
## 11905   8    11 2000   0.00 -28.78
## [1] "Structure"
## 'data.frame':	11536 obs. of  5 variables:
##  $ Day   : int  4 5 6 7 8 9 10 11 12 13 ...
##  $ Month : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Year  : int  1962 1962 1962 1962 1962 1962 1962 1962 1962 1962 ...
##  $ PRECIP: num  0 0.25 0.25 0 1.02 1.02 0 0 0 0 ...
##  $ TMEAN : num  -49.2 -42.1 -43.1 -36.4 -19.8 ...
## NULL
## [1] "Summary"
##      PRECIP            TMEAN       
##  Min.   :  0.000   Min.   :-57.89  
##  1st Qu.:  0.000   1st Qu.:-28.06  
##  Median :  0.000   Median :-10.00  
##  Mean   :  1.972   Mean   :-11.57  
##  3rd Qu.:  0.510   3rd Qu.:  5.61  
##  Max.   :150.110   Max.   : 26.50  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
## ****** Year: 1962 Observation: 308 Period: 4-1-1962 30-12-1962 ******
## ****** Year: 1963 Observation: 296 Period: 2-1-1963 31-12-1963 ******
## ****** Year: 1964 Observation: 279 Period: 1-1-1964 30-12-1964 ******
## ****** Year: 1965 Observation: 271 Period: 1-1-1965 31-12-1965 ******
## ****** Year: 1966 Observation: 339 Period: 2-1-1966 31-12-1966 ******
## ****** Year: 1967 Observation: 342 Period: 1-1-1967 30-12-1967 ******
## ****** Year: 1968 Observation: 347 Period: 3-1-1968 31-12-1968 ******
## ****** Year: 1969 Observation: 330 Period: 1-1-1969 31-12-1969 ******
## ****** Year: 1970 Observation: 309 Period: 1-1-1970 29-12-1970 ******
## ****** Year: 1971 Observation: 111 Period: 1-1-1971 30-6-1971 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1972
```

```
## ****** Year: 1972 
## #################### Skip a year!!!! 
## ****** Year: 1973 Observation: 306 Period: 1-1-1973 31-12-1973 ******
## ****** Year: 1974 Observation: 147 Period: 5-1-1974 30-12-1974 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1975 Observation: 218 Period: 1-1-1975 30-12-1975 ******
## ****** Year: 1976 Observation: 245 Period: 1-1-1976 30-12-1976 ******
## ****** Year: 1977 Observation: 193 Period: 2-1-1977 31-12-1977 ******
## ****** Year: 1978 Observation: 289 Period: 1-1-1978 31-12-1978 ******
## ****** Year: 1979 Observation: 308 Period: 1-1-1979 31-12-1979 ******
## ****** Year: 1980 Observation: 365 Period: 1-1-1980 31-12-1980 ******
## ****** Year: 1981 Observation: 359 Period: 1-1-1981 31-12-1981 ******
## ****** Year: 1982 Observation: 351 Period: 1-1-1982 31-12-1982 ******
## ****** Year: 1983 Observation: 355 Period: 1-1-1983 31-12-1983 ******
## ****** Year: 1984 Observation: 318 Period: 3-1-1984 31-12-1984 ******
## ****** Year: 1985 Observation: 325 Period: 2-1-1985 31-12-1985 ******
## ****** Year: 1986 Observation: 345 Period: 1-1-1986 31-12-1986 ******
## ****** Year: 1987 Observation: 361 Period: 1-1-1987 31-12-1987 ******
## ****** Year: 1988 Observation: 362 Period: 1-1-1988 31-12-1988 ******
## ****** Year: 1989 Observation: 349 Period: 1-1-1989 31-12-1989 ******
## ****** Year: 1990 Observation: 354 Period: 1-1-1990 31-12-1990 ******
## ****** Year: 1991 Observation: 297 Period: 1-1-1991 30-12-1991 ******
## ****** Year: 1992 Observation: 285 Period: 1-1-1992 31-12-1992 ******
## ****** Year: 1993 Observation: 196 Period: 2-1-1993 29-12-1993 ******
## ****** Year: 1994 Observation: 252 Period: 4-1-1994 31-12-1994 ******
## ****** Year: 1995 Observation: 346 Period: 1-1-1995 31-12-1995 ******
## ****** Year: 1996 Observation: 348 Period: 1-1-1996 31-12-1996 ******
## ****** Year: 1997 Observation: 343 Period: 1-1-1997 31-12-1997 ******
## ****** Year: 1998 Observation: 347 Period: 1-1-1998 31-12-1998 ******
## ****** Year: 1999 Observation: 349 Period: 1-1-1999 31-12-1999 ******
## ****** Year: 2000 Observation: 291 Period: 1-1-2000 8-11-2000 ******
## 
## elapsed time is 23.090000 seconds 
## 'data.frame':	38 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1962 1963 1964 1965 1966 1967 1968 1969 1970 1971 ...
##  $ ObsBeg      : chr  "4-1-1962" "2-1-1963" "1-1-1964" "1-1-1965" ...
##  $ ObsEnd      : chr  "30-12-1962" "31-12-1963" "30-12-1964" "31-12-1965" ...
##  $ StartSG     : num  146 146 116 101 150 138 150 132 139 92 ...
##  $ EndSG       : num  236 225 209 190 241 229 240 234 223 111 ...
##  $ STDAT0      : chr  "16-6-1962" "14-6-1963" "8-6-1964" "10-6-1965" ...
##  $ STDAT5      : chr  "21-6-1962" "18-6-1963" "16-6-1964" "13-6-1965" ...
##  $ FDAT0       : chr  "16-9-1962" "11-9-1963" "10-9-1964" "16-9-1965" ...
##  $ FDAT5       : chr  "12-9-1962" "5-9-1963" "8-9-1964" "9-9-1965" ...
##  $ INTER0      : num  92 89 94 98 93 90 94 107 108 35 ...
##  $ INTER5      : num  87 83 92 90 88 80 85 98 102 28 ...
##  $ MAXT        : num  25.2 26.4 23.6 24.7 20.7 ...
##  $ MDAT        : chr  "31-7-1962" "7-8-1963" "12-7-1964" "1-8-1965" ...
##  $ SUMT0       : num  1111 1026 1179 1110 1207 ...
##  $ SUMT5       : num  1026 967 1113 1037 1103 ...
##  $ T220        : num  370 376 837 996 316 ...
##  $ T225        : num  332 342 798 956 251 ...
##  $ FT220       : num  745 637 329 107 852 ...
##  $ FT225       : num  710.5 617.6 310.3 90.5 834.2 ...
##  $ SPEEDT      : num  0.2436 0.2045 0.0506 0.0625 0.1631 ...
##  $ SUMPREC     : num  460 1025 371 760 518 ...
## NULL
##   Station_Code Year   ObsBeg     ObsEnd StartSG EndSG    STDAT0    STDAT5
## 1        23365 1962 4-1-1962 30-12-1962     146   236 16-6-1962 21-6-1962
## 2        23365 1963 2-1-1963 31-12-1963     146   225 14-6-1963 18-6-1963
## 3        23365 1964 1-1-1964 30-12-1964     116   209  8-6-1964 16-6-1964
## 4        23365 1965 1-1-1965 31-12-1965     101   190 10-6-1965 13-6-1965
## 5        23365 1966 2-1-1966 31-12-1966     150   241  5-6-1966  8-6-1966
## 6        23365 1967 1-1-1967 30-12-1967     138   229  3-6-1967  6-6-1967
##       FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT   SUMT0   SUMT5   T220
## 1 16-9-1962 12-9-1962     92     87 25.22 31-7-1962 1110.60 1026.23 369.94
## 2 11-9-1963  5-9-1963     89     83 26.44  7-8-1963 1025.58  966.73 376.40
## 3 10-9-1964  8-9-1964     94     92 23.56 12-7-1964 1179.34 1113.28 836.78
## 4 16-9-1965  9-9-1965     98     90 24.67  1-8-1965 1109.75 1037.19 996.17
## 5  6-9-1966  2-9-1966     93     88 20.67  9-8-1966 1207.34 1102.74 316.45
## 6  1-9-1967 22-8-1967     90     80 25.72  3-7-1967 1447.84 1378.76 563.65
##     T225  FT220  FT225     SPEEDT SUMPREC
## 1 332.40 745.21 710.55 0.24355311  459.99
## 2 342.15 636.80 617.64 0.20454823 1024.62
## 3 798.11 329.34 310.34 0.05063921  371.36
## 4 955.69 106.95  90.50 0.06246849  760.18
## 5 251.29 851.57 834.24 0.16308300  517.63
## 6 551.32 785.69 767.04 0.65591036  351.56
##       Year         StartSG          EndSG           INTER0      
##  Min.   :1962   Min.   : 60.0   Min.   :104.0   Min.   : 35.00  
##  1st Qu.:1972   1st Qu.:118.2   1st Qu.:206.0   1st Qu.: 92.25  
##  Median :1982   Median :140.5   Median :233.0   Median : 98.50  
##  Mean   :1981   Mean   :132.8   Mean   :217.2   Mean   : 96.74  
##  3rd Qu.:1991   3rd Qu.:149.8   3rd Qu.:241.8   3rd Qu.:106.50  
##  Max.   :2000   Max.   :172.0   Max.   :257.0   Max.   :129.00  
##                                                                 
##      INTER5            MAXT           SUMT0            SUMT5       
##  Min.   : 28.00   Min.   :17.22   Min.   : 198.8   Min.   : 167.0  
##  1st Qu.: 85.50   1st Qu.:23.36   1st Qu.: 994.8   1st Qu.: 926.3  
##  Median : 92.00   Median :24.55   Median :1110.2   Median :1031.7  
##  Mean   : 90.21   Mean   :24.02   Mean   :1061.5   Mean   : 990.3  
##  3rd Qu.:100.00   3rd Qu.:25.72   3rd Qu.:1235.2   3rd Qu.:1147.4  
##  Max.   :119.00   Max.   :26.50   Max.   :1447.8   Max.   :1378.8  
##                                                                    
##       T220             T225            FT220            FT225       
##  Min.   : 133.3   Min.   : 91.77   Min.   :   0.0   Min.   :   0.0  
##  1st Qu.: 320.2   1st Qu.:261.02   1st Qu.: 352.1   1st Qu.: 327.7  
##  Median : 391.6   Median :371.77   Median : 721.0   Median : 689.8  
##  Mean   : 465.0   Mean   :427.60   Mean   : 597.2   Mean   : 573.7  
##  3rd Qu.: 570.5   3rd Qu.:545.54   3rd Qu.: 862.3   3rd Qu.: 840.4  
##  Max.   :1018.0   Max.   :961.77   Max.   :1158.4   Max.   :1130.2  
##                                                                     
##      SPEEDT            SUMPREC       
##  Min.   :-0.87524   Min.   :  24.63  
##  1st Qu.: 0.06247   1st Qu.:  83.25  
##  Median : 0.19671   Median : 139.57  
##  Mean   : 0.26057   Mean   : 224.07  
##  3rd Qu.: 0.38998   3rd Qu.: 274.90  
##  Max.   : 2.53000   Max.   :1024.62  
##  NA's   :1                           
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/north/24136099999 SUHANA.txt"
## The number of del/rep rows by column precipitation= 492 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##      Day Month Year PRECIP  TMEAN
## 7155  26    12 2015   1.02 -29.72
## 7156  27    12 2015   0.00 -42.50
## 7157  28    12 2015   0.00 -41.17
## 7158  29    12 2015   0.00 -30.33
## 7159  30    12 2015   0.51 -26.44
## 7160  31    12 2015   0.51 -30.11
## [1] "Structure"
## 'data.frame':	6668 obs. of  5 variables:
##  $ Day   : int  1 2 3 6 9 10 11 18 20 23 ...
##  $ Month : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Year  : int  1959 1959 1959 1959 1959 1959 1959 1959 1959 1959 ...
##  $ PRECIP: num  0 0 0 0.25 0 0 0 0.76 0 0 ...
##  $ TMEAN : num  -58.9 -51.7 -53.4 -43.8 -50 ...
## NULL
## [1] "Summary"
##      PRECIP            TMEAN       
##  Min.   :  0.000   Min.   :-60.00  
##  1st Qu.:  0.000   1st Qu.:-30.84  
##  Median :  0.000   Median : -7.53  
##  Mean   :  2.494   Mean   :-11.67  
##  3rd Qu.:  0.510   3rd Qu.:  7.17  
##  Max.   :150.110   Max.   : 26.67  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
## ****** Year: 1959 Observation: 94 Period: 1-1-1959 22-12-1959 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1960 
## #################### Skip a year!!!! 
## ****** Year: 1961 Observation: 275 Period: 3-1-1961 31-12-1961 ******
## ****** Year: 1962 Observation: 301 Period: 1-1-1962 30-12-1962 ******
## ****** Year: 1963 Observation: 302 Period: 1-1-1963 31-12-1963 ******
## ****** Year: 1964 Observation: 315 Period: 1-1-1964 31-12-1964 ******
## ****** Year: 1965 Observation: 172 Period: 1-1-1965 31-12-1965 ******
## ****** Year: 1966 Observation: 336 Period: 1-1-1966 31-12-1966 ******
## ****** Year: 1967 Observation: 347 Period: 1-1-1967 30-12-1967 ******
## ****** Year: 1968 Observation: 349 Period: 1-1-1968 30-12-1968 ******
## ****** Year: 1969 Observation: 320 Period: 1-1-1969 31-12-1969 ******
## ****** Year: 1970 Observation: 328 Period: 1-1-1970 31-12-1970 ******
## ****** Year: 1971 Observation: 144 Period: 1-1-1971 30-6-1971 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1972
```

```
## ****** Year: 1972 
## #################### Skip a year!!!! 
## ****** Year: 1973 Observation: 321 Period: 1-1-1973 31-12-1973 ******
## ****** Year: 1974 Observation: 231 Period: 1-1-1974 24-12-1974 ******
## ****** Year: 1975 Observation: 168 Period: 9-1-1975 30-12-1975 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1976 Observation: 159 Period: 1-1-1976 10-11-1976 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1977 
## #################### Skip a year!!!! 
## ****** Year: 1978 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1979
```

```
## ****** Year: 1979 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1980
```

```
## ****** Year: 1980 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1981
```

```
## ****** Year: 1981 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1982
```

```
## ****** Year: 1982 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1983
```

```
## ****** Year: 1983 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1984
```

```
## ****** Year: 1984 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1985
```

```
## ****** Year: 1985 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1986
```

```
## ****** Year: 1986 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1987
```

```
## ****** Year: 1987 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1988
```

```
## ****** Year: 1988 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1989
```

```
## ****** Year: 1989 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1990
```

```
## ****** Year: 1990 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1991
```

```
## ****** Year: 1991 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1992
```

```
## ****** Year: 1992 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1993
```

```
## ****** Year: 1993 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1994
```

```
## ****** Year: 1994 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1995
```

```
## ****** Year: 1995 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1996
```

```
## ****** Year: 1996 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1997
```

```
## ****** Year: 1997 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1998
```

```
## ****** Year: 1998 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1999
```

```
## ****** Year: 1999 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2000
```

```
## ****** Year: 2000 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2001
```

```
## ****** Year: 2001 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2002
```

```
## ****** Year: 2002 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2003
```

```
## ****** Year: 2003 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2004
```

```
## ****** Year: 2004 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2005
```

```
## ****** Year: 2005 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2006
```

```
## ****** Year: 2006 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2007
```

```
## ****** Year: 2007 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2008
```

```
## ****** Year: 2008 
## #################### Skip a year!!!! 
## ****** Year: 2009 Observation: 314 Period: 28-1-2009 31-12-2009 ******
## ****** Year: 2010 Observation: 334 Period: 1-1-2010 31-12-2010 ******
## ****** Year: 2011 Observation: 338 Period: 1-1-2011 31-12-2011 ******
## ****** Year: 2012 Observation: 344 Period: 1-1-2012 31-12-2012 ******
## ****** Year: 2013 Observation: 363 Period: 1-1-2013 31-12-2013 ******
## ****** Year: 2014 Observation: 364 Period: 1-1-2014 31-12-2014 ******
## ****** Year: 2015 Observation: 363 Period: 1-1-2015 31-12-2015 ******
## 
## elapsed time is 13.580000 seconds 
## 'data.frame':	23 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1959 1961 1962 1963 1964 1965 1966 1967 1968 1969 ...
##  $ ObsBeg      : chr  "1-1-1959" "3-1-1961" "1-1-1962" "1-1-1963" ...
##  $ ObsEnd      : chr  "22-12-1959" "31-12-1961" "30-12-1962" "31-12-1963" ...
##  $ StartSG     : num  27 109 132 144 132 37 130 144 152 120 ...
##  $ EndSG       : num  53 209 219 225 222 110 223 234 249 212 ...
##  $ STDAT0      : chr  "15-5-1959" "5-6-1961" "16-6-1962" "15-6-1963" ...
##  $ STDAT5      : chr  "17-6-1959" "12-6-1961" "19-6-1962" "24-6-1963" ...
##  $ FDAT0       : chr  "22-9-1959" "20-9-1961" "14-9-1962" "12-9-1963" ...
##  $ FDAT5       : chr  "20-9-1959" "16-9-1961" "12-9-1962" "3-9-1963" ...
##  $ INTER0      : num  130 107 90 89 96 112 94 91 101 104 ...
##  $ INTER5      : num  95 101 87 78 89 95 90 80 94 97 ...
##  $ MAXT        : num  23.3 23.2 24.2 25 23.9 ...
##  $ MDAT        : chr  "28-7-1959" "1-7-1961" "31-7-1962" "31-7-1963" ...
##  $ SUMT0       : num  219 1070 1086 1025 1212 ...
##  $ SUMT5       : num  191 970 1017 921 1135 ...
##  $ T220        : num  219 810 584 413 732 ...
##  $ T225        : num  191 775 541 354 684 ...
##  $ FT220       : num  219 257 508 612 466 ...
##  $ FT225       : num  191 195 491 575 449 ...
##  $ SPEEDT      : num  -0.8128 -0.0258 0.1621 0.2381 0.1653 ...
##  $ SUMPREC     : num  165 1071 743 850 545 ...
## NULL
##   Station_Code Year   ObsBeg     ObsEnd StartSG EndSG    STDAT0    STDAT5
## 1        23365 1959 1-1-1959 22-12-1959      27    53 15-5-1959 17-6-1959
## 3        23365 1961 3-1-1961 31-12-1961     109   209  5-6-1961 12-6-1961
## 4        23365 1962 1-1-1962 30-12-1962     132   219 16-6-1962 19-6-1962
## 5        23365 1963 1-1-1963 31-12-1963     144   225 15-6-1963 24-6-1963
## 6        23365 1964 1-1-1964 31-12-1964     132   222  8-6-1964 17-6-1964
## 7        23365 1965 1-1-1965 31-12-1965      37   110  6-6-1965 13-6-1965
##       FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT   SUMT0   SUMT5   T220
## 1 22-9-1959 20-9-1959    130     95 23.33 28-7-1959  219.04  191.17 219.04
## 3 20-9-1961 16-9-1961    107    101 23.22  1-7-1961 1070.41  970.15 809.89
## 4 14-9-1962 12-9-1962     90     87 24.22 31-7-1962 1086.27 1017.27 583.77
## 5 12-9-1963  3-9-1963     89     78 25.00 31-7-1963 1024.79  921.35 412.55
## 6 12-9-1964  6-9-1964     96     89 23.89  1-7-1964 1212.00 1134.89 731.84
## 7 26-9-1965  9-9-1965    112     95 23.33 27-7-1965  878.59  843.59 878.59
##     T225  FT220  FT225      SPEEDT SUMPREC
## 1 191.17 219.04 191.17 -0.81279001  165.35
## 3 774.89 256.51 195.26 -0.02579487 1071.12
## 4 540.88 508.11 491.06  0.16206272  742.67
## 5 354.10 612.24 575.14  0.23806404  850.40
## 6 684.44 465.61 449.34  0.16531642  544.57
## 7 843.59  11.28   0.00 -0.47731337  357.12
##       Year         StartSG          EndSG           INTER0     
##  Min.   :1959   Min.   : 27.0   Min.   : 53.0   Min.   : 31.0  
##  1st Qu.:1966   1st Qu.:112.0   1st Qu.:198.5   1st Qu.: 97.0  
##  Median :1971   Median :128.0   Median :223.0   Median :106.0  
##  Mean   :1981   Mean   :116.6   Mean   :206.6   Mean   :105.1  
##  3rd Qu.:2010   3rd Qu.:136.5   3rd Qu.:241.0   3rd Qu.:117.5  
##  Max.   :2015   Max.   :152.0   Max.   :263.0   Max.   :130.0  
##      INTER5           MAXT           SUMT0            SUMT5       
##  Min.   : 30.0   Min.   :18.78   Min.   : 219.0   Min.   : 191.2  
##  1st Qu.: 90.5   1st Qu.:23.22   1st Qu.: 990.3   1st Qu.: 904.4  
##  Median : 97.0   Median :23.72   Median :1207.0   Median :1128.0  
##  Mean   : 97.3   Mean   :23.90   Mean   :1125.7   Mean   :1053.3  
##  3rd Qu.:109.0   3rd Qu.:24.97   3rd Qu.:1401.9   3rd Qu.:1317.7  
##  Max.   :123.0   Max.   :26.67   Max.   :1532.0   Max.   :1453.7  
##       T220            T225           FT220             FT225       
##  Min.   :219.0   Min.   :191.2   Min.   :  11.28   Min.   :   0.0  
##  1st Qu.:477.0   1st Qu.:438.2   1st Qu.: 402.31   1st Qu.: 382.4  
##  Median :583.8   Median :540.9   Median : 633.79   Median : 611.2  
##  Mean   :586.5   Mean   :545.2   Mean   : 624.45   Mean   : 594.4  
##  3rd Qu.:702.5   3rd Qu.:666.0   3rd Qu.: 868.70   3rd Qu.: 838.9  
##  Max.   :955.8   Max.   :887.5   Max.   :1077.33   Max.   :1039.1  
##      SPEEDT            SUMPREC      
##  Min.   :-0.81279   Min.   :  28.7  
##  1st Qu.: 0.05157   1st Qu.: 118.9  
##  Median : 0.16206   Median : 207.5  
##  Mean   : 0.11197   Mean   : 311.2  
##  3rd Qu.: 0.23712   3rd Qu.: 420.6  
##  Max.   : 0.81967   Max.   :1071.1  
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/north/24143099999 DZARDZAN.txt"
## The number of del/rep rows by column precipitation= 449 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##       Day Month Year PRECIP  TMEAN
## 13880   9     1 1996   0.51 -16.44
## 13881  10     1 1996   0.00 -33.61
## 13882  11     1 1996   0.00 -38.39
## 13884  13     1 1996   0.51 -32.56
## 13885  14     1 1996   0.25 -45.56
## 13886  17     1 1996   0.00 -51.89
## [1] "Structure"
## 'data.frame':	13437 obs. of  5 variables:
##  $ Day   : int  5 8 10 11 13 15 17 21 27 4 ...
##  $ Month : int  1 1 1 1 1 1 1 1 1 2 ...
##  $ Year  : int  1948 1948 1948 1948 1948 1948 1948 1948 1948 1948 ...
##  $ PRECIP: num  0.51 0.51 0 0 0.51 0.51 0.25 0 0.51 0 ...
##  $ TMEAN : num  -29.7 -23.1 -40 -36.1 -36.1 ...
## NULL
## [1] "Summary"
##      PRECIP            TMEAN       
##  Min.   :  0.000   Min.   :-59.33  
##  1st Qu.:  0.000   1st Qu.:-30.17  
##  Median :  0.000   Median :-10.50  
##  Mean   :  1.477   Mean   :-12.06  
##  3rd Qu.:  0.510   3rd Qu.:  6.33  
##  Max.   :150.110   Max.   : 26.28  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1948
```

```
## ****** Year: 1948 
## #################### Skip a year!!!! 
## ****** Year: 1949 Observation: 112 Period: 4-1-1949 31-12-1949 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1950 Observation: 209 Period: 6-1-1950 28-12-1950 ******
## ****** Year: 1951 Observation: 167 Period: 3-1-1951 30-12-1951 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1952 Observation: 216 Period: 3-1-1952 29-12-1952 ******
## ****** Year: 1953 Observation: 73 Period: 1-1-1953 31-12-1953 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1954 Observation: 89 Period: 2-1-1954 30-12-1954 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1955 Observation: 200 Period: 2-1-1955 31-12-1955 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1956
```

```
## ****** Year: 1956 
## #################### Skip a year!!!! 
## ****** Year: 1957 Observation: 110 Period: 8-7-1957 30-12-1957 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1958 Observation: 188 Period: 1-1-1958 31-12-1958 ******
## ****** Year: 1959 Observation: 271 Period: 1-1-1959 31-12-1959 ******
## ****** Year: 1960 Observation: 276 Period: 1-1-1960 31-12-1960 ******
## ****** Year: 1961 Observation: 315 Period: 1-1-1961 31-12-1961 ******
## ****** Year: 1962 Observation: 319 Period: 1-1-1962 31-12-1962 ******
## ****** Year: 1963 Observation: 337 Period: 1-1-1963 31-12-1963 ******
## ****** Year: 1964 Observation: 351 Period: 1-1-1964 31-12-1964 ******
## ****** Year: 1965 Observation: 342 Period: 1-1-1965 31-12-1965 ******
## ****** Year: 1966 Observation: 360 Period: 1-1-1966 31-12-1966 ******
## ****** Year: 1967 Observation: 356 Period: 1-1-1967 30-12-1967 ******
## ****** Year: 1968 Observation: 356 Period: 1-1-1968 31-12-1968 ******
## ****** Year: 1969 Observation: 346 Period: 1-1-1969 31-12-1969 ******
## ****** Year: 1970 Observation: 357 Period: 1-1-1970 31-12-1970 ******
## ****** Year: 1971 Observation: 174 Period: 2-1-1971 30-6-1971 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1972
```

```
## ****** Year: 1972 
## #################### Skip a year!!!! 
## ****** Year: 1973 Observation: 355 Period: 1-1-1973 31-12-1973 ******
## ****** Year: 1974 Observation: 351 Period: 1-1-1974 31-12-1974 ******
## ****** Year: 1975 Observation: 357 Period: 1-1-1975 31-12-1975 ******
## ****** Year: 1976 Observation: 359 Period: 1-1-1976 30-12-1976 ******
## ****** Year: 1977 Observation: 357 Period: 1-1-1977 31-12-1977 ******
## ****** Year: 1978 Observation: 361 Period: 1-1-1978 31-12-1978 ******
## ****** Year: 1979 Observation: 364 Period: 1-1-1979 31-12-1979 ******
## ****** Year: 1980 Observation: 365 Period: 1-1-1980 31-12-1980 ******
## ****** Year: 1981 Observation: 359 Period: 1-1-1981 31-12-1981 ******
## ****** Year: 1982 Observation: 355 Period: 1-1-1982 31-12-1982 ******
## ****** Year: 1983 Observation: 341 Period: 1-1-1983 30-12-1983 ******
## ****** Year: 1984 Observation: 324 Period: 3-1-1984 30-12-1984 ******
## ****** Year: 1985 Observation: 344 Period: 2-1-1985 31-12-1985 ******
## ****** Year: 1986 Observation: 357 Period: 1-1-1986 31-12-1986 ******
## ****** Year: 1987 Observation: 359 Period: 1-1-1987 31-12-1987 ******
## ****** Year: 1988 Observation: 358 Period: 1-1-1988 31-12-1988 ******
## ****** Year: 1989 Observation: 357 Period: 1-1-1989 31-12-1989 ******
## ****** Year: 1990 Observation: 362 Period: 1-1-1990 31-12-1990 ******
## ****** Year: 1991 Observation: 328 Period: 1-1-1991 31-12-1991 ******
## ****** Year: 1992 Observation: 335 Period: 1-1-1992 31-12-1992 ******
## ****** Year: 1993 Observation: 305 Period: 1-1-1993 31-12-1993 ******
## ****** Year: 1994 Observation: 267 Period: 1-1-1994 31-12-1994 ******
## ****** Year: 1995 Observation: 256 Period: 1-1-1995 20-12-1995 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1996
```

```
## ****** Year: 1996 
## #################### Skip a year!!!! 
## 
## elapsed time is 27.830000 seconds 
## 'data.frame':	45 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1949 1950 1951 1952 1953 1954 1955 1957 1958 1959 ...
##  $ ObsBeg      : chr  "4-1-1949" "6-1-1950" "3-1-1951" "3-1-1952" ...
##  $ ObsEnd      : chr  "31-12-1949" "28-12-1950" "30-12-1951" "29-12-1952" ...
##  $ StartSG     : num  50 92 78 80 47 32 78 1 70 91 ...
##  $ EndSG       : num  101 173 132 150 62 85 138 30 122 184 ...
##  $ STDAT0      : chr  "29-5-1949" "28-5-1950" "2-6-1951" "9-6-1952" ...
##  $ STDAT5      : chr  "15-6-1949" "4-6-1950" "9-6-1951" "19-6-1952" ...
##  $ FDAT0       : chr  "25-8-1949" "15-9-1950" "30-9-1951" "20-9-1952" ...
##  $ FDAT5       : chr  "25-8-1949" "28-8-1950" "28-9-1951" "19-9-1952" ...
##  $ INTER0      : num  88 110 120 103 124 120 112 64 117 123 ...
##  $ INTER5      : num  87 92 113 102 101 94 89 55 113 119 ...
##  $ MAXT        : num  22.2 21.3 20.8 24.4 24.7 ...
##  $ MDAT        : chr  "15-7-1949" "3-7-1950" "12-7-1951" "3-8-1952" ...
##  $ SUMT0       : num  557 809 615 901 106 ...
##  $ SUMT5       : num  543.8 751 578.9 860.4 96.6 ...
##  $ T220        : num  557 806 615 901 106 ...
##  $ T225        : num  543.8 751 578.9 860.4 96.6 ...
##  $ FT220       : num  556.86 1.16 615.17 0 106.17 ...
##  $ FT225       : num  543.8 0 578.9 0 96.6 ...
##  $ SPEEDT      : num  -0.6492 -0.0353 -0.6051 -0.3957 -2.32 ...
##  $ SUMPREC     : num  61.2 139.7 54.9 92.5 20.1 ...
## NULL
##   Station_Code Year   ObsBeg     ObsEnd StartSG EndSG    STDAT0    STDAT5
## 2        23365 1949 4-1-1949 31-12-1949      50   101 29-5-1949 15-6-1949
## 3        23365 1950 6-1-1950 28-12-1950      92   173 28-5-1950  4-6-1950
## 4        23365 1951 3-1-1951 30-12-1951      78   132  2-6-1951  9-6-1951
## 5        23365 1952 3-1-1952 29-12-1952      80   150  9-6-1952 19-6-1952
## 6        23365 1953 1-1-1953 31-12-1953      47    62 25-5-1953  3-6-1953
## 7        23365 1954 2-1-1954 30-12-1954      32    85 26-5-1954 29-5-1954
##       FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT  SUMT0  SUMT5   T220
## 2 25-8-1949 25-8-1949     88     87 22.22 15-7-1949 556.86 543.82 556.86
## 3 15-9-1950 28-8-1950    110     92 21.33  3-7-1950 809.31 751.00 805.59
## 4 30-9-1951 28-9-1951    120    113 20.83 12-7-1951 615.17 578.91 615.17
## 5 20-9-1952 19-9-1952    103    102 24.44  3-8-1952 900.96 860.42 900.96
## 6 26-9-1953 12-9-1953    124    101 24.72  5-7-1953 106.17  96.62 106.17
## 7 23-9-1954 28-8-1954    120     94 24.17 29-7-1954 629.56 617.17 629.56
##     T225  FT220  FT225      SPEEDT SUMPREC
## 2 543.82 556.86 543.82 -0.64923051   61.22
## 3 751.00   1.16   0.00 -0.03532611  139.73
## 4 578.91 615.17 578.91 -0.60509849   54.88
## 5 860.42   0.00   0.00 -0.39566557   92.48
## 6  96.62 106.17  96.62 -2.32003663   20.07
## 7 617.17 629.56 617.17 -0.40253284   74.93
##       Year         StartSG          EndSG           INTER0     
##  Min.   :1949   Min.   :  1.0   Min.   : 30.0   Min.   : 29.0  
##  1st Qu.:1961   1st Qu.:107.0   1st Qu.:190.0   1st Qu.: 97.0  
##  Median :1973   Median :143.0   Median :243.0   Median :105.0  
##  Mean   :1972   Mean   :126.1   Mean   :214.2   Mean   :103.2  
##  3rd Qu.:1984   3rd Qu.:152.0   3rd Qu.:249.0   3rd Qu.:114.0  
##  Max.   :1995   Max.   :164.0   Max.   :267.0   Max.   :124.0  
##      INTER5            MAXT           SUMT0            SUMT5        
##  Min.   : 28.00   Min.   :17.22   Min.   : 106.2   Min.   :  96.62  
##  1st Qu.: 91.00   1st Qu.:21.78   1st Qu.:1037.1   1st Qu.: 955.88  
##  Median : 97.00   Median :23.44   Median :1145.7   Median :1079.28  
##  Mean   : 96.64   Mean   :22.97   Mean   :1075.2   Mean   :1008.26  
##  3rd Qu.:106.00   3rd Qu.:24.50   3rd Qu.:1277.9   3rd Qu.:1204.08  
##  Max.   :119.00   Max.   :26.28   Max.   :1484.0   Max.   :1409.86  
##       T220             T225             FT220            FT225       
##  Min.   : 106.2   Min.   :  96.62   Min.   :   0.0   Min.   :   0.0  
##  1st Qu.: 275.4   1st Qu.: 235.15   1st Qu.: 522.2   1st Qu.: 475.0  
##  Median : 408.9   Median : 367.79   Median : 803.2   Median : 778.7  
##  Mean   : 448.9   Mean   : 414.77   Mean   : 670.7   Mean   : 645.1  
##  3rd Qu.: 532.7   3rd Qu.: 506.61   3rd Qu.: 915.6   3rd Qu.: 888.8  
##  Max.   :1085.7   Max.   :1065.57   Max.   :1166.4   Max.   :1138.5  
##      SPEEDT              SUMPREC      
##  Min.   :-2.3200366   Min.   : 20.07  
##  1st Qu.:-0.0009154   1st Qu.: 80.50  
##  Median : 0.1980040   Median :113.31  
##  Mean   : 0.1228825   Mean   :192.99  
##  3rd Qu.: 0.3854903   3rd Qu.:227.35  
##  Max.   : 0.9303614   Max.   :879.35  
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/north/24152099999 VERKHOYANSK RANGE.txt"
## The number of del/rep rows by column precipitation= 93 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##      Day Month Year PRECIP  TMEAN
## 1156  25    12 1963   0.00 -28.44
## 1157  26    12 1963   0.00 -24.11
## 1158  27    12 1963   0.51 -29.17
## 1159  28    12 1963   0.51 -41.00
## 1161  30    12 1963   0.25 -42.22
## 1162  31    12 1963   0.25 -43.17
## [1] "Structure"
## 'data.frame':	1069 obs. of  5 variables:
##  $ Day   : int  1 3 4 5 6 7 10 11 12 13 ...
##  $ Month : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Year  : int  1959 1959 1959 1959 1959 1959 1959 1959 1959 1959 ...
##  $ PRECIP: num  0 0.25 0.25 0.51 0.25 0 0 0 0 0.25 ...
##  $ TMEAN : num  -43.6 -40.8 -38.7 -43.1 -41.7 ...
## NULL
## [1] "Summary"
##      PRECIP            TMEAN       
##  Min.   :  0.000   Min.   :-53.44  
##  1st Qu.:  0.000   1st Qu.:-31.11  
##  Median :  0.000   Median :-11.28  
##  Mean   :  5.528   Mean   :-12.91  
##  3rd Qu.:  1.020   3rd Qu.:  5.72  
##  Max.   :150.110   Max.   : 24.28  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1959
```

```
## ****** Year: 1959 
## #################### Skip a year!!!! 
## ****** Year: 1960 
## #################### Skip a year!!!! 
## ****** Year: 1961 Observation: 320 Period: 1-1-1961 31-12-1961 ******
## ****** Year: 1962 Observation: 290 Period: 1-1-1962 31-12-1962 ******
## ****** Year: 1963 Observation: 320 Period: 1-1-1963 31-12-1963 ******
## 
## elapsed time is 1.950000 seconds 
## 'data.frame':	3 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365"
##  $ Year        : int  1961 1962 1963
##  $ ObsBeg      : chr  "1-1-1961" "1-1-1962" "1-1-1963"
##  $ ObsEnd      : chr  "31-12-1961" "31-12-1962" "31-12-1963"
##  $ StartSG     : num  137 115 131
##  $ EndSG       : num  237 134 234
##  $ STDAT0      : chr  "4-6-1961" "28-5-1962" "30-5-1963"
##  $ STDAT5      : chr  "8-6-1961" "1-6-1962" "19-6-1963"
##  $ FDAT0       : chr  "20-9-1961" "16-6-1962" "11-9-1963"
##  $ FDAT5       : chr  "18-9-1961" "14-6-1962" "11-9-1963"
##  $ INTER0      : num  108 19 104
##  $ INTER5      : num  104 17 103
##  $ MAXT        : num  22.8 22.7 24.3
##  $ MDAT        : chr  "1-7-1961" "30-7-1962" "2-8-1963"
##  $ SUMT0       : num  1178 1103 1146
##  $ SUMT5       : num  1119 1050 1083
##  $ T220        : num  535 670 387
##  $ T225        : num  502 628 362
##  $ FT220       : num  650 520 750
##  $ FT225       : num  626 517 721
##  $ SPEEDT      : num  0.2116 0.1881 0.0657
##  $ SUMPREC     : num  673.1 25.6 1078
## NULL
##   Station_Code Year   ObsBeg     ObsEnd StartSG EndSG    STDAT0    STDAT5
## 3        23365 1961 1-1-1961 31-12-1961     137   237  4-6-1961  8-6-1961
## 4        23365 1962 1-1-1962 31-12-1962     115   134 28-5-1962  1-6-1962
## 5        23365 1963 1-1-1963 31-12-1963     131   234 30-5-1963 19-6-1963
##       FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT   SUMT0   SUMT5   T220
## 3 20-9-1961 18-9-1961    108    104 22.78  1-7-1961 1177.67 1118.78 535.47
## 4 16-6-1962 14-6-1962     19     17 22.67 30-7-1962 1102.96 1049.96 670.07
## 5 11-9-1963 11-9-1963    104    103 24.28  2-8-1963 1146.23 1082.90 386.97
##     T225  FT220  FT225     SPEEDT SUMPREC
## 3 501.75 649.92 626.09 0.21159974  673.09
## 4 628.12 520.18 517.29 0.18811345   25.64
## 5 362.08 750.37 720.82 0.06567944 1077.96
##       Year         StartSG          EndSG           INTER0     
##  Min.   :1961   Min.   :115.0   Min.   :134.0   Min.   : 19.0  
##  1st Qu.:1962   1st Qu.:123.0   1st Qu.:184.0   1st Qu.: 61.5  
##  Median :1962   Median :131.0   Median :234.0   Median :104.0  
##  Mean   :1962   Mean   :127.7   Mean   :201.7   Mean   : 77.0  
##  3rd Qu.:1962   3rd Qu.:134.0   3rd Qu.:235.5   3rd Qu.:106.0  
##  Max.   :1963   Max.   :137.0   Max.   :237.0   Max.   :108.0  
##      INTER5            MAXT           SUMT0          SUMT5     
##  Min.   : 17.00   Min.   :22.67   Min.   :1103   Min.   :1050  
##  1st Qu.: 60.00   1st Qu.:22.73   1st Qu.:1125   1st Qu.:1066  
##  Median :103.00   Median :22.78   Median :1146   Median :1083  
##  Mean   : 74.67   Mean   :23.24   Mean   :1142   Mean   :1084  
##  3rd Qu.:103.50   3rd Qu.:23.53   3rd Qu.:1162   3rd Qu.:1101  
##  Max.   :104.00   Max.   :24.28   Max.   :1178   Max.   :1119  
##       T220            T225           FT220           FT225      
##  Min.   :387.0   Min.   :362.1   Min.   :520.2   Min.   :517.3  
##  1st Qu.:461.2   1st Qu.:431.9   1st Qu.:585.0   1st Qu.:571.7  
##  Median :535.5   Median :501.8   Median :649.9   Median :626.1  
##  Mean   :530.8   Mean   :497.3   Mean   :640.2   Mean   :621.4  
##  3rd Qu.:602.8   3rd Qu.:564.9   3rd Qu.:700.1   3rd Qu.:673.5  
##  Max.   :670.1   Max.   :628.1   Max.   :750.4   Max.   :720.8  
##      SPEEDT           SUMPREC       
##  Min.   :0.06568   Min.   :  25.64  
##  1st Qu.:0.12690   1st Qu.: 349.37  
##  Median :0.18811   Median : 673.09  
##  Mean   :0.15513   Mean   : 592.23  
##  3rd Qu.:0.19986   3rd Qu.: 875.52  
##  Max.   :0.21160   Max.   :1077.96  
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/north/38401099999 IGARKA.txt"
## The number of del/rep rows by column precipitation= 1628 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##      Day Month Year PRECIP TMEAN
## 2709  10     6 2013      0 10.83
## 2710  11     6 2013      0 12.22
## 2711  12     6 2013      0 17.06
## 2712  13     6 2013      0 20.56
## 2717  18     7 2013      0 22.83
## 2718  19     7 2013      0 25.67
## [1] "Structure"
## 'data.frame':	1090 obs. of  5 variables:
##  $ Day   : int  24 30 3 4 5 10 14 19 20 23 ...
##  $ Month : int  8 8 9 9 9 9 9 9 9 9 ...
##  $ Year  : int  2004 2004 2004 2004 2004 2004 2004 2004 2004 2004 ...
##  $ PRECIP: num  0 0 0 0 0 0 0 0 0 0 ...
##  $ TMEAN : num  6.22 5.94 10.44 9 7.89 ...
## NULL
## [1] "Summary"
##      PRECIP      TMEAN        
##  Min.   :0   Min.   :-51.060  
##  1st Qu.:0   1st Qu.:-18.207  
##  Median :0   Median : -0.860  
##  Mean   :0   Mean   : -4.808  
##  3rd Qu.:0   3rd Qu.: 10.375  
##  Max.   :0   Max.   : 26.110  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2004
```

```
## ****** Year: 2004 
## #################### Skip a year!!!! 
## ****** Year: 2005 Observation: 78 Period: 31-1-2005 23-12-2005 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 2006 Observation: 124 Period: 6-1-2006 12-12-2006 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 2007 Observation: 140 Period: 10-1-2007 25-12-2007 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 2008 Observation: 138 Period: 6-1-2008 28-12-2008 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 2009 Observation: 167 Period: 2-1-2009 31-12-2009 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 2010 Observation: 151 Period: 5-1-2010 31-12-2010 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 2011 Observation: 89 Period: 9-1-2011 6-11-2011 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 2012 Observation: 118 Period: 3-1-2012 19-12-2012 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 2013 
## #################### Skip a year!!!! 
## 
## elapsed time is 3.150000 seconds 
## 'data.frame':	8 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  2005 2006 2007 2008 2009 2010 2011 2012
##  $ ObsBeg      : chr  "31-1-2005" "6-1-2006" "10-1-2007" "6-1-2008" ...
##  $ ObsEnd      : chr  "23-12-2005" "12-12-2006" "25-12-2007" "28-12-2008" ...
##  $ StartSG     : num  16 49 56 55 65 79 30 33
##  $ EndSG       : num  74 111 114 112 134 115 86 93
##  $ STDAT0      : chr  "13-5-2005" "29-5-2006" "27-5-2007" "28-5-2008" ...
##  $ STDAT5      : chr  "30-5-2005" "4-6-2006" "11-6-2007" "15-6-2008" ...
##  $ FDAT0       : chr  "22-9-2005" "25-9-2006" "26-9-2007" "30-9-2008" ...
##  $ FDAT5       : chr  "22-9-2005" "18-9-2006" "20-9-2007" "12-9-2008" ...
##  $ INTER0      : num  132 119 122 125 128 119 149 125
##  $ INTER5      : num  125 111 116 105 112 95 142 115
##  $ MAXT        : num  22.4 21.8 26.1 21 23.9 ...
##  $ MDAT        : chr  "25-7-2005" "24-7-2006" "6-7-2007" "1-8-2008" ...
##  $ SUMT0       : num  728 722 747 697 909 ...
##  $ SUMT5       : num  705 700 715 677 861 ...
##  $ T220        : num  728 722 747 697 909 ...
##  $ T225        : num  705 700 715 677 861 ...
##  $ FT220       : num  728 722 747 697 909 ...
##  $ FT225       : num  705 700 715 677 861 ...
##  $ SPEEDT      : num  -0.328 -0.516 -0.488 -0.488 -0.608 ...
##  $ SUMPREC     : num  0 0 0 0 0 0 0 0
## NULL
##   Station_Code Year    ObsBeg     ObsEnd StartSG EndSG    STDAT0    STDAT5
## 2        23365 2005 31-1-2005 23-12-2005      16    74 13-5-2005 30-5-2005
## 3        23365 2006  6-1-2006 12-12-2006      49   111 29-5-2006  4-6-2006
## 4        23365 2007 10-1-2007 25-12-2007      56   114 27-5-2007 11-6-2007
## 5        23365 2008  6-1-2008 28-12-2008      55   112 28-5-2008 15-6-2008
## 6        23365 2009  2-1-2009 31-12-2009      65   134  4-6-2009 21-6-2009
## 7        23365 2010  5-1-2010 31-12-2010      79   115 31-5-2010  4-6-2010
##        FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT  SUMT0  SUMT5   T220
## 2  22-9-2005 22-9-2005    132    125 22.44 25-7-2005 728.10 705.33 728.10
## 3  25-9-2006 18-9-2006    119    111 21.83 24-7-2006 721.75 700.19 721.75
## 4  26-9-2007 20-9-2007    122    116 26.11  6-7-2007 746.96 715.12 746.96
## 5  30-9-2008 12-9-2008    125    105 21.00  1-8-2008 696.67 677.40 696.67
## 6 10-10-2009 2-10-2009    128    112 23.94 10-7-2009 908.85 860.70 908.85
## 7  27-9-2010  3-9-2010    119     95 20.44 13-7-2010 329.18 308.23 329.18
##     T225  FT220  FT225     SPEEDT SUMPREC
## 2 705.33 728.10 705.33 -0.3276493       0
## 3 700.19 721.75 700.19 -0.5160104       0
## 4 715.12 746.96 715.12 -0.4884798       0
## 5 677.40 696.67 677.40 -0.4878062       0
## 6 860.70 908.85 860.70 -0.6078506       0
## 7 308.23 329.18 308.23 -0.7186301       0
##       Year         StartSG          EndSG            INTER0     
##  Min.   :2005   Min.   :16.00   Min.   : 74.00   Min.   :119.0  
##  1st Qu.:2007   1st Qu.:32.25   1st Qu.: 91.25   1st Qu.:121.2  
##  Median :2008   Median :52.00   Median :111.50   Median :125.0  
##  Mean   :2008   Mean   :47.88   Mean   :104.88   Mean   :127.4  
##  3rd Qu.:2010   3rd Qu.:58.25   3rd Qu.:114.25   3rd Qu.:129.0  
##  Max.   :2012   Max.   :79.00   Max.   :134.00   Max.   :149.0  
##      INTER5           MAXT           SUMT0           SUMT5      
##  Min.   : 95.0   Min.   :20.11   Min.   :329.2   Min.   :308.2  
##  1st Qu.:109.5   1st Qu.:20.86   1st Qu.:670.6   1st Qu.:643.8  
##  Median :113.5   Median :22.14   Median :724.9   Median :702.8  
##  Mean   :115.1   Mean   :22.58   Mean   :682.0   Mean   :653.7  
##  3rd Qu.:118.2   3rd Qu.:24.15   3rd Qu.:736.2   3rd Qu.:716.2  
##  Max.   :142.0   Max.   :26.11   Max.   :908.9   Max.   :860.7  
##       T220            T225           FT220           FT225      
##  Min.   :329.2   Min.   :308.2   Min.   :329.2   Min.   :308.2  
##  1st Qu.:670.6   1st Qu.:643.8   1st Qu.:670.6   1st Qu.:643.8  
##  Median :724.9   Median :702.8   Median :724.9   Median :702.8  
##  Mean   :682.0   Mean   :653.7   Mean   :682.0   Mean   :653.7  
##  3rd Qu.:736.2   3rd Qu.:716.2   3rd Qu.:736.2   3rd Qu.:716.2  
##  Max.   :908.9   Max.   :860.7   Max.   :908.9   Max.   :860.7  
##      SPEEDT           SUMPREC 
##  Min.   :-0.7186   Min.   :0  
##  1st Qu.:-0.5540   1st Qu.:0  
##  Median :-0.5022   Median :0  
##  Mean   :-0.4932   Mean   :0  
##  3rd Qu.:-0.4478   3rd Qu.:0  
##  Max.   :-0.2628   Max.   :0  
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/yenisei/23066099999 UST PORT UST ENISEISK.txt"
## The number of del/rep rows by column precipitation= 127 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##      Day Month Year PRECIP  TMEAN
## 1016   3    12 1955      0 -37.94
## 1017   7    12 1955      0 -38.78
## 1018  10    12 1955      0 -42.94
## 1019  12    12 1955      0 -40.56
## 1020  14    12 1955      0 -41.94
## 1021  16    12 1955      0 -26.94
## [1] "Structure"
## 'data.frame':	896 obs. of  5 variables:
##  $ Day   : int  11 27 5 7 12 13 17 23 24 11 ...
##  $ Month : int  1 1 2 3 3 3 3 6 12 1 ...
##  $ Year  : int  1948 1948 1948 1948 1948 1948 1948 1948 1948 1949 ...
##  $ PRECIP: num  0 0.25 0 0.51 1.02 1.02 0 0 0.51 0.51 ...
##  $ TMEAN : num  -40.1 -18.2 -36 -32.1 -14.7 ...
## NULL
## [1] "Summary"
##      PRECIP            TMEAN        
##  Min.   :  0.000   Min.   :-45.560  
##  1st Qu.:  0.000   1st Qu.:-23.060  
##  Median :  0.510   Median : -7.085  
##  Mean   :  1.186   Mean   : -9.466  
##  3rd Qu.:  1.020   3rd Qu.:  3.610  
##  Max.   :100.080   Max.   : 22.780  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1948
```

```
## ****** Year: 1948 
## #################### Skip a year!!!! 
## ****** Year: 1949 Observation: 101 Period: 11-1-1949 31-12-1949 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1950 Observation: 155 Period: 5-1-1950 27-12-1950 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1951 Observation: 164 Period: 10-1-1951 27-12-1951 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1952 Observation: 156 Period: 2-1-1952 25-12-1952 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1953 Observation: 108 Period: 8-1-1953 28-12-1953 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1954 Observation: 145 Period: 3-1-1954 30-12-1954 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1955 
## #################### Skip a year!!!! 
## 
## elapsed time is 2.730000 seconds 
## 'data.frame':	6 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1949 1950 1951 1952 1953 1954
##  $ ObsBeg      : chr  "11-1-1949" "5-1-1950" "10-1-1951" "2-1-1952" ...
##  $ ObsEnd      : chr  "31-12-1949" "27-12-1950" "27-12-1951" "25-12-1952" ...
##  $ StartSG     : num  16 93 72 75 56 80
##  $ EndSG       : num  45 125 115 124 86 121
##  $ STDAT0      : chr  "9-7-1949" "13-6-1950" "19-6-1951" "19-6-1952" ...
##  $ STDAT5      : chr  "9-7-1949" "28-7-1950" "6-7-1951" "4-7-1952" ...
##  $ FDAT0       : chr  "16-9-1949" "24-9-1950" "7-9-1951" "21-9-1952" ...
##  $ FDAT5       : chr  "11-9-1949" "24-9-1950" "1-9-1951" "21-9-1952" ...
##  $ INTER0      : num  69 103 80 94 97 89
##  $ INTER5      : num  64 97 70 85 74 77
##  $ MAXT        : num  20 15.1 18.1 17.1 21 ...
##  $ MDAT        : chr  "4-8-1949" "29-7-1950" "29-7-1951" "30-7-1952" ...
##  $ SUMT0       : num  246 239 439 464 283 ...
##  $ SUMT5       : num  223 194 387 402 226 ...
##  $ T220        : num  246 239 439 464 283 ...
##  $ T225        : num  223 194 387 402 226 ...
##  $ FT220       : num  246 239 439 464 283 ...
##  $ FT225       : num  223 194 387 402 226 ...
##  $ SPEEDT      : num  -0.55 -0.639 -0.402 -0.616 -0.715 ...
##  $ SUMPREC     : num  80.8 72.4 99.6 99.6 56.4 ...
## NULL
##   Station_Code Year    ObsBeg     ObsEnd StartSG EndSG    STDAT0    STDAT5
## 2        23365 1949 11-1-1949 31-12-1949      16    45  9-7-1949  9-7-1949
## 3        23365 1950  5-1-1950 27-12-1950      93   125 13-6-1950 28-7-1950
## 4        23365 1951 10-1-1951 27-12-1951      72   115 19-6-1951  6-7-1951
## 5        23365 1952  2-1-1952 25-12-1952      75   124 19-6-1952  4-7-1952
## 6        23365 1953  8-1-1953 28-12-1953      56    86 10-6-1953 27-6-1953
## 7        23365 1954  3-1-1954 30-12-1954      80   121 19-6-1954  8-7-1954
##       FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT  SUMT0  SUMT5   T220
## 2 16-9-1949 11-9-1949     69     64 20.00  4-8-1949 245.84 222.52 245.84
## 3 24-9-1950 24-9-1950    103     97 15.11 29-7-1950 239.26 194.00 239.26
## 4  7-9-1951  1-9-1951     80     70 18.06 29-7-1951 439.34 386.90 439.34
## 5 21-9-1952 21-9-1952     94     85 17.11 30-7-1952 463.67 402.18 463.67
## 6 15-9-1953 30-8-1953     97     74 21.00 20-7-1953 282.74 226.06 282.74
## 7 16-9-1954  4-9-1954     89     77 22.78 26-7-1954 513.97 483.52 513.97
##     T225  FT220  FT225     SPEEDT SUMPREC
## 2 222.52 245.84 222.52 -0.5504825   80.79
## 3 194.00 239.26 194.00 -0.6386943   72.42
## 4 386.90 439.34 386.90 -0.4016553   99.57
## 5 402.18 463.67 402.18 -0.6157164   99.59
## 6 226.06 282.74 226.06 -0.7153846   56.40
## 7 483.52 513.97 483.52 -0.4735209   43.21
##       Year         StartSG          EndSG            INTER0      
##  Min.   :1949   Min.   :16.00   Min.   : 45.00   Min.   : 69.00  
##  1st Qu.:1950   1st Qu.:60.00   1st Qu.: 93.25   1st Qu.: 82.25  
##  Median :1952   Median :73.50   Median :118.00   Median : 91.50  
##  Mean   :1952   Mean   :65.33   Mean   :102.67   Mean   : 88.67  
##  3rd Qu.:1953   3rd Qu.:78.75   3rd Qu.:123.25   3rd Qu.: 96.25  
##  Max.   :1954   Max.   :93.00   Max.   :125.00   Max.   :103.00  
##      INTER5           MAXT           SUMT0           SUMT5      
##  Min.   :64.00   Min.   :15.11   Min.   :239.3   Min.   :194.0  
##  1st Qu.:71.00   1st Qu.:17.35   1st Qu.:255.1   1st Qu.:223.4  
##  Median :75.50   Median :19.03   Median :361.0   Median :306.5  
##  Mean   :77.83   Mean   :19.01   Mean   :364.1   Mean   :319.2  
##  3rd Qu.:83.00   3rd Qu.:20.75   3rd Qu.:457.6   3rd Qu.:398.4  
##  Max.   :97.00   Max.   :22.78   Max.   :514.0   Max.   :483.5  
##       T220            T225           FT220           FT225      
##  Min.   :239.3   Min.   :194.0   Min.   :239.3   Min.   :194.0  
##  1st Qu.:255.1   1st Qu.:223.4   1st Qu.:255.1   1st Qu.:223.4  
##  Median :361.0   Median :306.5   Median :361.0   Median :306.5  
##  Mean   :364.1   Mean   :319.2   Mean   :364.1   Mean   :319.2  
##  3rd Qu.:457.6   3rd Qu.:398.4   3rd Qu.:457.6   3rd Qu.:398.4  
##  Max.   :514.0   Max.   :483.5   Max.   :514.0   Max.   :483.5  
##      SPEEDT           SUMPREC     
##  Min.   :-0.7154   Min.   :43.21  
##  1st Qu.:-0.6329   1st Qu.:60.41  
##  Median :-0.5831   Median :76.61  
##  Mean   :-0.5659   Mean   :75.33  
##  3rd Qu.:-0.4928   3rd Qu.:94.88  
##  Max.   :-0.4017   Max.   :99.59  
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/yenisei/23078099999 NORIL'SK.txt"
## The number of del/rep rows by column precipitation= 426 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##      Day Month Year PRECIP  TMEAN
## 8377  26    12 2015   0.00 -28.56
## 8378  27    12 2015   0.00 -26.61
## 8379  28    12 2015   0.25 -26.78
## 8380  29    12 2015   0.00 -29.00
## 8381  30    12 2015   0.00 -26.39
## 8382  31    12 2015   0.00 -24.11
## [1] "Structure"
## 'data.frame':	7956 obs. of  5 variables:
##  $ Day   : int  4 22 23 25 26 27 28 29 30 31 ...
##  $ Month : int  10 10 10 10 10 10 10 10 10 10 ...
##  $ Year  : int  1975 1975 1975 1975 1975 1975 1975 1975 1975 1975 ...
##  $ PRECIP: num  0 0.76 0 0 0 0.25 2.03 0.25 0.51 0 ...
##  $ TMEAN : num  -3.78 -16.89 -21.39 -27.83 -17.28 ...
## NULL
## [1] "Summary"
##      PRECIP           TMEAN       
##  Min.   :  0.00   Min.   :-52.50  
##  1st Qu.:  0.00   1st Qu.:-22.22  
##  Median :  0.00   Median : -8.78  
##  Mean   :  1.19   Mean   : -9.06  
##  3rd Qu.:  1.02   3rd Qu.:  5.17  
##  Max.   :141.99   Max.   : 26.61  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1975
```

```
## ****** Year: 1975 
## #################### Skip a year!!!! 
## ****** Year: 1976 Observation: 343 Period: 2-1-1976 31-12-1976 ******
## ****** Year: 1977 Observation: 325 Period: 1-1-1977 30-12-1977 ******
## ****** Year: 1978 Observation: 319 Period: 1-1-1978 31-12-1978 ******
## ****** Year: 1979 Observation: 332 Period: 1-1-1979 31-12-1979 ******
## ****** Year: 1980 Observation: 342 Period: 1-1-1980 31-12-1980 ******
## ****** Year: 1981 Observation: 350 Period: 1-1-1981 31-12-1981 ******
## ****** Year: 1982 Observation: 316 Period: 1-1-1982 31-12-1982 ******
## ****** Year: 1983 Observation: 336 Period: 1-1-1983 31-12-1983 ******
## ****** Year: 1984 Observation: 303 Period: 1-1-1984 31-12-1984 ******
## ****** Year: 1985 Observation: 351 Period: 2-1-1985 31-12-1985 ******
## ****** Year: 1986 Observation: 347 Period: 1-1-1986 31-12-1986 ******
## ****** Year: 1987 Observation: 359 Period: 1-1-1987 31-12-1987 ******
## ****** Year: 1988 Observation: 365 Period: 1-1-1988 31-12-1988 ******
## ****** Year: 1989 Observation: 358 Period: 1-1-1989 31-12-1989 ******
## ****** Year: 1990 Observation: 358 Period: 1-1-1990 31-12-1990 ******
## ****** Year: 1991 Observation: 307 Period: 1-1-1991 31-12-1991 ******
## ****** Year: 1992 Observation: 236 Period: 2-1-1992 31-12-1992 ******
## ****** Year: 1993 Observation: 351 Period: 1-1-1993 31-12-1993 ******
## ****** Year: 1994 Observation: 347 Period: 1-1-1994 31-12-1994 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1995
```

```
## ****** Year: 1995 
## #################### Skip a year!!!! 
## ****** Year: 1996 Observation: 87 Period: 20-5-1996 31-12-1996 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1997 Observation: 132 Period: 8-1-1997 31-12-1997 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1998
```

```
## ****** Year: 1998 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1999
```

```
## ****** Year: 1999 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2000
```

```
## ****** Year: 2000 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2001
```

```
## ****** Year: 2001 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2002
```

```
## ****** Year: 2002 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2003
```

```
## ****** Year: 2003 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2004
```

```
## ****** Year: 2004 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2005
```

```
## ****** Year: 2005 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2006
```

```
## ****** Year: 2006 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2007
```

```
## ****** Year: 2007 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2008
```

```
## ****** Year: 2008 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2009
```

```
## ****** Year: 2009 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2010
```

```
## ****** Year: 2010 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2011
```

```
## ****** Year: 2011 
## #################### Skip a year!!!! 
## ****** Year: 2012 Observation: 298 Period: 29-2-2012 31-12-2012 ******
## ****** Year: 2013 Observation: 319 Period: 1-1-2013 31-12-2013 ******
## ****** Year: 2014 Observation: 278 Period: 1-1-2014 31-12-2014 ******
## ****** Year: 2015 Observation: 348 Period: 1-1-2015 31-12-2015 ******
## 
## elapsed time is 20.560000 seconds 
## 'data.frame':	25 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1976 1977 1978 1979 1980 1981 1982 1983 1984 1985 ...
##  $ ObsBeg      : chr  "2-1-1976" "1-1-1977" "1-1-1978" "1-1-1979" ...
##  $ ObsEnd      : chr  "31-12-1976" "30-12-1977" "31-12-1978" "31-12-1979" ...
##  $ StartSG     : num  160 146 146 151 158 157 144 151 146 140 ...
##  $ EndSG       : num  253 239 218 242 236 256 226 255 236 239 ...
##  $ STDAT0      : chr  "14-6-1976" "15-6-1977" "20-6-1978" "7-6-1979" ...
##  $ STDAT5      : chr  "21-6-1976" "22-6-1977" "26-6-1978" "12-6-1979" ...
##  $ FDAT0       : chr  "22-9-1976" "23-9-1977" "13-9-1978" "14-9-1979" ...
##  $ FDAT5       : chr  "13-9-1976" "20-9-1977" "9-9-1978" "9-9-1979" ...
##  $ INTER0      : num  100 100 85 99 81 98 95 114 112 101 ...
##  $ INTER5      : num  91 97 77 94 73 95 94 109 97 96 ...
##  $ MAXT        : num  22 22.6 23.8 26.6 20.7 ...
##  $ MDAT        : chr  "27-6-1976" "28-6-1977" "14-7-1978" "5-7-1979" ...
##  $ SUMT0       : num  1069 1071 963 1169 1056 ...
##  $ SUMT5       : num  988 963 875 1101 949 ...
##  $ T220        : num  220 427 457 269 242 ...
##  $ T225        : num  176 354 411 232 183 ...
##  $ FT220       : num  861 658 505 878 760 ...
##  $ FT225       : num  828 623 482 861 734 ...
##  $ SPEEDT      : num  1.285 0.202 0.537 0.424 0.883 ...
##  $ SUMPREC     : num  185 112 50 233 102 ...
## NULL
##   Station_Code Year   ObsBeg     ObsEnd StartSG EndSG    STDAT0    STDAT5
## 2        23365 1976 2-1-1976 31-12-1976     160   253 14-6-1976 21-6-1976
## 3        23365 1977 1-1-1977 30-12-1977     146   239 15-6-1977 22-6-1977
## 4        23365 1978 1-1-1978 31-12-1978     146   218 20-6-1978 26-6-1978
## 5        23365 1979 1-1-1979 31-12-1979     151   242  7-6-1979 12-6-1979
## 6        23365 1980 1-1-1980 31-12-1980     158   236 25-6-1980  1-7-1980
## 7        23365 1981 1-1-1981 31-12-1981     157   256 13-6-1981 18-6-1981
##       FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT   SUMT0   SUMT5   T220
## 2 22-9-1976 13-9-1976    100     91 22.00 27-6-1976 1069.42  988.04 219.79
## 3 23-9-1977 20-9-1977    100     97 22.61 28-6-1977 1071.17  962.78 426.93
## 4 13-9-1978  9-9-1978     85     77 23.83 14-7-1978  962.97  875.41 456.58
## 5 14-9-1979  9-9-1979     99     94 26.61  5-7-1979 1168.70 1100.59 269.40
## 6 14-9-1980  8-9-1980     81     73 20.72 14-7-1980 1056.20  949.42 242.35
## 7 19-9-1981 16-9-1981     98     95 21.61  8-7-1981 1141.78 1076.68 167.88
##     T225  FT220  FT225     SPEEDT SUMPREC
## 2 175.79 861.07 827.69  1.2846593  184.92
## 3 353.60 658.41 623.35  0.2024481  111.75
## 4 410.62 505.47 482.02  0.5373993   50.03
## 5 232.28 878.36 861.25  0.4243478  232.93
## 6 183.45 759.74 733.69  0.8826618  102.14
## 7 135.67 980.51 947.62 -0.1419853  192.28
##       Year         StartSG          EndSG         INTER0     
##  Min.   :1976   Min.   : 17.0   Min.   : 61   Min.   : 69.0  
##  1st Qu.:1982   1st Qu.:140.0   1st Qu.:226   1st Qu.: 90.0  
##  Median :1988   Median :151.0   Median :239   Median :100.0  
##  Mean   :1990   Mean   :136.8   Mean   :223   Mean   : 98.8  
##  3rd Qu.:1994   3rd Qu.:157.0   3rd Qu.:252   3rd Qu.:110.0  
##  Max.   :2015   Max.   :183.0   Max.   :264   Max.   :117.0  
##      INTER5            MAXT           SUMT0            SUMT5       
##  Min.   : 67.00   Min.   :17.72   Min.   : 473.4   Min.   : 398.2  
##  1st Qu.: 83.00   1st Qu.:21.78   1st Qu.: 963.0   1st Qu.: 875.4  
##  Median : 94.00   Median :23.67   Median :1098.6   Median : 988.0  
##  Mean   : 90.68   Mean   :23.02   Mean   :1047.0   Mean   : 969.6  
##  3rd Qu.: 97.00   3rd Qu.:24.50   3rd Qu.:1175.2   3rd Qu.:1100.6  
##  Max.   :109.00   Max.   :26.61   Max.   :1328.7   Max.   :1294.2  
##       T220              T225             FT220            FT225      
##  Min.   :  40.05   Min.   :  10.83   Min.   :  3.17   Min.   :  0.0  
##  1st Qu.: 198.03   1st Qu.: 156.07   1st Qu.:606.19   1st Qu.:578.5  
##  Median : 308.44   Median : 277.94   Median :769.63   Median :758.5  
##  Mean   : 362.78   Mean   : 322.82   Mean   :704.11   Mean   :674.2  
##  3rd Qu.: 456.58   3rd Qu.: 398.19   3rd Qu.:864.69   3rd Qu.:835.2  
##  Max.   :1084.06   Max.   :1059.96   Max.   :999.59   Max.   :958.8  
##      SPEEDT             SUMPREC      
##  Min.   :-0.757776   Min.   : 28.46  
##  1st Qu.:-0.008013   1st Qu.: 68.32  
##  Median : 0.202448   Median :124.46  
##  Mean   : 0.319531   Mean   :142.40  
##  3rd Qu.: 0.537399   3rd Qu.:200.67  
##  Max.   : 1.583727   Max.   :335.76  
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/yenisei/23179099999 SNEZHNOGORSK.txt"
## The number of del/rep rows by column precipitation= 289 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##      Day Month Year PRECIP  TMEAN
## 8461  26    12 2015   0.00 -26.39
## 8462  27    12 2015   0.00 -26.56
## 8463  28    12 2015   0.00 -24.83
## 8464  29    12 2015   2.29 -20.39
## 8465  30    12 2015   0.51 -20.17
## 8466  31    12 2015   0.00 -28.61
## [1] "Structure"
## 'data.frame':	8177 obs. of  5 variables:
##  $ Day   : int  1 2 5 6 7 8 9 10 12 14 ...
##  $ Month : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Year  : int  1973 1973 1973 1973 1973 1973 1973 1973 1973 1973 ...
##  $ PRECIP: num  2.03 3.05 1.27 1.02 2.29 1.52 1.02 2.54 0.25 2.03 ...
##  $ TMEAN : num  -15 -16 -13.8 -22.8 -22 ...
## NULL
## [1] "Summary"
##      PRECIP          TMEAN        
##  Min.   : 0.00   Min.   :-52.830  
##  1st Qu.: 0.00   1st Qu.:-21.330  
##  Median : 0.25   Median : -7.220  
##  Mean   : 1.38   Mean   : -8.241  
##  3rd Qu.: 1.52   3rd Qu.:  5.780  
##  Max.   :99.06   Max.   : 26.170  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
## ****** Year: 1973 Observation: 318 Period: 1-1-1973 31-12-1973 ******
## ****** Year: 1974 Observation: 338 Period: 1-1-1974 31-12-1974 ******
## ****** Year: 1975 Observation: 358 Period: 1-1-1975 30-12-1975 ******
## ****** Year: 1976 Observation: 339 Period: 1-1-1976 31-12-1976 ******
## ****** Year: 1977 Observation: 318 Period: 1-1-1977 31-12-1977 ******
## ****** Year: 1978 Observation: 338 Period: 1-1-1978 31-12-1978 ******
## ****** Year: 1979 Observation: 334 Period: 1-1-1979 31-12-1979 ******
## ****** Year: 1980 Observation: 335 Period: 1-1-1980 31-12-1980 ******
## ****** Year: 1981 Observation: 340 Period: 1-1-1981 31-12-1981 ******
## ****** Year: 1982 Observation: 298 Period: 6-1-1982 31-12-1982 ******
## ****** Year: 1983 Observation: 335 Period: 1-1-1983 31-12-1983 ******
## ****** Year: 1984 Observation: 306 Period: 2-1-1984 31-12-1984 ******
## ****** Year: 1985 Observation: 349 Period: 1-1-1985 31-12-1985 ******
## ****** Year: 1986 Observation: 345 Period: 1-1-1986 31-12-1986 ******
## ****** Year: 1987 Observation: 358 Period: 1-1-1987 31-12-1987 ******
## ****** Year: 1988 Observation: 359 Period: 1-1-1988 31-12-1988 ******
## ****** Year: 1989 Observation: 356 Period: 1-1-1989 31-12-1989 ******
## ****** Year: 1990 Observation: 359 Period: 1-1-1990 31-12-1990 ******
## ****** Year: 1991 Observation: 305 Period: 1-1-1991 30-12-1991 ******
## ****** Year: 1992 Observation: 114 Period: 2-1-1992 31-12-1992 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1993 Observation: 192 Period: 2-1-1993 31-12-1993 ******
## ****** Year: 1994 Observation: 174 Period: 1-1-1994 31-12-1994 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1995
```

```
## ****** Year: 1995 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1996
```

```
## ****** Year: 1996 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1997
```

```
## ****** Year: 1997 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1998
```

```
## ****** Year: 1998 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1999
```

```
## ****** Year: 1999 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2000
```

```
## ****** Year: 2000 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2001
```

```
## ****** Year: 2001 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2002
```

```
## ****** Year: 2002 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2003
```

```
## ****** Year: 2003 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2004
```

```
## ****** Year: 2004 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2005
```

```
## ****** Year: 2005 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2006
```

```
## ****** Year: 2006 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2007
```

```
## ****** Year: 2007 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2008
```

```
## ****** Year: 2008 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2009
```

```
## ****** Year: 2009 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2010
```

```
## ****** Year: 2010 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2011
```

```
## ****** Year: 2011 
## #################### Skip a year!!!! 
## ****** Year: 2012 Observation: 269 Period: 28-3-2012 31-12-2012 ******
## ****** Year: 2013 Observation: 345 Period: 1-1-2013 30-12-2013 ******
## ****** Year: 2014 Observation: 334 Period: 1-1-2014 31-12-2014 ******
## ****** Year: 2015 Observation: 361 Period: 1-1-2015 31-12-2015 ******
## 
## elapsed time is 17.540000 seconds 
## 'data.frame':	26 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 ...
##  $ ObsBeg      : chr  "1-1-1973" "1-1-1974" "1-1-1975" "1-1-1976" ...
##  $ ObsEnd      : chr  "31-12-1973" "31-12-1974" "30-12-1975" "31-12-1976" ...
##  $ StartSG     : num  144 163 164 155 141 157 154 157 150 128 ...
##  $ EndSG       : num  219 239 267 252 231 236 250 230 251 209 ...
##  $ STDAT0      : chr  "2-7-1973" "1-7-1974" "16-6-1975" "14-6-1976" ...
##  $ STDAT5      : chr  "11-7-1973" "7-7-1974" "17-6-1975" "22-6-1976" ...
##  $ FDAT0       : chr  "20-9-1973" "18-9-1974" "29-9-1975" "23-9-1976" ...
##  $ FDAT5       : chr  "13-9-1973" "15-9-1974" "22-9-1975" "21-9-1976" ...
##  $ INTER0      : num  80 79 105 101 100 85 101 82 102 98 ...
##  $ INTER5      : num  73 76 98 98 98 76 91 74 94 92 ...
##  $ MAXT        : num  21.6 18.7 22.8 23.6 23.2 ...
##  $ MDAT        : chr  "27-7-1973" "28-7-1974" "22-7-1975" "29-6-1976" ...
##  $ SUMT0       : num  1050 920 1224 1159 1023 ...
##  $ SUMT5       : num  958 843 1147 1063 929 ...
##  $ T220        : num  568 217 190 310 445 ...
##  $ T225        : num  508 159 151 252 387 ...
##  $ FT220       : num  479 707 1036 855 590 ...
##  $ FT225       : num  459 694 1005 827 554 ...
##  $ SPEEDT      : num  0.477 0.492 -0.352 0.784 0.109 ...
##  $ SUMPREC     : num  148.6 91.9 173 71.6 126 ...
## NULL
##   Station_Code Year   ObsBeg     ObsEnd StartSG EndSG    STDAT0    STDAT5
## 1        23365 1973 1-1-1973 31-12-1973     144   219  2-7-1973 11-7-1973
## 2        23365 1974 1-1-1974 31-12-1974     163   239  1-7-1974  7-7-1974
## 3        23365 1975 1-1-1975 30-12-1975     164   267 16-6-1975 17-6-1975
## 4        23365 1976 1-1-1976 31-12-1976     155   252 14-6-1976 22-6-1976
## 5        23365 1977 1-1-1977 31-12-1977     141   231 15-6-1977 23-6-1977
## 6        23365 1978 1-1-1978 31-12-1978     157   236 19-6-1978 28-6-1978
##       FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT   SUMT0   SUMT5   T220
## 1 20-9-1973 13-9-1973     80     73 21.61 27-7-1973 1049.78  958.07 567.82
## 2 18-9-1974 15-9-1974     79     76 18.67 28-7-1974  920.12  843.04 217.25
## 3 29-9-1975 22-9-1975    105     98 22.83 22-7-1975 1224.14 1147.42 190.45
## 4 23-9-1976 21-9-1976    101     98 23.61 29-6-1976 1158.84 1063.27 310.44
## 5 23-9-1977 21-9-1977    100     98 23.17 29-6-1977 1023.17  928.73 444.60
## 6 12-9-1978  8-9-1978     85     76 21.39 14-7-1978 1020.88  893.08 249.79
##     T225   FT220   FT225     SPEEDT SUMPREC
## 1 507.77  478.79  458.80  0.4768571  148.62
## 2 158.77  707.37  693.99  0.4924242   91.94
## 3 151.33 1035.80 1004.92 -0.3518333  172.99
## 4 251.88  854.84  826.56  0.7837368   71.63
## 5 386.89  590.35  553.62  0.1088105  126.00
## 6 183.61  745.36  717.80  0.9989559   47.52
##       Year         StartSG          EndSG           INTER0     
##  Min.   :1973   Min.   : 37.0   Min.   : 70.0   Min.   : 74.0  
##  1st Qu.:1979   1st Qu.:141.0   1st Qu.:230.2   1st Qu.: 96.5  
##  Median :1986   Median :150.0   Median :240.5   Median :101.0  
##  Mean   :1988   Mean   :138.9   Mean   :226.3   Mean   :100.8  
##  3rd Qu.:1992   3rd Qu.:156.5   3rd Qu.:251.0   3rd Qu.:111.0  
##  Max.   :2015   Max.   :177.0   Max.   :267.0   Max.   :122.0  
##      INTER5            MAXT           SUMT0            SUMT5       
##  Min.   : 70.00   Min.   :18.17   Min.   : 315.7   Min.   : 303.4  
##  1st Qu.: 88.25   1st Qu.:20.11   1st Qu.: 974.5   1st Qu.: 872.2  
##  Median : 94.50   Median :21.70   Median :1132.5   Median :1034.8  
##  Mean   : 92.77   Mean   :21.79   Mean   :1057.6   Mean   : 978.9  
##  3rd Qu.:100.25   3rd Qu.:23.21   3rd Qu.:1225.3   3rd Qu.:1154.7  
##  Max.   :115.00   Max.   :26.17   Max.   :1420.2   Max.   :1368.8  
##       T220              T225             FT220             FT225       
##  Min.   :  71.24   Min.   :  24.56   Min.   :   0.11   Min.   :   0.0  
##  1st Qu.: 221.26   1st Qu.: 164.98   1st Qu.: 605.71   1st Qu.: 569.7  
##  Median : 300.71   Median : 251.03   Median : 748.73   Median : 718.5  
##  Mean   : 355.41   Mean   : 309.25   Mean   : 700.59   Mean   : 677.9  
##  3rd Qu.: 413.07   3rd Qu.: 368.40   3rd Qu.: 957.77   3rd Qu.: 947.1  
##  Max.   :1360.16   Max.   :1318.77   Max.   :1053.07   Max.   :1032.3  
##      SPEEDT            SUMPREC      
##  Min.   :-0.65126   Min.   : 44.21  
##  1st Qu.: 0.01744   1st Qu.: 84.08  
##  Median : 0.23674   Median :124.09  
##  Mean   : 0.22223   Mean   :133.67  
##  3rd Qu.: 0.47590   3rd Qu.:189.55  
##  Max.   : 1.00000   Max.   :276.33  
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/yenisei/23365099999 SIDOROVSK.txt"
## The number of del/rep rows by column precipitation= 59 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##      Day Month Year PRECIP  TMEAN
## 7277  15    12 1994   0.51 -32.11
## 7278  18    12 1994   1.02 -23.56
## 7279  22    12 1994   0.00 -39.67
## 7280  23    12 1994   0.00 -42.44
## 7281  28    12 1994   2.03  -8.28
## 7282  31    12 1994   3.56 -10.44
## [1] "Structure"
## 'data.frame':	7223 obs. of  5 variables:
##  $ Day   : int  5 18 23 2 4 6 7 9 10 11 ...
##  $ Month : int  8 1 1 8 8 8 8 8 8 8 ...
##  $ Year  : int  1961 1969 1969 1969 1969 1969 1969 1969 1969 1969 ...
##  $ PRECIP: num  1.02 0 0 0 0 1.02 4.06 0 0 0 ...
##  $ TMEAN : num  13.2 -43.3 -38.1 11.8 11.4 ...
## NULL
## [1] "Summary"
##      PRECIP            TMEAN        
##  Min.   :  0.000   Min.   :-52.000  
##  1st Qu.:  0.000   1st Qu.:-20.280  
##  Median :  0.250   Median : -6.940  
##  Mean   :  1.388   Mean   : -7.733  
##  3rd Qu.:  1.020   3rd Qu.:  6.000  
##  Max.   :199.900   Max.   : 26.610  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1961
```

```
## ****** Year: 1961 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1962
```

```
## ****** Year: 1962 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1963
```

```
## ****** Year: 1963 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1964
```

```
## ****** Year: 1964 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1965
```

```
## ****** Year: 1965 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1966
```

```
## ****** Year: 1966 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1967
```

```
## ****** Year: 1967 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1968
```

```
## ****** Year: 1968 
## #################### Skip a year!!!! 
## ****** Year: 1969 Observation: 131 Period: 18-1-1969 31-12-1969 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1970 Observation: 282 Period: 2-1-1970 31-12-1970 ******
## ****** Year: 1971 Observation: 174 Period: 1-1-1971 30-6-1971 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1972
```

```
## ****** Year: 1972 
## #################### Skip a year!!!! 
## ****** Year: 1973 Observation: 325 Period: 2-1-1973 31-12-1973 ******
## ****** Year: 1974 Observation: 357 Period: 1-1-1974 31-12-1974 ******
## ****** Year: 1975 Observation: 350 Period: 1-1-1975 31-12-1975 ******
## ****** Year: 1976 Observation: 348 Period: 1-1-1976 30-12-1976 ******
## ****** Year: 1977 Observation: 343 Period: 1-1-1977 31-12-1977 ******
## ****** Year: 1978 Observation: 352 Period: 1-1-1978 31-12-1978 ******
## ****** Year: 1979 Observation: 344 Period: 1-1-1979 31-12-1979 ******
## ****** Year: 1980 Observation: 347 Period: 1-1-1980 31-12-1980 ******
## ****** Year: 1981 Observation: 319 Period: 1-1-1981 31-12-1981 ******
## ****** Year: 1982 Observation: 241 Period: 2-1-1982 30-12-1982 ******
## ****** Year: 1983 Observation: 245 Period: 2-1-1983 31-12-1983 ******
## ****** Year: 1984 Observation: 272 Period: 2-1-1984 31-12-1984 ******
## ****** Year: 1985 Observation: 214 Period: 2-1-1985 30-12-1985 ******
## ****** Year: 1986 Observation: 278 Period: 1-1-1986 31-12-1986 ******
## ****** Year: 1987 Observation: 352 Period: 1-1-1987 31-12-1987 ******
## ****** Year: 1988 Observation: 360 Period: 1-1-1988 31-12-1988 ******
## ****** Year: 1989 Observation: 351 Period: 1-1-1989 31-12-1989 ******
## ****** Year: 1990 Observation: 357 Period: 2-1-1990 31-12-1990 ******
## ****** Year: 1991 Observation: 238 Period: 1-1-1991 30-12-1991 ******
## ****** Year: 1992 Observation: 189 Period: 3-1-1992 31-12-1992 ******
## ****** Year: 1993 Observation: 244 Period: 2-1-1993 31-12-1993 ******
## ****** Year: 1994 Observation: 209 Period: 2-1-1994 31-12-1994 ******
## 
## elapsed time is 16.360000 seconds 
## 'data.frame':	25 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1969 1970 1971 1973 1974 1975 1976 1977 1978 1979 ...
##  $ ObsBeg      : chr  "18-1-1969" "2-1-1970" "1-1-1971" "2-1-1973" ...
##  $ ObsEnd      : chr  "31-12-1969" "31-12-1970" "30-6-1971" "31-12-1973" ...
##  $ StartSG     : num  3 118 155 126 169 162 152 148 162 155 ...
##  $ EndSG       : num  43 210 174 226 258 263 256 253 247 264 ...
##  $ STDAT0      : chr  "2-8-1969" "11-6-1970" "11-6-1971" "8-6-1973" ...
##  $ STDAT5      : chr  "2-8-1969" "20-6-1970" "18-6-1971" "15-6-1973" ...
##  $ FDAT0       : chr  "16-9-1969" "29-9-1970" "30-6-1971" "19-9-1973" ...
##  $ FDAT5       : chr  "8-9-1969" "27-9-1970" "30-6-1971" "17-9-1973" ...
##  $ INTER0      : num  45 110 19 103 90 105 106 111 87 118 ...
##  $ INTER5      : num  37 108 16 101 83 97 100 107 83 115 ...
##  $ MAXT        : num  16.2 25.4 21 22.4 18.8 ...
##  $ MDAT        : chr  "26-8-1969" "26-7-1970" "22-6-1971" "14-7-1973" ...
##  $ SUMT0       : num  372 1012 299 1185 1056 ...
##  $ SUMT5       : num  337 944 259 1124 969 ...
##  $ T220        : num  372 699 279 563 114 ...
##  $ T225        : num  336.7 651.9 239.9 519.2 58.3 ...
##  $ FT220       : num  372.2 318.1 30.9 637.8 935.9 ...
##  $ FT225       : num  336.7 300.9 30.9 624.1 910.9 ...
##  $ SPEEDT      : num  -0.3105 0.0734 0.747 0.2538 2.023 ...
##  $ SUMPREC     : num  346 298.9 94.5 175 151.7 ...
## NULL
##    Station_Code Year    ObsBeg     ObsEnd StartSG EndSG    STDAT0
## 9         23365 1969 18-1-1969 31-12-1969       3    43  2-8-1969
## 10        23365 1970  2-1-1970 31-12-1970     118   210 11-6-1970
## 11        23365 1971  1-1-1971  30-6-1971     155   174 11-6-1971
## 13        23365 1973  2-1-1973 31-12-1973     126   226  8-6-1973
## 14        23365 1974  1-1-1974 31-12-1974     169   258 23-6-1974
## 15        23365 1975  1-1-1975 31-12-1975     162   263 16-6-1975
##       STDAT5     FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT   SUMT0
## 9   2-8-1969 16-9-1969  8-9-1969     45     37 16.22 26-8-1969  372.21
## 10 20-6-1970 29-9-1970 27-9-1970    110    108 25.44 26-7-1970 1012.18
## 11 18-6-1971 30-6-1971 30-6-1971     19     16 21.00 22-6-1971  298.72
## 13 15-6-1973 19-9-1973 17-9-1973    103    101 22.44 14-7-1973 1184.95
## 14 27-6-1974 21-9-1974 16-9-1974     90     83 18.83  8-7-1974 1056.42
## 15 17-6-1975 29-9-1975 21-9-1975    105     97 24.72 22-7-1975 1257.16
##      SUMT5   T220   T225   FT220   FT225      SPEEDT SUMPREC
## 9   336.69 372.21 336.69  372.21  336.69 -0.31052348  345.95
## 10  944.19 698.75 651.87  318.05  300.88  0.07338312  298.95
## 11  259.21 279.45 239.94   30.88   30.88  0.74702786   94.50
## 13 1123.57 562.57 519.18  637.78  624.06  0.25384944  175.04
## 14  968.94 113.53  58.33  935.88  910.94  2.02300000  151.65
## 15 1184.32 208.05 162.88 1044.56 1023.44 -0.04509091  207.47
##       Year         StartSG          EndSG         INTER0     
##  Min.   :1969   Min.   :  3.0   Min.   : 43   Min.   : 19.0  
##  1st Qu.:1976   1st Qu.:109.0   1st Qu.:182   1st Qu.: 99.0  
##  Median :1982   Median :140.0   Median :226   Median :106.0  
##  Mean   :1982   Mean   :128.4   Mean   :211   Mean   :102.2  
##  3rd Qu.:1988   3rd Qu.:155.0   3rd Qu.:254   3rd Qu.:116.0  
##  Max.   :1994   Max.   :169.0   Max.   :264   Max.   :134.0  
##      INTER5            MAXT           SUMT0            SUMT5       
##  Min.   : 16.00   Min.   :16.22   Min.   : 298.7   Min.   : 259.2  
##  1st Qu.: 90.00   1st Qu.:23.00   1st Qu.: 912.5   1st Qu.: 865.0  
##  Median :100.00   Median :24.11   Median :1130.7   Median :1035.7  
##  Mean   : 95.84   Mean   :23.58   Mean   :1027.0   Mean   : 958.3  
##  3rd Qu.:108.00   3rd Qu.:25.22   3rd Qu.:1268.2   3rd Qu.:1175.0  
##  Max.   :134.00   Max.   :26.61   Max.   :1369.0   Max.   :1309.6  
##       T220            T225            FT220             FT225        
##  Min.   :113.5   Min.   : 58.33   Min.   :   1.83   Min.   :   0.00  
##  1st Qu.:229.3   1st Qu.:196.60   1st Qu.:  67.73   1st Qu.:  46.94  
##  Median :376.0   Median :341.07   Median : 637.78   Median : 624.06  
##  Mean   :470.9   Mean   :427.61   Mean   : 570.22   Mean   : 549.01  
##  3rd Qu.:706.7   3rd Qu.:673.69   3rd Qu.: 941.94   3rd Qu.: 929.34  
##  Max.   :918.2   Max.   :908.39   Max.   :1113.32   Max.   :1094.48  
##      SPEEDT            SUMPREC      
##  Min.   :-0.39395   Min.   : 38.62  
##  1st Qu.: 0.03612   1st Qu.:102.64  
##  Median : 0.25385   Median :144.05  
##  Mean   : 0.31522   Mean   :167.06  
##  3rd Qu.: 0.63800   3rd Qu.:251.46  
##  Max.   : 2.02300   Max.   :345.95  
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/yenisei/23445099999 NADYM.txt"
## The number of del/rep rows by column precipitation= 1112 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##       Day Month Year PRECIP  TMEAN
## 11373  26    12 2015   0.25 -30.06
## 11374  27    12 2015   0.00 -30.89
## 11375  28    12 2015   0.25 -25.28
## 11376  29    12 2015   0.51 -25.50
## 11377  30    12 2015   0.76 -23.72
## 11378  31    12 2015   0.25 -23.33
## [1] "Structure"
## 'data.frame':	10266 obs. of  5 variables:
##  $ Day   : int  18 20 22 12 18 19 19 11 18 20 ...
##  $ Month : int  1 1 1 2 2 2 3 4 4 4 ...
##  $ Year  : int  1956 1956 1956 1956 1956 1956 1956 1956 1956 1956 ...
##  $ PRECIP: num  0 0 0 0 0 0 0 0 0 0 ...
##  $ TMEAN : num  -16.9 -16.8 -26.9 -31 -19.2 ...
## NULL
## [1] "Summary"
##      PRECIP            TMEAN        
##  Min.   :  0.000   Min.   :-49.330  
##  1st Qu.:  0.000   1st Qu.:-17.000  
##  Median :  0.000   Median : -4.390  
##  Mean   :  2.338   Mean   : -5.593  
##  3rd Qu.:  1.020   3rd Qu.:  7.098  
##  Max.   :150.110   Max.   : 26.670  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1956
```

```
## ****** Year: 1956 
## #################### Skip a year!!!! 
## ****** Year: 1957 
## #################### Skip a year!!!! 
## ****** Year: 1958 
## #################### Skip a year!!!! 
## ****** Year: 1959 Observation: 149 Period: 2-1-1959 31-12-1959 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1960 Observation: 130 Period: 2-1-1960 28-12-1960 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1961 Observation: 282 Period: 2-1-1961 27-12-1961 ******
## ****** Year: 1962 Observation: 259 Period: 1-1-1962 29-12-1962 ******
## ****** Year: 1963 Observation: 241 Period: 1-1-1963 31-12-1963 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1964
```

```
## ****** Year: 1964 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1965
```

```
## ****** Year: 1965 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1966
```

```
## ****** Year: 1966 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1967
```

```
## ****** Year: 1967 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1968
```

```
## ****** Year: 1968 
## #################### Skip a year!!!! 
## ****** Year: 1969 Observation: 330 Period: 1-1-1969 31-12-1969 ******
## ****** Year: 1970 Observation: 325 Period: 1-1-1970 31-12-1970 ******
## ****** Year: 1971 Observation: 98 Period: 1-1-1971 28-6-1971 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1972
```

```
## ****** Year: 1972 
## #################### Skip a year!!!! 
## ****** Year: 1973 Observation: 265 Period: 1-1-1973 31-12-1973 ******
## ****** Year: 1974 Observation: 318 Period: 1-1-1974 31-12-1974 ******
## ****** Year: 1975 Observation: 346 Period: 1-1-1975 31-12-1975 ******
## ****** Year: 1976 Observation: 323 Period: 2-1-1976 31-12-1976 ******
## ****** Year: 1977 Observation: 270 Period: 1-1-1977 31-12-1977 ******
## ****** Year: 1978 Observation: 304 Period: 1-1-1978 31-12-1978 ******
## ****** Year: 1979 Observation: 298 Period: 1-1-1979 31-12-1979 ******
## ****** Year: 1980 Observation: 281 Period: 1-1-1980 31-12-1980 ******
## ****** Year: 1981 Observation: 318 Period: 2-1-1981 31-12-1981 ******
## ****** Year: 1982 Observation: 213 Period: 1-1-1982 31-12-1982 ******
## ****** Year: 1983 Observation: 263 Period: 8-1-1983 30-12-1983 ******
## ****** Year: 1984 Observation: 277 Period: 2-1-1984 26-12-1984 ******
## ****** Year: 1985 Observation: 337 Period: 1-1-1985 31-12-1985 ******
## ****** Year: 1986 Observation: 335 Period: 1-1-1986 31-12-1986 ******
## ****** Year: 1987 Observation: 360 Period: 1-1-1987 31-12-1987 ******
## ****** Year: 1988 Observation: 360 Period: 1-1-1988 31-12-1988 ******
## ****** Year: 1989 Observation: 360 Period: 1-1-1989 31-12-1989 ******
## ****** Year: 1990 Observation: 354 Period: 1-1-1990 31-12-1990 ******
## ****** Year: 1991 Observation: 263 Period: 1-1-1991 31-12-1991 ******
## ****** Year: 1992 Observation: 232 Period: 2-1-1992 31-12-1992 ******
## ****** Year: 1993 Observation: 356 Period: 1-1-1993 31-12-1993 ******
## ****** Year: 1994 Observation: 255 Period: 1-1-1994 29-12-1994 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1995
```

```
## ****** Year: 1995 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1996
```

```
## ****** Year: 1996 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1997
```

```
## ****** Year: 1997 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1998
```

```
## ****** Year: 1998 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1999
```

```
## ****** Year: 1999 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2000
```

```
## ****** Year: 2000 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2001
```

```
## ****** Year: 2001 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2002
```

```
## ****** Year: 2002 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2003
```

```
## ****** Year: 2003 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2004
```

```
## ****** Year: 2004 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2005
```

```
## ****** Year: 2005 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2006
```

```
## ****** Year: 2006 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2007
```

```
## ****** Year: 2007 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2008
```

```
## ****** Year: 2008 
## #################### Skip a year!!!! 
## ****** Year: 2009 Observation: 131 Period: 25-3-2009 31-12-2009 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 2010 Observation: 169 Period: 1-1-2010 31-12-2010 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 2011 Observation: 129 Period: 1-1-2011 21-12-2011 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 2012 Observation: 227 Period: 5-1-2012 31-12-2012 ******
## ****** Year: 2013 Observation: 321 Period: 1-1-2013 31-12-2013 ******
## ****** Year: 2014 Observation: 290 Period: 2-1-2014 31-12-2014 ******
## ****** Year: 2015 Observation: 364 Period: 1-1-2015 31-12-2015 ******
## 
## elapsed time is 25.060000 seconds 
## 'data.frame':	37 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1959 1960 1961 1962 1963 1969 1970 1971 1973 1974 ...
##  $ ObsBeg      : chr  "2-1-1959" "2-1-1960" "2-1-1961" "1-1-1962" ...
##  $ ObsEnd      : chr  "31-12-1959" "28-12-1960" "27-12-1961" "29-12-1962" ...
##  $ StartSG     : num  69 66 117 89 128 146 144 87 90 140 ...
##  $ EndSG       : num  108 102 209 105 186 236 165 98 179 244 ...
##  $ STDAT0      : chr  "12-5-1959" "20-5-1960" "11-6-1961" "29-4-1962" ...
##  $ STDAT5      : chr  "18-6-1959" "6-6-1960" "20-6-1961" "6-5-1962" ...
##  $ FDAT0       : chr  "5-10-1959" "30-9-1960" "24-9-1961" "18-5-1962" ...
##  $ FDAT5       : chr  "24-9-1959" "15-9-1960" "15-9-1961" "10-5-1962" ...
##  $ INTER0      : num  146 133 105 19 123 94 21 19 110 105 ...
##  $ INTER5      : num  101 117 96 11 119 89 20 19 105 101 ...
##  $ MAXT        : num  20.6 20.4 23.3 24.6 26.5 ...
##  $ MDAT        : chr  "17-7-1959" "8-6-1960" "13-7-1961" "17-7-1962" ...
##  $ SUMT0       : num  383 306 1161 1202 720 ...
##  $ SUMT5       : num  366 279 1063 1138 680 ...
##  $ T220        : num  383 306 832 874 642 ...
##  $ T225        : num  366 279 787 818 615 ...
##  $ FT220       : num  382.6 305.5 312.8 757.7 88.8 ...
##  $ FT225       : num  366 279.2 262.9 721.3 77.1 ...
##  $ SPEEDT      : num  -0.5897 -0.6389 0.0293 0.1665 0.0214 ...
##  $ SUMPREC     : num  376 374 1356 154 764 ...
## NULL
##    Station_Code Year   ObsBeg     ObsEnd StartSG EndSG    STDAT0    STDAT5
## 4         23365 1959 2-1-1959 31-12-1959      69   108 12-5-1959 18-6-1959
## 5         23365 1960 2-1-1960 28-12-1960      66   102 20-5-1960  6-6-1960
## 6         23365 1961 2-1-1961 27-12-1961     117   209 11-6-1961 20-6-1961
## 7         23365 1962 1-1-1962 29-12-1962      89   105 29-4-1962  6-5-1962
## 8         23365 1963 1-1-1963 31-12-1963     128   186  4-6-1963 15-6-1963
## 14        23365 1969 1-1-1969 31-12-1969     146   236 14-6-1969 20-6-1969
##        FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT   SUMT0   SUMT5
## 4  5-10-1959 24-9-1959    146    101 20.56 17-7-1959  382.57  365.95
## 5  30-9-1960 15-9-1960    133    117 20.44  8-6-1960  305.52  279.25
## 6  24-9-1961 15-9-1961    105     96 23.33 13-7-1961 1160.66 1062.76
## 7  18-5-1962 10-5-1962     19     11 24.56 17-7-1962 1202.39 1138.36
## 8  5-10-1963 2-10-1963    123    119 26.50 22-6-1963  719.80  680.13
## 14 16-9-1969 12-9-1969     94     89 25.67  6-7-1969 1201.00 1101.58
##      T220   T225  FT220  FT225      SPEEDT SUMPREC
## 4  382.57 365.95 382.57 365.95 -0.58973035  375.65
## 5  305.52 279.25 305.52 279.25 -0.63885883  373.89
## 6  832.01 787.27 312.82 262.88  0.02929699 1355.84
## 7  874.06 817.58 757.69 721.26  0.16653215  153.93
## 8  641.91 614.85  88.78  77.06  0.02144664  764.03
## 14 479.84 422.57 678.06 664.34  0.73563492  211.03
##       Year         StartSG          EndSG           INTER0     
##  Min.   :1959   Min.   : 28.0   Min.   : 98.0   Min.   : 19.0  
##  1st Qu.:1974   1st Qu.: 90.0   1st Qu.:165.0   1st Qu.:105.0  
##  Median :1983   Median :128.0   Median :209.0   Median :113.0  
##  Mean   :1985   Mean   :116.7   Mean   :197.8   Mean   :110.7  
##  3rd Qu.:1992   3rd Qu.:144.0   3rd Qu.:241.0   3rd Qu.:129.0  
##  Max.   :2015   Max.   :166.0   Max.   :266.0   Max.   :170.0  
##      INTER5           MAXT           SUMT0            SUMT5       
##  Min.   : 11.0   Min.   :17.44   Min.   : 172.8   Min.   : 143.3  
##  1st Qu.: 96.0   1st Qu.:22.72   1st Qu.: 928.7   1st Qu.: 846.4  
##  Median :106.0   Median :24.44   Median :1135.9   Median :1062.8  
##  Mean   :102.1   Mean   :24.01   Mean   :1081.1   Mean   :1007.9  
##  3rd Qu.:117.0   3rd Qu.:25.67   3rd Qu.:1307.2   3rd Qu.:1227.2  
##  Max.   :156.0   Max.   :26.67   Max.   :1605.2   Max.   :1499.6  
##       T220             T225             FT220            FT225       
##  Min.   : 135.5   Min.   :  65.01   Min.   :   0.0   Min.   :   0.0  
##  1st Qu.: 377.2   1st Qu.: 321.12   1st Qu.: 205.7   1st Qu.: 192.9  
##  Median : 542.6   Median : 490.12   Median : 650.2   Median : 580.3  
##  Mean   : 589.8   Mean   : 544.43   Mean   : 569.5   Mean   : 546.6  
##  3rd Qu.: 837.2   3rd Qu.: 787.27   3rd Qu.: 888.5   3rd Qu.: 862.6  
##  Max.   :1173.6   Max.   :1137.73   Max.   :1218.5   Max.   :1193.6  
##      SPEEDT            SUMPREC      
##  Min.   :-0.63886   Min.   :   0.0  
##  1st Qu.:-0.01854   1st Qu.: 112.5  
##  Median : 0.14175   Median : 182.2  
##  Mean   : 0.10517   Mean   : 225.5  
##  3rd Qu.: 0.34283   3rd Qu.: 259.6  
##  Max.   : 0.73563   Max.   :1355.8  
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/yenisei/23453099999 URENGOJ.txt"
## The number of del/rep rows by column precipitation= 223 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##      Day Month Year PRECIP  TMEAN
## 2533  26    12 2015   0.00 -36.94
## 2534  27    12 2015   0.00 -31.11
## 2535  28    12 2015   0.00 -27.83
## 2536  29    12 2015   1.02 -24.33
## 2537  30    12 2015   0.00 -26.06
## 2538  31    12 2015   0.00 -23.33
## [1] "Structure"
## 'data.frame':	2315 obs. of  5 variables:
##  $ Day   : int  6 7 22 8 17 21 20 7 12 22 ...
##  $ Month : int  8 8 8 9 9 9 10 11 11 1 ...
##  $ Year  : int  1955 1955 1955 1955 1955 1955 1955 1955 1955 1956 ...
##  $ PRECIP: num  0.51 0.51 0 0 0 0.25 6.1 0 0 0 ...
##  $ TMEAN : num  11.94 10.72 12.5 6.78 3.22 ...
## NULL
## [1] "Summary"
##      PRECIP            TMEAN       
##  Min.   :  0.000   Min.   :-48.89  
##  1st Qu.:  0.000   1st Qu.:-20.75  
##  Median :  0.000   Median : -7.22  
##  Mean   :  4.905   Mean   : -8.16  
##  3rd Qu.:  1.020   3rd Qu.:  5.28  
##  Max.   :150.110   Max.   : 25.89  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1955
```

```
## ****** Year: 1955 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1956
```

```
## ****** Year: 1956 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1957
```

```
## ****** Year: 1957 
## #################### Skip a year!!!! 
## ****** Year: 1958 
## #################### Skip a year!!!! 
## ****** Year: 1959 Observation: 133 Period: 2-1-1959 31-12-1959 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1960 Observation: 120 Period: 3-1-1960 31-12-1960 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1961 Observation: 286 Period: 2-1-1961 31-12-1961 ******
## ****** Year: 1962 Observation: 271 Period: 1-1-1962 31-12-1962 ******
## ****** Year: 1963 Observation: 212 Period: 1-1-1963 31-12-1963 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1964
```

```
## ****** Year: 1964 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1965
```

```
## ****** Year: 1965 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1966
```

```
## ****** Year: 1966 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1967
```

```
## ****** Year: 1967 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1968
```

```
## ****** Year: 1968 
## #################### Skip a year!!!! 
## ****** Year: 1969 Observation: 300 Period: 1-1-1969 31-12-1969 ******
## ****** Year: 1970 Observation: 206 Period: 2-1-1970 20-12-1970 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1971
```

```
## ****** Year: 1971 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1972
```

```
## ****** Year: 1972 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1973
```

```
## ****** Year: 1973 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1974
```

```
## ****** Year: 1974 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1975
```

```
## ****** Year: 1975 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1976
```

```
## ****** Year: 1976 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1977
```

```
## ****** Year: 1977 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1978
```

```
## ****** Year: 1978 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1979
```

```
## ****** Year: 1979 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1980
```

```
## ****** Year: 1980 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1981
```

```
## ****** Year: 1981 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1982
```

```
## ****** Year: 1982 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1983
```

```
## ****** Year: 1983 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1984
```

```
## ****** Year: 1984 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1985
```

```
## ****** Year: 1985 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1986
```

```
## ****** Year: 1986 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1987
```

```
## ****** Year: 1987 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1988
```

```
## ****** Year: 1988 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1989
```

```
## ****** Year: 1989 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1990
```

```
## ****** Year: 1990 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1991
```

```
## ****** Year: 1991 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1992
```

```
## ****** Year: 1992 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1993
```

```
## ****** Year: 1993 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1994
```

```
## ****** Year: 1994 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1995
```

```
## ****** Year: 1995 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1996
```

```
## ****** Year: 1996 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1997
```

```
## ****** Year: 1997 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1998
```

```
## ****** Year: 1998 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1999
```

```
## ****** Year: 1999 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2000
```

```
## ****** Year: 2000 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2001
```

```
## ****** Year: 2001 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2002
```

```
## ****** Year: 2002 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2003
```

```
## ****** Year: 2003 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2004
```

```
## ****** Year: 2004 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2005
```

```
## ****** Year: 2005 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2006
```

```
## ****** Year: 2006 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2007
```

```
## ****** Year: 2007 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2008
```

```
## ****** Year: 2008 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2009
```

```
## ****** Year: 2009 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2010
```

```
## ****** Year: 2010 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2011
```

```
## ****** Year: 2011 
## #################### Skip a year!!!! 
## ****** Year: 2012 Observation: 195 Period: 25-4-2012 31-12-2012 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2013
```

```
## ****** Year: 2013 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2014
```

```
## ****** Year: 2014 
## #################### Skip a year!!!! 
## ****** Year: 2015 Observation: 321 Period: 1-1-2015 31-12-2015 ******
## 
## elapsed time is 8.840000 seconds 
## 'data.frame':	9 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1959 1960 1961 1962 1963 1969 1970 2012 2015
##  $ ObsBeg      : chr  "2-1-1959" "3-1-1960" "2-1-1961" "1-1-1962" ...
##  $ ObsEnd      : chr  "31-12-1959" "31-12-1960" "31-12-1961" "31-12-1962" ...
##  $ StartSG     : num  60 57 122 128 125 137 140 10 101
##  $ EndSG       : num  94 90 208 218 171 211 182 105 221
##  $ STDAT0      : chr  "31-5-1959" "21-5-1960" "15-6-1961" "4-6-1962" ...
##  $ STDAT5      : chr  "17-6-1959" "31-5-1960" "20-6-1961" "12-6-1962" ...
##  $ FDAT0       : chr  "28-9-1959" "23-9-1960" "26-9-1961" "1-10-1962" ...
##  $ FDAT5       : chr  "28-9-1959" "16-9-1960" "26-9-1961" "22-9-1962" ...
##  $ INTER0      : num  120 125 103 119 125 101 110 144 121
##  $ INTER5      : num  107 118 102 109 103 81 104 125 110
##  $ MAXT        : num  19.3 16.7 24 24.8 24.4 ...
##  $ MDAT        : chr  "9-8-1959" "6-6-1960" "30-6-1961" "20-7-1962" ...
##  $ SUMT0       : num  315 298 1040 1163 549 ...
##  $ SUMT5       : num  308 292 949 1096 508 ...
##  $ T220        : num  315 298 731 719 547 ...
##  $ T225        : num  308 292 675 657 508 ...
##  $ FT220       : num  315 298 313 460 0 ...
##  $ FT225       : num  308 292 282 458 0 ...
##  $ SPEEDT      : num  -0.70627 -0.72504 0.00165 0.31886 -0.1405 ...
##  $ SUMPREC     : num  294 448 804 891 121 ...
## NULL
##    Station_Code Year   ObsBeg     ObsEnd StartSG EndSG    STDAT0    STDAT5
## 5         23365 1959 2-1-1959 31-12-1959      60    94 31-5-1959 17-6-1959
## 6         23365 1960 3-1-1960 31-12-1960      57    90 21-5-1960 31-5-1960
## 7         23365 1961 2-1-1961 31-12-1961     122   208 15-6-1961 20-6-1961
## 8         23365 1962 1-1-1962 31-12-1962     128   218  4-6-1962 12-6-1962
## 9         23365 1963 1-1-1963 31-12-1963     125   171  3-6-1963 20-6-1963
## 15        23365 1969 1-1-1969 31-12-1969     137   211 11-6-1969 21-6-1969
##        FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT   SUMT0   SUMT5
## 5  28-9-1959 28-9-1959    120    107 19.33  9-8-1959  314.96  308.12
## 6  23-9-1960 16-9-1960    125    118 16.67  6-6-1960  298.19  292.47
## 7  26-9-1961 26-9-1961    103    102 24.00 30-6-1961 1039.50  948.72
## 8  1-10-1962 22-9-1962    119    109 24.78 20-7-1962 1163.49 1096.04
## 9  6-10-1963 17-9-1963    125    103 24.44 22-6-1963  548.51  508.23
## 15 20-9-1969  2-9-1969    101     81 25.56  8-7-1969  920.81  850.52
##      T220   T225  FT220  FT225       SPEEDT SUMPREC
## 5  314.96 308.12 314.96 308.12 -0.706267012  293.89
## 6  298.19 292.47 298.19 292.47 -0.725044643  447.80
## 7  730.91 675.25 313.42 281.75  0.001653394  804.17
## 8  719.37 656.58 459.51 457.96  0.318856390  890.77
## 9  546.84 508.23   0.00   0.00 -0.140502063  121.40
## 15 599.13 549.23 312.74 305.18  0.285041184  401.83
##       Year         StartSG           EndSG           INTER0     
##  Min.   :1959   Min.   : 10.00   Min.   : 90.0   Min.   :101.0  
##  1st Qu.:1961   1st Qu.: 60.00   1st Qu.:105.0   1st Qu.:110.0  
##  Median :1963   Median :122.00   Median :182.0   Median :120.0  
##  Mean   :1975   Mean   : 97.78   Mean   :166.7   Mean   :118.7  
##  3rd Qu.:1970   3rd Qu.:128.00   3rd Qu.:211.0   3rd Qu.:125.0  
##  Max.   :2015   Max.   :140.00   Max.   :221.0   Max.   :144.0  
##      INTER5           MAXT           SUMT0            SUMT5       
##  Min.   : 81.0   Min.   :15.83   Min.   : 298.2   Min.   : 292.5  
##  1st Qu.:103.0   1st Qu.:19.33   1st Qu.: 377.2   1st Qu.: 313.5  
##  Median :107.0   Median :24.00   Median : 920.8   Median : 850.5  
##  Mean   :106.6   Mean   :22.22   Mean   : 822.2   Mean   : 770.0  
##  3rd Qu.:110.0   3rd Qu.:24.78   3rd Qu.:1163.5   3rd Qu.:1096.0  
##  Max.   :125.0   Max.   :25.89   Max.   :1552.7   Max.   :1443.5  
##       T220             T225            FT220            FT225       
##  Min.   : 298.2   Min.   : 283.9   Min.   :  0.00   Min.   :  0.00  
##  1st Qu.: 328.9   1st Qu.: 308.1   1st Qu.: 54.06   1st Qu.: 38.89  
##  Median : 599.1   Median : 549.2   Median :312.74   Median :292.47  
##  Mean   : 647.4   Mean   : 609.6   Mean   :245.49   Mean   :233.78  
##  3rd Qu.: 730.9   3rd Qu.: 675.2   3rd Qu.:314.96   3rd Qu.:308.12  
##  Max.   :1184.1   Max.   :1169.2   Max.   :459.51   Max.   :457.96  
##      SPEEDT             SUMPREC     
##  Min.   :-0.725045   Min.   :101.8  
##  1st Qu.:-0.281058   1st Qu.:121.4  
##  Median : 0.001653   Median :293.9  
##  Mean   :-0.120258   Mean   :377.8  
##  3rd Qu.: 0.106685   3rd Qu.:447.8  
##  Max.   : 0.318856   Max.   :890.8  
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/yenisei/23657099999 NOYABR' SK.txt"
## The number of del/rep rows by column precipitation= 189 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##      Day Month Year PRECIP  TMEAN
## 1338  26    12 2015   0.25 -29.11
## 1339  27    12 2015   0.00 -29.17
## 1340  28    12 2015   0.25 -28.72
## 1341  29    12 2015   0.00 -29.11
## 1342  30    12 2015   0.51 -24.22
## 1343  31    12 2015   0.25 -26.11
## [1] "Structure"
## 'data.frame':	1154 obs. of  5 variables:
##  $ Day   : int  25 26 27 28 29 30 8 10 11 12 ...
##  $ Month : int  4 4 4 4 4 4 5 5 5 5 ...
##  $ Year  : int  2012 2012 2012 2012 2012 2012 2012 2012 2012 2012 ...
##  $ PRECIP: num  0 0 0 0 0 0 0 0 0 0 ...
##  $ TMEAN : num  -8.67 -7.89 -8.28 -6.72 -2.17 -0.17 -5.78 5.5 8.56 10.5 ...
## NULL
## [1] "Summary"
##      PRECIP            TMEAN        
##  Min.   :  0.000   Min.   :-46.610  
##  1st Qu.:  0.000   1st Qu.:-13.170  
##  Median :  0.250   Median : -1.220  
##  Mean   :  1.573   Mean   : -2.574  
##  3rd Qu.:  1.270   3rd Qu.:  9.780  
##  Max.   :109.980   Max.   : 25.170  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
## ****** Year: 2012 Observation: 198 Period: 25-4-2012 31-12-2012 ******
## ****** Year: 2013 Observation: 323 Period: 1-1-2013 31-12-2013 ******
## ****** Year: 2014 Observation: 281 Period: 1-1-2014 31-12-2014 ******
## ****** Year: 2015 Observation: 352 Period: 1-1-2015 31-12-2015 ******
## 
## elapsed time is 5.130000 seconds 
## 'data.frame':	4 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365"
##  $ Year        : int  2012 2013 2014 2015
##  $ ObsBeg      : chr  "25-4-2012" "1-1-2013" "1-1-2014" "1-1-2015"
##  $ ObsEnd      : chr  "31-12-2012" "31-12-2013" "31-12-2014" "31-12-2015"
##  $ StartSG     : num  9 141 108 115
##  $ EndSG       : num  109 243 204 250
##  $ STDAT0      : chr  "11-5-2012" "2-6-2013" "3-6-2014" "8-5-2015"
##  $ STDAT5      : chr  "21-5-2012" "7-6-2013" "13-6-2014" "15-5-2015"
##  $ FDAT0       : chr  "1-10-2012" "22-9-2013" "24-9-2014" "20-9-2015"
##  $ FDAT5       : chr  "30-9-2012" "13-9-2013" "22-9-2014" "10-9-2015"
##  $ INTER0      : num  143 112 113 135
##  $ INTER5      : num  142 99 104 121
##  $ MAXT        : num  25.2 24.9 24.4 23.9
##  $ MDAT        : chr  "11-6-2012" "18-7-2013" "15-6-2014" "29-6-2015"
##  $ SUMT0       : num  1375 1391 1233 1673
##  $ SUMT5       : num  1368 1292 1136 1583
##  $ T220        : num  1375 430 931 788
##  $ T225        : num  1368 378 878 746
##  $ FT220       : num  1.05 962.55 284.22 871.75
##  $ FT225       : num  0 931 253 839
##  $ SPEEDT      : num  -0.26035 0.27786 0.00656 0.16603
##  $ SUMPREC     : num  74.9 270.5 267.5 422.9
## NULL
##   Station_Code Year    ObsBeg     ObsEnd StartSG EndSG    STDAT0    STDAT5
## 1        23365 2012 25-4-2012 31-12-2012       9   109 11-5-2012 21-5-2012
## 2        23365 2013  1-1-2013 31-12-2013     141   243  2-6-2013  7-6-2013
## 3        23365 2014  1-1-2014 31-12-2014     108   204  3-6-2014 13-6-2014
## 4        23365 2015  1-1-2015 31-12-2015     115   250  8-5-2015 15-5-2015
##       FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT   SUMT0   SUMT5
## 1 1-10-2012 30-9-2012    143    142 25.17 11-6-2012 1374.97 1367.76
## 2 22-9-2013 13-9-2013    112     99 24.94 18-7-2013 1391.35 1291.62
## 3 24-9-2014 22-9-2014    113    104 24.44 15-6-2014 1232.91 1135.74
## 4 20-9-2015 10-9-2015    135    121 23.89 29-6-2015 1673.21 1583.05
##      T220    T225  FT220  FT225       SPEEDT SUMPREC
## 1 1374.97 1367.76   1.05   0.00 -0.260350306   74.92
## 2  430.13  378.46 962.55 931.33  0.277857405  270.51
## 3  931.48  878.30 284.22 253.11  0.006559441  267.49
## 4  787.57  746.47 871.75 838.64  0.166031868  422.92
##       Year         StartSG           EndSG           INTER0     
##  Min.   :2012   Min.   :  9.00   Min.   :109.0   Min.   :112.0  
##  1st Qu.:2013   1st Qu.: 83.25   1st Qu.:180.2   1st Qu.:112.8  
##  Median :2014   Median :111.50   Median :223.5   Median :124.0  
##  Mean   :2014   Mean   : 93.25   Mean   :201.5   Mean   :125.8  
##  3rd Qu.:2014   3rd Qu.:121.50   3rd Qu.:244.8   3rd Qu.:137.0  
##  Max.   :2015   Max.   :141.00   Max.   :250.0   Max.   :143.0  
##      INTER5           MAXT           SUMT0          SUMT5     
##  Min.   : 99.0   Min.   :23.89   Min.   :1233   Min.   :1136  
##  1st Qu.:102.8   1st Qu.:24.30   1st Qu.:1339   1st Qu.:1253  
##  Median :112.5   Median :24.69   Median :1383   Median :1330  
##  Mean   :116.5   Mean   :24.61   Mean   :1418   Mean   :1345  
##  3rd Qu.:126.2   3rd Qu.:25.00   3rd Qu.:1462   3rd Qu.:1422  
##  Max.   :142.0   Max.   :25.17   Max.   :1673   Max.   :1583  
##       T220             T225            FT220            FT225      
##  Min.   : 430.1   Min.   : 378.5   Min.   :  1.05   Min.   :  0.0  
##  1st Qu.: 698.2   1st Qu.: 654.5   1st Qu.:213.43   1st Qu.:189.8  
##  Median : 859.5   Median : 812.4   Median :577.99   Median :545.9  
##  Mean   : 881.0   Mean   : 842.7   Mean   :529.89   Mean   :505.8  
##  3rd Qu.:1042.4   3rd Qu.:1000.7   3rd Qu.:894.45   3rd Qu.:861.8  
##  Max.   :1375.0   Max.   :1367.8   Max.   :962.55   Max.   :931.3  
##      SPEEDT            SUMPREC      
##  Min.   :-0.26035   Min.   : 74.92  
##  1st Qu.:-0.06017   1st Qu.:219.35  
##  Median : 0.08630   Median :269.00  
##  Mean   : 0.04752   Mean   :258.96  
##  3rd Qu.: 0.19399   3rd Qu.:308.61  
##  Max.   : 0.27786   Max.   :422.92  
## [1] "+---------------------------------------------------------+"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/yenisei/23788099999 KUZ' MOVKA.txt"
## The number of del/rep rows by column precipitation= 559 
## The number of del/rep rows by column temp= 0 
## [1] "Tail"
##       Day Month Year PRECIP  TMEAN
## 10701  25    12 2015   0.51 -33.06
## 10703  27    12 2015   2.03 -13.50
## 10704  28    12 2015   7.11  -8.00
## 10705  29    12 2015   1.27 -13.56
## 10706  30    12 2015   0.76 -14.17
## 10707  31    12 2015   0.76 -19.56
## [1] "Structure"
## 'data.frame':	10148 obs. of  5 variables:
##  $ Day   : int  1 18 24 25 27 10 13 14 15 19 ...
##  $ Month : int  2 2 2 2 2 3 3 3 3 3 ...
##  $ Year  : int  1958 1958 1958 1958 1958 1958 1958 1958 1958 1958 ...
##  $ PRECIP: num  0 0 0 0 0 2.03 0 0 0.76 0 ...
##  $ TMEAN : num  -34.2 -44.7 -37.4 -30.3 -32.9 ...
## NULL
## [1] "Summary"
##      PRECIP           TMEAN        
##  Min.   :  0.00   Min.   :-55.500  
##  1st Qu.:  0.00   1st Qu.:-17.625  
##  Median :  0.00   Median : -2.030  
##  Mean   :  2.28   Mean   : -5.347  
##  3rd Qu.:  2.03   3rd Qu.:  8.670  
##  Max.   :150.11   Max.   : 26.000  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
## ****** Year: 1958 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1959
```

```
## ****** Year: 1959 
## #################### Skip a year!!!! 
## ****** Year: 1960 Observation: 120 Period: 3-1-1960 31-12-1960 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## ****** Year: 1961 Observation: 196 Period: 5-1-1961 24-10-1961 ******
## ****** Year: 1962 Observation: 141 Period: 24-2-1962 27-12-1962 ******
```

```
## Warning in T2205(data.cli, data.calc, period[i]): june 22 will come after
## the date of the last observation
```

```
## Warning in T2205(data.cli, data.calc, period[i], 5): june 22 will come
## after the date of the last observation
```

```
## Warning in FT2205(data.cli, data.calc, period[i]): the last date of
## observation is less than the computed end of the growing season
```

```
## Warning in FT2205(data.cli, data.calc, period[i], temp.c = 5): the last
## date of observation is less than the computed end of the growing season
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1963
```

```
## ****** Year: 1963 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1964
```

```
## ****** Year: 1964 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1965
```

```
## ****** Year: 1965 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1966
```

```
## ****** Year: 1966 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1967
```

```
## ****** Year: 1967 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1968
```

```
## ****** Year: 1968 
## #################### Skip a year!!!! 
## ****** Year: 1969 Observation: 351 Period: 1-1-1969 31-12-1969 ******
## ****** Year: 1970 Observation: 350 Period: 1-1-1970 31-12-1970 ******
## ****** Year: 1971 Observation: 177 Period: 1-1-1971 30-6-1971 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1972
```

```
## ****** Year: 1972 
## #################### Skip a year!!!! 
## ****** Year: 1973 Observation: 302 Period: 1-1-1973 31-12-1973 ******
## ****** Year: 1974 Observation: 327 Period: 1-1-1974 31-12-1974 ******
## ****** Year: 1975 Observation: 356 Period: 1-1-1975 31-12-1975 ******
## ****** Year: 1976 Observation: 342 Period: 1-1-1976 31-12-1976 ******
## ****** Year: 1977 Observation: 325 Period: 1-1-1977 31-12-1977 ******
## ****** Year: 1978 Observation: 324 Period: 1-1-1978 31-12-1978 ******
## ****** Year: 1979 Observation: 333 Period: 1-1-1979 31-12-1979 ******
## ****** Year: 1980 Observation: 338 Period: 1-1-1980 31-12-1980 ******
## ****** Year: 1981 Observation: 345 Period: 1-1-1981 31-12-1981 ******
## ****** Year: 1982 Observation: 321 Period: 1-1-1982 31-12-1982 ******
## ****** Year: 1983 Observation: 317 Period: 1-1-1983 31-12-1983 ******
## ****** Year: 1984 Observation: 300 Period: 2-1-1984 31-12-1984 ******
## ****** Year: 1985 Observation: 347 Period: 2-1-1985 31-12-1985 ******
## ****** Year: 1986 Observation: 339 Period: 1-1-1986 31-12-1986 ******
## ****** Year: 1987 Observation: 353 Period: 1-1-1987 31-12-1987 ******
## ****** Year: 1988 Observation: 361 Period: 1-1-1988 31-12-1988 ******
## ****** Year: 1989 Observation: 356 Period: 1-1-1989 31-12-1989 ******
## ****** Year: 1990 Observation: 357 Period: 1-1-1990 31-12-1990 ******
## ****** Year: 1991 Observation: 302 Period: 1-1-1991 31-12-1991 ******
## ****** Year: 1992 Observation: 227 Period: 2-1-1992 31-12-1992 ******
## ****** Year: 1993 Observation: 348 Period: 1-1-1993 31-12-1993 ******
## ****** Year: 1994 Observation: 311 Period: 1-1-1994 31-12-1994 ******
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1995
```

```
## ****** Year: 1995 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1996
```

```
## ****** Year: 1996 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1997
```

```
## ****** Year: 1997 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1998
```

```
## ****** Year: 1998 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 1999
```

```
## ****** Year: 1999 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2000
```

```
## ****** Year: 2000 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2001
```

```
## ****** Year: 2001 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2002
```

```
## ****** Year: 2002 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2003
```

```
## ****** Year: 2003 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2004
```

```
## ****** Year: 2004 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2005
```

```
## ****** Year: 2005 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2006
```

```
## ****** Year: 2006 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2007
```

```
## ****** Year: 2007 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2008
```

```
## ****** Year: 2008 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2009
```

```
## ****** Year: 2009 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2010
```

```
## ****** Year: 2010 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i], war = TRUE): Invalid begin day
## Year= 2011
```

```
## ****** Year: 2011 
## #################### Skip a year!!!! 
## ****** Year: 2012 Observation: 298 Period: 1-3-2012 31-12-2012 ******
## ****** Year: 2013 Observation: 353 Period: 1-1-2013 31-12-2013 ******
## ****** Year: 2014 Observation: 364 Period: 1-1-2014 31-12-2014 ******
## ****** Year: 2015 Observation: 352 Period: 1-1-2015 31-12-2015 ******
## 
## elapsed time is 24.380000 seconds 
## 'data.frame':	32 obs. of  22 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1960 1961 1962 1969 1970 1971 1973 1974 1975 1976 ...
##  $ ObsBeg      : chr  "3-1-1960" "5-1-1961" "24-2-1962" "1-1-1969" ...
##  $ ObsEnd      : chr  "31-12-1960" "24-10-1961" "27-12-1962" "31-12-1969" ...
##  $ StartSG     : num  61 108 71 146 150 146 112 132 149 142 ...
##  $ EndSG       : num  109 192 128 251 259 177 221 243 266 260 ...
##  $ STDAT0      : chr  "18-5-1960" "11-6-1961" "1-6-1962" "3-6-1969" ...
##  $ STDAT5      : chr  "31-5-1960" "21-6-1961" "17-6-1962" "8-6-1969" ...
##  $ FDAT0       : chr  "3-10-1960" "13-9-1961" "29-9-1962" "18-9-1969" ...
##  $ FDAT5       : chr  "3-10-1960" "13-9-1961" "17-9-1962" "14-9-1969" ...
##  $ INTER0      : num  138 94 120 107 113 31 113 113 119 121 ...
##  $ INTER5      : num  138 94 107 103 111 31 106 107 110 116 ...
##  $ MAXT        : num  19.3 18.9 21 26 22.8 ...
##  $ MDAT        : chr  "27-7-1960" "23-6-1961" "27-7-1962" "9-7-1969" ...
##  $ SUMT0       : num  527 1163 684 1495 1409 ...
##  $ SUMT5       : num  507 1080 629 1421 1325 ...
##  $ T220        : num  527 984 684 419 419 ...
##  $ T225        : num  507 901 629 371 360 ...
##  $ FT220       : num  527 189 684 1079 972 ...
##  $ FT225       : num  507 189 629 1065 953 ...
##  $ SPEEDT      : num  -0.66925 0.00662 -0.40495 0.43312 0.38038 ...
##  $ SUMPREC     : num  364 831 672 540 331 ...
## NULL
##    Station_Code Year    ObsBeg     ObsEnd StartSG EndSG    STDAT0
## 3         23365 1960  3-1-1960 31-12-1960      61   109 18-5-1960
## 4         23365 1961  5-1-1961 24-10-1961     108   192 11-6-1961
## 5         23365 1962 24-2-1962 27-12-1962      71   128  1-6-1962
## 12        23365 1969  1-1-1969 31-12-1969     146   251  3-6-1969
## 13        23365 1970  1-1-1970 31-12-1970     150   259  5-6-1970
## 14        23365 1971  1-1-1971  30-6-1971     146   177 30-5-1971
##       STDAT5     FDAT0     FDAT5 INTER0 INTER5  MAXT      MDAT   SUMT0
## 3  31-5-1960 3-10-1960 3-10-1960    138    138 19.28 27-7-1960  526.85
## 4  21-6-1961 13-9-1961 13-9-1961     94     94 18.89 23-6-1961 1163.35
## 5  17-6-1962 29-9-1962 17-9-1962    120    107 21.00 27-7-1962  684.44
## 12  8-6-1969 18-9-1969 14-9-1969    107    103 26.00  9-7-1969 1495.13
## 13 11-6-1970 26-9-1970 24-9-1970    113    111 22.83 23-6-1970 1408.85
## 14  7-6-1971 30-6-1971 30-6-1971     31     31 24.22 21-6-1971  605.33
##      SUMT5   T220   T225   FT220   FT225       SPEEDT SUMPREC
## 3   506.57 526.85 506.57  526.85  506.57 -0.669250625  364.23
## 4  1080.39 984.07 901.11  188.56  188.56  0.006621066  831.09
## 5   628.67 684.44 628.67  684.44  628.67 -0.404954728  672.05
## 12 1420.69 418.56 371.41 1079.06 1065.22  0.433119658  540.25
## 13 1325.19 419.05 359.96  972.18  952.67  0.380375494  330.95
## 14  548.64 516.50 459.81  107.22  107.22  0.673192918  104.41
##       Year         StartSG          EndSG           INTER0     
##  Min.   :1960   Min.   : 40.0   Min.   :109.0   Min.   : 31.0  
##  1st Qu.:1975   1st Qu.:126.8   1st Qu.:235.2   1st Qu.:113.0  
##  Median :1982   Median :137.0   Median :243.5   Median :119.0  
##  Mean   :1984   Mean   :128.2   Mean   :232.4   Mean   :116.1  
##  3rd Qu.:1990   3rd Qu.:143.8   3rd Qu.:256.2   3rd Qu.:124.0  
##  Max.   :2015   Max.   :162.0   Max.   :273.0   Max.   :140.0  
##      INTER5           MAXT           SUMT0            SUMT5       
##  Min.   : 31.0   Min.   :18.89   Min.   : 526.9   Min.   : 506.6  
##  1st Qu.:106.8   1st Qu.:22.32   1st Qu.:1398.6   1st Qu.:1275.3  
##  Median :111.5   Median :23.59   Median :1492.9   Median :1383.4  
##  Mean   :111.2   Mean   :23.16   Mean   :1425.1   Mean   :1322.5  
##  3rd Qu.:120.0   3rd Qu.:24.23   3rd Qu.:1598.5   3rd Qu.:1477.5  
##  Max.   :138.0   Max.   :26.00   Max.   :1837.4   Max.   :1754.0  
##       T220             T225            FT220             FT225        
##  Min.   : 298.8   Min.   : 227.5   Min.   :  43.11   Min.   :  11.45  
##  1st Qu.: 460.3   1st Qu.: 401.1   1st Qu.: 697.61   1st Qu.: 635.55  
##  Median : 535.1   Median : 476.3   Median : 864.46   Median : 835.68  
##  Mean   : 616.2   Mean   : 551.0   Mean   : 834.51   Mean   : 809.94  
##  3rd Qu.: 685.0   3rd Qu.: 629.8   3rd Qu.:1078.97   3rd Qu.:1061.39  
##  Max.   :1487.8   Max.   :1431.5   Max.   :1215.46   Max.   :1178.07  
##      SPEEDT           SUMPREC     
##  Min.   :-0.6693   Min.   : 80.5  
##  1st Qu.: 0.1451   1st Qu.:180.5  
##  Median : 0.2441   Median :226.0  
##  Mean   : 0.2411   Mean   :268.8  
##  3rd Qu.: 0.3816   3rd Qu.:296.7  
##  Max.   : 1.0117   Max.   :831.1  
## elapsed time is 24.800000 seconds
```

```r
# The calculation run parameters for a particular station
# cli/lena/24051099999 SIKTJAH.txt  1
#par.lena <- cli2par(paste0(mm_path, "/cli/lena/"), lena.files, info = TRUE)
# cli/north/20982099999 VOLOCHANKA.txt 2


# https://www.rstudio.com/wp-content/uploads/2016/02/advancedR.pdf
# https://englianhu.files.wordpress.com/2016/05/advanced-r.pdf
# traceback()
#  Reading a specific year, specific weather stations
getCliStation <- function(path, files) {
    D <- read.csv(paste0(path, files), header = FALSE, sep = "", dec = ".")
    D <- setNames(D, c("Day", "Month", "Year", "PRECIP", "TMEAN"))
    return(D)
}
SA472 <- getCliStation(paste0(mm_path, "/cli/altai/"), altai.files[2])
Y1971 <- get_one_year(SA472, 1971)
numberObservation(SA472, 1972)
```

```
## [1] 0
```

```r
numberObservation(SA472, 1948)
```

```
## [1] 0
```

```r
# This is not implemented yet.
# http://adv-r.had.co.nz/Exceptions-Debugging.html#debugging-techniques
```










