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
Rmd2R("transect.Rmd", "transect.R")
```

```
## [1] "transect.R"
```

```r
source("transect.R")
```

```
## 'data.frame':	38716 obs. of  8 variables:
##  $ Station: int  29866 29866 29866 29866 29866 29866 29866 29866 29866 29866 ...
##  $ Year   : int  1910 1910 1910 1910 1910 1910 1910 1910 1910 1910 ...
##  $ Month  : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Day    : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ TMIN   : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ TMEAN  : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ TMAX   : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ PRECIP : num  NA NA NA NA NA NA NA NA NA NA ...
## numberObservation  1964 366 
## Reading of results season_growth  115 281 
## NumDay= 173 
## getNumDays(1964, 6, 22)=  169
```

![plot of chunk begin](figure/begin-1.png)

```
## 
## Call:
## lm(formula = DT$Temp ~ DT$Day, data = DT)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -5.5746 -2.8873 -0.0402  2.5231  7.9313 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -29.09152    6.25954  -4.648 3.31e-05 ***
## DT$Day        0.28419    0.04144   6.857 2.33e-08 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 3.491 on 42 degrees of freedom
## Multiple R-squared:  0.5282,	Adjusted R-squared:  0.517 
## F-statistic: 47.02 on 1 and 42 DF,  p-value: 2.327e-08
## 
## FT2205=  1758.6 1738.8 
## T2205=  970.3 917.5 
## SUMT0=  2320.4 2193.2 
## STDAT0=  9 5 1969 17 5 1969 
## FDAT0=  25 9 1969 18 9 1969 
## INTER0=  167 170 131 
## SUMPREC=  168.4 
## MAXT=  24.9 25.3 
## MDAT=  25 7 1964 25-7-1964 
## Start eval16CliPars
## ****** Year: 2011 Observation: 365 Period: 1-1-2011 31-12-2011 ******
## ****** Year: 2012 Observation: 366 Period: 1-1-2012 31-12-2012 ******
## ****** Year: 2013 Observation: 365 Period: 1-1-2013 31-12-2013 ******
## 
## elapsed time is 31.570000 seconds 
## 'data.frame':	3 obs. of  24 variables:
##  $ Station_Code: chr  "23365" "23365" "23365"
##  $ Year        : int  2011 2012 2013
##  $ ObsBeg      : chr  "1-1-2011" "1-1-2012" "1-1-2013"
##  $ ObsEnd      : chr  "31-12-2011" "31-12-2012" "31-12-2013"
##  $ StartSG     : int  5 27 49
##  $ EndSG       : int  6 28 50
##  $ STDAT0      : chr  "7-4-2011" "25-4-2012" "18-4-2013"
##  $ STDAT5      : chr  "11-4-2011" "1-5-2012" "25-4-2013"
##  $ FDAT0       : chr  "22-10-2011" "10-10-2012" "11-10-2013"
##  $ FDAT5       : chr  "18-10-2011" "10-10-2012" "10-10-2013"
##  $ INTER0      : num  198 168 176
##  $ INTER5      : num  194 168 175
##  $ MAXT        : num  26.9 25.1 23.5
##  $ MDAT        : chr  "13-7-2011" "23-7-2012" "22-7-2013"
##  $ SUMT0       : num  2755 2763 2603
##  $ SUMT5       : num  2682 2666 2488
##  $ T220        : num  1031 933 862
##  $ T225        : num  999 861 823
##  $ FT220       : num  1722 1802 1651
##  $ FT225       : num  1690 1799 1629
##  $ SPEEDT      : num  0.213 0.323 0.169
##  $ SUMPREC     : num  291 229 253
##  $ StartD      : num  97 116 108
##  $ EndD        : num  296 289 285
## EVAL16CLIPARS Done.
```

```r
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
## [28] "29998099999 ORLIK.txt"                
## [29] "29998_Orlik(WS).txt"                  
## [30] "36229099999 UST'- KOKSA.txt"          
## [31] "36231099999 ONGUDAJ.txt"              
## [32] "36246099999 UST-ULAGAN.txt"           
## [33] "38401099999 IGARKA.txt"
```

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
            cat("Delete/Replace the rows contains the number -9999\n")
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
            #print(summary(D[4:5]))
            print(summary(D))
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
            #todo insert numStation
            E <- eval16CliPars("23365", D, D, startYear, endYear)
            toc()
        } else {
            E <- eval16CliPars("23365", D, D, startYear, endYear)
        }
        # Deleted row is marked as bad
        E <- E[E$StartD != -9999, ]
        str(E)
        Sys.setenv(R_ZIPCMD = paste0(path, "/zip.exe"))  ## path to zip.exe
        require(openxlsx)  # # WriteXLSX
        openxlsx::write.xlsx(E, file = paste0(path, "/cli2par/", listFiles[i], ".xlsx"))
        # Save result to list listE[i] <- E
    }
    return(E)
}

par.alatai <- cli2par(paste0(mm_path, "/cli/altai/"), altai.files[2], info = TRUE)
```

```
## [1] "+---------------------------------------------------------+"
## [1] "Z:/home/larisa/Dropbox/24516/transect/cli/altai/29998_Orlik(WS).txt"
## Delete/Replace the rows contains the number -9999
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
##       Day            Month             Year          PRECIP       
##  Min.   : 1.00   Min.   : 1.000   Min.   :1948   Min.   :  0.000  
##  1st Qu.: 8.00   1st Qu.: 3.000   1st Qu.:1963   1st Qu.:  0.000  
##  Median :16.00   Median : 6.000   Median :1975   Median :  0.000  
##  Mean   :15.73   Mean   : 6.476   Mean   :1974   Mean   :  1.312  
##  3rd Qu.:23.00   3rd Qu.:10.000   3rd Qu.:1985   3rd Qu.:  0.000  
##  Max.   :31.00   Max.   :12.000   Max.   :1995   Max.   :150.110  
##      TMEAN        
##  Min.   :-42.060  
##  1st Qu.:-16.940  
##  Median : -3.830  
##  Mean   : -5.029  
##  3rd Qu.:  7.610  
##  Max.   : 23.000  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1948
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
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1972
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
## elapsed time is 211.740000 seconds 
## 'data.frame':	46 obs. of  24 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1949 1950 1951 1952 1953 1954 1955 1956 1957 1958 ...
##  $ ObsBeg      : chr  "7-1-1949" "3-1-1950" "2-1-1951" "1-1-1952" ...
##  $ ObsEnd      : chr  "30-12-1949" "30-12-1950" "31-12-1951" "31-12-1952" ...
##  $ StartSG     : int  27 49 71 93 115 137 159 181 203 225 ...
##  $ EndSG       : int  28 50 72 94 116 138 160 182 204 226 ...
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
##  $ StartD      : num  31 117 105 109 51 68 94 76 56 74 ...
##  $ EndD        : num  69 202 178 189 88 127 129 105 97 133 ...
```

```r
par.lena <- cli2par(paste0(mm_path, "/cli/lena/"), lena.files, info = TRUE)
```

```
## [1] "+---------------------------------------------------------+"
## [1] "Z:/home/larisa/Dropbox/24516/transect/cli/lena/24051099999 SIKTJAH.txt"
## Delete/Replace the rows contains the number -9999
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
##       Day            Month             Year          PRECIP        
##  Min.   : 1.00   Min.   : 1.000   Min.   :1969   Min.   :  0.0000  
##  1st Qu.: 8.00   1st Qu.: 3.000   1st Qu.:1975   1st Qu.:  0.0000  
##  Median :16.00   Median : 6.000   Median :1980   Median :  0.0000  
##  Mean   :15.71   Mean   : 6.442   Mean   :1980   Mean   :  0.9301  
##  3rd Qu.:23.00   3rd Qu.: 9.000   3rd Qu.:1986   3rd Qu.:  0.5100  
##  Max.   :31.00   Max.   :12.000   Max.   :1990   Max.   :150.1100  
##      TMEAN       
##  Min.   :-57.33  
##  1st Qu.:-30.22  
##  Median :-12.56  
##  Mean   :-13.17  
##  3rd Qu.:  4.56  
##  Max.   : 26.33  
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
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1972
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
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1982
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
## elapsed time is 53.030000 seconds 
## 'data.frame':	20 obs. of  24 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1969 1970 1971 1973 1974 1975 1976 1977 1978 1979 ...
##  $ ObsBeg      : chr  "1-1-1969" "2-1-1970" "1-1-1971" "1-1-1973" ...
##  $ ObsEnd      : chr  "31-12-1969" "31-12-1970" "30-6-1971" "31-12-1973" ...
##  $ StartSG     : int  5 27 49 93 115 137 159 181 203 225 ...
##  $ EndSG       : int  6 28 50 94 116 138 160 182 204 226 ...
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
##  $ StartD      : num  124 145 130 147 145 139 163 108 122 152 ...
##  $ EndD        : num  223 240 152 257 225 233 249 178 203 230 ...
## [1] "+---------------------------------------------------------+"
## [1] "Z:/home/larisa/Dropbox/24516/transect/cli/lena/24261099999 BATAGAJ-ALYTA.txt"
## Delete/Replace the rows contains the number -9999
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
##       Day            Month             Year          PRECIP       
##  Min.   : 1.00   Min.   : 1.000   Min.   :1959   Min.   :  0.000  
##  1st Qu.: 8.00   1st Qu.: 4.000   1st Qu.:1963   1st Qu.:  0.000  
##  Median :16.00   Median : 7.000   Median :2013   Median :  0.000  
##  Mean   :15.76   Mean   : 6.654   Mean   :1994   Mean   :  1.056  
##  3rd Qu.:23.00   3rd Qu.:10.000   3rd Qu.:2014   3rd Qu.:  0.000  
##  Max.   :31.00   Max.   :12.000   Max.   :2015   Max.   :150.110  
##      TMEAN       
##  Min.   :-53.06  
##  1st Qu.:-32.61  
##  Median :-14.00  
##  Mean   :-14.10  
##  3rd Qu.:  4.33  
##  Max.   : 22.94  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1959
```

```
## ****** Year: 1959 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1960
```

```
## ****** Year: 1960 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1961
```

```
## ****** Year: 1961 
## #################### Skip a year!!!! 
## ****** Year: 1962 Observation: 314 Period: 1-1-1962 31-12-1962 ******
```

```
## Error in `$<-.data.frame`(`*tmp*`, "EndD", value = c(NA, NA, NA, 144)): replacement has 4 rows, data has 57
```

```r
par.north <- cli2par(paste0(mm_path, "/cli/north/"), north.files, info = TRUE)
```

```
## [1] "+---------------------------------------------------------+"
## [1] "Z:/home/larisa/Dropbox/24516/transect/cli/north/20973099999 KRESTI.txt"
## Delete/Replace the rows contains the number -9999
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
##       Day            Month             Year          PRECIP       
##  Min.   : 1.00   Min.   : 1.000   Min.   :1955   Min.   :  0.000  
##  1st Qu.: 8.00   1st Qu.: 4.000   1st Qu.:1966   1st Qu.:  0.000  
##  Median :16.00   Median : 7.000   Median :1976   Median :  0.000  
##  Mean   :15.79   Mean   : 6.505   Mean   :1976   Mean   :  3.174  
##  3rd Qu.:23.00   3rd Qu.: 9.000   3rd Qu.:1986   3rd Qu.:  1.020  
##  Max.   :31.00   Max.   :12.000   Max.   :2001   Max.   :150.110  
##      TMEAN       
##  Min.   :-55.06  
##  1st Qu.:-29.00  
##  Median :-14.61  
##  Mean   :-15.10  
##  3rd Qu.:  0.39  
##  Max.   : 18.50  
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
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1956
```

```
## ****** Year: 1956 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1957
```

```
## ****** Year: 1957 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1958
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
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1960
```

```
## ****** Year: 1960 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1961
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
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1971
```

```
## ****** Year: 1971 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1972
```

```
## ****** Year: 1972 
## #################### Skip a year!!!! 
## ****** Year: 1973 Observation: 281 Period: 1-1-1973 31-12-1973 ******
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1974
```

```
## ****** Year: 1974 
## #################### Skip a year!!!! 
## ****** Year: 1975 Observation: 342 Period: 1-1-1975 31-12-1975 ******
## ****** Year: 1976 Observation: 308 Period: 1-1-1976 31-12-1976 ******
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1977
```

```
## ****** Year: 1977 
## #################### Skip a year!!!! 
## ****** Year: 1978 Observation: 218 Period: 1-1-1978 4-10-1978 ******
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1979
```

```
## ****** Year: 1979 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1980
```

```
## ****** Year: 1980 
## #################### Skip a year!!!! 
## ****** Year: 1981 Observation: 307 Period: 1-1-1981 31-12-1981 ******
## ****** Year: 1982 Observation: 265 Period: 1-1-1982 31-12-1982 ******
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1983
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
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1988
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
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1994
```

```
## ****** Year: 1994 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1995
```

```
## ****** Year: 1995 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1996
```

```
## ****** Year: 1996 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1997
```

```
## ****** Year: 1997 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1998
```

```
## ****** Year: 1998 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1999
```

```
## ****** Year: 1999 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2000
```

```
## ****** Year: 2000 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2001
```

```
## ****** Year: 2001 
## #################### Skip a year!!!! 
## 
## elapsed time is 58.150000 seconds 
## 'data.frame':	26 obs. of  24 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1955 1959 1962 1963 1964 1965 1966 1967 1968 1969 ...
##  $ ObsBeg      : chr  "16-4-1955" "7-1-1959" "3-1-1962" "3-1-1963" ...
##  $ ObsEnd      : chr  "31-12-1955" "31-12-1959" "31-12-1962" "31-12-1963" ...
##  $ StartSG     : int  5 93 159 181 203 225 247 269 291 313 ...
##  $ EndSG       : int  6 94 160 182 204 226 248 270 292 314 ...
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
##  $ StartD      : num  14 34 123 162 127 95 181 165 163 150 ...
##  $ EndD        : num  38 57 159 200 193 146 208 222 184 191 ...
## [1] "+---------------------------------------------------------+"
## [1] "Z:/home/larisa/Dropbox/24516/transect/cli/north/20982099999 VOLOCHANKA.txt"
## Delete/Replace the rows contains the number -9999
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
##       Day            Month             Year          PRECIP       
##  Min.   : 1.00   Min.   : 1.000   Min.   :1937   Min.   :  0.000  
##  1st Qu.: 8.00   1st Qu.: 4.000   1st Qu.:1961   1st Qu.:  0.000  
##  Median :16.00   Median : 7.000   Median :1965   Median :  0.000  
##  Mean   :15.69   Mean   : 6.637   Mean   :1969   Mean   :  3.302  
##  3rd Qu.:23.00   3rd Qu.:10.000   3rd Qu.:1969   3rd Qu.:  1.020  
##  Max.   :31.00   Max.   :12.000   Max.   :2015   Max.   :150.110  
##      TMEAN        
##  Min.   :-52.220  
##  1st Qu.:-27.500  
##  Median :-12.415  
##  Mean   :-12.524  
##  3rd Qu.:  3.292  
##  Max.   : 26.440  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1937
```

```
## ****** Year: 1937 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1938
```

```
## ****** Year: 1938 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1939
```

```
## ****** Year: 1939 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1940
```

```
## ****** Year: 1940 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1941
```

```
## ****** Year: 1941 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1942
```

```
## ****** Year: 1942 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1943
```

```
## ****** Year: 1943 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1944
```

```
## ****** Year: 1944 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1945
```

```
## ****** Year: 1945 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1946
```

```
## ****** Year: 1946 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1947
```

```
## ****** Year: 1947 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1948
```

```
## ****** Year: 1948 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1949
```

```
## ****** Year: 1949 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1950
```

```
## ****** Year: 1950 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1951
```

```
## ****** Year: 1951 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1952
```

```
## ****** Year: 1952 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1953
```

```
## ****** Year: 1953 
## #################### Skip a year!!!!
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1954
```

```
## ****** Year: 1954 
## #################### Skip a year!!!! 
## ****** Year: 1955 Observation: 114 Period: 14-4-1955 28-12-1955 ******
```

```
## Error in `$<-.data.frame`(`*tmp*`, "EndD", value = c(NA, NA, NA, NA, NA, : replacement has 19 rows, data has 79
```

```r
par.yenisei <- cli2par(paste0(mm_path, "/cli/yenisei/"), yenisei.files, info = TRUE)
```

```
## [1] "+---------------------------------------------------------+"
## [1] "Z:/home/larisa/Dropbox/24516/transect/cli/yenisei/23066099999 UST PORT UST ENISEISK.txt"
## Delete/Replace the rows contains the number -9999
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
##       Day            Month             Year          PRECIP       
##  Min.   : 1.00   Min.   : 1.000   Min.   :1948   Min.   :  0.000  
##  1st Qu.: 9.00   1st Qu.: 4.000   1st Qu.:1950   1st Qu.:  0.000  
##  Median :16.00   Median : 6.000   Median :1952   Median :  0.510  
##  Mean   :16.18   Mean   : 6.386   Mean   :1952   Mean   :  1.186  
##  3rd Qu.:24.00   3rd Qu.: 9.000   3rd Qu.:1953   3rd Qu.:  1.020  
##  Max.   :31.00   Max.   :12.000   Max.   :1955   Max.   :100.080  
##      TMEAN        
##  Min.   :-45.560  
##  1st Qu.:-23.060  
##  Median : -7.085  
##  Mean   : -9.466  
##  3rd Qu.:  3.610  
##  Max.   : 22.780  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1948
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
## elapsed time is 9.920000 seconds 
## 'data.frame':	6 obs. of  24 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1949 1950 1951 1952 1953 1954
##  $ ObsBeg      : chr  "11-1-1949" "5-1-1950" "10-1-1951" "2-1-1952" ...
##  $ ObsEnd      : chr  "31-12-1949" "27-12-1950" "27-12-1951" "25-12-1952" ...
##  $ StartSG     : int  27 49 71 93 115 137
##  $ EndSG       : int  28 50 72 94 116 138
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
##  $ StartD      : num  16 93 72 75 56 80
##  $ EndD        : num  45 125 115 124 86 121
## [1] "+---------------------------------------------------------+"
## [1] "Z:/home/larisa/Dropbox/24516/transect/cli/yenisei/23078099999 NORIL'SK.txt"
## Delete/Replace the rows contains the number -9999
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
##       Day            Month             Year          PRECIP      
##  Min.   : 1.00   Min.   : 1.000   Min.   :1975   Min.   :  0.00  
##  1st Qu.: 8.00   1st Qu.: 4.000   1st Qu.:1981   1st Qu.:  0.00  
##  Median :16.00   Median : 7.000   Median :1987   Median :  0.00  
##  Mean   :15.75   Mean   : 6.595   Mean   :1990   Mean   :  1.19  
##  3rd Qu.:23.00   3rd Qu.:10.000   3rd Qu.:1993   3rd Qu.:  1.02  
##  Max.   :31.00   Max.   :12.000   Max.   :2015   Max.   :141.99  
##      TMEAN       
##  Min.   :-52.50  
##  1st Qu.:-22.22  
##  Median : -8.78  
##  Mean   : -9.06  
##  3rd Qu.:  5.17  
##  Max.   : 26.61  
## [1] "+---------------------------------------------------------+"
## Start eval16CliPars
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1975
```

```
## ****** Year: 1975 
## #################### Skip a year!!!! 
## ****** Year: 1976 Observation: 343 Period: 2-1-1976 31-12-1976 ******
```

```
## Error in `$<-.data.frame`(`*tmp*`, "EndD", value = c(NA, 253)): replacement has 2 rows, data has 41
```

```r
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
## [1] 12
```

```r
# http://adv-r.had.co.nz/Exceptions-Debugging.html#debugging-techniques
```











