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
source("https://raw.githubusercontent.com/tmeits/24516/master/transect/set_work_dir.R")
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
## Convert data as strung=  2007-11-12 
## Convert data as strung=  12-11-2007
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
## ****************Year= 2011 Observation= 365 **********************
## ****************Year= 2012 Observation= 366 **********************
## ****************Year= 2013 Observation= 365 **********************
## 
## elapsed time is 3.420000 seconds 
## 'data.frame':	3 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365"
##  $ Year        : int  2011 2012 2013
##  $ StartD      : num  97 116 108
##  $ EndD        : num  296 289 285
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
## [29] "36229099999 UST'- KOKSA.txt"          
## [30] "36231099999 ONGUDAJ.txt"              
## [31] "36246099999 UST-ULAGAN.txt"           
## [32] "38401099999 IGARKA.txt"               
## [33] "Orlick (mt stn).txt"
```

```r
cli2par <- function(path, listFiles, info = TRUE) {
    listE <- list(1:length(listFiles))
    for (i in 1:length(listFiles)) {
        D <- read.csv(paste0(path, listFiles[i]), header = FALSE, sep = "", dec = ".")
        # The names of each column assign
        D <- setNames(D, c("Day", "Month", "Year", "PRECIP", "TMEAN"))
        if (info == TRUE) {
            print("***************************************************************")
            print(paste0(path, listFiles[i]))
            # Delete the rows contains the number -9999
            na <- abs(length(D[D$PRECIP != -9999, ][, 1]) - length(D[, 1]))
            cat("The number of deleted rows by column precipitation=", na, "\n")
            D <- D[D$PRECIP != -9999, ]
            na <- abs(length(D[D$TMEAN != -9999, ][, 1]) - length(D[, 1]))
            cat("The number of deleted rows by column temp=", na, "\n")
            D <- D[D$TMEAN != -9999, ]
            print(tail(D))
            print(str(D))
            print(summary(D[4:5]))
            print("***************************************************************")
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
            E <- eval16CliPars("23365", D, D, startYear, endYear)
            str(E)
            toc()
        } else {
            E <- eval16CliPars("23365", D, D, startYear, endYear)
        }
        # Deleted row is marked as bad
        E <- E[E$StartD != -9999, ]
        Sys.setenv(R_ZIPCMD = paste0(path, "/zip.exe"))  ## path to zip.exe
        require(openxlsx)  # # WriteXLSX
        openxlsx::write.xlsx(E, file = paste0(path, "/cli2par/", listFiles[i], ".xlsx"))
        # Save result to list listE[i] <- E
    }
    return(E)
}



par.alatai <- cli2par(paste0(mm_path, "/cli/altai/"), altai.files, info = TRUE)
```

```
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/altai/29998099999 ORLIK.txt"
## The number of deleted rows by column precipitation= 46 
## The number of deleted rows by column temp= 0 
##      Day Month Year PRECIP  TMEAN
## 5275  23    12 2015      0 -33.83
## 5276  24    12 2015      0 -22.61
## 5277  25    12 2015      0 -15.78
## 5278  26    12 2015      0 -18.83
## 5279  27    12 2015      0 -20.06
## 5280  28    12 2015      0 -19.22
## 'data.frame':	5234 obs. of  5 variables:
##  $ Day   : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ Month : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Year  : int  1997 1997 1997 1997 1997 1997 1997 1997 1997 1997 ...
##  $ PRECIP: num  0 0 0 0 0 0 0 0 0 0 ...
##  $ TMEAN : num  -27.6 -27 -29.9 -30.2 -26.4 ...
## NULL
##      PRECIP            TMEAN        
##  Min.   : 0.0000   Min.   :-39.440  
##  1st Qu.: 0.0000   1st Qu.:-17.000  
##  Median : 0.0000   Median : -3.140  
##  Mean   : 0.7805   Mean   : -4.936  
##  3rd Qu.: 0.0000   3rd Qu.:  7.780  
##  Max.   :97.0300   Max.   : 23.000  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 1997 Observation= 331 **********************
## ****************Year= 1998 Observation= 234 **********************
## ****************Year= 1999 Observation= 137 **********************
## WARNING: T2205 num_days=  172 lenYear=  137  
## WARNING: T2205 num_days=  172 lenYear=  137  
## WARNING: FT2205 num_days=  172 lenYear=  137  
## WARNING: FT2205 seasonBegin=  73 seasonEnd=  98  
## WARNING: FT2205 num_days=  172 lenYear=  137  
## WARNING: FT2205 seasonBegin=  73 seasonEnd=  98  
## ****************Year= 2000 Observation= 59 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2000
```

```
## #################### Skip a year!!!! 
## ****************Year= 2001 Observation= 119 **********************
## WARNING: T2205 num_days=  172 lenYear=  119  
## WARNING: T2205 num_days=  172 lenYear=  119  
## WARNING: FT2205 num_days=  172 lenYear=  119  
## WARNING: FT2205 seasonBegin=  48 seasonEnd=  76  
## WARNING: FT2205 num_days=  172 lenYear=  119  
## WARNING: FT2205 seasonBegin=  48 seasonEnd=  76  
## ****************Year= 2002 Observation= 166 **********************
## WARNING: T2205 num_days=  172 lenYear=  166  
## WARNING: T2205 num_days=  172 lenYear=  166  
## WARNING: FT2205 num_days=  172 lenYear=  166  
## WARNING: FT2205 seasonBegin=  74 seasonEnd=  119  
## WARNING: FT2205 num_days=  172 lenYear=  166  
## WARNING: FT2205 seasonBegin=  74 seasonEnd=  119  
## ****************Year= 2003 Observation= 235 **********************
## ****************Year= 2004 Observation= 267 **********************
## ****************Year= 2005 Observation= 287 **********************
## ****************Year= 2006 Observation= 281 **********************
## ****************Year= 2007 Observation= 313 **********************
## ****************Year= 2008 Observation= 333 **********************
## ****************Year= 2009 Observation= 350 **********************
## ****************Year= 2010 Observation= 347 **********************
## ****************Year= 2011 Observation= 351 **********************
## ****************Year= 2012 Observation= 359 **********************
## ****************Year= 2013 Observation= 352 **********************
## ****************Year= 2014 Observation= 357 **********************
## ****************Year= 2015 Observation= 356 **********************
## 
## 'data.frame':	19 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 ...
##  $ StartD      : num  125 129 73 -9999 48 ...
##  $ EndD        : num  230 183 98 64 76 119 183 193 211 214 ...
##  $ STDAT0      : chr  "15-5-1997" "22-5-1998" "2-5-1999" "65" ...
##  $ STDAT5      : chr  "16-5-1997" "29-5-1998" "27-5-1999" "66" ...
##  $ FDAT0       : chr  "14-9-1997" "27-9-1998" "22-9-1999" "67" ...
##  $ FDAT5       : chr  "14-9-1997" "27-9-1998" "21-9-1999" "68" ...
##  $ INTER0      : num  122 128 143 69 157 135 136 137 111 126 ...
##  $ INTER5      : num  122 127 142 70 128 128 132 130 107 109 ...
##  $ MAXT        : num  21.9 17.6 17.4 71 16.4 ...
##  $ MDAT        : chr  "25-6-1997" "30-6-1998" "11-7-1999" "72" ...
##  $ SUMT0       : num  1435 686 212 73 245 ...
##  $ SUMT5       : num  1326 619 184 74 223 ...
##  $ T220        : num  672 626 212 75 245 ...
##  $ T225        : num  620 577 184 76 223 ...
##  $ FT220       : num  666.2 56.4 211.8 77 244.8 ...
##  $ FT225       : num  642 46.2 184.1 78 222.6 ...
##  $ SPEEDT      : num  0.171 0.102 -0.594 79 -0.615 ...
##  $ SUMPREC     : num  214.65 49.3 9.15 80 43.93 ...
## elapsed time is 11.300000 seconds
```

```
## Loading required package: openxlsx
```

```
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/altai/36229099999 UST'- KOKSA.txt"
## The number of deleted rows by column precipitation= 119 
## The number of deleted rows by column temp= 0 
##      Day Month Year PRECIP TMEAN
## 2494  26    12 2015   0.00 -5.44
## 2495  27    12 2015   4.32 -4.44
## 2496  28    12 2015   0.25 -5.72
## 2497  29    12 2015   5.08 -5.83
## 2498  30    12 2015   0.76 -8.11
## 2499  31    12 2015   2.54 -8.56
## 'data.frame':	2380 obs. of  5 variables:
##  $ Day   : int  25 26 27 28 1 2 3 4 5 6 ...
##  $ Month : int  2 2 2 2 3 3 3 3 3 3 ...
##  $ Year  : int  2009 2009 2009 2009 2009 2009 2009 2009 2009 2009 ...
##  $ PRECIP: num  0 0 0 0 0 0 0 0 0 0 ...
##  $ TMEAN : num  -18.1 -16.4 -14.3 -13.3 -14.3 ...
## NULL
##      PRECIP           TMEAN         
##  Min.   : 0.000   Min.   :-37.1100  
##  1st Qu.: 0.000   1st Qu.: -9.7925  
##  Median : 0.000   Median :  3.8300  
##  Mean   : 1.384   Mean   :  0.5372  
##  3rd Qu.: 0.760   3rd Qu.: 12.1100  
##  Max.   :39.880   Max.   : 23.5600  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 2009 Observation= 290 **********************
## ****************Year= 2010 Observation= 343 **********************
## ****************Year= 2011 Observation= 350 **********************
## ****************Year= 2012 Observation= 348 **********************
## ****************Year= 2013 Observation= 345 **********************
## ****************Year= 2014 Observation= 341 **********************
## ****************Year= 2015 Observation= 363 **********************
## 
## 'data.frame':	7 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  2009 2010 2011 2012 2013 2014 2015
##  $ StartD      : num  56 104 92 107 110 111 103
##  $ EndD        : num  218 267 274 269 259 265 269
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
## elapsed time is 5.450000 seconds 
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/altai/36231099999 ONGUDAJ.txt"
## The number of deleted rows by column precipitation= 206 
## The number of deleted rows by column temp= 0 
##       Day Month Year PRECIP TMEAN
## 11106   7     5 1995   0.00  7.33
## 11107   8     5 1995   0.00 11.28
## 11108   9     5 1995   2.03 10.78
## 11109  10     5 1995  12.95 10.33
## 11110  14     5 1995   2.03  8.50
## 11111  26     5 1995   5.08 13.28
## 'data.frame':	10905 obs. of  5 variables:
##  $ Day   : int  26 6 13 15 20 24 1 2 9 11 ...
##  $ Month : int  1 2 2 2 2 2 3 3 3 3 ...
##  $ Year  : int  1958 1958 1958 1958 1958 1958 1958 1958 1958 1958 ...
##  $ PRECIP: num  0 1.02 0 1.27 0 0.51 0 0 0 2.03 ...
##  $ TMEAN : num  -12.06 -17.39 -8.22 -16.5 -2.06 ...
## NULL
##      PRECIP            TMEAN          
##  Min.   :  0.000   Min.   :-41.06000  
##  1st Qu.:  0.000   1st Qu.:-11.17000  
##  Median :  0.000   Median :  2.44000  
##  Mean   :  1.515   Mean   : -0.00222  
##  3rd Qu.:  0.000   3rd Qu.: 12.17000  
##  Max.   :299.720   Max.   : 28.11000  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 1958 Observation= 56 **********************
## #################### Skip a year!!!! 
## ****************Year= 1959 Observation= 77 **********************
## WARNING: T2205 num_days=  172 lenYear=  77  
## WARNING: T2205 num_days=  172 lenYear=  77  
## WARNING: FT2205 num_days=  172 lenYear=  77  
## WARNING: FT2205 seasonBegin=  22 seasonEnd=  53  
## WARNING: FT2205 num_days=  172 lenYear=  77  
## WARNING: FT2205 seasonBegin=  22 seasonEnd=  53  
## ****************Year= 1960 Observation= 138 **********************
## WARNING: T2205 num_days=  173 lenYear=  138  
## WARNING: T2205 num_days=  173 lenYear=  138  
## WARNING: FT2205 num_days=  173 lenYear=  138  
## WARNING: FT2205 seasonBegin=  60 seasonEnd=  111  
## WARNING: FT2205 num_days=  173 lenYear=  138  
## WARNING: FT2205 seasonBegin=  60 seasonEnd=  111  
## ****************Year= 1961 Observation= 238 **********************
## ****************Year= 1962 Observation= 199 **********************
## ****************Year= 1963 Observation= 107 **********************
## WARNING: T2205 num_days=  172 lenYear=  107  
## WARNING: T2205 num_days=  172 lenYear=  107  
## WARNING: FT2205 num_days=  172 lenYear=  107  
## WARNING: FT2205 seasonBegin=  80 seasonEnd=  106  
## WARNING: FT2205 num_days=  172 lenYear=  107  
## WARNING: FT2205 seasonBegin=  80 seasonEnd=  106  
## ****************Year= 1964 Observation= 251 **********************
## ****************Year= 1965 Observation= 300 **********************
## ****************Year= 1966 Observation= 364 **********************
## ****************Year= 1967 Observation= 364 **********************
## ****************Year= 1968 Observation= 362 **********************
## ****************Year= 1969 Observation= 361 **********************
## ****************Year= 1970 Observation= 364 **********************
## ****************Year= 1971 Observation= 181 **********************
## ****************Year= 1972 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1972
```

```
## #################### Skip a year!!!! 
## ****************Year= 1973 Observation= 356 **********************
## ****************Year= 1974 Observation= 362 **********************
## ****************Year= 1975 Observation= 359 **********************
## ****************Year= 1976 Observation= 349 **********************
## ****************Year= 1977 Observation= 346 **********************
## ****************Year= 1978 Observation= 352 **********************
## ****************Year= 1979 Observation= 336 **********************
## ****************Year= 1980 Observation= 342 **********************
## ****************Year= 1981 Observation= 358 **********************
## ****************Year= 1982 Observation= 356 **********************
## ****************Year= 1983 Observation= 348 **********************
## ****************Year= 1984 Observation= 350 **********************
## ****************Year= 1985 Observation= 360 **********************
## ****************Year= 1986 Observation= 359 **********************
## ****************Year= 1987 Observation= 362 **********************
## ****************Year= 1988 Observation= 364 **********************
## ****************Year= 1989 Observation= 362 **********************
## ****************Year= 1990 Observation= 364 **********************
## ****************Year= 1991 Observation= 227 **********************
## ****************Year= 1992 Observation= 186 **********************
## ****************Year= 1993 Observation= 347 **********************
## ****************Year= 1994 Observation= 337 **********************
## ****************Year= 1995 Observation= 61 **********************
## #################### Skip a year!!!! 
## 
## 'data.frame':	38 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1958 1959 1960 1961 1962 1963 1964 1965 1966 1967 ...
##  $ StartD      : num  -9999 22 60 84 60 ...
##  $ EndD        : num  4 53 111 182 154 106 183 220 284 284 ...
##  $ STDAT0      : chr  "5" "29-3-1959" "19-4-1960" "15-5-1961" ...
##  $ STDAT5      : chr  "6" "11-5-1959" "23-5-1960" "26-5-1961" ...
##  $ FDAT0       : chr  "7" "26-10-1959" "15-10-1960" "30-9-1961" ...
##  $ FDAT5       : chr  "8" "3-10-1959" "9-10-1960" "29-9-1961" ...
##  $ INTER0      : num  9 211 179 138 161 185 152 170 168 180 ...
##  $ INTER5      : num  10 145 173 137 154 185 149 161 162 171 ...
##  $ MAXT        : num  11 18.5 17.9 19.6 20.6 ...
##  $ MDAT        : chr  "12" "8-9-1959" "11-8-1960" "6-7-1961" ...
##  $ SUMT0       : num  13 280 571 1269 1256 ...
##  $ SUMT5       : num  14 269 547 1167 1211 ...
##  $ T220        : num  15 280 571 1199 1256 ...
##  $ T225        : num  16 269 547 1123 1211 ...
##  $ FT220       : num  17 280.3 571.1 50.7 40.8 ...
##  $ FT225       : num  18 268.8 546.9 34.8 23.9 ...
##  $ SPEEDT      : num  19 -0.80835 -0.43245 0.00213 -0.17047 ...
##  $ SUMPREC     : num  20 92.7 169.2 631.4 553 ...
## elapsed time is 24.540000 seconds 
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/altai/36246099999 UST-ULAGAN.txt"
## The number of deleted rows by column precipitation= 164 
## The number of deleted rows by column temp= 0 
##      Day Month Year PRECIP  TMEAN
## 6210  26    12 1988      0 -19.61
## 6211  27    12 1988      0 -24.83
## 6212  28    12 1988      0 -30.22
## 6213  29    12 1988      0 -23.89
## 6214  30    12 1988      0 -22.06
## 6215  31    12 1988      0 -23.56
## 'data.frame':	6051 obs. of  5 variables:
##  $ Day   : int  8 9 10 11 12 13 14 15 16 17 ...
##  $ Month : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Year  : int  1969 1969 1969 1969 1969 1969 1969 1969 1969 1969 ...
##  $ PRECIP: num  7.11 0 0 0 7.87 0 0 0 0 0 ...
##  $ TMEAN : num  -22.6 -33.2 -24.3 -20 -30.7 ...
## NULL
##      PRECIP            TMEAN        
##  Min.   :  0.000   Min.   :-42.500  
##  1st Qu.:  0.000   1st Qu.:-15.940  
##  Median :  0.000   Median : -1.110  
##  Mean   :  1.683   Mean   : -3.531  
##  3rd Qu.:  0.000   3rd Qu.:  9.560  
##  Max.   :150.110   Max.   : 26.500  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 1969 Observation= 338 **********************
## ****************Year= 1970 Observation= 358 **********************
## ****************Year= 1971 Observation= 175 **********************
## ****************Year= 1972 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1972
```

```
## #################### Skip a year!!!! 
## ****************Year= 1973 Observation= 323 **********************
## ****************Year= 1974 Observation= 336 **********************
## ****************Year= 1975 Observation= 362 **********************
## ****************Year= 1976 Observation= 338 **********************
## ****************Year= 1977 Observation= 326 **********************
## ****************Year= 1978 Observation= 335 **********************
## ****************Year= 1979 Observation= 325 **********************
## ****************Year= 1980 Observation= 338 **********************
## ****************Year= 1981 Observation= 335 **********************
## ****************Year= 1982 Observation= 284 **********************
## ****************Year= 1983 Observation= 318 **********************
## ****************Year= 1984 Observation= 261 **********************
## ****************Year= 1985 Observation= 315 **********************
## ****************Year= 1986 Observation= 296 **********************
## ****************Year= 1987 Observation= 339 **********************
## ****************Year= 1988 Observation= 349 **********************
## 
## 'data.frame':	20 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1969 1970 1971 1972 1973 1974 1975 1976 1977 1978 ...
##  $ StartD      : num  121 128 135 -9999 113 ...
##  $ EndD        : num  242 273 175 64 234 237 267 255 248 250 ...
##  $ STDAT0      : chr  "13-5-1969" "9-5-1970" "16-5-1971" "65" ...
##  $ STDAT5      : chr  "16-5-1969" "18-5-1970" "17-5-1971" "66" ...
##  $ FDAT0       : chr  "22-9-1969" "4-10-1970" "30-6-1971" "67" ...
##  $ FDAT5       : chr  "17-9-1969" "2-10-1970" "30-6-1971" "68" ...
##  $ INTER0      : num  132 148 45 69 131 131 127 163 148 139 ...
##  $ INTER5      : num  124 144 45 70 130 129 127 163 146 136 ...
##  $ MAXT        : num  19.4 24.2 23.1 71 19.8 ...
##  $ MDAT        : chr  "10-7-1969" "17-7-1970" "24-6-1971" "72" ...
##  $ SUMT0       : num  1488 1659 655 73 1479 ...
##  $ SUMT5       : num  1383 1558 589 74 1417 ...
##  $ T220        : num  731 587 608 75 862 ...
##  $ T225        : num  674 538 542 76 818 ...
##  $ FT220       : num  744.4 1074.3 61.8 77 616.6 ...
##  $ FT225       : num  717.6 1035.9 61.8 78 608.5 ...
##  $ SPEEDT      : num  0.2164 0.2103 0.2771 79 0.0894 ...
##  $ SUMPREC     : num  901 1619 258 80 238 ...
## elapsed time is 12.090000 seconds 
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/altai/Orlick (mt stn).txt"
## The number of deleted rows by column precipitation= 119 
## The number of deleted rows by column temp= 0 
##       Day Month Year PRECIP  TMEAN
## 14499  26    12 1995      0 -27.44
## 14500  27    12 1995      0 -25.61
## 14501  28    12 1995      0 -20.67
## 14502  29    12 1995      0  -9.17
## 14503  30    12 1995      0  -9.56
## 14504  31    12 1995      0  -7.39
## 'data.frame':	14385 obs. of  5 variables:
##  $ Day   : int  2 10 13 14 25 30 5 7 8 17 ...
##  $ Month : int  7 8 9 9 9 10 11 11 11 11 ...
##  $ Year  : int  1948 1948 1948 1948 1948 1948 1948 1948 1948 1948 ...
##  $ PRECIP: num  0 0.51 0 2.03 0 0 0 7.11 0 0 ...
##  $ TMEAN : num  13.33 11.78 4.61 5 2.5 ...
## NULL
##      PRECIP            TMEAN        
##  Min.   :  0.000   Min.   :-42.060  
##  1st Qu.:  0.000   1st Qu.:-16.940  
##  Median :  0.000   Median : -3.830  
##  Mean   :  1.312   Mean   : -5.029  
##  3rd Qu.:  0.000   3rd Qu.:  7.610  
##  Max.   :150.110   Max.   : 23.000  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 1948 Observation= 12 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1948
```

```
## #################### Skip a year!!!! 
## ****************Year= 1949 Observation= 122 **********************
## WARNING: T2205 num_days=  172 lenYear=  122  
## WARNING: T2205 num_days=  172 lenYear=  122  
## WARNING: FT2205 num_days=  172 lenYear=  122  
## WARNING: FT2205 seasonBegin=  31 seasonEnd=  69  
## WARNING: FT2205 num_days=  172 lenYear=  122  
## WARNING: FT2205 seasonBegin=  31 seasonEnd=  69  
## ****************Year= 1950 Observation= 270 **********************
## ****************Year= 1951 Observation= 234 **********************
## ****************Year= 1952 Observation= 264 **********************
## ****************Year= 1953 Observation= 117 **********************
## WARNING: T2205 num_days=  172 lenYear=  117  
## WARNING: T2205 num_days=  172 lenYear=  117  
## WARNING: FT2205 num_days=  172 lenYear=  117  
## WARNING: FT2205 seasonBegin=  51 seasonEnd=  88  
## WARNING: FT2205 num_days=  172 lenYear=  117  
## WARNING: FT2205 seasonBegin=  51 seasonEnd=  88  
## ****************Year= 1954 Observation= 171 **********************
## WARNING: T2205 num_days=  172 lenYear=  171  
## WARNING: T2205 num_days=  172 lenYear=  171  
## WARNING: FT2205 num_days=  172 lenYear=  171  
## WARNING: FT2205 seasonBegin=  68 seasonEnd=  127  
## WARNING: FT2205 num_days=  172 lenYear=  171  
## WARNING: FT2205 seasonBegin=  68 seasonEnd=  127  
## ****************Year= 1955 Observation= 188 **********************
## ****************Year= 1956 Observation= 156 **********************
## WARNING: T2205 num_days=  173 lenYear=  156  
## WARNING: T2205 num_days=  173 lenYear=  156  
## WARNING: FT2205 num_days=  173 lenYear=  156  
## WARNING: FT2205 seasonBegin=  76 seasonEnd=  105  
## WARNING: FT2205 num_days=  173 lenYear=  156  
## WARNING: FT2205 seasonBegin=  76 seasonEnd=  105  
## ****************Year= 1957 Observation= 157 **********************
## WARNING: T2205 num_days=  172 lenYear=  157  
## WARNING: T2205 num_days=  172 lenYear=  157  
## WARNING: FT2205 num_days=  172 lenYear=  157  
## WARNING: FT2205 seasonBegin=  56 seasonEnd=  97  
## WARNING: FT2205 num_days=  172 lenYear=  157  
## WARNING: FT2205 seasonBegin=  56 seasonEnd=  97  
## ****************Year= 1958 Observation= 204 **********************
## ****************Year= 1959 Observation= 354 **********************
## ****************Year= 1960 Observation= 346 **********************
## ****************Year= 1961 Observation= 355 **********************
## ****************Year= 1962 Observation= 362 **********************
## ****************Year= 1963 Observation= 360 **********************
## ****************Year= 1964 Observation= 364 **********************
## ****************Year= 1965 Observation= 323 **********************
## ****************Year= 1966 Observation= 362 **********************
## ****************Year= 1967 Observation= 361 **********************
## ****************Year= 1968 Observation= 362 **********************
## ****************Year= 1969 Observation= 352 **********************
## ****************Year= 1970 Observation= 355 **********************
## ****************Year= 1971 Observation= 175 **********************
## ****************Year= 1972 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1972
```

```
## #################### Skip a year!!!! 
## ****************Year= 1973 Observation= 354 **********************
## ****************Year= 1974 Observation= 352 **********************
## ****************Year= 1975 Observation= 360 **********************
## ****************Year= 1976 Observation= 364 **********************
## ****************Year= 1977 Observation= 362 **********************
## ****************Year= 1978 Observation= 363 **********************
## ****************Year= 1979 Observation= 365 **********************
## ****************Year= 1980 Observation= 359 **********************
## ****************Year= 1981 Observation= 364 **********************
## ****************Year= 1982 Observation= 357 **********************
## ****************Year= 1983 Observation= 354 **********************
## ****************Year= 1984 Observation= 355 **********************
## ****************Year= 1985 Observation= 358 **********************
## ****************Year= 1986 Observation= 350 **********************
## ****************Year= 1987 Observation= 345 **********************
## ****************Year= 1988 Observation= 356 **********************
## ****************Year= 1989 Observation= 357 **********************
## ****************Year= 1990 Observation= 353 **********************
## ****************Year= 1991 Observation= 314 **********************
## ****************Year= 1992 Observation= 305 **********************
## ****************Year= 1993 Observation= 347 **********************
## ****************Year= 1994 Observation= 320 **********************
## ****************Year= 1995 Observation= 345 **********************
## 
## 'data.frame':	48 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1948 1949 1950 1951 1952 1953 1954 1955 1956 1957 ...
##  $ StartD      : num  -9999 31 117 105 109 ...
##  $ EndD        : num  4 69 202 178 189 88 127 129 105 97 ...
##  $ STDAT0      : chr  "5" "19-5-1949" "19-5-1950" "16-5-1951" ...
##  $ STDAT5      : chr  "6" "4-6-1949" "26-5-1950" "23-5-1951" ...
##  $ FDAT0       : chr  "7" "27-9-1949" "17-9-1950" "24-9-1951" ...
##  $ FDAT5       : chr  "8" "11-9-1949" "10-9-1950" "21-9-1951" ...
##  $ INTER0      : num  9 131 121 131 122 147 126 113 131 82 ...
##  $ INTER5      : num  10 111 114 127 113 130 118 100 119 80 ...
##  $ MAXT        : num  11 16 20.6 20.2 17.5 ...
##  $ MDAT        : chr  "12" "8-8-1949" "8-7-1950" "19-7-1951" ...
##  $ SUMT0       : num  13 334 1002 802 963 ...
##  $ SUMT5       : num  14 290 933 772 893 ...
##  $ T220        : num  15 334 714 780 862 ...
##  $ T225        : num  16 290 684 766 824 ...
##  $ FT220       : num  17 334.3 260.5 28.7 100.2 ...
##  $ FT225       : num  18 290.2 247.9 12.9 80.5 ...
##  $ SPEEDT      : num  19 -0.5421 0.1532 -0.0192 0.0414 ...
##  $ SUMPREC     : num  20 87.6 236.5 88.9 212.6 ...
## elapsed time is 29.510000 seconds
```

```r
par.lena <- cli2par(paste0(mm_path, "/cli/lena/"), lena.files, info = TRUE)
```

```
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/lena/24051099999 SIKTJAH.txt"
## The number of deleted rows by column precipitation= 86 
## The number of deleted rows by column temp= 0 
##      Day Month Year PRECIP  TMEAN
## 6552  22    12 1990   1.02 -42.78
## 6553  25    12 1990   0.25 -46.44
## 6554  27    12 1990   0.00 -45.72
## 6555  28    12 1990   0.00 -46.06
## 6556  29    12 1990   0.25 -41.50
## 6557  30    12 1990   1.02 -42.33
## 'data.frame':	6471 obs. of  5 variables:
##  $ Day   : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ Month : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Year  : int  1969 1969 1969 1969 1969 1969 1969 1969 1969 1969 ...
##  $ PRECIP: num  0.25 0 0 0 0.25 1.27 0.76 0.25 0 0 ...
##  $ TMEAN : num  -27.8 -28.5 -33.7 -38.1 -33 ...
## NULL
##      PRECIP             TMEAN       
##  Min.   :  0.0000   Min.   :-57.33  
##  1st Qu.:  0.0000   1st Qu.:-30.22  
##  Median :  0.0000   Median :-12.56  
##  Mean   :  0.9301   Mean   :-13.17  
##  3rd Qu.:  0.5100   3rd Qu.:  4.56  
##  Max.   :150.1100   Max.   : 26.33  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 1969 Observation= 335 **********************
## ****************Year= 1970 Observation= 340 **********************
## ****************Year= 1971 Observation= 152 **********************
## WARNING: T2205 num_days=  172 lenYear=  152  
## WARNING: T2205 num_days=  172 lenYear=  152  
## WARNING: FT2205 num_days=  172 lenYear=  152  
## WARNING: FT2205 seasonBegin=  130 seasonEnd=  152  
## WARNING: FT2205 num_days=  172 lenYear=  152  
## WARNING: FT2205 seasonBegin=  130 seasonEnd=  152  
## ****************Year= 1972 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1972
```

```
## #################### Skip a year!!!! 
## ****************Year= 1973 Observation= 346 **********************
## ****************Year= 1974 Observation= 321 **********************
## ****************Year= 1975 Observation= 331 **********************
## ****************Year= 1976 Observation= 324 **********************
## ****************Year= 1977 Observation= 237 **********************
## ****************Year= 1978 Observation= 316 **********************
## ****************Year= 1979 Observation= 346 **********************
## ****************Year= 1980 Observation= 304 **********************
## ****************Year= 1981 Observation= 277 **********************
## ****************Year= 1982 Observation= 38 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1982
```

```
## #################### Skip a year!!!! 
## ****************Year= 1983 Observation= 281 **********************
## ****************Year= 1984 Observation= 358 **********************
## ****************Year= 1985 Observation= 363 **********************
## ****************Year= 1986 Observation= 363 **********************
## ****************Year= 1987 Observation= 361 **********************
## ****************Year= 1988 Observation= 363 **********************
## ****************Year= 1989 Observation= 364 **********************
## ****************Year= 1990 Observation= 351 **********************
## 
## 'data.frame':	22 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1969 1970 1971 1972 1973 1974 1975 1976 1977 1978 ...
##  $ StartD      : num  124 145 130 -9999 147 ...
##  $ EndD        : num  223 240 152 64 257 225 233 249 178 203 ...
##  $ STDAT0      : chr  "25-5-1969" "4-6-1970" "1-6-1971" "65" ...
##  $ STDAT5      : chr  "1-6-1969" "9-6-1970" "13-6-1971" "66" ...
##  $ FDAT0       : chr  "6-9-1969" "16-9-1970" "30-6-1971" "67" ...
##  $ FDAT5       : chr  "1-9-1969" "16-9-1970" "30-6-1971" "68" ...
##  $ INTER0      : num  104 104 29 69 112 94 97 98 97 98 ...
##  $ INTER5      : num  96 101 28 70 106 85 95 91 95 85 ...
##  $ MAXT        : num  23.8 24.1 16.8 71 25.3 ...
##  $ MDAT        : chr  "29-7-1969" "7-7-1970" "13-6-1971" "72" ...
##  $ SUMT0       : num  1213 1040 210 73 1295 ...
##  $ SUMT5       : num  1162 962 182 74 1204 ...
##  $ T220        : num  564 302 210 75 316 ...
##  $ T225        : num  538 282 182 76 263 ...
##  $ FT220       : num  642 738 210 77 988 ...
##  $ FT225       : num  632 690 182 78 950 ...
##  $ SPEEDT      : num  0.1338 0.2483 0.0541 79 0.0882 ...
##  $ SUMPREC     : num  457.7 280.2 55.4 80 180.6 ...
## elapsed time is 12.760000 seconds 
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/lena/24261099999 BATAGAJ-ALYTA.txt"
## The number of deleted rows by column precipitation= 98 
## The number of deleted rows by column temp= 0 
##      Day Month Year PRECIP  TMEAN
## 2004  26    12 2015   0.25 -35.50
## 2005  27    12 2015   0.00 -33.78
## 2006  28    12 2015   0.00 -36.06
## 2007  29    12 2015   0.00 -33.83
## 2008  30    12 2015   0.25 -27.11
## 2009  31    12 2015   0.25 -31.39
## 'data.frame':	1911 obs. of  5 variables:
##  $ Day   : int  3 5 7 9 11 19 21 22 28 29 ...
##  $ Month : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Year  : int  1959 1959 1959 1959 1959 1959 1959 1959 1959 1959 ...
##  $ PRECIP: num  0 1.52 0.25 0 0 0.25 0.51 0 0 0 ...
##  $ TMEAN : num  -34.3 -33.1 -34.4 -46.1 -42.8 ...
## NULL
##      PRECIP            TMEAN       
##  Min.   :  0.000   Min.   :-53.06  
##  1st Qu.:  0.000   1st Qu.:-32.61  
##  Median :  0.000   Median :-14.00  
##  Mean   :  1.056   Mean   :-14.10  
##  3rd Qu.:  0.000   3rd Qu.:  4.33  
##  Max.   :150.110   Max.   : 22.94  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 1959 Observation= 34 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1959
```

```
## #################### Skip a year!!!! 
## ****************Year= 1960 Observation= 6 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1960
```

```
## #################### Skip a year!!!! 
## ****************Year= 1961 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1961
```

```
## #################### Skip a year!!!! 
## ****************Year= 1962 Observation= 314 **********************
## ****************Year= 1963 Observation= 262 **********************
## ****************Year= 1964 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1964
```

```
## #################### Skip a year!!!! 
## ****************Year= 1965 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1965
```

```
## #################### Skip a year!!!! 
## ****************Year= 1966 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1966
```

```
## #################### Skip a year!!!! 
## ****************Year= 1967 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1967
```

```
## #################### Skip a year!!!! 
## ****************Year= 1968 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1968
```

```
## #################### Skip a year!!!! 
## ****************Year= 1969 Observation= 85 **********************
## WARNING: T2205 num_days=  172 lenYear=  85  
## WARNING: T2205 num_days=  172 lenYear=  85  
## WARNING: FT2205 num_days=  172 lenYear=  85  
## WARNING: FT2205 seasonBegin=  14 seasonEnd=  51  
## WARNING: FT2205 num_days=  172 lenYear=  85  
## WARNING: FT2205 seasonBegin=  14 seasonEnd=  51  
## ****************Year= 1970 Observation= 62 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1970
```

```
## #################### Skip a year!!!! 
## ****************Year= 1971 Observation= 9 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1971
```

```
## #################### Skip a year!!!! 
## ****************Year= 1972 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1972
```

```
## #################### Skip a year!!!! 
## ****************Year= 1973 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1973
```

```
## #################### Skip a year!!!! 
## ****************Year= 1974 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1974
```

```
## #################### Skip a year!!!! 
## ****************Year= 1975 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1975
```

```
## #################### Skip a year!!!! 
## ****************Year= 1976 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1976
```

```
## #################### Skip a year!!!! 
## ****************Year= 1977 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1977
```

```
## #################### Skip a year!!!! 
## ****************Year= 1978 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1978
```

```
## #################### Skip a year!!!! 
## ****************Year= 1979 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1979
```

```
## #################### Skip a year!!!! 
## ****************Year= 1980 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1980
```

```
## #################### Skip a year!!!! 
## ****************Year= 1981 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1981
```

```
## #################### Skip a year!!!! 
## ****************Year= 1982 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1982
```

```
## #################### Skip a year!!!! 
## ****************Year= 1983 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1983
```

```
## #################### Skip a year!!!! 
## ****************Year= 1984 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1984
```

```
## #################### Skip a year!!!! 
## ****************Year= 1985 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1985
```

```
## #################### Skip a year!!!! 
## ****************Year= 1986 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1986
```

```
## #################### Skip a year!!!! 
## ****************Year= 1987 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1987
```

```
## #################### Skip a year!!!! 
## ****************Year= 1988 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1988
```

```
## #################### Skip a year!!!! 
## ****************Year= 1989 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1989
```

```
## #################### Skip a year!!!! 
## ****************Year= 1990 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1990
```

```
## #################### Skip a year!!!! 
## ****************Year= 1991 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1991
```

```
## #################### Skip a year!!!! 
## ****************Year= 1992 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1992
```

```
## #################### Skip a year!!!! 
## ****************Year= 1993 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1993
```

```
## #################### Skip a year!!!! 
## ****************Year= 1994 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1994
```

```
## #################### Skip a year!!!! 
## ****************Year= 1995 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1995
```

```
## #################### Skip a year!!!! 
## ****************Year= 1996 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1996
```

```
## #################### Skip a year!!!! 
## ****************Year= 1997 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1997
```

```
## #################### Skip a year!!!! 
## ****************Year= 1998 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1998
```

```
## #################### Skip a year!!!! 
## ****************Year= 1999 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1999
```

```
## #################### Skip a year!!!! 
## ****************Year= 2000 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2000
```

```
## #################### Skip a year!!!! 
## ****************Year= 2001 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2001
```

```
## #################### Skip a year!!!! 
## ****************Year= 2002 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2002
```

```
## #################### Skip a year!!!! 
## ****************Year= 2003 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2003
```

```
## #################### Skip a year!!!! 
## ****************Year= 2004 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2004
```

```
## #################### Skip a year!!!! 
## ****************Year= 2005 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2005
```

```
## #################### Skip a year!!!! 
## ****************Year= 2006 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2006
```

```
## #################### Skip a year!!!! 
## ****************Year= 2007 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2007
```

```
## #################### Skip a year!!!! 
## ****************Year= 2008 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2008
```

```
## #################### Skip a year!!!! 
## ****************Year= 2009 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2009
```

```
## #################### Skip a year!!!! 
## ****************Year= 2010 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2010
```

```
## #################### Skip a year!!!! 
## ****************Year= 2011 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2011
```

```
## #################### Skip a year!!!! 
## ****************Year= 2012 Observation= 109 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2012
```

```
## #################### Skip a year!!!! 
## ****************Year= 2013 Observation= 340 **********************
## ****************Year= 2014 Observation= 327 **********************
## ****************Year= 2015 Observation= 363 **********************
## 
## 'data.frame':	57 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1959 1960 1961 1962 1963 1964 1965 1966 1967 1968 ...
##  $ StartD      : num  -9999 -9999 -9999 123 138 ...
##  $ EndD        : num  4 24 44 144 207 104 124 144 164 184 ...
##  $ STDAT0      : chr  "5" "25" "45" "26-5-1962" ...
##  $ STDAT5      : chr  "6" "26" "46" "31-5-1962" ...
##  $ FDAT0       : chr  "7" "27" "47" "15-6-1962" ...
##  $ FDAT5       : chr  "8" "28" "48" "14-6-1962" ...
##  $ INTER0      : num  9 29 49 20 85 109 129 149 169 189 ...
##  $ INTER5      : num  10 30 50 17 76 110 130 150 170 190 ...
##  $ MAXT        : num  11 31 51 18.6 22.9 ...
##  $ MDAT        : chr  "12" "32" "52" "5-8-1962" ...
##  $ SUMT0       : num  13 33 53 848 798 ...
##  $ SUMT5       : num  14 34 54 774 714 ...
##  $ T220        : num  15 35 55 407 436 ...
##  $ T225        : num  16 36 56 358 401 ...
##  $ FT220       : num  17 37 57 252 345 ...
##  $ FT225       : num  18 38 58 225 312 ...
##  $ SPEEDT      : num  19 39 59 0.0824 0.2516 ...
##  $ SUMPREC     : num  20 40 60 19.3 120.7 ...
## elapsed time is 3.530000 seconds 
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/lena/24643099999 HATYAYK-HOMO.txt"
## The number of deleted rows by column precipitation= 287 
## The number of deleted rows by column temp= 0 
##      Day Month Year PRECIP  TMEAN
## 3473  26    12 2015      0 -44.06
## 3474  27    12 2015      0 -32.00
## 3475  28    12 2015      0 -40.17
## 3476  29    12 2015      0 -41.67
## 3477  30    12 2015      0 -35.44
## 3478  31    12 2015      0 -41.22
## 'data.frame':	3191 obs. of  5 variables:
##  $ Day   : int  3 4 5 8 11 12 13 14 15 17 ...
##  $ Month : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Year  : int  1959 1959 1959 1959 1959 1959 1959 1959 1959 1959 ...
##  $ PRECIP: num  0 0 0 0 0.51 0 0 0.25 0 0.76 ...
##  $ TMEAN : num  -42.9 -43.9 -42.7 -51.3 -46 ...
## NULL
##      PRECIP           TMEAN        
##  Min.   :  0.00   Min.   :-51.780  
##  1st Qu.:  0.00   1st Qu.:-27.390  
##  Median :  0.00   Median : -4.170  
##  Mean   :  2.02   Mean   : -8.341  
##  3rd Qu.:  0.25   3rd Qu.: 10.440  
##  Max.   :150.11   Max.   : 26.330  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 1959 Observation= 27 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1959
```

```
## #################### Skip a year!!!! 
## ****************Year= 1960 Observation= 8 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1960
```

```
## #################### Skip a year!!!! 
## ****************Year= 1961 Observation= 304 **********************
## ****************Year= 1962 Observation= 332 **********************
## ****************Year= 1963 Observation= 337 **********************
## ****************Year= 1964 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1964
```

```
## #################### Skip a year!!!! 
## ****************Year= 1965 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1965
```

```
## #################### Skip a year!!!! 
## ****************Year= 1966 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1966
```

```
## #################### Skip a year!!!! 
## ****************Year= 1967 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1967
```

```
## #################### Skip a year!!!! 
## ****************Year= 1968 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1968
```

```
## #################### Skip a year!!!! 
## ****************Year= 1969 Observation= 181 **********************
## ****************Year= 1970 Observation= 170 **********************
## WARNING: T2205 num_days=  172 lenYear=  170  
## WARNING: T2205 num_days=  172 lenYear=  170  
## WARNING: FT2205 num_days=  172 lenYear=  170  
## WARNING: FT2205 seasonBegin=  82 seasonEnd=  130  
## WARNING: FT2205 num_days=  172 lenYear=  170  
## WARNING: FT2205 seasonBegin=  82 seasonEnd=  130  
## ****************Year= 1971 Observation= 26 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1971
```

```
## #################### Skip a year!!!! 
## ****************Year= 1972 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1972
```

```
## #################### Skip a year!!!! 
## ****************Year= 1973 Observation= 123 **********************
## WARNING: T2205 num_days=  172 lenYear=  123  
## WARNING: T2205 num_days=  172 lenYear=  123  
## WARNING: FT2205 num_days=  172 lenYear=  123  
## WARNING: FT2205 seasonBegin=  39 seasonEnd=  109  
## WARNING: FT2205 num_days=  172 lenYear=  123  
## WARNING: FT2205 seasonBegin=  39 seasonEnd=  109  
## ****************Year= 1974 Observation= 52 **********************
## #################### Skip a year!!!! 
## ****************Year= 1975 Observation= 221 **********************
## ****************Year= 1976 Observation= 173 **********************
## ****************Year= 1977 Observation= 34 **********************
## #################### Skip a year!!!! 
## ****************Year= 1978 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1978
```

```
## #################### Skip a year!!!! 
## ****************Year= 1979 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1979
```

```
## #################### Skip a year!!!! 
## ****************Year= 1980 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1980
```

```
## #################### Skip a year!!!! 
## ****************Year= 1981 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1981
```

```
## #################### Skip a year!!!! 
## ****************Year= 1982 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1982
```

```
## #################### Skip a year!!!! 
## ****************Year= 1983 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1983
```

```
## #################### Skip a year!!!! 
## ****************Year= 1984 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1984
```

```
## #################### Skip a year!!!! 
## ****************Year= 1985 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1985
```

```
## #################### Skip a year!!!! 
## ****************Year= 1986 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1986
```

```
## #################### Skip a year!!!! 
## ****************Year= 1987 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1987
```

```
## #################### Skip a year!!!! 
## ****************Year= 1988 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1988
```

```
## #################### Skip a year!!!! 
## ****************Year= 1989 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1989
```

```
## #################### Skip a year!!!! 
## ****************Year= 1990 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1990
```

```
## #################### Skip a year!!!! 
## ****************Year= 1991 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1991
```

```
## #################### Skip a year!!!! 
## ****************Year= 1992 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1992
```

```
## #################### Skip a year!!!! 
## ****************Year= 1993 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1993
```

```
## #################### Skip a year!!!! 
## ****************Year= 1994 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1994
```

```
## #################### Skip a year!!!! 
## ****************Year= 1995 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1995
```

```
## #################### Skip a year!!!! 
## ****************Year= 1996 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1996
```

```
## #################### Skip a year!!!! 
## ****************Year= 1997 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1997
```

```
## #################### Skip a year!!!! 
## ****************Year= 1998 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1998
```

```
## #################### Skip a year!!!! 
## ****************Year= 1999 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1999
```

```
## #################### Skip a year!!!! 
## ****************Year= 2000 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2000
```

```
## #################### Skip a year!!!! 
## ****************Year= 2001 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2001
```

```
## #################### Skip a year!!!! 
## ****************Year= 2002 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2002
```

```
## #################### Skip a year!!!! 
## ****************Year= 2003 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2003
```

```
## #################### Skip a year!!!! 
## ****************Year= 2004 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2004
```

```
## #################### Skip a year!!!! 
## ****************Year= 2005 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2005
```

```
## #################### Skip a year!!!! 
## ****************Year= 2006 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2006
```

```
## #################### Skip a year!!!! 
## ****************Year= 2007 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2007
```

```
## #################### Skip a year!!!! 
## ****************Year= 2008 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2008
```

```
## #################### Skip a year!!!! 
## ****************Year= 2009 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2009
```

```
## #################### Skip a year!!!! 
## ****************Year= 2010 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2010
```

```
## #################### Skip a year!!!! 
## ****************Year= 2011 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2011
```

```
## #################### Skip a year!!!! 
## ****************Year= 2012 Observation= 123 **********************
## WARNING: T2205 num_days=  173 lenYear=  123  
## WARNING: T2205 num_days=  173 lenYear=  123  
## WARNING: FT2205 num_days=  173 lenYear=  123  
## WARNING: FT2205 seasonBegin=  1 seasonEnd=  25  
## WARNING: FT2205 num_days=  173 lenYear=  123  
## WARNING: FT2205 seasonBegin=  1 seasonEnd=  25  
## ****************Year= 2013 Observation= 352 **********************
## ****************Year= 2014 Observation= 364 **********************
## ****************Year= 2015 Observation= 364 **********************
## 
## 'data.frame':	57 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1959 1960 1961 1962 1963 1964 1965 1966 1967 1968 ...
##  $ StartD      : num  -9999 -9999 104 130 128 ...
##  $ EndD        : num  4 24 221 249 242 104 124 144 164 184 ...
##  $ STDAT0      : chr  "5" "25" "27-5-1961" "23-5-1962" ...
##  $ STDAT5      : chr  "6" "26" "28-5-1961" "29-5-1962" ...
##  $ FDAT0       : chr  "7" "27" "28-9-1961" "16-9-1962" ...
##  $ FDAT5       : chr  "8" "28" "22-9-1961" "13-9-1962" ...
##  $ INTER0      : num  9 29 124 116 115 109 129 149 169 189 ...
##  $ INTER5      : num  10 30 118 110 107 110 130 150 170 190 ...
##  $ MAXT        : num  11 31 24.6 24.3 23.2 ...
##  $ MDAT        : chr  "12" "32" "1-8-1961" "1-8-1962" ...
##  $ SUMT0       : num  13 33 1598 1585 1512 ...
##  $ SUMT5       : num  14 34 1510 1513 1452 ...
##  $ T220        : num  15 35 1146 545 563 ...
##  $ T225        : num  16 36 1094 491 528 ...
##  $ FT220       : num  17 37 455 1049 921 ...
##  $ FT225       : num  18 38 424 1037 914 ...
##  $ SPEEDT      : num  19 39 0.15 0.214 0.182 ...
##  $ SUMPREC     : num  20 40 630 213 322 ...
## elapsed time is 6.880000 seconds 
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/lena/24652099999 SANGARY.txt"
## The number of deleted rows by column precipitation= 413 
## The number of deleted rows by column temp= 0 
##       Day Month Year PRECIP  TMEAN
## 17346  26    12 2015   0.25 -44.11
## 17347  27    12 2015   0.00 -41.61
## 17348  28    12 2015   0.00 -41.67
## 17349  29    12 2015   0.00 -40.17
## 17350  30    12 2015   0.00 -39.72
## 17351  31    12 2015   0.00 -41.17
## 'data.frame':	16938 obs. of  5 variables:
##  $ Day   : int  10 9 12 17 2 13 17 7 23 13 ...
##  $ Month : int  1 3 3 3 4 4 4 6 6 7 ...
##  $ Year  : int  1948 1948 1948 1948 1948 1948 1948 1948 1948 1948 ...
##  $ PRECIP: num  0 0 0 0.51 0.25 0 0 0 2.03 0 ...
##  $ TMEAN : num  -33.06 -12.61 -23.89 -15.72 -5.28 ...
## NULL
##      PRECIP            TMEAN        
##  Min.   :  0.000   Min.   :-54.500  
##  1st Qu.:  0.000   1st Qu.:-29.280  
##  Median :  0.000   Median : -6.440  
##  Mean   :  1.135   Mean   : -9.226  
##  3rd Qu.:  0.510   3rd Qu.: 10.330  
##  Max.   :150.110   Max.   : 26.610  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 1948 Observation= 15 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1948
```

```
## #################### Skip a year!!!! 
## ****************Year= 1949 Observation= 132 **********************
## WARNING: T2205 num_days=  172 lenYear=  132  
## WARNING: T2205 num_days=  172 lenYear=  132  
## WARNING: FT2205 num_days=  172 lenYear=  132  
## WARNING: FT2205 seasonBegin=  41 seasonEnd=  106  
## WARNING: FT2205 num_days=  172 lenYear=  132  
## WARNING: FT2205 seasonBegin=  41 seasonEnd=  106  
## ****************Year= 1950 Observation= 227 **********************
## ****************Year= 1951 Observation= 56 **********************
## #################### Skip a year!!!! 
## ****************Year= 1952 Observation= 147 **********************
## WARNING: T2205 num_days=  173 lenYear=  147  
## WARNING: T2205 num_days=  173 lenYear=  147  
## WARNING: FT2205 num_days=  173 lenYear=  147  
## WARNING: FT2205 seasonBegin=  12 seasonEnd=  85  
## WARNING: FT2205 num_days=  173 lenYear=  147  
## WARNING: FT2205 seasonBegin=  12 seasonEnd=  85  
## ****************Year= 1953 Observation= 38 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1953
```

```
## #################### Skip a year!!!! 
## ****************Year= 1954 Observation= 97 **********************
## WARNING: T2205 num_days=  172 lenYear=  97  
## WARNING: T2205 num_days=  172 lenYear=  97  
## WARNING: FT2205 num_days=  172 lenYear=  97  
## WARNING: FT2205 seasonBegin=  32 seasonEnd=  86  
## WARNING: FT2205 num_days=  172 lenYear=  97  
## WARNING: FT2205 seasonBegin=  32 seasonEnd=  86  
## ****************Year= 1955 Observation= 133 **********************
## WARNING: T2205 num_days=  172 lenYear=  133  
## WARNING: T2205 num_days=  172 lenYear=  133  
## WARNING: FT2205 num_days=  172 lenYear=  133  
## WARNING: FT2205 seasonBegin=  54 seasonEnd=  106  
## WARNING: FT2205 num_days=  172 lenYear=  133  
## WARNING: FT2205 seasonBegin=  54 seasonEnd=  106  
## ****************Year= 1956 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1956
```

```
## #################### Skip a year!!!! 
## ****************Year= 1957 Observation= 27 **********************
## #################### Skip a year!!!! 
## ****************Year= 1958 Observation= 36 **********************
## #################### Skip a year!!!! 
## ****************Year= 1959 Observation= 55 **********************
## #################### Skip a year!!!! 
## ****************Year= 1960 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1960
```

```
## #################### Skip a year!!!! 
## ****************Year= 1961 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1961
```

```
## #################### Skip a year!!!! 
## ****************Year= 1962 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1962
```

```
## #################### Skip a year!!!! 
## ****************Year= 1963 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1963
```

```
## #################### Skip a year!!!! 
## ****************Year= 1964 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1964
```

```
## #################### Skip a year!!!! 
## ****************Year= 1965 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1965
```

```
## #################### Skip a year!!!! 
## ****************Year= 1966 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1966
```

```
## #################### Skip a year!!!! 
## ****************Year= 1967 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1967
```

```
## #################### Skip a year!!!! 
## ****************Year= 1968 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1968
```

```
## #################### Skip a year!!!! 
## ****************Year= 1969 Observation= 329 **********************
## ****************Year= 1970 Observation= 320 **********************
## ****************Year= 1971 Observation= 148 **********************
## WARNING: T2205 num_days=  172 lenYear=  148  
## WARNING: T2205 num_days=  172 lenYear=  148  
## WARNING: FT2205 num_days=  172 lenYear=  148  
## WARNING: FT2205 seasonBegin=  118 seasonEnd=  148  
## WARNING: FT2205 num_days=  172 lenYear=  148  
## WARNING: FT2205 seasonBegin=  118 seasonEnd=  148  
## ****************Year= 1972 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1972
```

```
## #################### Skip a year!!!! 
## ****************Year= 1973 Observation= 350 **********************
## ****************Year= 1974 Observation= 336 **********************
## ****************Year= 1975 Observation= 362 **********************
## ****************Year= 1976 Observation= 352 **********************
## ****************Year= 1977 Observation= 352 **********************
## ****************Year= 1978 Observation= 364 **********************
## ****************Year= 1979 Observation= 363 **********************
## ****************Year= 1980 Observation= 361 **********************
## ****************Year= 1981 Observation= 360 **********************
## ****************Year= 1982 Observation= 361 **********************
## ****************Year= 1983 Observation= 361 **********************
## ****************Year= 1984 Observation= 361 **********************
## ****************Year= 1985 Observation= 365 **********************
## ****************Year= 1986 Observation= 361 **********************
## ****************Year= 1987 Observation= 363 **********************
## ****************Year= 1988 Observation= 356 **********************
## ****************Year= 1989 Observation= 361 **********************
## ****************Year= 1990 Observation= 364 **********************
## ****************Year= 1991 Observation= 360 **********************
## ****************Year= 1992 Observation= 364 **********************
## ****************Year= 1993 Observation= 363 **********************
## ****************Year= 1994 Observation= 364 **********************
## ****************Year= 1995 Observation= 365 **********************
## ****************Year= 1996 Observation= 363 **********************
## ****************Year= 1997 Observation= 365 **********************
## ****************Year= 1998 Observation= 354 **********************
## ****************Year= 1999 Observation= 362 **********************
## ****************Year= 2000 Observation= 210 **********************
## ****************Year= 2001 Observation= 306 **********************
## ****************Year= 2002 Observation= 354 **********************
## ****************Year= 2003 Observation= 362 **********************
## ****************Year= 2004 Observation= 366 **********************
## ****************Year= 2005 Observation= 360 **********************
## ****************Year= 2006 Observation= 337 **********************
## ****************Year= 2007 Observation= 347 **********************
## ****************Year= 2008 Observation= 346 **********************
## ****************Year= 2009 Observation= 348 **********************
## ****************Year= 2010 Observation= 345 **********************
## ****************Year= 2011 Observation= 341 **********************
## ****************Year= 2012 Observation= 350 **********************
## ****************Year= 2013 Observation= 364 **********************
## ****************Year= 2014 Observation= 364 **********************
## ****************Year= 2015 Observation= 365 **********************
## 
## 'data.frame':	68 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1948 1949 1950 1951 1952 1953 1954 1955 1956 1957 ...
##  $ StartD      : num  -9999 41 113 -9999 12 ...
##  $ EndD        : num  4 106 193 64 85 104 86 106 164 184 ...
##  $ STDAT0      : chr  "5" "10-5-1949" "26-5-1950" "65" ...
##  $ STDAT5      : chr  "6" "21-5-1949" "30-5-1950" "66" ...
##  $ FDAT0       : chr  "7" "12-10-1949" "16-9-1950" "67" ...
##  $ FDAT5       : chr  "8" "25-9-1949" "8-9-1950" "68" ...
##  $ INTER0      : num  9 155 113 69 130 109 118 122 169 189 ...
##  $ INTER5      : num  10 134 102 70 122 110 91 111 170 190 ...
##  $ MAXT        : num  11 25.6 24.9 71 25.6 ...
##  $ MDAT        : chr  "12" "11-8-1949" "24-6-1950" "72" ...
##  $ SUMT0       : num  13 819 1115 73 888 ...
##  $ SUMT5       : num  14 799 1016 74 868 ...
##  $ T220        : num  15 819 913 75 888 ...
##  $ T225        : num  16 799 846 76 868 ...
##  $ FT220       : num  17 819 186 77 888 ...
##  $ FT225       : num  18 799 172 78 868 ...
##  $ SPEEDT      : num  19 -0.6859 0.0875 79 -0.539 ...
##  $ SUMPREC     : num  20 66.3 79.3 80 41.9 ...
## elapsed time is 33.630000 seconds 
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/lena/24668099999 VERHOJANSK PEREVOZ.txt"
## The number of deleted rows by column precipitation= 133 
## The number of deleted rows by column temp= 0 
##      Day Month Year PRECIP  TMEAN
## 9407  26    12 2015      0 -48.61
## 9408  27    12 2015      0 -46.00
## 9409  28    12 2015      0 -41.33
## 9410  29    12 2015      0 -41.72
## 9411  30    12 2015      0 -43.78
## 9412  31    12 2015      0 -42.72
## 'data.frame':	9279 obs. of  5 variables:
##  $ Day   : int  2 3 6 8 11 17 18 19 22 24 ...
##  $ Month : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Year  : int  1959 1959 1959 1959 1959 1959 1959 1959 1959 1959 ...
##  $ PRECIP: num  0 0 0 0 0 0 0 0 0 0 ...
##  $ TMEAN : num  -44.6 -42.4 -50.4 -53.6 -44.2 ...
## NULL
##      PRECIP            TMEAN       
##  Min.   :  0.000   Min.   :-58.94  
##  1st Qu.:  0.000   1st Qu.:-33.11  
##  Median :  0.000   Median : -7.00  
##  Mean   :  1.065   Mean   :-11.36  
##  3rd Qu.:  0.250   3rd Qu.: 10.00  
##  Max.   :150.110   Max.   : 26.44  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 1959 Observation= 33 **********************
## #################### Skip a year!!!! 
## ****************Year= 1960 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1960
```

```
## #################### Skip a year!!!! 
## ****************Year= 1961 Observation= 345 **********************
## ****************Year= 1962 Observation= 335 **********************
## ****************Year= 1963 Observation= 342 **********************
## ****************Year= 1964 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1964
```

```
## #################### Skip a year!!!! 
## ****************Year= 1965 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1965
```

```
## #################### Skip a year!!!! 
## ****************Year= 1966 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1966
```

```
## #################### Skip a year!!!! 
## ****************Year= 1967 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1967
```

```
## #################### Skip a year!!!! 
## ****************Year= 1968 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1968
```

```
## #################### Skip a year!!!! 
## ****************Year= 1969 Observation= 352 **********************
## ****************Year= 1970 Observation= 357 **********************
## ****************Year= 1971 Observation= 166 **********************
## WARNING: T2205 num_days=  172 lenYear=  166  
## WARNING: T2205 num_days=  172 lenYear=  166  
## WARNING: FT2205 num_days=  172 lenYear=  166  
## WARNING: FT2205 seasonBegin=  123 seasonEnd=  166  
## WARNING: FT2205 num_days=  172 lenYear=  166  
## WARNING: FT2205 seasonBegin=  123 seasonEnd=  166  
## ****************Year= 1972 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1972
```

```
## #################### Skip a year!!!! 
## ****************Year= 1973 Observation= 347 **********************
## ****************Year= 1974 Observation= 318 **********************
## ****************Year= 1975 Observation= 355 **********************
## ****************Year= 1976 Observation= 338 **********************
## ****************Year= 1977 Observation= 267 **********************
## ****************Year= 1978 Observation= 329 **********************
## ****************Year= 1979 Observation= 359 **********************
## ****************Year= 1980 Observation= 364 **********************
## ****************Year= 1981 Observation= 361 **********************
## ****************Year= 1982 Observation= 63 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1982
```

```
## #################### Skip a year!!!! 
## ****************Year= 1983 Observation= 273 **********************
## ****************Year= 1984 Observation= 360 **********************
## ****************Year= 1985 Observation= 364 **********************
## ****************Year= 1986 Observation= 365 **********************
## ****************Year= 1987 Observation= 363 **********************
## ****************Year= 1988 Observation= 363 **********************
## ****************Year= 1989 Observation= 363 **********************
## ****************Year= 1990 Observation= 360 **********************
## ****************Year= 1991 Observation= 224 **********************
## ****************Year= 1992 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1992
```

```
## #################### Skip a year!!!! 
## ****************Year= 1993 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1993
```

```
## #################### Skip a year!!!! 
## ****************Year= 1994 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1994
```

```
## #################### Skip a year!!!! 
## ****************Year= 1995 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1995
```

```
## #################### Skip a year!!!! 
## ****************Year= 1996 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1996
```

```
## #################### Skip a year!!!! 
## ****************Year= 1997 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1997
```

```
## #################### Skip a year!!!! 
## ****************Year= 1998 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1998
```

```
## #################### Skip a year!!!! 
## ****************Year= 1999 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1999
```

```
## #################### Skip a year!!!! 
## ****************Year= 2000 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2000
```

```
## #################### Skip a year!!!! 
## ****************Year= 2001 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2001
```

```
## #################### Skip a year!!!! 
## ****************Year= 2002 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2002
```

```
## #################### Skip a year!!!! 
## ****************Year= 2003 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2003
```

```
## #################### Skip a year!!!! 
## ****************Year= 2004 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2004
```

```
## #################### Skip a year!!!! 
## ****************Year= 2005 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2005
```

```
## #################### Skip a year!!!! 
## ****************Year= 2006 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2006
```

```
## #################### Skip a year!!!! 
## ****************Year= 2007 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2007
```

```
## #################### Skip a year!!!! 
## ****************Year= 2008 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2008
```

```
## #################### Skip a year!!!! 
## ****************Year= 2009 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2009
```

```
## #################### Skip a year!!!! 
## ****************Year= 2010 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2010
```

```
## #################### Skip a year!!!! 
## ****************Year= 2011 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2011
```

```
## #################### Skip a year!!!! 
## ****************Year= 2012 Observation= 123 **********************
## WARNING: T2205 num_days=  173 lenYear=  123  
## WARNING: T2205 num_days=  173 lenYear=  123  
## WARNING: FT2205 num_days=  173 lenYear=  123  
## WARNING: FT2205 seasonBegin=  1 seasonEnd=  25  
## WARNING: FT2205 num_days=  173 lenYear=  123  
## WARNING: FT2205 seasonBegin=  1 seasonEnd=  25  
## ****************Year= 2013 Observation= 364 **********************
## ****************Year= 2014 Observation= 361 **********************
## ****************Year= 2015 Observation= 365 **********************
## 
## 'data.frame':	57 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1959 1960 1961 1962 1963 1964 1965 1966 1967 1968 ...
##  $ StartD      : num  -9999 -9999 137 129 130 ...
##  $ EndD        : num  4 24 260 249 243 104 124 144 164 184 ...
##  $ STDAT0      : chr  "5" "25" "27-5-1961" "23-5-1962" ...
##  $ STDAT5      : chr  "6" "26" "28-5-1961" "29-5-1962" ...
##  $ FDAT0       : chr  "7" "27" "28-9-1961" "22-9-1962" ...
##  $ FDAT5       : chr  "8" "28" "26-9-1961" "16-9-1962" ...
##  $ INTER0      : num  9 29 124 122 115 109 129 149 169 189 ...
##  $ INTER5      : num  10 30 122 115 111 110 130 150 170 190 ...
##  $ MAXT        : num  11 31 24.7 24.4 23.2 ...
##  $ MDAT        : chr  "12" "32" "31-7-1961" "24-7-1962" ...
##  $ SUMT0       : num  13 33 1782 1689 1613 ...
##  $ SUMT5       : num  14 34 1732 1622 1528 ...
##  $ T220        : num  15 35 618 619 642 ...
##  $ T225        : num  16 36 595 558 592 ...
##  $ FT220       : num  17 37 1177 1083 946 ...
##  $ FT225       : num  18 38 1158 1077 932 ...
##  $ SPEEDT      : num  19 39 0.33 0.197 0.25 ...
##  $ SUMPREC     : num  20 40 355 422 411 ...
## elapsed time is 18.290000 seconds 
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/lena/24768099999 CURAPCA.txt"
## The number of deleted rows by column precipitation= 530 
## The number of deleted rows by column temp= 0 
##       Day Month Year PRECIP TMEAN
## 21035  26     6 2016   3.05 13.11
## 21036  27     6 2016   0.00 15.33
## 21037  28     6 2016   2.03 12.39
## 21038  29     6 2016   0.00 18.33
## 21039  30     6 2016   0.00 22.33
## 21040   1     7 2016   0.00 24.83
## 'data.frame':	20510 obs. of  5 variables:
##  $ Day   : int  2 3 5 6 8 9 10 12 13 14 ...
##  $ Month : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Year  : int  1948 1948 1948 1948 1948 1948 1948 1948 1948 1948 ...
##  $ PRECIP: num  2.03 0.51 0.25 0.51 0 0 0.51 0 0 0 ...
##  $ TMEAN : num  -28.4 -24.3 -36.4 -38.1 -46.1 ...
## NULL
##      PRECIP             TMEAN       
##  Min.   :  0.0000   Min.   :-60.28  
##  1st Qu.:  0.0000   1st Qu.:-32.50  
##  Median :  0.0000   Median : -6.00  
##  Mean   :  0.9418   Mean   :-10.44  
##  3rd Qu.:  0.2500   3rd Qu.: 10.56  
##  Max.   :184.9100   Max.   : 26.61  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 1948 Observation= 206 **********************
## ****************Year= 1949 Observation= 337 **********************
## ****************Year= 1950 Observation= 329 **********************
## ****************Year= 1951 Observation= 264 **********************
## ****************Year= 1952 Observation= 318 **********************
## ****************Year= 1953 Observation= 127 **********************
## WARNING: T2205 num_days=  172 lenYear=  127  
## WARNING: T2205 num_days=  172 lenYear=  127  
## WARNING: FT2205 num_days=  172 lenYear=  127  
## WARNING: FT2205 seasonBegin=  58 seasonEnd=  104  
## WARNING: FT2205 num_days=  172 lenYear=  127  
## WARNING: FT2205 seasonBegin=  58 seasonEnd=  104  
## ****************Year= 1954 Observation= 127 **********************
## WARNING: T2205 num_days=  172 lenYear=  127  
## WARNING: T2205 num_days=  172 lenYear=  127  
## WARNING: FT2205 num_days=  172 lenYear=  127  
## WARNING: FT2205 seasonBegin=  40 seasonEnd=  98  
## WARNING: FT2205 num_days=  172 lenYear=  127  
## WARNING: FT2205 seasonBegin=  40 seasonEnd=  98  
## ****************Year= 1955 Observation= 259 **********************
## ****************Year= 1956 Observation= 277 **********************
## ****************Year= 1957 Observation= 279 **********************
## ****************Year= 1958 Observation= 234 **********************
## ****************Year= 1959 Observation= 142 **********************
## WARNING: T2205 num_days=  172 lenYear=  142  
## WARNING: T2205 num_days=  172 lenYear=  142  
## WARNING: FT2205 num_days=  172 lenYear=  142  
## WARNING: FT2205 seasonBegin=  54 seasonEnd=  138  
## WARNING: FT2205 num_days=  172 lenYear=  142  
## WARNING: FT2205 seasonBegin=  54 seasonEnd=  138  
## ****************Year= 1960 Observation= 327 **********************
## ****************Year= 1961 Observation= 358 **********************
## ****************Year= 1962 Observation= 351 **********************
## ****************Year= 1963 Observation= 343 **********************
## ****************Year= 1964 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1964
```

```
## #################### Skip a year!!!! 
## ****************Year= 1965 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1965
```

```
## #################### Skip a year!!!! 
## ****************Year= 1966 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1966
```

```
## #################### Skip a year!!!! 
## ****************Year= 1967 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1967
```

```
## #################### Skip a year!!!! 
## ****************Year= 1968 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1968
```

```
## #################### Skip a year!!!! 
## ****************Year= 1969 Observation= 348 **********************
## ****************Year= 1970 Observation= 357 **********************
## ****************Year= 1971 Observation= 179 **********************
## ****************Year= 1972 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1972
```

```
## #################### Skip a year!!!! 
## ****************Year= 1973 Observation= 345 **********************
## ****************Year= 1974 Observation= 336 **********************
## ****************Year= 1975 Observation= 359 **********************
## ****************Year= 1976 Observation= 364 **********************
## ****************Year= 1977 Observation= 360 **********************
## ****************Year= 1978 Observation= 355 **********************
## ****************Year= 1979 Observation= 364 **********************
## ****************Year= 1980 Observation= 365 **********************
## ****************Year= 1981 Observation= 363 **********************
## ****************Year= 1982 Observation= 364 **********************
## ****************Year= 1983 Observation= 364 **********************
## ****************Year= 1984 Observation= 366 **********************
## ****************Year= 1985 Observation= 365 **********************
## ****************Year= 1986 Observation= 364 **********************
## ****************Year= 1987 Observation= 364 **********************
## ****************Year= 1988 Observation= 361 **********************
## ****************Year= 1989 Observation= 365 **********************
## ****************Year= 1990 Observation= 365 **********************
## ****************Year= 1991 Observation= 364 **********************
## ****************Year= 1992 Observation= 365 **********************
## ****************Year= 1993 Observation= 364 **********************
## ****************Year= 1994 Observation= 364 **********************
## ****************Year= 1995 Observation= 364 **********************
## ****************Year= 1996 Observation= 365 **********************
## ****************Year= 1997 Observation= 365 **********************
## ****************Year= 1998 Observation= 361 **********************
## ****************Year= 1999 Observation= 364 **********************
## ****************Year= 2000 Observation= 175 **********************
## ****************Year= 2001 Observation= 312 **********************
## ****************Year= 2002 Observation= 353 **********************
## ****************Year= 2003 Observation= 364 **********************
## ****************Year= 2004 Observation= 365 **********************
## ****************Year= 2005 Observation= 349 **********************
## ****************Year= 2006 Observation= 338 **********************
## ****************Year= 2007 Observation= 338 **********************
## ****************Year= 2008 Observation= 340 **********************
## ****************Year= 2009 Observation= 334 **********************
## ****************Year= 2010 Observation= 339 **********************
## ****************Year= 2011 Observation= 341 **********************
## ****************Year= 2012 Observation= 359 **********************
## ****************Year= 2013 Observation= 364 **********************
## ****************Year= 2014 Observation= 364 **********************
## ****************Year= 2015 Observation= 365 **********************
## ****************Year= 2016 Observation= 183 **********************
## 
## 'data.frame':	69 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1948 1949 1950 1951 1952 1953 1954 1955 1956 1957 ...
##  $ StartD      : num  82 124 133 115 122 58 40 91 109 102 ...
##  $ EndD        : num  155 254 235 197 228 104 98 184 204 192 ...
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
## elapsed time is 41.760000 seconds 
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/lena/24859099999 BROLOGYAKHATAT.txt"
## The number of deleted rows by column precipitation= 394 
## The number of deleted rows by column temp= 0 
##      Day Month Year PRECIP TMEAN
## 5186  27     5 1988   0.00 13.22
## 5187  28     5 1988   0.00 12.39
## 5188  29     5 1988   4.06 13.11
## 5189  30     5 1988   0.00 11.44
## 5190  31     5 1988   0.00 15.50
## 5191   1     6 1988   0.00 12.89
## 'data.frame':	4797 obs. of  5 variables:
##  $ Day   : int  1 2 3 4 5 6 8 9 12 18 ...
##  $ Month : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Year  : int  1959 1959 1959 1959 1959 1959 1959 1959 1959 1959 ...
##  $ PRECIP: num  0 0.25 2.03 0.51 1.52 0.51 0 0 0 2.03 ...
##  $ TMEAN : num  -41.1 -39.3 -35.7 -35.4 -40.7 ...
## NULL
##      PRECIP             TMEAN        
##  Min.   :  0.0000   Min.   :-57.780  
##  1st Qu.:  0.0000   1st Qu.:-29.940  
##  Median :  0.0000   Median : -5.830  
##  Mean   :  0.9752   Mean   : -9.914  
##  3rd Qu.:  0.2500   3rd Qu.:  9.780  
##  Max.   :150.1100   Max.   : 26.440  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 1959 Observation= 26 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1959
```

```
## #################### Skip a year!!!! 
## ****************Year= 1960 Observation= 3 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1960
```

```
## #################### Skip a year!!!! 
## ****************Year= 1961 Observation= 1 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1961
```

```
## #################### Skip a year!!!! 
## ****************Year= 1962 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1962
```

```
## #################### Skip a year!!!! 
## ****************Year= 1963 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1963
```

```
## #################### Skip a year!!!! 
## ****************Year= 1964 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1964
```

```
## #################### Skip a year!!!! 
## ****************Year= 1965 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1965
```

```
## #################### Skip a year!!!! 
## ****************Year= 1966 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1966
```

```
## #################### Skip a year!!!! 
## ****************Year= 1967 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1967
```

```
## #################### Skip a year!!!! 
## ****************Year= 1968 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1968
```

```
## #################### Skip a year!!!! 
## ****************Year= 1969 Observation= 186 **********************
## ****************Year= 1970 Observation= 177 **********************
## ****************Year= 1971 Observation= 36 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1971
```

```
## #################### Skip a year!!!! 
## ****************Year= 1972 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1972
```

```
## #################### Skip a year!!!! 
## ****************Year= 1973 Observation= 122 **********************
## WARNING: T2205 num_days=  172 lenYear=  122  
## WARNING: T2205 num_days=  172 lenYear=  122  
## WARNING: FT2205 num_days=  172 lenYear=  122  
## WARNING: FT2205 seasonBegin=  38 seasonEnd=  104  
## WARNING: FT2205 num_days=  172 lenYear=  122  
## WARNING: FT2205 seasonBegin=  38 seasonEnd=  104  
## ****************Year= 1974 Observation= 167 **********************
## WARNING: T2205 num_days=  172 lenYear=  167  
## WARNING: T2205 num_days=  172 lenYear=  167  
## WARNING: FT2205 num_days=  172 lenYear=  167  
## WARNING: FT2205 seasonBegin=  73 seasonEnd=  139  
## WARNING: FT2205 num_days=  172 lenYear=  167  
## WARNING: FT2205 seasonBegin=  73 seasonEnd=  139  
## ****************Year= 1975 Observation= 256 **********************
## ****************Year= 1976 Observation= 279 **********************
## ****************Year= 1977 Observation= 202 **********************
## ****************Year= 1978 Observation= 335 **********************
## ****************Year= 1979 Observation= 361 **********************
## ****************Year= 1980 Observation= 360 **********************
## ****************Year= 1981 Observation= 355 **********************
## ****************Year= 1982 Observation= 62 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1982
```

```
## #################### Skip a year!!!! 
## ****************Year= 1983 Observation= 282 **********************
## ****************Year= 1984 Observation= 355 **********************
## ****************Year= 1985 Observation= 359 **********************
## ****************Year= 1986 Observation= 362 **********************
## ****************Year= 1987 Observation= 359 **********************
## ****************Year= 1988 Observation= 152 **********************
## WARNING: T2205 num_days=  173 lenYear=  152  
## WARNING: T2205 num_days=  173 lenYear=  152  
## WARNING: FT2205 num_days=  173 lenYear=  152  
## WARNING: FT2205 seasonBegin=  134 seasonEnd=  152  
## WARNING: FT2205 num_days=  173 lenYear=  152  
## WARNING: FT2205 seasonBegin=  134 seasonEnd=  152  
## 
## 'data.frame':	30 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1959 1960 1961 1962 1963 1964 1965 1966 1967 1968 ...
##  $ StartD      : num  -9999 -9999 -9999 -9999 -9999 ...
##  $ EndD        : num  4 24 44 64 84 104 124 144 164 184 ...
##  $ STDAT0      : chr  "5" "25" "45" "65" ...
##  $ STDAT5      : chr  "6" "26" "46" "66" ...
##  $ FDAT0       : chr  "7" "27" "47" "67" ...
##  $ FDAT5       : chr  "8" "28" "48" "68" ...
##  $ INTER0      : num  9 29 49 69 89 109 129 149 169 189 ...
##  $ INTER5      : num  10 30 50 70 90 110 130 150 170 190 ...
##  $ MAXT        : num  11 31 51 71 91 111 131 151 171 191 ...
##  $ MDAT        : chr  "12" "32" "52" "72" ...
##  $ SUMT0       : num  13 33 53 73 93 113 133 153 173 193 ...
##  $ SUMT5       : num  14 34 54 74 94 114 134 154 174 194 ...
##  $ T220        : num  15 35 55 75 95 115 135 155 175 195 ...
##  $ T225        : num  16 36 56 76 96 116 136 156 176 196 ...
##  $ FT220       : num  17 37 57 77 97 117 137 157 177 197 ...
##  $ FT225       : num  18 38 58 78 98 118 138 158 178 198 ...
##  $ SPEEDT      : num  19 39 59 79 99 119 139 159 179 199 ...
##  $ SUMPREC     : num  20 40 60 80 100 120 140 160 180 200 ...
## elapsed time is 9.750000 seconds
```

```r
par.north <- cli2par(paste0(mm_path, "/cli/north/"), north.files, info = TRUE)
```

```
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/north/20973099999 KRESTI.txt"
## The number of deleted rows by column precipitation= 751 
## The number of deleted rows by column temp= 151 
##       Day Month Year PRECIP  TMEAN
## 10340  28     2 2001   0.00 -49.00
## 10341   6     3 2001   0.00 -37.56
## 10342  15     3 2001   0.00 -36.33
## 10343  16     3 2001   0.00 -38.00
## 10346  25     4 2001   0.00 -25.22
## 10347  27     4 2001   0.76 -19.39
## 'data.frame':	9445 obs. of  5 variables:
##  $ Day   : int  16 18 19 21 23 24 1 3 10 23 ...
##  $ Month : int  4 4 4 4 4 4 5 5 5 5 ...
##  $ Year  : int  1955 1955 1955 1955 1955 1955 1955 1955 1955 1955 ...
##  $ PRECIP: num  1.52 0.76 1.02 4.06 1.52 1.02 0.25 0 0.51 0.51 ...
##  $ TMEAN : num  -5.28 -1.67 -6 -1 -14.28 ...
## NULL
##      PRECIP            TMEAN       
##  Min.   :  0.000   Min.   :-55.06  
##  1st Qu.:  0.000   1st Qu.:-29.00  
##  Median :  0.000   Median :-14.61  
##  Mean   :  3.174   Mean   :-15.10  
##  3rd Qu.:  1.020   3rd Qu.:  0.39  
##  Max.   :150.110   Max.   : 18.50  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 1955 Observation= 72 **********************
## WARNING: T2205 num_days=  172 lenYear=  72  
## WARNING: T2205 num_days=  172 lenYear=  72  
## WARNING: FT2205 num_days=  172 lenYear=  72  
## WARNING: FT2205 seasonBegin=  14 seasonEnd=  38  
## WARNING: FT2205 num_days=  172 lenYear=  72  
## WARNING: FT2205 seasonBegin=  14 seasonEnd=  38  
## ****************Year= 1956 Observation= 129 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1956
```

```
## #################### Skip a year!!!! 
## ****************Year= 1957 Observation= 44 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1957
```

```
## #################### Skip a year!!!! 
## ****************Year= 1958 Observation= 128 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1958
```

```
## #################### Skip a year!!!! 
## ****************Year= 1959 Observation= 124 **********************
## WARNING: T2205 num_days=  172 lenYear=  124  
## WARNING: T2205 num_days=  172 lenYear=  124  
## WARNING: FT2205 num_days=  172 lenYear=  124  
## WARNING: FT2205 seasonBegin=  34 seasonEnd=  57  
## WARNING: FT2205 num_days=  172 lenYear=  124  
## WARNING: FT2205 seasonBegin=  34 seasonEnd=  57  
## ****************Year= 1960 Observation= 208 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1960
```

```
## #################### Skip a year!!!! 
## ****************Year= 1961 Observation= 283 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1961
```

```
## #################### Skip a year!!!! 
## ****************Year= 1962 Observation= 260 **********************
## ****************Year= 1963 Observation= 274 **********************
## ****************Year= 1964 Observation= 279 **********************
## ****************Year= 1965 Observation= 257 **********************
## ****************Year= 1966 Observation= 339 **********************
## ****************Year= 1967 Observation= 330 **********************
## ****************Year= 1968 Observation= 315 **********************
## ****************Year= 1969 Observation= 331 **********************
## ****************Year= 1970 Observation= 331 **********************
## ****************Year= 1971 Observation= 167 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1971
```

```
## #################### Skip a year!!!! 
## ****************Year= 1972 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1972
```

```
## #################### Skip a year!!!! 
## ****************Year= 1973 Observation= 281 **********************
## ****************Year= 1974 Observation= 167 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1974
```

```
## #################### Skip a year!!!! 
## ****************Year= 1975 Observation= 342 **********************
## ****************Year= 1976 Observation= 308 **********************
## ****************Year= 1977 Observation= 319 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1977
```

```
## #################### Skip a year!!!! 
## ****************Year= 1978 Observation= 218 **********************
## ****************Year= 1979 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1979
```

```
## #################### Skip a year!!!! 
## ****************Year= 1980 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1980
```

```
## #################### Skip a year!!!! 
## ****************Year= 1981 Observation= 307 **********************
## ****************Year= 1982 Observation= 265 **********************
## ****************Year= 1983 Observation= 284 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1983
```

```
## #################### Skip a year!!!! 
## ****************Year= 1984 Observation= 278 **********************
## ****************Year= 1985 Observation= 346 **********************
## ****************Year= 1986 Observation= 340 **********************
## ****************Year= 1987 Observation= 355 **********************
## ****************Year= 1988 Observation= 361 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1988
```

```
## #################### Skip a year!!!! 
## ****************Year= 1989 Observation= 359 **********************
## ****************Year= 1990 Observation= 358 **********************
## ****************Year= 1991 Observation= 282 **********************
## ****************Year= 1992 Observation= 141 **********************
## WARNING: T2205 num_days=  173 lenYear=  141  
## WARNING: T2205 num_days=  173 lenYear=  141  
## WARNING: FT2205 num_days=  173 lenYear=  141  
## WARNING: FT2205 seasonBegin=  62 seasonEnd=  88  
## WARNING: FT2205 num_days=  173 lenYear=  141  
## WARNING: FT2205 seasonBegin=  62 seasonEnd=  88  
## ****************Year= 1993 Observation= 168 **********************
## WARNING: T2205 num_days=  172 lenYear=  168  
## WARNING: T2205 num_days=  172 lenYear=  168  
## WARNING: FT2205 num_days=  172 lenYear=  168  
## WARNING: FT2205 seasonBegin=  122 seasonEnd=  139  
## WARNING: FT2205 num_days=  172 lenYear=  168  
## WARNING: FT2205 seasonBegin=  122 seasonEnd=  139  
## ****************Year= 1994 Observation= 50 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1994
```

```
## #################### Skip a year!!!! 
## ****************Year= 1995 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1995
```

```
## #################### Skip a year!!!! 
## ****************Year= 1996 Observation= 12 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1996
```

```
## #################### Skip a year!!!! 
## ****************Year= 1997 Observation= 23 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1997
```

```
## #################### Skip a year!!!! 
## ****************Year= 1998 Observation= 1 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1998
```

```
## #################### Skip a year!!!! 
## ****************Year= 1999 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1999
```

```
## #################### Skip a year!!!! 
## ****************Year= 2000 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2000
```

```
## #################### Skip a year!!!! 
## ****************Year= 2001 Observation= 9 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2001
```

```
## #################### Skip a year!!!! 
## 
## 'data.frame':	47 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1955 1956 1957 1958 1959 1960 1961 1962 1963 1964 ...
##  $ StartD      : num  14 -9999 -9999 -9999 34 ...
##  $ EndD        : num  38 24 44 64 57 104 124 159 200 193 ...
##  $ STDAT0      : chr  "19-6-1955" "25" "45" "65" ...
##  $ STDAT5      : chr  "26-6-1955" "26" "46" "66" ...
##  $ FDAT0       : chr  "30-8-1955" "27" "47" "67" ...
##  $ FDAT5       : chr  "30-8-1955" "28" "48" "68" ...
##  $ INTER0      : num  72 29 49 69 73 109 129 43 40 75 ...
##  $ INTER5      : num  69 30 50 70 44 110 130 36 35 66 ...
##  $ MAXT        : num  13.8 31 51 71 12.8 ...
##  $ MDAT        : chr  "28-6-1955" "32" "52" "72" ...
##  $ SUMT0       : num  165 33 53 73 187 ...
##  $ SUMT5       : num  129 34 54 74 144 ...
##  $ T220        : num  165 35 55 75 187 ...
##  $ T225        : num  129 36 56 76 144 ...
##  $ FT220       : num  165 37 57 77 187 ...
##  $ FT225       : num  129 38 58 78 144 ...
##  $ SPEEDT      : num  -0.82 39 59 79 -0.597 ...
##  $ SUMPREC     : num  79.8 40 60 80 76.7 ...
## elapsed time is 15.270000 seconds 
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/north/20982099999 VOLOCHANKA.txt"
## The number of deleted rows by column precipitation= 491 
## The number of deleted rows by column temp= 0 
##      Day Month Year PRECIP  TMEAN
## 4958  26    12 2015   0.00 -31.89
## 4959  27    12 2015   0.00 -35.72
## 4960  28    12 2015   0.00 -35.11
## 4961  29    12 2015   0.00 -36.00
## 4962  30    12 2015   0.00 -33.06
## 4963  31    12 2015   0.25 -35.17
## 'data.frame':	4472 obs. of  5 variables:
##  $ Day   : int  3 5 10 1 25 31 11 18 15 17 ...
##  $ Month : int  1 1 1 5 5 5 6 6 7 7 ...
##  $ Year  : int  1937 1937 1937 1937 1937 1937 1937 1937 1937 1937 ...
##  $ PRECIP: num  0 0 0 0 0 0 0 0 0 0 ...
##  $ TMEAN : num  -32.06 -39.28 -7.67 1.78 -9.44 ...
## NULL
##      PRECIP            TMEAN        
##  Min.   :  0.000   Min.   :-52.220  
##  1st Qu.:  0.000   1st Qu.:-27.500  
##  Median :  0.000   Median :-12.415  
##  Mean   :  3.302   Mean   :-12.524  
##  3rd Qu.:  1.020   3rd Qu.:  3.292  
##  Max.   :150.110   Max.   : 26.440  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 1937 Observation= 11 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1937
```

```
## #################### Skip a year!!!! 
## ****************Year= 1938 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1938
```

```
## #################### Skip a year!!!! 
## ****************Year= 1939 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1939
```

```
## #################### Skip a year!!!! 
## ****************Year= 1940 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1940
```

```
## #################### Skip a year!!!! 
## ****************Year= 1941 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1941
```

```
## #################### Skip a year!!!! 
## ****************Year= 1942 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1942
```

```
## #################### Skip a year!!!! 
## ****************Year= 1943 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1943
```

```
## #################### Skip a year!!!! 
## ****************Year= 1944 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1944
```

```
## #################### Skip a year!!!! 
## ****************Year= 1945 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1945
```

```
## #################### Skip a year!!!! 
## ****************Year= 1946 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1946
```

```
## #################### Skip a year!!!! 
## ****************Year= 1947 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1947
```

```
## #################### Skip a year!!!! 
## ****************Year= 1948 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1948
```

```
## #################### Skip a year!!!! 
## ****************Year= 1949 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1949
```

```
## #################### Skip a year!!!! 
## ****************Year= 1950 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1950
```

```
## #################### Skip a year!!!! 
## ****************Year= 1951 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1951
```

```
## #################### Skip a year!!!! 
## ****************Year= 1952 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1952
```

```
## #################### Skip a year!!!! 
## ****************Year= 1953 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1953
```

```
## #################### Skip a year!!!! 
## ****************Year= 1954 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1954
```

```
## #################### Skip a year!!!! 
## ****************Year= 1955 Observation= 114 **********************
## WARNING: T2205 num_days=  172 lenYear=  114  
## WARNING: T2205 num_days=  172 lenYear=  114  
## WARNING: FT2205 num_days=  172 lenYear=  114  
## WARNING: FT2205 seasonBegin=  12 seasonEnd=  66  
## WARNING: FT2205 num_days=  172 lenYear=  114  
## WARNING: FT2205 seasonBegin=  12 seasonEnd=  66  
## ****************Year= 1956 Observation= 195 **********************
## ****************Year= 1957 Observation= 145 **********************
## WARNING: T2205 num_days=  172 lenYear=  145  
## WARNING: T2205 num_days=  172 lenYear=  145  
## WARNING: FT2205 num_days=  172 lenYear=  145  
## WARNING: FT2205 seasonBegin=  70 seasonEnd=  109  
## WARNING: FT2205 num_days=  172 lenYear=  145  
## WARNING: FT2205 seasonBegin=  70 seasonEnd=  109  
## ****************Year= 1958 Observation= 150 **********************
## WARNING: T2205 num_days=  172 lenYear=  150  
## WARNING: T2205 num_days=  172 lenYear=  150  
## WARNING: FT2205 num_days=  172 lenYear=  150  
## WARNING: FT2205 seasonBegin=  70 seasonEnd=  98  
## WARNING: FT2205 num_days=  172 lenYear=  150  
## WARNING: FT2205 seasonBegin=  70 seasonEnd=  98  
## ****************Year= 1959 Observation= 154 **********************
## WARNING: T2205 num_days=  172 lenYear=  154  
## WARNING: T2205 num_days=  172 lenYear=  154  
## WARNING: FT2205 num_days=  172 lenYear=  154  
## WARNING: FT2205 seasonBegin=  43 seasonEnd=  83  
## WARNING: FT2205 num_days=  172 lenYear=  154  
## WARNING: FT2205 seasonBegin=  43 seasonEnd=  83  
## ****************Year= 1960 Observation= 241 **********************
## ****************Year= 1961 Observation= 279 **********************
## ****************Year= 1962 Observation= 271 **********************
## ****************Year= 1963 Observation= 278 **********************
## ****************Year= 1964 Observation= 304 **********************
## ****************Year= 1965 Observation= 253 **********************
## ****************Year= 1966 Observation= 333 **********************
## ****************Year= 1967 Observation= 255 **********************
## ****************Year= 1968 Observation= 183 **********************
## ****************Year= 1969 Observation= 203 **********************
## ****************Year= 1970 Observation= 170 **********************
## WARNING: T2205 num_days=  172 lenYear=  170  
## WARNING: T2205 num_days=  172 lenYear=  170  
## WARNING: FT2205 num_days=  172 lenYear=  170  
## WARNING: FT2205 seasonBegin=  79 seasonEnd=  123  
## WARNING: FT2205 num_days=  172 lenYear=  170  
## WARNING: FT2205 seasonBegin=  79 seasonEnd=  123  
## ****************Year= 1971 Observation= 50 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1971
```

```
## #################### Skip a year!!!! 
## ****************Year= 1972 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1972
```

```
## #################### Skip a year!!!! 
## ****************Year= 1973 Observation= 37 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1973
```

```
## #################### Skip a year!!!! 
## ****************Year= 1974 Observation= 16 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1974
```

```
## #################### Skip a year!!!! 
## ****************Year= 1975 Observation= 41 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1975
```

```
## #################### Skip a year!!!! 
## ****************Year= 1976 Observation= 14 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1976
```

```
## #################### Skip a year!!!! 
## ****************Year= 1977 Observation= 1 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1977
```

```
## #################### Skip a year!!!! 
## ****************Year= 1978 Observation= 1 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1978
```

```
## #################### Skip a year!!!! 
## ****************Year= 1979 Observation= 1 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1979
```

```
## #################### Skip a year!!!! 
## ****************Year= 1980 Observation= 2 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1980
```

```
## #################### Skip a year!!!! 
## ****************Year= 1981 Observation= 2 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1981
```

```
## #################### Skip a year!!!! 
## ****************Year= 1982 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1982
```

```
## #################### Skip a year!!!! 
## ****************Year= 1983 Observation= 67 **********************
## #################### Skip a year!!!! 
## ****************Year= 1984 Observation= 79 **********************
## WARNING: T2205 num_days=  173 lenYear=  79  
## WARNING: T2205 num_days=  173 lenYear=  79  
## WARNING: FT2205 num_days=  173 lenYear=  79  
## WARNING: FT2205 seasonBegin=  58 seasonEnd=  79  
## WARNING: FT2205 num_days=  173 lenYear=  79  
## WARNING: FT2205 seasonBegin=  58 seasonEnd=  79  
## ****************Year= 1985 Observation= 53 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1985
```

```
## #################### Skip a year!!!! 
## ****************Year= 1986 Observation= 77 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1986
```

```
## #################### Skip a year!!!! 
## ****************Year= 1987 Observation= 164 **********************
## WARNING: T2205 num_days=  172 lenYear=  164  
## WARNING: T2205 num_days=  172 lenYear=  164  
## WARNING: FT2205 num_days=  172 lenYear=  164  
## WARNING: FT2205 seasonBegin=  97 seasonEnd=  140  
## WARNING: FT2205 num_days=  172 lenYear=  164  
## WARNING: FT2205 seasonBegin=  97 seasonEnd=  140  
## ****************Year= 1988 Observation= 57 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1988
```

```
## #################### Skip a year!!!! 
## ****************Year= 1989 Observation= 29 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1989
```

```
## #################### Skip a year!!!! 
## ****************Year= 1990 Observation= 19 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1990
```

```
## #################### Skip a year!!!! 
## ****************Year= 1991 Observation= 11 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1991
```

```
## #################### Skip a year!!!! 
## ****************Year= 1992 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1992
```

```
## #################### Skip a year!!!! 
## ****************Year= 1993 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1993
```

```
## #################### Skip a year!!!! 
## ****************Year= 1994 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1994
```

```
## #################### Skip a year!!!! 
## ****************Year= 1995 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1995
```

```
## #################### Skip a year!!!! 
## ****************Year= 1996 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1996
```

```
## #################### Skip a year!!!! 
## ****************Year= 1997 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1997
```

```
## #################### Skip a year!!!! 
## ****************Year= 1998 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1998
```

```
## #################### Skip a year!!!! 
## ****************Year= 1999 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1999
```

```
## #################### Skip a year!!!! 
## ****************Year= 2000 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2000
```

```
## #################### Skip a year!!!! 
## ****************Year= 2001 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2001
```

```
## #################### Skip a year!!!! 
## ****************Year= 2002 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2002
```

```
## #################### Skip a year!!!! 
## ****************Year= 2003 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2003
```

```
## #################### Skip a year!!!! 
## ****************Year= 2004 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2004
```

```
## #################### Skip a year!!!! 
## ****************Year= 2005 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2005
```

```
## #################### Skip a year!!!! 
## ****************Year= 2006 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2006
```

```
## #################### Skip a year!!!! 
## ****************Year= 2007 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2007
```

```
## #################### Skip a year!!!! 
## ****************Year= 2008 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2008
```

```
## #################### Skip a year!!!! 
## ****************Year= 2009 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2009
```

```
## #################### Skip a year!!!! 
## ****************Year= 2010 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2010
```

```
## #################### Skip a year!!!! 
## ****************Year= 2011 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2011
```

```
## #################### Skip a year!!!! 
## ****************Year= 2012 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2012
```

```
## #################### Skip a year!!!! 
## ****************Year= 2013 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2013
```

```
## #################### Skip a year!!!! 
## ****************Year= 2014 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2014
```

```
## #################### Skip a year!!!! 
## ****************Year= 2015 Observation= 212 **********************
## 
## 'data.frame':	79 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1937 1938 1939 1940 1941 1942 1943 1944 1945 1946 ...
##  $ StartD      : num  -9999 -9999 -9999 -9999 -9999 ...
##  $ EndD        : num  4 24 44 64 84 104 124 144 164 184 ...
##  $ STDAT0      : chr  "5" "25" "45" "65" ...
##  $ STDAT5      : chr  "6" "26" "46" "66" ...
##  $ FDAT0       : chr  "7" "27" "47" "67" ...
##  $ FDAT5       : chr  "8" "28" "48" "68" ...
##  $ INTER0      : num  9 29 49 69 89 109 129 149 169 189 ...
##  $ INTER5      : num  10 30 50 70 90 110 130 150 170 190 ...
##  $ MAXT        : num  11 31 51 71 91 111 131 151 171 191 ...
##  $ MDAT        : chr  "12" "32" "52" "72" ...
##  $ SUMT0       : num  13 33 53 73 93 113 133 153 173 193 ...
##  $ SUMT5       : num  14 34 54 74 94 114 134 154 174 194 ...
##  $ T220        : num  15 35 55 75 95 115 135 155 175 195 ...
##  $ T225        : num  16 36 56 76 96 116 136 156 176 196 ...
##  $ FT220       : num  17 37 57 77 97 117 137 157 177 197 ...
##  $ FT225       : num  18 38 58 78 98 118 138 158 178 198 ...
##  $ SPEEDT      : num  19 39 59 79 99 119 139 159 179 199 ...
##  $ SUMPREC     : num  20 40 60 80 100 120 140 160 180 200 ...
## elapsed time is 9.160000 seconds 
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/north/21908099999 DZALINDA.txt"
## The number of deleted rows by column precipitation= 332 
## The number of deleted rows by column temp= 0 
##       Day Month Year PRECIP  TMEAN
## 14709  15     4 2013      0 -21.56
## 14710  16     4 2013      0 -13.83
## 14711  17     4 2013      0  -8.28
## 14712  18     4 2013      0  -2.50
## 14713  19     4 2013      0  -4.39
## 14714  20     4 2013      0  -1.33
## 'data.frame':	14382 obs. of  5 variables:
##  $ Day   : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ Month : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Year  : int  1959 1959 1959 1959 1959 1959 1959 1959 1959 1959 ...
##  $ PRECIP: num  0 0 0 0 0 0.51 0.25 0 0 0 ...
##  $ TMEAN : num  -59.6 -57.1 -55 -47.6 -34.8 ...
## NULL
##      PRECIP             TMEAN        
##  Min.   :  0.0000   Min.   :-62.280  
##  1st Qu.:  0.0000   1st Qu.:-30.280  
##  Median :  0.0000   Median :-10.940  
##  Mean   :  0.8173   Mean   :-12.717  
##  3rd Qu.:  0.5100   3rd Qu.:  5.428  
##  Max.   :150.1100   Max.   : 26.610  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 1959 Observation= 286 **********************
## ****************Year= 1960 Observation= 279 **********************
## ****************Year= 1961 Observation= 338 **********************
## ****************Year= 1962 Observation= 352 **********************
## ****************Year= 1963 Observation= 343 **********************
## ****************Year= 1964 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1964
```

```
## #################### Skip a year!!!! 
## ****************Year= 1965 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1965
```

```
## #################### Skip a year!!!! 
## ****************Year= 1966 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1966
```

```
## #################### Skip a year!!!! 
## ****************Year= 1967 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1967
```

```
## #################### Skip a year!!!! 
## ****************Year= 1968 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1968
```

```
## #################### Skip a year!!!! 
## ****************Year= 1969 Observation= 342 **********************
## ****************Year= 1970 Observation= 355 **********************
## ****************Year= 1971 Observation= 170 **********************
## WARNING: T2205 num_days=  172 lenYear=  170  
## WARNING: T2205 num_days=  172 lenYear=  170  
## WARNING: FT2205 num_days=  172 lenYear=  170  
## WARNING: FT2205 seasonBegin=  160 seasonEnd=  170  
## WARNING: FT2205 num_days=  172 lenYear=  170  
## WARNING: FT2205 seasonBegin=  160 seasonEnd=  170  
## ****************Year= 1972 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1972
```

```
## #################### Skip a year!!!! 
## ****************Year= 1973 Observation= 321 **********************
## ****************Year= 1974 Observation= 308 **********************
## ****************Year= 1975 Observation= 329 **********************
## ****************Year= 1976 Observation= 332 **********************
## ****************Year= 1977 Observation= 342 **********************
## ****************Year= 1978 Observation= 322 **********************
## ****************Year= 1979 Observation= 359 **********************
## ****************Year= 1980 Observation= 363 **********************
## ****************Year= 1981 Observation= 336 **********************
## ****************Year= 1982 Observation= 340 **********************
## ****************Year= 1983 Observation= 330 **********************
## ****************Year= 1984 Observation= 308 **********************
## ****************Year= 1985 Observation= 334 **********************
## ****************Year= 1986 Observation= 334 **********************
## ****************Year= 1987 Observation= 349 **********************
## ****************Year= 1988 Observation= 341 **********************
## ****************Year= 1989 Observation= 338 **********************
## ****************Year= 1990 Observation= 350 **********************
## ****************Year= 1991 Observation= 309 **********************
## ****************Year= 1992 Observation= 305 **********************
## ****************Year= 1993 Observation= 189 **********************
## ****************Year= 1994 Observation= 135 **********************
## WARNING: T2205 num_days=  172 lenYear=  135  
## WARNING: T2205 num_days=  172 lenYear=  135  
## WARNING: FT2205 num_days=  172 lenYear=  135  
## WARNING: FT2205 seasonBegin=  55 seasonEnd=  118  
## WARNING: FT2205 num_days=  172 lenYear=  135  
## WARNING: FT2205 seasonBegin=  55 seasonEnd=  118  
## ****************Year= 1995 Observation= 166 **********************
## WARNING: T2205 num_days=  172 lenYear=  166  
## WARNING: T2205 num_days=  172 lenYear=  166  
## WARNING: FT2205 num_days=  172 lenYear=  166  
## WARNING: FT2205 seasonBegin=  67 seasonEnd=  131  
## WARNING: FT2205 num_days=  172 lenYear=  166  
## WARNING: FT2205 seasonBegin=  67 seasonEnd=  131  
## ****************Year= 1996 Observation= 172 **********************
## WARNING: T2205 num_days=  173 lenYear=  172  
## WARNING: T2205 num_days=  173 lenYear=  172  
## WARNING: FT2205 num_days=  173 lenYear=  172  
## WARNING: FT2205 seasonBegin=  69 seasonEnd=  136  
## WARNING: FT2205 num_days=  173 lenYear=  172  
## WARNING: FT2205 seasonBegin=  69 seasonEnd=  136  
## ****************Year= 1997 Observation= 222 **********************
## ****************Year= 1998 Observation= 241 **********************
## ****************Year= 1999 Observation= 237 **********************
## ****************Year= 2000 Observation= 122 **********************
## WARNING: T2205 num_days=  173 lenYear=  122  
## WARNING: T2205 num_days=  173 lenYear=  122  
## WARNING: FT2205 num_days=  173 lenYear=  122  
## WARNING: FT2205 seasonBegin=  62 seasonEnd=  112  
## WARNING: FT2205 num_days=  173 lenYear=  122  
## WARNING: FT2205 seasonBegin=  62 seasonEnd=  112  
## ****************Year= 2001 Observation= 261 **********************
## ****************Year= 2002 Observation= 292 **********************
## ****************Year= 2003 Observation= 219 **********************
## ****************Year= 2004 Observation= 268 **********************
## ****************Year= 2005 Observation= 261 **********************
## ****************Year= 2006 Observation= 302 **********************
## ****************Year= 2007 Observation= 342 **********************
## ****************Year= 2008 Observation= 347 **********************
## ****************Year= 2009 Observation= 353 **********************
## ****************Year= 2010 Observation= 345 **********************
## ****************Year= 2011 Observation= 332 **********************
## ****************Year= 2012 Observation= 351 **********************
## ****************Year= 2013 Observation= 110 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2013
```

```
## #################### Skip a year!!!! 
## 
## 'data.frame':	55 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1959 1960 1961 1962 1963 1964 1965 1966 1967 1968 ...
##  $ StartD      : num  116 124 151 164 172 ...
##  $ EndD        : num  191 215 215 251 248 104 124 144 164 184 ...
##  $ STDAT0      : chr  "26-5-1959" "24-5-1960" "10-6-1961" "16-6-1962" ...
##  $ STDAT5      : chr  "30-5-1959" "1-6-1960" "12-6-1961" "22-6-1962" ...
##  $ FDAT0       : chr  "18-9-1959" "8-9-1960" "20-8-1961" "15-9-1962" ...
##  $ FDAT5       : chr  "10-9-1959" "6-9-1960" "16-8-1961" "12-9-1962" ...
##  $ INTER0      : num  115 107 71 91 80 109 129 149 169 189 ...
##  $ INTER5      : num  105 103 67 87 73 110 130 150 170 190 ...
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
## elapsed time is 29.150000 seconds 
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/north/21921099999 KJUSJUR.txt"
## The number of deleted rows by column precipitation= 318 
## The number of deleted rows by column temp= 0 
##       Day Month Year PRECIP  TMEAN
## 12343  17     4 2008      0 -17.94
## 12344  18     4 2008      0 -16.61
## 12345  19     4 2008      0 -14.83
## 12346  20     4 2008      0 -15.06
## 12347  21     4 2008      0 -14.22
## 12348  22     4 2008      0 -15.33
## 'data.frame':	12030 obs. of  5 variables:
##  $ Day   : int  8 10 11 17 18 20 21 22 1 4 ...
##  $ Month : int  1 1 1 1 1 1 1 1 2 2 ...
##  $ Year  : int  1948 1948 1948 1948 1948 1948 1948 1948 1948 1948 ...
##  $ PRECIP: num  0.03 0 0.05 0.1 0.05 0.1 0.05 0.05 0 0.03 ...
##  $ TMEAN : num  -30.4 -37.9 -38.5 -33.1 -43.2 ...
## NULL
##      PRECIP            TMEAN       
##  Min.   : 0.0000   Min.   :-58.89  
##  1st Qu.: 0.0000   1st Qu.:-30.28  
##  Median : 0.0000   Median :-13.39  
##  Mean   : 0.1272   Mean   :-13.59  
##  3rd Qu.: 0.0800   3rd Qu.:  4.00  
##  Max.   :15.0100   Max.   : 26.61  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 1948 Observation= 30 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1948
```

```
## #################### Skip a year!!!! 
## ****************Year= 1949 Observation= 159 **********************
## WARNING: T2205 num_days=  172 lenYear=  159  
## WARNING: T2205 num_days=  172 lenYear=  159  
## WARNING: FT2205 num_days=  172 lenYear=  159  
## WARNING: FT2205 seasonBegin=  80 seasonEnd=  133  
## WARNING: FT2205 num_days=  172 lenYear=  159  
## WARNING: FT2205 seasonBegin=  80 seasonEnd=  133  
## ****************Year= 1950 Observation= 58 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1950
```

```
## #################### Skip a year!!!! 
## ****************Year= 1951 Observation= 1 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1951
```

```
## #################### Skip a year!!!! 
## ****************Year= 1952 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1952
```

```
## #################### Skip a year!!!! 
## ****************Year= 1953 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1953
```

```
## #################### Skip a year!!!! 
## ****************Year= 1954 Observation= 12 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1954
```

```
## #################### Skip a year!!!! 
## ****************Year= 1955 Observation= 21 **********************
## #################### Skip a year!!!! 
## ****************Year= 1956 Observation= 10 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1956
```

```
## #################### Skip a year!!!! 
## ****************Year= 1957 Observation= 1 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1957
```

```
## #################### Skip a year!!!! 
## ****************Year= 1958 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1958
```

```
## #################### Skip a year!!!! 
## ****************Year= 1959 Observation= 3 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1959
```

```
## #################### Skip a year!!!! 
## ****************Year= 1960 Observation= 1 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1960
```

```
## #################### Skip a year!!!! 
## ****************Year= 1961 Observation= 18 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1961
```

```
## #################### Skip a year!!!! 
## ****************Year= 1962 Observation= 111 **********************
## WARNING: T2205 num_days=  172 lenYear=  111  
## WARNING: T2205 num_days=  172 lenYear=  111  
## WARNING: FT2205 num_days=  172 lenYear=  111  
## WARNING: FT2205 seasonBegin=  95 seasonEnd=  108  
## WARNING: FT2205 num_days=  172 lenYear=  111  
## WARNING: FT2205 seasonBegin=  95 seasonEnd=  108  
## ****************Year= 1963 Observation= 124 **********************
## WARNING: T2205 num_days=  172 lenYear=  124  
## WARNING: T2205 num_days=  172 lenYear=  124  
## WARNING: FT2205 num_days=  172 lenYear=  124  
## WARNING: FT2205 seasonBegin=  85 seasonEnd=  111  
## WARNING: FT2205 num_days=  172 lenYear=  124  
## WARNING: FT2205 seasonBegin=  85 seasonEnd=  111  
## ****************Year= 1964 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1964
```

```
## #################### Skip a year!!!! 
## ****************Year= 1965 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1965
```

```
## #################### Skip a year!!!! 
## ****************Year= 1966 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1966
```

```
## #################### Skip a year!!!! 
## ****************Year= 1967 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1967
```

```
## #################### Skip a year!!!! 
## ****************Year= 1968 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1968
```

```
## #################### Skip a year!!!! 
## ****************Year= 1969 Observation= 335 **********************
## ****************Year= 1970 Observation= 354 **********************
## ****************Year= 1971 Observation= 170 **********************
## WARNING: T2205 num_days=  172 lenYear=  170  
## WARNING: T2205 num_days=  172 lenYear=  170  
## WARNING: FT2205 num_days=  172 lenYear=  170  
## WARNING: FT2205 seasonBegin=  144 seasonEnd=  170  
## WARNING: FT2205 num_days=  172 lenYear=  170  
## WARNING: FT2205 seasonBegin=  144 seasonEnd=  170  
## ****************Year= 1972 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1972
```

```
## #################### Skip a year!!!! 
## ****************Year= 1973 Observation= 351 **********************
## ****************Year= 1974 Observation= 351 **********************
## ****************Year= 1975 Observation= 349 **********************
## ****************Year= 1976 Observation= 321 **********************
## ****************Year= 1977 Observation= 256 **********************
## ****************Year= 1978 Observation= 247 **********************
## ****************Year= 1979 Observation= 169 **********************
## WARNING: T2205 num_days=  172 lenYear=  169  
## WARNING: T2205 num_days=  172 lenYear=  169  
## WARNING: FT2205 num_days=  172 lenYear=  169  
## WARNING: FT2205 seasonBegin=  80 seasonEnd=  129  
## WARNING: FT2205 num_days=  172 lenYear=  169  
## WARNING: FT2205 seasonBegin=  80 seasonEnd=  129  
## ****************Year= 1980 Observation= 302 **********************
## ****************Year= 1981 Observation= 323 **********************
## ****************Year= 1982 Observation= 54 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1982
```

```
## #################### Skip a year!!!! 
## ****************Year= 1983 Observation= 240 **********************
## ****************Year= 1984 Observation= 343 **********************
## ****************Year= 1985 Observation= 344 **********************
## ****************Year= 1986 Observation= 364 **********************
## ****************Year= 1987 Observation= 362 **********************
## ****************Year= 1988 Observation= 364 **********************
## ****************Year= 1989 Observation= 361 **********************
## ****************Year= 1990 Observation= 340 **********************
## ****************Year= 1991 Observation= 361 **********************
## ****************Year= 1992 Observation= 329 **********************
## ****************Year= 1993 Observation= 352 **********************
## ****************Year= 1994 Observation= 343 **********************
## ****************Year= 1995 Observation= 350 **********************
## ****************Year= 1996 Observation= 297 **********************
## ****************Year= 1997 Observation= 349 **********************
## ****************Year= 1998 Observation= 299 **********************
## ****************Year= 1999 Observation= 300 **********************
## ****************Year= 2000 Observation= 224 **********************
## ****************Year= 2001 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2001
```

```
## #################### Skip a year!!!! 
## ****************Year= 2002 Observation= 141 **********************
## WARNING: T2205 num_days=  172 lenYear=  141  
## WARNING: T2205 num_days=  172 lenYear=  141  
## WARNING: FT2205 num_days=  172 lenYear=  141  
## WARNING: FT2205 seasonBegin=  2 seasonEnd=  42  
## WARNING: FT2205 num_days=  172 lenYear=  141  
## WARNING: FT2205 seasonBegin=  2 seasonEnd=  42  
## ****************Year= 2003 Observation= 347 **********************
## ****************Year= 2004 Observation= 359 **********************
## ****************Year= 2005 Observation= 346 **********************
## ****************Year= 2006 Observation= 336 **********************
## ****************Year= 2007 Observation= 341 **********************
## ****************Year= 2008 Observation= 107 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2008
```

```
## #################### Skip a year!!!! 
## 
## 'data.frame':	61 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1948 1949 1950 1951 1952 1953 1954 1955 1956 1957 ...
##  $ StartD      : num  -9999 80 -9999 -9999 -9999 ...
##  $ EndD        : num  4 133 44 64 84 104 124 144 164 184 ...
##  $ STDAT0      : chr  "5" "29-6-1949" "45" "65" ...
##  $ STDAT5      : chr  "6" "7-7-1949" "46" "66" ...
##  $ FDAT0       : chr  "7" "9-10-1949" "47" "67" ...
##  $ FDAT5       : chr  "8" "17-9-1949" "48" "68" ...
##  $ INTER0      : num  9 102 49 69 89 109 129 149 169 189 ...
##  $ INTER5      : num  10 80 50 70 90 110 130 150 170 190 ...
##  $ MAXT        : num  11 19 51 71 91 111 131 151 171 191 ...
##  $ MDAT        : chr  "12" "12-7-1949" "52" "72" ...
##  $ SUMT0       : num  13 524 53 73 93 ...
##  $ SUMT5       : num  14 471 54 74 94 ...
##  $ T220        : num  15 524 55 75 95 ...
##  $ T225        : num  16 471 56 76 96 ...
##  $ FT220       : num  17 524 57 77 97 ...
##  $ FT225       : num  18 471 58 78 98 ...
##  $ SPEEDT      : num  19 -0.653 59 79 99 ...
##  $ SUMPREC     : num  20 11.9 60 80 100 ...
## elapsed time is 23.300000 seconds 
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/north/23077099999 NORILSK.txt"
## The number of deleted rows by column precipitation= 86 
## The number of deleted rows by column temp= 0 
##      Day Month Year PRECIP TMEAN
## 2278  14     9 1975   9.91  5.28
## 2279  20     9 1975   0.00  9.22
## 2280  21     9 1975   1.02  6.22
## 2281  22     9 1975   0.00  3.78
## 2282  23     9 1975   0.00  0.78
## 2283  24     9 1975   0.00  0.50
## 'data.frame':	2197 obs. of  5 variables:
##  $ Day   : int  2 4 13 27 28 29 14 22 8 10 ...
##  $ Month : int  1 1 1 1 1 1 10 10 11 11 ...
##  $ Year  : int  1959 1959 1959 1959 1959 1959 1959 1959 1959 1959 ...
##  $ PRECIP: num  0.25 0.51 1.52 0 1.52 ...
##  $ TMEAN : num  -28.9 -25.3 -30.2 -31.8 -22.9 ...
## NULL
##      PRECIP            TMEAN       
##  Min.   :  0.000   Min.   :-50.28  
##  1st Qu.:  0.000   1st Qu.:-22.78  
##  Median :  0.250   Median :-10.89  
##  Mean   :  4.965   Mean   :-10.18  
##  3rd Qu.:  1.520   3rd Qu.:  4.17  
##  Max.   :150.110   Max.   : 25.28  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 1959 Observation= 39 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1959
```

```
## #################### Skip a year!!!! 
## ****************Year= 1960 Observation= 32 **********************
## #################### Skip a year!!!! 
## ****************Year= 1961 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1961
```

```
## #################### Skip a year!!!! 
## ****************Year= 1962 Observation= 76 **********************
## WARNING: T2205 num_days=  172 lenYear=  76  
## WARNING: T2205 num_days=  172 lenYear=  76  
## WARNING: FT2205 num_days=  172 lenYear=  76  
## WARNING: FT2205 seasonBegin=  1 seasonEnd=  41  
## WARNING: FT2205 num_days=  172 lenYear=  76  
## WARNING: FT2205 seasonBegin=  1 seasonEnd=  41  
## ****************Year= 1963 Observation= 216 **********************
## ****************Year= 1964 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1964
```

```
## #################### Skip a year!!!! 
## ****************Year= 1965 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1965
```

```
## #################### Skip a year!!!! 
## ****************Year= 1966 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1966
```

```
## #################### Skip a year!!!! 
## ****************Year= 1967 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1967
```

```
## #################### Skip a year!!!! 
## ****************Year= 1968 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1968
```

```
## #################### Skip a year!!!! 
## ****************Year= 1969 Observation= 350 **********************
## ****************Year= 1970 Observation= 349 **********************
## ****************Year= 1971 Observation= 176 **********************
## ****************Year= 1972 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1972
```

```
## #################### Skip a year!!!! 
## ****************Year= 1973 Observation= 350 **********************
## ****************Year= 1974 Observation= 361 **********************
## ****************Year= 1975 Observation= 248 **********************
## 
## 'data.frame':	17 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1959 1960 1961 1962 1963 1964 1965 1966 1967 1968 ...
##  $ StartD      : num  -9999 -9999 -9999 1 119 ...
##  $ EndD        : num  4 24 44 41 177 104 124 144 164 184 ...
##  $ STDAT0      : chr  "5" "25" "45" "2-7-1962" ...
##  $ STDAT5      : chr  "6" "26" "46" "2-7-1962" ...
##  $ FDAT0       : chr  "7" "27" "47" "23-9-1962" ...
##  $ FDAT5       : chr  "8" "28" "48" "21-9-1962" ...
##  $ INTER0      : num  9 29 49 83 74 109 129 149 169 189 ...
##  $ INTER5      : num  10 30 50 81 74 110 130 150 170 190 ...
##  $ MAXT        : num  11 31 51 23.4 20.7 ...
##  $ MDAT        : chr  "12" "32" "52" "28-7-1962" ...
##  $ SUMT0       : num  13 33 53 382 728 ...
##  $ SUMT5       : num  14 34 54 359 661 ...
##  $ T220        : num  15 35 55 382 706 ...
##  $ T225        : num  16 36 56 359 642 ...
##  $ FT220       : num  17 37 57 381.9 22.7 ...
##  $ FT225       : num  18 38 58 358.8 18.4 ...
##  $ SPEEDT      : num  19 39 59 -0.6677 0.0284 ...
##  $ SUMPREC     : num  20 40 60 246 1137 ...
## elapsed time is 4.570000 seconds 
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/north/23078099999 NORIL'SK.txt"
## The number of deleted rows by column precipitation= 426 
## The number of deleted rows by column temp= 0 
##      Day Month Year PRECIP  TMEAN
## 8377  26    12 2015   0.00 -28.56
## 8378  27    12 2015   0.00 -26.61
## 8379  28    12 2015   0.25 -26.78
## 8380  29    12 2015   0.00 -29.00
## 8381  30    12 2015   0.00 -26.39
## 8382  31    12 2015   0.00 -24.11
## 'data.frame':	7956 obs. of  5 variables:
##  $ Day   : int  4 22 23 25 26 27 28 29 30 31 ...
##  $ Month : int  10 10 10 10 10 10 10 10 10 10 ...
##  $ Year  : int  1975 1975 1975 1975 1975 1975 1975 1975 1975 1975 ...
##  $ PRECIP: num  0 0.76 0 0 0 0.25 2.03 0.25 0.51 0 ...
##  $ TMEAN : num  -3.78 -16.89 -21.39 -27.83 -17.28 ...
## NULL
##      PRECIP           TMEAN       
##  Min.   :  0.00   Min.   :-52.50  
##  1st Qu.:  0.00   1st Qu.:-22.22  
##  Median :  0.00   Median : -8.78  
##  Mean   :  1.19   Mean   : -9.06  
##  3rd Qu.:  1.02   3rd Qu.:  5.17  
##  Max.   :141.99   Max.   : 26.61  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 1975 Observation= 67 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1975
```

```
## #################### Skip a year!!!! 
## ****************Year= 1976 Observation= 343 **********************
## ****************Year= 1977 Observation= 325 **********************
## ****************Year= 1978 Observation= 319 **********************
## ****************Year= 1979 Observation= 332 **********************
## ****************Year= 1980 Observation= 342 **********************
## ****************Year= 1981 Observation= 350 **********************
## ****************Year= 1982 Observation= 316 **********************
## ****************Year= 1983 Observation= 336 **********************
## ****************Year= 1984 Observation= 303 **********************
## ****************Year= 1985 Observation= 351 **********************
## ****************Year= 1986 Observation= 347 **********************
## ****************Year= 1987 Observation= 359 **********************
## ****************Year= 1988 Observation= 365 **********************
## ****************Year= 1989 Observation= 358 **********************
## ****************Year= 1990 Observation= 358 **********************
## ****************Year= 1991 Observation= 307 **********************
## ****************Year= 1992 Observation= 236 **********************
## ****************Year= 1993 Observation= 351 **********************
## ****************Year= 1994 Observation= 347 **********************
## ****************Year= 1995 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1995
```

```
## #################### Skip a year!!!! 
## ****************Year= 1996 Observation= 87 **********************
## WARNING: T2205 num_days=  173 lenYear=  87  
## WARNING: T2205 num_days=  173 lenYear=  87  
## WARNING: FT2205 num_days=  173 lenYear=  87  
## WARNING: FT2205 seasonBegin=  17 seasonEnd=  61  
## WARNING: FT2205 num_days=  173 lenYear=  87  
## WARNING: FT2205 seasonBegin=  17 seasonEnd=  61  
## ****************Year= 1997 Observation= 132 **********************
## WARNING: T2205 num_days=  172 lenYear=  132  
## WARNING: T2205 num_days=  172 lenYear=  132  
## WARNING: FT2205 num_days=  172 lenYear=  132  
## WARNING: FT2205 seasonBegin=  70 seasonEnd=  110  
## WARNING: FT2205 num_days=  172 lenYear=  132  
## WARNING: FT2205 seasonBegin=  70 seasonEnd=  110  
## ****************Year= 1998 Observation= 64 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1998
```

```
## #################### Skip a year!!!! 
## ****************Year= 1999 Observation= 8 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1999
```

```
## #################### Skip a year!!!! 
## ****************Year= 2000 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2000
```

```
## #################### Skip a year!!!! 
## ****************Year= 2001 Observation= 10 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2001
```

```
## #################### Skip a year!!!! 
## ****************Year= 2002 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2002
```

```
## #################### Skip a year!!!! 
## ****************Year= 2003 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2003
```

```
## #################### Skip a year!!!! 
## ****************Year= 2004 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2004
```

```
## #################### Skip a year!!!! 
## ****************Year= 2005 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2005
```

```
## #################### Skip a year!!!! 
## ****************Year= 2006 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2006
```

```
## #################### Skip a year!!!! 
## ****************Year= 2007 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2007
```

```
## #################### Skip a year!!!! 
## ****************Year= 2008 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2008
```

```
## #################### Skip a year!!!! 
## ****************Year= 2009 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2009
```

```
## #################### Skip a year!!!! 
## ****************Year= 2010 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2010
```

```
## #################### Skip a year!!!! 
## ****************Year= 2011 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2011
```

```
## #################### Skip a year!!!! 
## ****************Year= 2012 Observation= 298 **********************
## ****************Year= 2013 Observation= 319 **********************
## ****************Year= 2014 Observation= 278 **********************
## ****************Year= 2015 Observation= 348 **********************
## 
## 'data.frame':	41 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 ...
##  $ StartD      : num  -9999 160 146 146 151 ...
##  $ EndD        : num  4 253 239 218 242 236 256 226 255 236 ...
##  $ STDAT0      : chr  "5" "14-6-1976" "15-6-1977" "20-6-1978" ...
##  $ STDAT5      : chr  "6" "21-6-1976" "22-6-1977" "26-6-1978" ...
##  $ FDAT0       : chr  "7" "22-9-1976" "23-9-1977" "13-9-1978" ...
##  $ FDAT5       : chr  "8" "13-9-1976" "20-9-1977" "9-9-1978" ...
##  $ INTER0      : num  9 100 100 85 99 81 98 95 114 112 ...
##  $ INTER5      : num  10 91 97 77 94 73 95 94 109 97 ...
##  $ MAXT        : num  11 22 22.6 23.8 26.6 ...
##  $ MDAT        : chr  "12" "27-6-1976" "28-6-1977" "14-7-1978" ...
##  $ SUMT0       : num  13 1069 1071 963 1169 ...
##  $ SUMT5       : num  14 988 963 875 1101 ...
##  $ T220        : num  15 220 427 457 269 ...
##  $ T225        : num  16 176 354 411 232 ...
##  $ FT220       : num  17 861 658 505 878 ...
##  $ FT225       : num  18 828 623 482 861 ...
##  $ SPEEDT      : num  19 1.285 0.202 0.537 0.424 ...
##  $ SUMPREC     : num  20 185 112 50 233 ...
## elapsed time is 15.100000 seconds 
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/north/23179099999 SNEZHNOGORSK.txt"
## The number of deleted rows by column precipitation= 289 
## The number of deleted rows by column temp= 0 
##      Day Month Year PRECIP  TMEAN
## 8461  26    12 2015   0.00 -26.39
## 8462  27    12 2015   0.00 -26.56
## 8463  28    12 2015   0.00 -24.83
## 8464  29    12 2015   2.29 -20.39
## 8465  30    12 2015   0.51 -20.17
## 8466  31    12 2015   0.00 -28.61
## 'data.frame':	8177 obs. of  5 variables:
##  $ Day   : int  1 2 5 6 7 8 9 10 12 14 ...
##  $ Month : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Year  : int  1973 1973 1973 1973 1973 1973 1973 1973 1973 1973 ...
##  $ PRECIP: num  2.03 3.05 1.27 1.02 2.29 1.52 1.02 2.54 0.25 2.03 ...
##  $ TMEAN : num  -15 -16 -13.8 -22.8 -22 ...
## NULL
##      PRECIP          TMEAN        
##  Min.   : 0.00   Min.   :-52.830  
##  1st Qu.: 0.00   1st Qu.:-21.330  
##  Median : 0.25   Median : -7.220  
##  Mean   : 1.38   Mean   : -8.241  
##  3rd Qu.: 1.52   3rd Qu.:  5.780  
##  Max.   :99.06   Max.   : 26.170  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 1973 Observation= 318 **********************
## ****************Year= 1974 Observation= 338 **********************
## ****************Year= 1975 Observation= 358 **********************
## ****************Year= 1976 Observation= 339 **********************
## ****************Year= 1977 Observation= 318 **********************
## ****************Year= 1978 Observation= 338 **********************
## ****************Year= 1979 Observation= 334 **********************
## ****************Year= 1980 Observation= 335 **********************
## ****************Year= 1981 Observation= 340 **********************
## ****************Year= 1982 Observation= 298 **********************
## ****************Year= 1983 Observation= 335 **********************
## ****************Year= 1984 Observation= 306 **********************
## ****************Year= 1985 Observation= 349 **********************
## ****************Year= 1986 Observation= 345 **********************
## ****************Year= 1987 Observation= 358 **********************
## ****************Year= 1988 Observation= 359 **********************
## ****************Year= 1989 Observation= 356 **********************
## ****************Year= 1990 Observation= 359 **********************
## ****************Year= 1991 Observation= 305 **********************
## ****************Year= 1992 Observation= 114 **********************
## WARNING: T2205 num_days=  173 lenYear=  114  
## WARNING: T2205 num_days=  173 lenYear=  114  
## WARNING: FT2205 num_days=  173 lenYear=  114  
## WARNING: FT2205 seasonBegin=  37 seasonEnd=  70  
## WARNING: FT2205 num_days=  173 lenYear=  114  
## WARNING: FT2205 seasonBegin=  37 seasonEnd=  70  
## ****************Year= 1993 Observation= 192 **********************
## ****************Year= 1994 Observation= 174 **********************
## ****************Year= 1995 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1995
```

```
## #################### Skip a year!!!! 
## ****************Year= 1996 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1996
```

```
## #################### Skip a year!!!! 
## ****************Year= 1997 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1997
```

```
## #################### Skip a year!!!! 
## ****************Year= 1998 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1998
```

```
## #################### Skip a year!!!! 
## ****************Year= 1999 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1999
```

```
## #################### Skip a year!!!! 
## ****************Year= 2000 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2000
```

```
## #################### Skip a year!!!! 
## ****************Year= 2001 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2001
```

```
## #################### Skip a year!!!! 
## ****************Year= 2002 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2002
```

```
## #################### Skip a year!!!! 
## ****************Year= 2003 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2003
```

```
## #################### Skip a year!!!! 
## ****************Year= 2004 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2004
```

```
## #################### Skip a year!!!! 
## ****************Year= 2005 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2005
```

```
## #################### Skip a year!!!! 
## ****************Year= 2006 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2006
```

```
## #################### Skip a year!!!! 
## ****************Year= 2007 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2007
```

```
## #################### Skip a year!!!! 
## ****************Year= 2008 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2008
```

```
## #################### Skip a year!!!! 
## ****************Year= 2009 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2009
```

```
## #################### Skip a year!!!! 
## ****************Year= 2010 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2010
```

```
## #################### Skip a year!!!! 
## ****************Year= 2011 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2011
```

```
## #################### Skip a year!!!! 
## ****************Year= 2012 Observation= 269 **********************
## ****************Year= 2013 Observation= 345 **********************
## ****************Year= 2014 Observation= 334 **********************
## ****************Year= 2015 Observation= 361 **********************
## 
## 'data.frame':	43 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 ...
##  $ StartD      : num  144 163 164 155 141 157 154 157 150 128 ...
##  $ EndD        : num  219 239 267 252 231 236 250 230 251 209 ...
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
## elapsed time is 18.140000 seconds 
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/north/23376099999 SVETLOGORSK.txt"
## The number of deleted rows by column precipitation= 39 
## The number of deleted rows by column temp= 0 
##      Day Month Year PRECIP  TMEAN
## 1163  25    12 2015      0 -30.67
## 1164  26    12 2015      0 -24.78
## 1165  28    12 2015      0 -19.44
## 1166  29    12 2015      0 -18.22
## 1167  30    12 2015      0 -16.39
## 1168  31    12 2015      0 -25.28
## 'data.frame':	1129 obs. of  5 variables:
##  $ Day   : int  28 30 31 1 2 3 4 5 6 7 ...
##  $ Month : int  3 3 3 4 4 4 4 4 4 4 ...
##  $ Year  : int  2012 2012 2012 2012 2012 2012 2012 2012 2012 2012 ...
##  $ PRECIP: num  0 0.51 0.25 1.52 0 2.03 0 0.76 0.51 0.51 ...
##  $ TMEAN : num  -12 -2.56 -2 -3.11 -8.67 -0.44 2.33 -4.44 -7.83 -7.78 ...
## NULL
##      PRECIP            TMEAN        
##  Min.   : 0.0000   Min.   :-51.110  
##  1st Qu.: 0.0000   1st Qu.:-18.830  
##  Median : 0.0000   Median : -3.390  
##  Mean   : 0.8574   Mean   : -5.642  
##  3rd Qu.: 0.2500   3rd Qu.:  8.560  
##  Max.   :24.8900   Max.   : 26.280  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 2012 Observation= 269 **********************
## ****************Year= 2013 Observation= 331 **********************
## ****************Year= 2014 Observation= 260 **********************
## ****************Year= 2015 Observation= 269 **********************
## 
## 'data.frame':	4 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365"
##  $ Year        : int  2012 2013 2014 2015
##  $ StartD      : num  60 141 105 69
##  $ EndD        : num  178 246 180 168
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
## elapsed time is 2.200000 seconds 
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/north/24125099999 OLENEK.txt"
## The number of deleted rows by column precipitation= 369 
## The number of deleted rows by column temp= 0 
##       Day Month Year PRECIP  TMEAN
## 11900   3    11 2000   0.51 -22.56
## 11901   4    11 2000   1.52 -26.83
## 11902   5    11 2000   0.76 -25.89
## 11903   6    11 2000   0.76 -25.39
## 11904   7    11 2000   0.76 -20.78
## 11905   8    11 2000   0.00 -28.78
## 'data.frame':	11536 obs. of  5 variables:
##  $ Day   : int  4 5 6 7 8 9 10 11 12 13 ...
##  $ Month : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Year  : int  1962 1962 1962 1962 1962 1962 1962 1962 1962 1962 ...
##  $ PRECIP: num  0 0.25 0.25 0 1.02 1.02 0 0 0 0 ...
##  $ TMEAN : num  -49.2 -42.1 -43.1 -36.4 -19.8 ...
## NULL
##      PRECIP            TMEAN       
##  Min.   :  0.000   Min.   :-57.89  
##  1st Qu.:  0.000   1st Qu.:-28.06  
##  Median :  0.000   Median :-10.00  
##  Mean   :  1.972   Mean   :-11.57  
##  3rd Qu.:  0.510   3rd Qu.:  5.61  
##  Max.   :150.110   Max.   : 26.50  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 1962 Observation= 308 **********************
## ****************Year= 1963 Observation= 296 **********************
## ****************Year= 1964 Observation= 279 **********************
## ****************Year= 1965 Observation= 271 **********************
## ****************Year= 1966 Observation= 339 **********************
## ****************Year= 1967 Observation= 342 **********************
## ****************Year= 1968 Observation= 347 **********************
## ****************Year= 1969 Observation= 330 **********************
## ****************Year= 1970 Observation= 309 **********************
## ****************Year= 1971 Observation= 111 **********************
## WARNING: T2205 num_days=  172 lenYear=  111  
## WARNING: T2205 num_days=  172 lenYear=  111  
## WARNING: FT2205 num_days=  172 lenYear=  111  
## WARNING: FT2205 seasonBegin=  92 seasonEnd=  111  
## WARNING: FT2205 num_days=  172 lenYear=  111  
## WARNING: FT2205 seasonBegin=  92 seasonEnd=  111  
## ****************Year= 1972 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1972
```

```
## #################### Skip a year!!!! 
## ****************Year= 1973 Observation= 306 **********************
## ****************Year= 1974 Observation= 147 **********************
## WARNING: T2205 num_days=  172 lenYear=  147  
## WARNING: T2205 num_days=  172 lenYear=  147  
## WARNING: FT2205 num_days=  172 lenYear=  147  
## WARNING: FT2205 seasonBegin=  60 seasonEnd=  104  
## WARNING: FT2205 num_days=  172 lenYear=  147  
## WARNING: FT2205 seasonBegin=  60 seasonEnd=  104  
## ****************Year= 1975 Observation= 218 **********************
## ****************Year= 1976 Observation= 245 **********************
## ****************Year= 1977 Observation= 193 **********************
## ****************Year= 1978 Observation= 289 **********************
## ****************Year= 1979 Observation= 308 **********************
## ****************Year= 1980 Observation= 365 **********************
## ****************Year= 1981 Observation= 359 **********************
## ****************Year= 1982 Observation= 351 **********************
## ****************Year= 1983 Observation= 355 **********************
## ****************Year= 1984 Observation= 318 **********************
## ****************Year= 1985 Observation= 325 **********************
## ****************Year= 1986 Observation= 345 **********************
## ****************Year= 1987 Observation= 361 **********************
## ****************Year= 1988 Observation= 362 **********************
## ****************Year= 1989 Observation= 349 **********************
## ****************Year= 1990 Observation= 354 **********************
## ****************Year= 1991 Observation= 297 **********************
## ****************Year= 1992 Observation= 285 **********************
## ****************Year= 1993 Observation= 196 **********************
## ****************Year= 1994 Observation= 252 **********************
## ****************Year= 1995 Observation= 346 **********************
## ****************Year= 1996 Observation= 348 **********************
## ****************Year= 1997 Observation= 343 **********************
## ****************Year= 1998 Observation= 347 **********************
## ****************Year= 1999 Observation= 349 **********************
## ****************Year= 2000 Observation= 291 **********************
## 
## 'data.frame':	39 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1962 1963 1964 1965 1966 1967 1968 1969 1970 1971 ...
##  $ StartD      : num  146 146 116 101 150 138 150 132 139 92 ...
##  $ EndD        : num  236 225 209 190 241 229 240 234 223 111 ...
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
## elapsed time is 23.980000 seconds 
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/north/24136099999 SUHANA.txt"
## The number of deleted rows by column precipitation= 492 
## The number of deleted rows by column temp= 0 
##      Day Month Year PRECIP  TMEAN
## 7155  26    12 2015   1.02 -29.72
## 7156  27    12 2015   0.00 -42.50
## 7157  28    12 2015   0.00 -41.17
## 7158  29    12 2015   0.00 -30.33
## 7159  30    12 2015   0.51 -26.44
## 7160  31    12 2015   0.51 -30.11
## 'data.frame':	6668 obs. of  5 variables:
##  $ Day   : int  1 2 3 6 9 10 11 18 20 23 ...
##  $ Month : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Year  : int  1959 1959 1959 1959 1959 1959 1959 1959 1959 1959 ...
##  $ PRECIP: num  0 0 0 0.25 0 0 0 0.76 0 0 ...
##  $ TMEAN : num  -58.9 -51.7 -53.4 -43.8 -50 ...
## NULL
##      PRECIP            TMEAN       
##  Min.   :  0.000   Min.   :-60.00  
##  1st Qu.:  0.000   1st Qu.:-30.84  
##  Median :  0.000   Median : -7.53  
##  Mean   :  2.494   Mean   :-11.67  
##  3rd Qu.:  0.510   3rd Qu.:  7.17  
##  Max.   :150.110   Max.   : 26.67  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 1959 Observation= 94 **********************
## WARNING: T2205 num_days=  172 lenYear=  94  
## WARNING: T2205 num_days=  172 lenYear=  94  
## WARNING: FT2205 num_days=  172 lenYear=  94  
## WARNING: FT2205 seasonBegin=  27 seasonEnd=  53  
## WARNING: FT2205 num_days=  172 lenYear=  94  
## WARNING: FT2205 seasonBegin=  27 seasonEnd=  53  
## ****************Year= 1960 Observation= 30 **********************
## #################### Skip a year!!!! 
## ****************Year= 1961 Observation= 275 **********************
## ****************Year= 1962 Observation= 301 **********************
## ****************Year= 1963 Observation= 302 **********************
## ****************Year= 1964 Observation= 315 **********************
## ****************Year= 1965 Observation= 172 **********************
## ****************Year= 1966 Observation= 336 **********************
## ****************Year= 1967 Observation= 347 **********************
## ****************Year= 1968 Observation= 349 **********************
## ****************Year= 1969 Observation= 320 **********************
## ****************Year= 1970 Observation= 328 **********************
## ****************Year= 1971 Observation= 144 **********************
## WARNING: T2205 num_days=  172 lenYear=  144  
## WARNING: T2205 num_days=  172 lenYear=  144  
## WARNING: FT2205 num_days=  172 lenYear=  144  
## WARNING: FT2205 seasonBegin=  118 seasonEnd=  144  
## WARNING: FT2205 num_days=  172 lenYear=  144  
## WARNING: FT2205 seasonBegin=  118 seasonEnd=  144  
## ****************Year= 1972 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1972
```

```
## #################### Skip a year!!!! 
## ****************Year= 1973 Observation= 321 **********************
## ****************Year= 1974 Observation= 231 **********************
## ****************Year= 1975 Observation= 168 **********************
## WARNING: T2205 num_days=  172 lenYear=  168  
## WARNING: T2205 num_days=  172 lenYear=  168  
## WARNING: FT2205 num_days=  172 lenYear=  168  
## WARNING: FT2205 seasonBegin=  39 seasonEnd=  120  
## WARNING: FT2205 num_days=  172 lenYear=  168  
## WARNING: FT2205 seasonBegin=  39 seasonEnd=  120  
## ****************Year= 1976 Observation= 159 **********************
## WARNING: T2205 num_days=  173 lenYear=  159  
## WARNING: T2205 num_days=  173 lenYear=  159  
## WARNING: FT2205 num_days=  173 lenYear=  159  
## WARNING: FT2205 seasonBegin=  99 seasonEnd=  155  
## WARNING: FT2205 num_days=  173 lenYear=  159  
## WARNING: FT2205 seasonBegin=  99 seasonEnd=  155  
## ****************Year= 1977 Observation= 44 **********************
## #################### Skip a year!!!! 
## ****************Year= 1978 Observation= 12 **********************
## #################### Skip a year!!!! 
## ****************Year= 1979 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1979
```

```
## #################### Skip a year!!!! 
## ****************Year= 1980 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1980
```

```
## #################### Skip a year!!!! 
## ****************Year= 1981 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1981
```

```
## #################### Skip a year!!!! 
## ****************Year= 1982 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1982
```

```
## #################### Skip a year!!!! 
## ****************Year= 1983 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1983
```

```
## #################### Skip a year!!!! 
## ****************Year= 1984 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1984
```

```
## #################### Skip a year!!!! 
## ****************Year= 1985 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1985
```

```
## #################### Skip a year!!!! 
## ****************Year= 1986 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1986
```

```
## #################### Skip a year!!!! 
## ****************Year= 1987 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1987
```

```
## #################### Skip a year!!!! 
## ****************Year= 1988 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1988
```

```
## #################### Skip a year!!!! 
## ****************Year= 1989 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1989
```

```
## #################### Skip a year!!!! 
## ****************Year= 1990 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1990
```

```
## #################### Skip a year!!!! 
## ****************Year= 1991 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1991
```

```
## #################### Skip a year!!!! 
## ****************Year= 1992 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1992
```

```
## #################### Skip a year!!!! 
## ****************Year= 1993 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1993
```

```
## #################### Skip a year!!!! 
## ****************Year= 1994 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1994
```

```
## #################### Skip a year!!!! 
## ****************Year= 1995 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1995
```

```
## #################### Skip a year!!!! 
## ****************Year= 1996 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1996
```

```
## #################### Skip a year!!!! 
## ****************Year= 1997 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1997
```

```
## #################### Skip a year!!!! 
## ****************Year= 1998 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1998
```

```
## #################### Skip a year!!!! 
## ****************Year= 1999 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1999
```

```
## #################### Skip a year!!!! 
## ****************Year= 2000 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2000
```

```
## #################### Skip a year!!!! 
## ****************Year= 2001 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2001
```

```
## #################### Skip a year!!!! 
## ****************Year= 2002 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2002
```

```
## #################### Skip a year!!!! 
## ****************Year= 2003 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2003
```

```
## #################### Skip a year!!!! 
## ****************Year= 2004 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2004
```

```
## #################### Skip a year!!!! 
## ****************Year= 2005 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2005
```

```
## #################### Skip a year!!!! 
## ****************Year= 2006 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2006
```

```
## #################### Skip a year!!!! 
## ****************Year= 2007 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2007
```

```
## #################### Skip a year!!!! 
## ****************Year= 2008 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2008
```

```
## #################### Skip a year!!!! 
## ****************Year= 2009 Observation= 314 **********************
## ****************Year= 2010 Observation= 334 **********************
## ****************Year= 2011 Observation= 338 **********************
## ****************Year= 2012 Observation= 344 **********************
## ****************Year= 2013 Observation= 363 **********************
## ****************Year= 2014 Observation= 364 **********************
## ****************Year= 2015 Observation= 363 **********************
## 
## 'data.frame':	57 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1959 1960 1961 1962 1963 1964 1965 1966 1967 1968 ...
##  $ StartD      : num  27 -9999 109 132 144 ...
##  $ EndD        : num  53 24 209 219 225 222 110 223 234 249 ...
##  $ STDAT0      : chr  "15-5-1959" "25" "5-6-1961" "16-6-1962" ...
##  $ STDAT5      : chr  "17-6-1959" "26" "12-6-1961" "19-6-1962" ...
##  $ FDAT0       : chr  "22-9-1959" "27" "20-9-1961" "14-9-1962" ...
##  $ FDAT5       : chr  "20-9-1959" "28" "16-9-1961" "12-9-1962" ...
##  $ INTER0      : num  130 29 107 90 89 96 112 94 91 101 ...
##  $ INTER5      : num  95 30 101 87 78 89 95 90 80 94 ...
##  $ MAXT        : num  23.3 31 23.2 24.2 25 ...
##  $ MDAT        : chr  "28-7-1959" "32" "1-7-1961" "31-7-1962" ...
##  $ SUMT0       : num  219 33 1070 1086 1025 ...
##  $ SUMT5       : num  191 34 970 1017 921 ...
##  $ T220        : num  219 35 810 584 413 ...
##  $ T225        : num  191 36 775 541 354 ...
##  $ FT220       : num  219 37 257 508 612 ...
##  $ FT225       : num  191 38 195 491 575 ...
##  $ SPEEDT      : num  -0.8128 39 -0.0258 0.1621 0.2381 ...
##  $ SUMPREC     : num  165 40 1071 743 850 ...
## elapsed time is 12.890000 seconds 
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/north/24143099999 DZARDZAN.txt"
## The number of deleted rows by column precipitation= 449 
## The number of deleted rows by column temp= 0 
##       Day Month Year PRECIP  TMEAN
## 13880   9     1 1996   0.51 -16.44
## 13881  10     1 1996   0.00 -33.61
## 13882  11     1 1996   0.00 -38.39
## 13884  13     1 1996   0.51 -32.56
## 13885  14     1 1996   0.25 -45.56
## 13886  17     1 1996   0.00 -51.89
## 'data.frame':	13437 obs. of  5 variables:
##  $ Day   : int  5 8 10 11 13 15 17 21 27 4 ...
##  $ Month : int  1 1 1 1 1 1 1 1 1 2 ...
##  $ Year  : int  1948 1948 1948 1948 1948 1948 1948 1948 1948 1948 ...
##  $ PRECIP: num  0.51 0.51 0 0 0.51 0.51 0.25 0 0.51 0 ...
##  $ TMEAN : num  -29.7 -23.1 -40 -36.1 -36.1 ...
## NULL
##      PRECIP            TMEAN       
##  Min.   :  0.000   Min.   :-59.33  
##  1st Qu.:  0.000   1st Qu.:-30.17  
##  Median :  0.000   Median :-10.50  
##  Mean   :  1.477   Mean   :-12.06  
##  3rd Qu.:  0.510   3rd Qu.:  6.33  
##  Max.   :150.110   Max.   : 26.28  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 1948 Observation= 26 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1948
```

```
## #################### Skip a year!!!! 
## ****************Year= 1949 Observation= 112 **********************
## WARNING: T2205 num_days=  172 lenYear=  112  
## WARNING: T2205 num_days=  172 lenYear=  112  
## WARNING: FT2205 num_days=  172 lenYear=  112  
## WARNING: FT2205 seasonBegin=  50 seasonEnd=  101  
## WARNING: FT2205 num_days=  172 lenYear=  112  
## WARNING: FT2205 seasonBegin=  50 seasonEnd=  101  
## ****************Year= 1950 Observation= 209 **********************
## ****************Year= 1951 Observation= 167 **********************
## WARNING: T2205 num_days=  172 lenYear=  167  
## WARNING: T2205 num_days=  172 lenYear=  167  
## WARNING: FT2205 num_days=  172 lenYear=  167  
## WARNING: FT2205 seasonBegin=  78 seasonEnd=  132  
## WARNING: FT2205 num_days=  172 lenYear=  167  
## WARNING: FT2205 seasonBegin=  78 seasonEnd=  132  
## ****************Year= 1952 Observation= 216 **********************
## ****************Year= 1953 Observation= 73 **********************
## WARNING: T2205 num_days=  172 lenYear=  73  
## WARNING: T2205 num_days=  172 lenYear=  73  
## WARNING: FT2205 num_days=  172 lenYear=  73  
## WARNING: FT2205 seasonBegin=  47 seasonEnd=  62  
## WARNING: FT2205 num_days=  172 lenYear=  73  
## WARNING: FT2205 seasonBegin=  47 seasonEnd=  62  
## ****************Year= 1954 Observation= 89 **********************
## WARNING: T2205 num_days=  172 lenYear=  89  
## WARNING: T2205 num_days=  172 lenYear=  89  
## WARNING: FT2205 num_days=  172 lenYear=  89  
## WARNING: FT2205 seasonBegin=  32 seasonEnd=  85  
## WARNING: FT2205 num_days=  172 lenYear=  89  
## WARNING: FT2205 seasonBegin=  32 seasonEnd=  85  
## ****************Year= 1955 Observation= 200 **********************
## ****************Year= 1956 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1956
```

```
## #################### Skip a year!!!! 
## ****************Year= 1957 Observation= 110 **********************
## WARNING: T2205 num_days=  172 lenYear=  110  
## WARNING: T2205 num_days=  172 lenYear=  110  
## WARNING: FT2205 num_days=  172 lenYear=  110  
## WARNING: FT2205 seasonBegin=  1 seasonEnd=  30  
## WARNING: FT2205 num_days=  172 lenYear=  110  
## WARNING: FT2205 seasonBegin=  1 seasonEnd=  30  
## ****************Year= 1958 Observation= 188 **********************
## ****************Year= 1959 Observation= 271 **********************
## ****************Year= 1960 Observation= 276 **********************
## ****************Year= 1961 Observation= 315 **********************
## ****************Year= 1962 Observation= 319 **********************
## ****************Year= 1963 Observation= 337 **********************
## ****************Year= 1964 Observation= 351 **********************
## ****************Year= 1965 Observation= 342 **********************
## ****************Year= 1966 Observation= 360 **********************
## ****************Year= 1967 Observation= 356 **********************
## ****************Year= 1968 Observation= 356 **********************
## ****************Year= 1969 Observation= 346 **********************
## ****************Year= 1970 Observation= 357 **********************
## ****************Year= 1971 Observation= 174 **********************
## ****************Year= 1972 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1972
```

```
## #################### Skip a year!!!! 
## ****************Year= 1973 Observation= 355 **********************
## ****************Year= 1974 Observation= 351 **********************
## ****************Year= 1975 Observation= 357 **********************
## ****************Year= 1976 Observation= 359 **********************
## ****************Year= 1977 Observation= 357 **********************
## ****************Year= 1978 Observation= 361 **********************
## ****************Year= 1979 Observation= 364 **********************
## ****************Year= 1980 Observation= 365 **********************
## ****************Year= 1981 Observation= 359 **********************
## ****************Year= 1982 Observation= 355 **********************
## ****************Year= 1983 Observation= 341 **********************
## ****************Year= 1984 Observation= 324 **********************
## ****************Year= 1985 Observation= 344 **********************
## ****************Year= 1986 Observation= 357 **********************
## ****************Year= 1987 Observation= 359 **********************
## ****************Year= 1988 Observation= 358 **********************
## ****************Year= 1989 Observation= 357 **********************
## ****************Year= 1990 Observation= 362 **********************
## ****************Year= 1991 Observation= 328 **********************
## ****************Year= 1992 Observation= 335 **********************
## ****************Year= 1993 Observation= 305 **********************
## ****************Year= 1994 Observation= 267 **********************
## ****************Year= 1995 Observation= 256 **********************
## ****************Year= 1996 Observation= 11 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1996
```

```
## #################### Skip a year!!!! 
## 
## 'data.frame':	49 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1948 1949 1950 1951 1952 1953 1954 1955 1956 1957 ...
##  $ StartD      : num  -9999 50 92 78 80 ...
##  $ EndD        : num  4 101 173 132 150 62 85 138 164 30 ...
##  $ STDAT0      : chr  "5" "29-5-1949" "28-5-1950" "2-6-1951" ...
##  $ STDAT5      : chr  "6" "15-6-1949" "4-6-1950" "9-6-1951" ...
##  $ FDAT0       : chr  "7" "25-8-1949" "15-9-1950" "30-9-1951" ...
##  $ FDAT5       : chr  "8" "25-8-1949" "28-8-1950" "28-9-1951" ...
##  $ INTER0      : num  9 88 110 120 103 124 120 112 169 64 ...
##  $ INTER5      : num  10 87 92 113 102 101 94 89 170 55 ...
##  $ MAXT        : num  11 22.2 21.3 20.8 24.4 ...
##  $ MDAT        : chr  "12" "15-7-1949" "3-7-1950" "12-7-1951" ...
##  $ SUMT0       : num  13 557 809 615 901 ...
##  $ SUMT5       : num  14 544 751 579 860 ...
##  $ T220        : num  15 557 806 615 901 ...
##  $ T225        : num  16 544 751 579 860 ...
##  $ FT220       : num  17 556.86 1.16 615.17 0 ...
##  $ FT225       : num  18 544 0 579 0 ...
##  $ SPEEDT      : num  19 -0.6492 -0.0353 -0.6051 -0.3957 ...
##  $ SUMPREC     : num  20 61.2 139.7 54.9 92.5 ...
## elapsed time is 26.880000 seconds 
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/north/24152099999 VERKHOYANSK RANGE.txt"
## The number of deleted rows by column precipitation= 93 
## The number of deleted rows by column temp= 0 
##      Day Month Year PRECIP  TMEAN
## 1156  25    12 1963   0.00 -28.44
## 1157  26    12 1963   0.00 -24.11
## 1158  27    12 1963   0.51 -29.17
## 1159  28    12 1963   0.51 -41.00
## 1161  30    12 1963   0.25 -42.22
## 1162  31    12 1963   0.25 -43.17
## 'data.frame':	1069 obs. of  5 variables:
##  $ Day   : int  1 3 4 5 6 7 10 11 12 13 ...
##  $ Month : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Year  : int  1959 1959 1959 1959 1959 1959 1959 1959 1959 1959 ...
##  $ PRECIP: num  0 0.25 0.25 0.51 0.25 0 0 0 0 0.25 ...
##  $ TMEAN : num  -43.6 -40.8 -38.7 -43.1 -41.7 ...
## NULL
##      PRECIP            TMEAN       
##  Min.   :  0.000   Min.   :-53.44  
##  1st Qu.:  0.000   1st Qu.:-31.11  
##  Median :  0.000   Median :-11.28  
##  Mean   :  5.528   Mean   :-12.91  
##  3rd Qu.:  1.020   3rd Qu.:  5.72  
##  Max.   :150.110   Max.   : 24.28  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 1959 Observation= 83 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1959
```

```
## #################### Skip a year!!!! 
## ****************Year= 1960 Observation= 56 **********************
## #################### Skip a year!!!! 
## ****************Year= 1961 Observation= 320 **********************
## ****************Year= 1962 Observation= 290 **********************
## ****************Year= 1963 Observation= 320 **********************
## 
## 'data.frame':	5 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1959 1960 1961 1962 1963
##  $ StartD      : num  -9999 -9999 137 115 131
##  $ EndD        : num  4 24 237 134 234
##  $ STDAT0      : chr  "5" "25" "4-6-1961" "28-5-1962" ...
##  $ STDAT5      : chr  "6" "26" "8-6-1961" "1-6-1962" ...
##  $ FDAT0       : chr  "7" "27" "20-9-1961" "16-6-1962" ...
##  $ FDAT5       : chr  "8" "28" "18-9-1961" "14-6-1962" ...
##  $ INTER0      : num  9 29 108 19 104
##  $ INTER5      : num  10 30 104 17 103
##  $ MAXT        : num  11 31 22.8 22.7 24.3
##  $ MDAT        : chr  "12" "32" "1-7-1961" "30-7-1962" ...
##  $ SUMT0       : num  13 33 1178 1103 1146
##  $ SUMT5       : num  14 34 1119 1050 1083
##  $ T220        : num  15 35 535 670 387
##  $ T225        : num  16 36 502 628 362
##  $ FT220       : num  17 37 650 520 750
##  $ FT225       : num  18 38 626 517 721
##  $ SPEEDT      : num  19 39 0.2116 0.1881 0.0657
##  $ SUMPREC     : num  20 40 673.1 25.6 1078
## elapsed time is 1.990000 seconds 
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/north/38401099999 IGARKA.txt"
## The number of deleted rows by column precipitation= 1628 
## The number of deleted rows by column temp= 0 
##      Day Month Year PRECIP TMEAN
## 2709  10     6 2013      0 10.83
## 2710  11     6 2013      0 12.22
## 2711  12     6 2013      0 17.06
## 2712  13     6 2013      0 20.56
## 2717  18     7 2013      0 22.83
## 2718  19     7 2013      0 25.67
## 'data.frame':	1090 obs. of  5 variables:
##  $ Day   : int  24 30 3 4 5 10 14 19 20 23 ...
##  $ Month : int  8 8 9 9 9 9 9 9 9 9 ...
##  $ Year  : int  2004 2004 2004 2004 2004 2004 2004 2004 2004 2004 ...
##  $ PRECIP: num  0 0 0 0 0 0 0 0 0 0 ...
##  $ TMEAN : num  6.22 5.94 10.44 9 7.89 ...
## NULL
##      PRECIP      TMEAN        
##  Min.   :0   Min.   :-51.060  
##  1st Qu.:0   1st Qu.:-18.207  
##  Median :0   Median : -0.860  
##  Mean   :0   Mean   : -4.808  
##  3rd Qu.:0   3rd Qu.: 10.375  
##  Max.   :0   Max.   : 26.110  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 2004 Observation= 22 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2004
```

```
## #################### Skip a year!!!! 
## ****************Year= 2005 Observation= 78 **********************
## WARNING: T2205 num_days=  172 lenYear=  78  
## WARNING: T2205 num_days=  172 lenYear=  78  
## WARNING: FT2205 num_days=  172 lenYear=  78  
## WARNING: FT2205 seasonBegin=  16 seasonEnd=  74  
## WARNING: FT2205 num_days=  172 lenYear=  78  
## WARNING: FT2205 seasonBegin=  16 seasonEnd=  74  
## ****************Year= 2006 Observation= 124 **********************
## WARNING: T2205 num_days=  172 lenYear=  124  
## WARNING: T2205 num_days=  172 lenYear=  124  
## WARNING: FT2205 num_days=  172 lenYear=  124  
## WARNING: FT2205 seasonBegin=  49 seasonEnd=  111  
## WARNING: FT2205 num_days=  172 lenYear=  124  
## WARNING: FT2205 seasonBegin=  49 seasonEnd=  111  
## ****************Year= 2007 Observation= 140 **********************
## WARNING: T2205 num_days=  172 lenYear=  140  
## WARNING: T2205 num_days=  172 lenYear=  140  
## WARNING: FT2205 num_days=  172 lenYear=  140  
## WARNING: FT2205 seasonBegin=  56 seasonEnd=  114  
## WARNING: FT2205 num_days=  172 lenYear=  140  
## WARNING: FT2205 seasonBegin=  56 seasonEnd=  114  
## ****************Year= 2008 Observation= 138 **********************
## WARNING: T2205 num_days=  173 lenYear=  138  
## WARNING: T2205 num_days=  173 lenYear=  138  
## WARNING: FT2205 num_days=  173 lenYear=  138  
## WARNING: FT2205 seasonBegin=  55 seasonEnd=  112  
## WARNING: FT2205 num_days=  173 lenYear=  138  
## WARNING: FT2205 seasonBegin=  55 seasonEnd=  112  
## ****************Year= 2009 Observation= 167 **********************
## WARNING: T2205 num_days=  172 lenYear=  167  
## WARNING: T2205 num_days=  172 lenYear=  167  
## WARNING: FT2205 num_days=  172 lenYear=  167  
## WARNING: FT2205 seasonBegin=  65 seasonEnd=  134  
## WARNING: FT2205 num_days=  172 lenYear=  167  
## WARNING: FT2205 seasonBegin=  65 seasonEnd=  134  
## ****************Year= 2010 Observation= 151 **********************
## WARNING: T2205 num_days=  172 lenYear=  151  
## WARNING: T2205 num_days=  172 lenYear=  151  
## WARNING: FT2205 num_days=  172 lenYear=  151  
## WARNING: FT2205 seasonBegin=  79 seasonEnd=  115  
## WARNING: FT2205 num_days=  172 lenYear=  151  
## WARNING: FT2205 seasonBegin=  79 seasonEnd=  115  
## ****************Year= 2011 Observation= 89 **********************
## WARNING: T2205 num_days=  172 lenYear=  89  
## WARNING: T2205 num_days=  172 lenYear=  89  
## WARNING: FT2205 num_days=  172 lenYear=  89  
## WARNING: FT2205 seasonBegin=  30 seasonEnd=  86  
## WARNING: FT2205 num_days=  172 lenYear=  89  
## WARNING: FT2205 seasonBegin=  30 seasonEnd=  86  
## ****************Year= 2012 Observation= 118 **********************
## WARNING: T2205 num_days=  173 lenYear=  118  
## WARNING: T2205 num_days=  173 lenYear=  118  
## WARNING: FT2205 num_days=  173 lenYear=  118  
## WARNING: FT2205 seasonBegin=  33 seasonEnd=  93  
## WARNING: FT2205 num_days=  173 lenYear=  118  
## WARNING: FT2205 seasonBegin=  33 seasonEnd=  93  
## ****************Year= 2013 Observation= 63 **********************
## #################### Skip a year!!!! 
## 
## 'data.frame':	10 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  2004 2005 2006 2007 2008 2009 2010 2011 2012 2013
##  $ StartD      : num  -9999 16 49 56 55 ...
##  $ EndD        : num  4 74 111 114 112 134 115 86 93 184
##  $ STDAT0      : chr  "5" "13-5-2005" "29-5-2006" "27-5-2007" ...
##  $ STDAT5      : chr  "6" "30-5-2005" "4-6-2006" "11-6-2007" ...
##  $ FDAT0       : chr  "7" "22-9-2005" "25-9-2006" "26-9-2007" ...
##  $ FDAT5       : chr  "8" "22-9-2005" "18-9-2006" "20-9-2007" ...
##  $ INTER0      : num  9 132 119 122 125 128 119 149 125 189
##  $ INTER5      : num  10 125 111 116 105 112 95 142 115 190
##  $ MAXT        : num  11 22.4 21.8 26.1 21 ...
##  $ MDAT        : chr  "12" "25-7-2005" "24-7-2006" "6-7-2007" ...
##  $ SUMT0       : num  13 728 722 747 697 ...
##  $ SUMT5       : num  14 705 700 715 677 ...
##  $ T220        : num  15 728 722 747 697 ...
##  $ T225        : num  16 705 700 715 677 ...
##  $ FT220       : num  17 728 722 747 697 ...
##  $ FT225       : num  18 705 700 715 677 ...
##  $ SPEEDT      : num  19 -0.328 -0.516 -0.488 -0.488 ...
##  $ SUMPREC     : num  20 0 0 0 0 0 0 0 0 200
## elapsed time is 3.350000 seconds
```

```r
par.yenisei <- cli2par(paste0(mm_path, "/cli/yenisei/"), yenisei.files, info = TRUE)
```

```
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/yenisei/23066099999 UST PORT UST ENISEISK.txt"
## The number of deleted rows by column precipitation= 127 
## The number of deleted rows by column temp= 0 
##      Day Month Year PRECIP  TMEAN
## 1016   3    12 1955      0 -37.94
## 1017   7    12 1955      0 -38.78
## 1018  10    12 1955      0 -42.94
## 1019  12    12 1955      0 -40.56
## 1020  14    12 1955      0 -41.94
## 1021  16    12 1955      0 -26.94
## 'data.frame':	896 obs. of  5 variables:
##  $ Day   : int  11 27 5 7 12 13 17 23 24 11 ...
##  $ Month : int  1 1 2 3 3 3 3 6 12 1 ...
##  $ Year  : int  1948 1948 1948 1948 1948 1948 1948 1948 1948 1949 ...
##  $ PRECIP: num  0 0.25 0 0.51 1.02 1.02 0 0 0.51 0.51 ...
##  $ TMEAN : num  -40.1 -18.2 -36 -32.1 -14.7 ...
## NULL
##      PRECIP            TMEAN        
##  Min.   :  0.000   Min.   :-45.560  
##  1st Qu.:  0.000   1st Qu.:-23.060  
##  Median :  0.510   Median : -7.085  
##  Mean   :  1.186   Mean   : -9.466  
##  3rd Qu.:  1.020   3rd Qu.:  3.610  
##  Max.   :100.080   Max.   : 22.780  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 1948 Observation= 9 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1948
```

```
## #################### Skip a year!!!! 
## ****************Year= 1949 Observation= 101 **********************
## WARNING: T2205 num_days=  172 lenYear=  101  
## WARNING: T2205 num_days=  172 lenYear=  101  
## WARNING: FT2205 num_days=  172 lenYear=  101  
## WARNING: FT2205 seasonBegin=  16 seasonEnd=  45  
## WARNING: FT2205 num_days=  172 lenYear=  101  
## WARNING: FT2205 seasonBegin=  16 seasonEnd=  45  
## ****************Year= 1950 Observation= 155 **********************
## WARNING: T2205 num_days=  172 lenYear=  155  
## WARNING: T2205 num_days=  172 lenYear=  155  
## WARNING: FT2205 num_days=  172 lenYear=  155  
## WARNING: FT2205 seasonBegin=  93 seasonEnd=  125  
## WARNING: FT2205 num_days=  172 lenYear=  155  
## WARNING: FT2205 seasonBegin=  93 seasonEnd=  125  
## ****************Year= 1951 Observation= 164 **********************
## WARNING: T2205 num_days=  172 lenYear=  164  
## WARNING: T2205 num_days=  172 lenYear=  164  
## WARNING: FT2205 num_days=  172 lenYear=  164  
## WARNING: FT2205 seasonBegin=  72 seasonEnd=  115  
## WARNING: FT2205 num_days=  172 lenYear=  164  
## WARNING: FT2205 seasonBegin=  72 seasonEnd=  115  
## ****************Year= 1952 Observation= 156 **********************
## WARNING: T2205 num_days=  173 lenYear=  156  
## WARNING: T2205 num_days=  173 lenYear=  156  
## WARNING: FT2205 num_days=  173 lenYear=  156  
## WARNING: FT2205 seasonBegin=  75 seasonEnd=  124  
## WARNING: FT2205 num_days=  173 lenYear=  156  
## WARNING: FT2205 seasonBegin=  75 seasonEnd=  124  
## ****************Year= 1953 Observation= 108 **********************
## WARNING: T2205 num_days=  172 lenYear=  108  
## WARNING: T2205 num_days=  172 lenYear=  108  
## WARNING: FT2205 num_days=  172 lenYear=  108  
## WARNING: FT2205 seasonBegin=  56 seasonEnd=  86  
## WARNING: FT2205 num_days=  172 lenYear=  108  
## WARNING: FT2205 seasonBegin=  56 seasonEnd=  86  
## ****************Year= 1954 Observation= 145 **********************
## WARNING: T2205 num_days=  172 lenYear=  145  
## WARNING: T2205 num_days=  172 lenYear=  145  
## WARNING: FT2205 num_days=  172 lenYear=  145  
## WARNING: FT2205 seasonBegin=  80 seasonEnd=  121  
## WARNING: FT2205 num_days=  172 lenYear=  145  
## WARNING: FT2205 seasonBegin=  80 seasonEnd=  121  
## ****************Year= 1955 Observation= 58 **********************
## #################### Skip a year!!!! 
## 
## 'data.frame':	8 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1948 1949 1950 1951 1952 1953 1954 1955
##  $ StartD      : num  -9999 16 93 72 75 ...
##  $ EndD        : num  4 45 125 115 124 86 121 144
##  $ STDAT0      : chr  "5" "9-7-1949" "13-6-1950" "19-6-1951" ...
##  $ STDAT5      : chr  "6" "9-7-1949" "28-7-1950" "6-7-1951" ...
##  $ FDAT0       : chr  "7" "16-9-1949" "24-9-1950" "7-9-1951" ...
##  $ FDAT5       : chr  "8" "11-9-1949" "24-9-1950" "1-9-1951" ...
##  $ INTER0      : num  9 69 103 80 94 97 89 149
##  $ INTER5      : num  10 64 97 70 85 74 77 150
##  $ MAXT        : num  11 20 15.1 18.1 17.1 ...
##  $ MDAT        : chr  "12" "4-8-1949" "29-7-1950" "29-7-1951" ...
##  $ SUMT0       : num  13 246 239 439 464 ...
##  $ SUMT5       : num  14 223 194 387 402 ...
##  $ T220        : num  15 246 239 439 464 ...
##  $ T225        : num  16 223 194 387 402 ...
##  $ FT220       : num  17 246 239 439 464 ...
##  $ FT225       : num  18 223 194 387 402 ...
##  $ SPEEDT      : num  19 -0.55 -0.639 -0.402 -0.616 ...
##  $ SUMPREC     : num  20 80.8 72.4 99.6 99.6 ...
## elapsed time is 2.590000 seconds 
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/yenisei/23078099999 NORIL'SK.txt"
## The number of deleted rows by column precipitation= 426 
## The number of deleted rows by column temp= 0 
##      Day Month Year PRECIP  TMEAN
## 8377  26    12 2015   0.00 -28.56
## 8378  27    12 2015   0.00 -26.61
## 8379  28    12 2015   0.25 -26.78
## 8380  29    12 2015   0.00 -29.00
## 8381  30    12 2015   0.00 -26.39
## 8382  31    12 2015   0.00 -24.11
## 'data.frame':	7956 obs. of  5 variables:
##  $ Day   : int  4 22 23 25 26 27 28 29 30 31 ...
##  $ Month : int  10 10 10 10 10 10 10 10 10 10 ...
##  $ Year  : int  1975 1975 1975 1975 1975 1975 1975 1975 1975 1975 ...
##  $ PRECIP: num  0 0.76 0 0 0 0.25 2.03 0.25 0.51 0 ...
##  $ TMEAN : num  -3.78 -16.89 -21.39 -27.83 -17.28 ...
## NULL
##      PRECIP           TMEAN       
##  Min.   :  0.00   Min.   :-52.50  
##  1st Qu.:  0.00   1st Qu.:-22.22  
##  Median :  0.00   Median : -8.78  
##  Mean   :  1.19   Mean   : -9.06  
##  3rd Qu.:  1.02   3rd Qu.:  5.17  
##  Max.   :141.99   Max.   : 26.61  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 1975 Observation= 67 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1975
```

```
## #################### Skip a year!!!! 
## ****************Year= 1976 Observation= 343 **********************
## ****************Year= 1977 Observation= 325 **********************
## ****************Year= 1978 Observation= 319 **********************
## ****************Year= 1979 Observation= 332 **********************
## ****************Year= 1980 Observation= 342 **********************
## ****************Year= 1981 Observation= 350 **********************
## ****************Year= 1982 Observation= 316 **********************
## ****************Year= 1983 Observation= 336 **********************
## ****************Year= 1984 Observation= 303 **********************
## ****************Year= 1985 Observation= 351 **********************
## ****************Year= 1986 Observation= 347 **********************
## ****************Year= 1987 Observation= 359 **********************
## ****************Year= 1988 Observation= 365 **********************
## ****************Year= 1989 Observation= 358 **********************
## ****************Year= 1990 Observation= 358 **********************
## ****************Year= 1991 Observation= 307 **********************
## ****************Year= 1992 Observation= 236 **********************
## ****************Year= 1993 Observation= 351 **********************
## ****************Year= 1994 Observation= 347 **********************
## ****************Year= 1995 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1995
```

```
## #################### Skip a year!!!! 
## ****************Year= 1996 Observation= 87 **********************
## WARNING: T2205 num_days=  173 lenYear=  87  
## WARNING: T2205 num_days=  173 lenYear=  87  
## WARNING: FT2205 num_days=  173 lenYear=  87  
## WARNING: FT2205 seasonBegin=  17 seasonEnd=  61  
## WARNING: FT2205 num_days=  173 lenYear=  87  
## WARNING: FT2205 seasonBegin=  17 seasonEnd=  61  
## ****************Year= 1997 Observation= 132 **********************
## WARNING: T2205 num_days=  172 lenYear=  132  
## WARNING: T2205 num_days=  172 lenYear=  132  
## WARNING: FT2205 num_days=  172 lenYear=  132  
## WARNING: FT2205 seasonBegin=  70 seasonEnd=  110  
## WARNING: FT2205 num_days=  172 lenYear=  132  
## WARNING: FT2205 seasonBegin=  70 seasonEnd=  110  
## ****************Year= 1998 Observation= 64 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1998
```

```
## #################### Skip a year!!!! 
## ****************Year= 1999 Observation= 8 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1999
```

```
## #################### Skip a year!!!! 
## ****************Year= 2000 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2000
```

```
## #################### Skip a year!!!! 
## ****************Year= 2001 Observation= 10 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2001
```

```
## #################### Skip a year!!!! 
## ****************Year= 2002 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2002
```

```
## #################### Skip a year!!!! 
## ****************Year= 2003 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2003
```

```
## #################### Skip a year!!!! 
## ****************Year= 2004 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2004
```

```
## #################### Skip a year!!!! 
## ****************Year= 2005 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2005
```

```
## #################### Skip a year!!!! 
## ****************Year= 2006 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2006
```

```
## #################### Skip a year!!!! 
## ****************Year= 2007 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2007
```

```
## #################### Skip a year!!!! 
## ****************Year= 2008 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2008
```

```
## #################### Skip a year!!!! 
## ****************Year= 2009 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2009
```

```
## #################### Skip a year!!!! 
## ****************Year= 2010 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2010
```

```
## #################### Skip a year!!!! 
## ****************Year= 2011 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2011
```

```
## #################### Skip a year!!!! 
## ****************Year= 2012 Observation= 298 **********************
## ****************Year= 2013 Observation= 319 **********************
## ****************Year= 2014 Observation= 278 **********************
## ****************Year= 2015 Observation= 348 **********************
## 
## 'data.frame':	41 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1975 1976 1977 1978 1979 1980 1981 1982 1983 1984 ...
##  $ StartD      : num  -9999 160 146 146 151 ...
##  $ EndD        : num  4 253 239 218 242 236 256 226 255 236 ...
##  $ STDAT0      : chr  "5" "14-6-1976" "15-6-1977" "20-6-1978" ...
##  $ STDAT5      : chr  "6" "21-6-1976" "22-6-1977" "26-6-1978" ...
##  $ FDAT0       : chr  "7" "22-9-1976" "23-9-1977" "13-9-1978" ...
##  $ FDAT5       : chr  "8" "13-9-1976" "20-9-1977" "9-9-1978" ...
##  $ INTER0      : num  9 100 100 85 99 81 98 95 114 112 ...
##  $ INTER5      : num  10 91 97 77 94 73 95 94 109 97 ...
##  $ MAXT        : num  11 22 22.6 23.8 26.6 ...
##  $ MDAT        : chr  "12" "27-6-1976" "28-6-1977" "14-7-1978" ...
##  $ SUMT0       : num  13 1069 1071 963 1169 ...
##  $ SUMT5       : num  14 988 963 875 1101 ...
##  $ T220        : num  15 220 427 457 269 ...
##  $ T225        : num  16 176 354 411 232 ...
##  $ FT220       : num  17 861 658 505 878 ...
##  $ FT225       : num  18 828 623 482 861 ...
##  $ SPEEDT      : num  19 1.285 0.202 0.537 0.424 ...
##  $ SUMPREC     : num  20 185 112 50 233 ...
## elapsed time is 16.610000 seconds 
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/yenisei/23179099999 SNEZHNOGORSK.txt"
## The number of deleted rows by column precipitation= 289 
## The number of deleted rows by column temp= 0 
##      Day Month Year PRECIP  TMEAN
## 8461  26    12 2015   0.00 -26.39
## 8462  27    12 2015   0.00 -26.56
## 8463  28    12 2015   0.00 -24.83
## 8464  29    12 2015   2.29 -20.39
## 8465  30    12 2015   0.51 -20.17
## 8466  31    12 2015   0.00 -28.61
## 'data.frame':	8177 obs. of  5 variables:
##  $ Day   : int  1 2 5 6 7 8 9 10 12 14 ...
##  $ Month : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Year  : int  1973 1973 1973 1973 1973 1973 1973 1973 1973 1973 ...
##  $ PRECIP: num  2.03 3.05 1.27 1.02 2.29 1.52 1.02 2.54 0.25 2.03 ...
##  $ TMEAN : num  -15 -16 -13.8 -22.8 -22 ...
## NULL
##      PRECIP          TMEAN        
##  Min.   : 0.00   Min.   :-52.830  
##  1st Qu.: 0.00   1st Qu.:-21.330  
##  Median : 0.25   Median : -7.220  
##  Mean   : 1.38   Mean   : -8.241  
##  3rd Qu.: 1.52   3rd Qu.:  5.780  
##  Max.   :99.06   Max.   : 26.170  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 1973 Observation= 318 **********************
## ****************Year= 1974 Observation= 338 **********************
## ****************Year= 1975 Observation= 358 **********************
## ****************Year= 1976 Observation= 339 **********************
## ****************Year= 1977 Observation= 318 **********************
## ****************Year= 1978 Observation= 338 **********************
## ****************Year= 1979 Observation= 334 **********************
## ****************Year= 1980 Observation= 335 **********************
## ****************Year= 1981 Observation= 340 **********************
## ****************Year= 1982 Observation= 298 **********************
## ****************Year= 1983 Observation= 335 **********************
## ****************Year= 1984 Observation= 306 **********************
## ****************Year= 1985 Observation= 349 **********************
## ****************Year= 1986 Observation= 345 **********************
## ****************Year= 1987 Observation= 358 **********************
## ****************Year= 1988 Observation= 359 **********************
## ****************Year= 1989 Observation= 356 **********************
## ****************Year= 1990 Observation= 359 **********************
## ****************Year= 1991 Observation= 305 **********************
## ****************Year= 1992 Observation= 114 **********************
## WARNING: T2205 num_days=  173 lenYear=  114  
## WARNING: T2205 num_days=  173 lenYear=  114  
## WARNING: FT2205 num_days=  173 lenYear=  114  
## WARNING: FT2205 seasonBegin=  37 seasonEnd=  70  
## WARNING: FT2205 num_days=  173 lenYear=  114  
## WARNING: FT2205 seasonBegin=  37 seasonEnd=  70  
## ****************Year= 1993 Observation= 192 **********************
## ****************Year= 1994 Observation= 174 **********************
## ****************Year= 1995 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1995
```

```
## #################### Skip a year!!!! 
## ****************Year= 1996 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1996
```

```
## #################### Skip a year!!!! 
## ****************Year= 1997 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1997
```

```
## #################### Skip a year!!!! 
## ****************Year= 1998 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1998
```

```
## #################### Skip a year!!!! 
## ****************Year= 1999 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1999
```

```
## #################### Skip a year!!!! 
## ****************Year= 2000 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2000
```

```
## #################### Skip a year!!!! 
## ****************Year= 2001 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2001
```

```
## #################### Skip a year!!!! 
## ****************Year= 2002 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2002
```

```
## #################### Skip a year!!!! 
## ****************Year= 2003 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2003
```

```
## #################### Skip a year!!!! 
## ****************Year= 2004 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2004
```

```
## #################### Skip a year!!!! 
## ****************Year= 2005 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2005
```

```
## #################### Skip a year!!!! 
## ****************Year= 2006 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2006
```

```
## #################### Skip a year!!!! 
## ****************Year= 2007 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2007
```

```
## #################### Skip a year!!!! 
## ****************Year= 2008 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2008
```

```
## #################### Skip a year!!!! 
## ****************Year= 2009 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2009
```

```
## #################### Skip a year!!!! 
## ****************Year= 2010 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2010
```

```
## #################### Skip a year!!!! 
## ****************Year= 2011 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2011
```

```
## #################### Skip a year!!!! 
## ****************Year= 2012 Observation= 269 **********************
## ****************Year= 2013 Observation= 345 **********************
## ****************Year= 2014 Observation= 334 **********************
## ****************Year= 2015 Observation= 361 **********************
## 
## 'data.frame':	43 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1973 1974 1975 1976 1977 1978 1979 1980 1981 1982 ...
##  $ StartD      : num  144 163 164 155 141 157 154 157 150 128 ...
##  $ EndD        : num  219 239 267 252 231 236 250 230 251 209 ...
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
## elapsed time is 14.880000 seconds 
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/yenisei/23365099999 SIDOROVSK.txt"
## The number of deleted rows by column precipitation= 59 
## The number of deleted rows by column temp= 0 
##      Day Month Year PRECIP  TMEAN
## 7277  15    12 1994   0.51 -32.11
## 7278  18    12 1994   1.02 -23.56
## 7279  22    12 1994   0.00 -39.67
## 7280  23    12 1994   0.00 -42.44
## 7281  28    12 1994   2.03  -8.28
## 7282  31    12 1994   3.56 -10.44
## 'data.frame':	7223 obs. of  5 variables:
##  $ Day   : int  5 18 23 2 4 6 7 9 10 11 ...
##  $ Month : int  8 1 1 8 8 8 8 8 8 8 ...
##  $ Year  : int  1961 1969 1969 1969 1969 1969 1969 1969 1969 1969 ...
##  $ PRECIP: num  1.02 0 0 0 0 1.02 4.06 0 0 0 ...
##  $ TMEAN : num  13.2 -43.3 -38.1 11.8 11.4 ...
## NULL
##      PRECIP            TMEAN        
##  Min.   :  0.000   Min.   :-52.000  
##  1st Qu.:  0.000   1st Qu.:-20.280  
##  Median :  0.250   Median : -6.940  
##  Mean   :  1.388   Mean   : -7.733  
##  3rd Qu.:  1.020   3rd Qu.:  6.000  
##  Max.   :199.900   Max.   : 26.610  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 1961 Observation= 1 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1961
```

```
## #################### Skip a year!!!! 
## ****************Year= 1962 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1962
```

```
## #################### Skip a year!!!! 
## ****************Year= 1963 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1963
```

```
## #################### Skip a year!!!! 
## ****************Year= 1964 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1964
```

```
## #################### Skip a year!!!! 
## ****************Year= 1965 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1965
```

```
## #################### Skip a year!!!! 
## ****************Year= 1966 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1966
```

```
## #################### Skip a year!!!! 
## ****************Year= 1967 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1967
```

```
## #################### Skip a year!!!! 
## ****************Year= 1968 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1968
```

```
## #################### Skip a year!!!! 
## ****************Year= 1969 Observation= 131 **********************
## WARNING: T2205 num_days=  172 lenYear=  131  
## WARNING: T2205 num_days=  172 lenYear=  131  
## WARNING: FT2205 num_days=  172 lenYear=  131  
## WARNING: FT2205 seasonBegin=  3 seasonEnd=  43  
## WARNING: FT2205 num_days=  172 lenYear=  131  
## WARNING: FT2205 seasonBegin=  3 seasonEnd=  43  
## ****************Year= 1970 Observation= 282 **********************
## ****************Year= 1971 Observation= 174 **********************
## ****************Year= 1972 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1972
```

```
## #################### Skip a year!!!! 
## ****************Year= 1973 Observation= 325 **********************
## ****************Year= 1974 Observation= 357 **********************
## ****************Year= 1975 Observation= 350 **********************
## ****************Year= 1976 Observation= 348 **********************
## ****************Year= 1977 Observation= 343 **********************
## ****************Year= 1978 Observation= 352 **********************
## ****************Year= 1979 Observation= 344 **********************
## ****************Year= 1980 Observation= 347 **********************
## ****************Year= 1981 Observation= 319 **********************
## ****************Year= 1982 Observation= 241 **********************
## ****************Year= 1983 Observation= 245 **********************
## ****************Year= 1984 Observation= 272 **********************
## ****************Year= 1985 Observation= 214 **********************
## ****************Year= 1986 Observation= 278 **********************
## ****************Year= 1987 Observation= 352 **********************
## ****************Year= 1988 Observation= 360 **********************
## ****************Year= 1989 Observation= 351 **********************
## ****************Year= 1990 Observation= 357 **********************
## ****************Year= 1991 Observation= 238 **********************
## ****************Year= 1992 Observation= 189 **********************
## ****************Year= 1993 Observation= 244 **********************
## ****************Year= 1994 Observation= 209 **********************
## 
## 'data.frame':	34 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1961 1962 1963 1964 1965 1966 1967 1968 1969 1970 ...
##  $ StartD      : num  -9999 -9999 -9999 -9999 -9999 ...
##  $ EndD        : num  4 24 44 64 84 104 124 144 43 210 ...
##  $ STDAT0      : chr  "5" "25" "45" "65" ...
##  $ STDAT5      : chr  "6" "26" "46" "66" ...
##  $ FDAT0       : chr  "7" "27" "47" "67" ...
##  $ FDAT5       : chr  "8" "28" "48" "68" ...
##  $ INTER0      : num  9 29 49 69 89 109 129 149 45 110 ...
##  $ INTER5      : num  10 30 50 70 90 110 130 150 37 108 ...
##  $ MAXT        : num  11 31 51 71 91 ...
##  $ MDAT        : chr  "12" "32" "52" "72" ...
##  $ SUMT0       : num  13 33 53 73 93 ...
##  $ SUMT5       : num  14 34 54 74 94 ...
##  $ T220        : num  15 35 55 75 95 ...
##  $ T225        : num  16 36 56 76 96 ...
##  $ FT220       : num  17 37 57 77 97 ...
##  $ FT225       : num  18 38 58 78 98 ...
##  $ SPEEDT      : num  19 39 59 79 99 ...
##  $ SUMPREC     : num  20 40 60 80 100 ...
## elapsed time is 13.210000 seconds 
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/yenisei/23445099999 NADYM.txt"
## The number of deleted rows by column precipitation= 1112 
## The number of deleted rows by column temp= 0 
##       Day Month Year PRECIP  TMEAN
## 11373  26    12 2015   0.25 -30.06
## 11374  27    12 2015   0.00 -30.89
## 11375  28    12 2015   0.25 -25.28
## 11376  29    12 2015   0.51 -25.50
## 11377  30    12 2015   0.76 -23.72
## 11378  31    12 2015   0.25 -23.33
## 'data.frame':	10266 obs. of  5 variables:
##  $ Day   : int  18 20 22 12 18 19 19 11 18 20 ...
##  $ Month : int  1 1 1 2 2 2 3 4 4 4 ...
##  $ Year  : int  1956 1956 1956 1956 1956 1956 1956 1956 1956 1956 ...
##  $ PRECIP: num  0 0 0 0 0 0 0 0 0 0 ...
##  $ TMEAN : num  -16.9 -16.8 -26.9 -31 -19.2 ...
## NULL
##      PRECIP            TMEAN        
##  Min.   :  0.000   Min.   :-49.330  
##  1st Qu.:  0.000   1st Qu.:-17.000  
##  Median :  0.000   Median : -4.390  
##  Mean   :  2.338   Mean   : -5.593  
##  3rd Qu.:  1.020   3rd Qu.:  7.098  
##  Max.   :150.110   Max.   : 26.670  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 1956 Observation= 21 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1956
```

```
## #################### Skip a year!!!! 
## ****************Year= 1957 Observation= 52 **********************
## #################### Skip a year!!!! 
## ****************Year= 1958 Observation= 60 **********************
## #################### Skip a year!!!! 
## ****************Year= 1959 Observation= 149 **********************
## WARNING: T2205 num_days=  172 lenYear=  149  
## WARNING: T2205 num_days=  172 lenYear=  149  
## WARNING: FT2205 num_days=  172 lenYear=  149  
## WARNING: FT2205 seasonBegin=  69 seasonEnd=  108  
## WARNING: FT2205 num_days=  172 lenYear=  149  
## WARNING: FT2205 seasonBegin=  69 seasonEnd=  108  
## ****************Year= 1960 Observation= 130 **********************
## WARNING: T2205 num_days=  173 lenYear=  130  
## WARNING: T2205 num_days=  173 lenYear=  130  
## WARNING: FT2205 num_days=  173 lenYear=  130  
## WARNING: FT2205 seasonBegin=  66 seasonEnd=  102  
## WARNING: FT2205 num_days=  173 lenYear=  130  
## WARNING: FT2205 seasonBegin=  66 seasonEnd=  102  
## ****************Year= 1961 Observation= 282 **********************
## ****************Year= 1962 Observation= 259 **********************
## ****************Year= 1963 Observation= 241 **********************
## ****************Year= 1964 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1964
```

```
## #################### Skip a year!!!! 
## ****************Year= 1965 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1965
```

```
## #################### Skip a year!!!! 
## ****************Year= 1966 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1966
```

```
## #################### Skip a year!!!! 
## ****************Year= 1967 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1967
```

```
## #################### Skip a year!!!! 
## ****************Year= 1968 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1968
```

```
## #################### Skip a year!!!! 
## ****************Year= 1969 Observation= 330 **********************
## ****************Year= 1970 Observation= 325 **********************
## ****************Year= 1971 Observation= 98 **********************
## WARNING: T2205 num_days=  172 lenYear=  98  
## WARNING: T2205 num_days=  172 lenYear=  98  
## WARNING: FT2205 num_days=  172 lenYear=  98  
## WARNING: FT2205 seasonBegin=  87 seasonEnd=  98  
## WARNING: FT2205 num_days=  172 lenYear=  98  
## WARNING: FT2205 seasonBegin=  87 seasonEnd=  98  
## ****************Year= 1972 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1972
```

```
## #################### Skip a year!!!! 
## ****************Year= 1973 Observation= 265 **********************
## ****************Year= 1974 Observation= 318 **********************
## ****************Year= 1975 Observation= 346 **********************
## ****************Year= 1976 Observation= 323 **********************
## ****************Year= 1977 Observation= 270 **********************
## ****************Year= 1978 Observation= 304 **********************
## ****************Year= 1979 Observation= 298 **********************
## ****************Year= 1980 Observation= 281 **********************
## ****************Year= 1981 Observation= 318 **********************
## ****************Year= 1982 Observation= 213 **********************
## ****************Year= 1983 Observation= 263 **********************
## ****************Year= 1984 Observation= 277 **********************
## ****************Year= 1985 Observation= 337 **********************
## ****************Year= 1986 Observation= 335 **********************
## ****************Year= 1987 Observation= 360 **********************
## ****************Year= 1988 Observation= 360 **********************
## ****************Year= 1989 Observation= 360 **********************
## ****************Year= 1990 Observation= 354 **********************
## ****************Year= 1991 Observation= 263 **********************
## ****************Year= 1992 Observation= 232 **********************
## ****************Year= 1993 Observation= 356 **********************
## ****************Year= 1994 Observation= 255 **********************
## ****************Year= 1995 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1995
```

```
## #################### Skip a year!!!! 
## ****************Year= 1996 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1996
```

```
## #################### Skip a year!!!! 
## ****************Year= 1997 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1997
```

```
## #################### Skip a year!!!! 
## ****************Year= 1998 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1998
```

```
## #################### Skip a year!!!! 
## ****************Year= 1999 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1999
```

```
## #################### Skip a year!!!! 
## ****************Year= 2000 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2000
```

```
## #################### Skip a year!!!! 
## ****************Year= 2001 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2001
```

```
## #################### Skip a year!!!! 
## ****************Year= 2002 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2002
```

```
## #################### Skip a year!!!! 
## ****************Year= 2003 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2003
```

```
## #################### Skip a year!!!! 
## ****************Year= 2004 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2004
```

```
## #################### Skip a year!!!! 
## ****************Year= 2005 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2005
```

```
## #################### Skip a year!!!! 
## ****************Year= 2006 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2006
```

```
## #################### Skip a year!!!! 
## ****************Year= 2007 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2007
```

```
## #################### Skip a year!!!! 
## ****************Year= 2008 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2008
```

```
## #################### Skip a year!!!! 
## ****************Year= 2009 Observation= 131 **********************
## WARNING: T2205 num_days=  172 lenYear=  131  
## WARNING: T2205 num_days=  172 lenYear=  131  
## WARNING: FT2205 num_days=  172 lenYear=  131  
## WARNING: FT2205 seasonBegin=  28 seasonEnd=  104  
## WARNING: FT2205 num_days=  172 lenYear=  131  
## WARNING: FT2205 seasonBegin=  28 seasonEnd=  104  
## ****************Year= 2010 Observation= 169 **********************
## WARNING: T2205 num_days=  172 lenYear=  169  
## WARNING: T2205 num_days=  172 lenYear=  169  
## WARNING: FT2205 num_days=  172 lenYear=  169  
## WARNING: FT2205 seasonBegin=  75 seasonEnd=  132  
## WARNING: FT2205 num_days=  172 lenYear=  169  
## WARNING: FT2205 seasonBegin=  75 seasonEnd=  132  
## ****************Year= 2011 Observation= 129 **********************
## WARNING: T2205 num_days=  172 lenYear=  129  
## WARNING: T2205 num_days=  172 lenYear=  129  
## WARNING: FT2205 num_days=  172 lenYear=  129  
## WARNING: FT2205 seasonBegin=  42 seasonEnd=  115  
## WARNING: FT2205 num_days=  172 lenYear=  129  
## WARNING: FT2205 seasonBegin=  42 seasonEnd=  115  
## ****************Year= 2012 Observation= 227 **********************
## ****************Year= 2013 Observation= 321 **********************
## ****************Year= 2014 Observation= 290 **********************
## ****************Year= 2015 Observation= 364 **********************
## 
## 'data.frame':	60 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1956 1957 1958 1959 1960 1961 1962 1963 1964 1965 ...
##  $ StartD      : num  -9999 -9999 -9999 69 66 ...
##  $ EndD        : num  4 24 44 108 102 209 105 186 164 184 ...
##  $ STDAT0      : chr  "5" "25" "45" "12-5-1959" ...
##  $ STDAT5      : chr  "6" "26" "46" "18-6-1959" ...
##  $ FDAT0       : chr  "7" "27" "47" "5-10-1959" ...
##  $ FDAT5       : chr  "8" "28" "48" "24-9-1959" ...
##  $ INTER0      : num  9 29 49 146 133 105 19 123 169 189 ...
##  $ INTER5      : num  10 30 50 101 117 96 11 119 170 190 ...
##  $ MAXT        : num  11 31 51 20.6 20.4 ...
##  $ MDAT        : chr  "12" "32" "52" "17-7-1959" ...
##  $ SUMT0       : num  13 33 53 383 306 ...
##  $ SUMT5       : num  14 34 54 366 279 ...
##  $ T220        : num  15 35 55 383 306 ...
##  $ T225        : num  16 36 56 366 279 ...
##  $ FT220       : num  17 37 57 383 306 ...
##  $ FT225       : num  18 38 58 366 279 ...
##  $ SPEEDT      : num  19 39 59 -0.59 -0.639 ...
##  $ SUMPREC     : num  20 40 60 376 374 ...
## elapsed time is 18.930000 seconds 
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/yenisei/23453099999 URENGOJ.txt"
## The number of deleted rows by column precipitation= 223 
## The number of deleted rows by column temp= 0 
##      Day Month Year PRECIP  TMEAN
## 2533  26    12 2015   0.00 -36.94
## 2534  27    12 2015   0.00 -31.11
## 2535  28    12 2015   0.00 -27.83
## 2536  29    12 2015   1.02 -24.33
## 2537  30    12 2015   0.00 -26.06
## 2538  31    12 2015   0.00 -23.33
## 'data.frame':	2315 obs. of  5 variables:
##  $ Day   : int  6 7 22 8 17 21 20 7 12 22 ...
##  $ Month : int  8 8 8 9 9 9 10 11 11 1 ...
##  $ Year  : int  1955 1955 1955 1955 1955 1955 1955 1955 1955 1956 ...
##  $ PRECIP: num  0.51 0.51 0 0 0 0.25 6.1 0 0 0 ...
##  $ TMEAN : num  11.94 10.72 12.5 6.78 3.22 ...
## NULL
##      PRECIP            TMEAN       
##  Min.   :  0.000   Min.   :-48.89  
##  1st Qu.:  0.000   1st Qu.:-20.75  
##  Median :  0.000   Median : -7.22  
##  Mean   :  4.905   Mean   : -8.16  
##  3rd Qu.:  1.020   3rd Qu.:  5.28  
##  Max.   :150.110   Max.   : 25.89  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 1955 Observation= 9 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1955
```

```
## #################### Skip a year!!!! 
## ****************Year= 1956 Observation= 23 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1956
```

```
## #################### Skip a year!!!! 
## ****************Year= 1957 Observation= 19 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1957
```

```
## #################### Skip a year!!!! 
## ****************Year= 1958 Observation= 52 **********************
## #################### Skip a year!!!! 
## ****************Year= 1959 Observation= 133 **********************
## WARNING: T2205 num_days=  172 lenYear=  133  
## WARNING: T2205 num_days=  172 lenYear=  133  
## WARNING: FT2205 num_days=  172 lenYear=  133  
## WARNING: FT2205 seasonBegin=  60 seasonEnd=  94  
## WARNING: FT2205 num_days=  172 lenYear=  133  
## WARNING: FT2205 seasonBegin=  60 seasonEnd=  94  
## ****************Year= 1960 Observation= 120 **********************
## WARNING: T2205 num_days=  173 lenYear=  120  
## WARNING: T2205 num_days=  173 lenYear=  120  
## WARNING: FT2205 num_days=  173 lenYear=  120  
## WARNING: FT2205 seasonBegin=  57 seasonEnd=  90  
## WARNING: FT2205 num_days=  173 lenYear=  120  
## WARNING: FT2205 seasonBegin=  57 seasonEnd=  90  
## ****************Year= 1961 Observation= 286 **********************
## ****************Year= 1962 Observation= 271 **********************
## ****************Year= 1963 Observation= 212 **********************
## ****************Year= 1964 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1964
```

```
## #################### Skip a year!!!! 
## ****************Year= 1965 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1965
```

```
## #################### Skip a year!!!! 
## ****************Year= 1966 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1966
```

```
## #################### Skip a year!!!! 
## ****************Year= 1967 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1967
```

```
## #################### Skip a year!!!! 
## ****************Year= 1968 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1968
```

```
## #################### Skip a year!!!! 
## ****************Year= 1969 Observation= 300 **********************
## ****************Year= 1970 Observation= 206 **********************
## ****************Year= 1971 Observation= 8 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1971
```

```
## #################### Skip a year!!!! 
## ****************Year= 1972 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1972
```

```
## #################### Skip a year!!!! 
## ****************Year= 1973 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1973
```

```
## #################### Skip a year!!!! 
## ****************Year= 1974 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1974
```

```
## #################### Skip a year!!!! 
## ****************Year= 1975 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1975
```

```
## #################### Skip a year!!!! 
## ****************Year= 1976 Observation= 1 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1976
```

```
## #################### Skip a year!!!! 
## ****************Year= 1977 Observation= 4 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1977
```

```
## #################### Skip a year!!!! 
## ****************Year= 1978 Observation= 1 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1978
```

```
## #################### Skip a year!!!! 
## ****************Year= 1979 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1979
```

```
## #################### Skip a year!!!! 
## ****************Year= 1980 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1980
```

```
## #################### Skip a year!!!! 
## ****************Year= 1981 Observation= 11 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1981
```

```
## #################### Skip a year!!!! 
## ****************Year= 1982 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1982
```

```
## #################### Skip a year!!!! 
## ****************Year= 1983 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1983
```

```
## #################### Skip a year!!!! 
## ****************Year= 1984 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1984
```

```
## #################### Skip a year!!!! 
## ****************Year= 1985 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1985
```

```
## #################### Skip a year!!!! 
## ****************Year= 1986 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1986
```

```
## #################### Skip a year!!!! 
## ****************Year= 1987 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1987
```

```
## #################### Skip a year!!!! 
## ****************Year= 1988 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1988
```

```
## #################### Skip a year!!!! 
## ****************Year= 1989 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1989
```

```
## #################### Skip a year!!!! 
## ****************Year= 1990 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1990
```

```
## #################### Skip a year!!!! 
## ****************Year= 1991 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1991
```

```
## #################### Skip a year!!!! 
## ****************Year= 1992 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1992
```

```
## #################### Skip a year!!!! 
## ****************Year= 1993 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1993
```

```
## #################### Skip a year!!!! 
## ****************Year= 1994 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1994
```

```
## #################### Skip a year!!!! 
## ****************Year= 1995 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1995
```

```
## #################### Skip a year!!!! 
## ****************Year= 1996 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1996
```

```
## #################### Skip a year!!!! 
## ****************Year= 1997 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1997
```

```
## #################### Skip a year!!!! 
## ****************Year= 1998 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1998
```

```
## #################### Skip a year!!!! 
## ****************Year= 1999 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1999
```

```
## #################### Skip a year!!!! 
## ****************Year= 2000 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2000
```

```
## #################### Skip a year!!!! 
## ****************Year= 2001 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2001
```

```
## #################### Skip a year!!!! 
## ****************Year= 2002 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2002
```

```
## #################### Skip a year!!!! 
## ****************Year= 2003 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2003
```

```
## #################### Skip a year!!!! 
## ****************Year= 2004 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2004
```

```
## #################### Skip a year!!!! 
## ****************Year= 2005 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2005
```

```
## #################### Skip a year!!!! 
## ****************Year= 2006 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2006
```

```
## #################### Skip a year!!!! 
## ****************Year= 2007 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2007
```

```
## #################### Skip a year!!!! 
## ****************Year= 2008 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2008
```

```
## #################### Skip a year!!!! 
## ****************Year= 2009 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2009
```

```
## #################### Skip a year!!!! 
## ****************Year= 2010 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2010
```

```
## #################### Skip a year!!!! 
## ****************Year= 2011 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2011
```

```
## #################### Skip a year!!!! 
## ****************Year= 2012 Observation= 195 **********************
## ****************Year= 2013 Observation= 120 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2013
```

```
## #################### Skip a year!!!! 
## ****************Year= 2014 Observation= 23 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2014
```

```
## #################### Skip a year!!!! 
## ****************Year= 2015 Observation= 321 **********************
## 
## 'data.frame':	61 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1955 1956 1957 1958 1959 1960 1961 1962 1963 1964 ...
##  $ StartD      : num  -9999 -9999 -9999 -9999 60 ...
##  $ EndD        : num  4 24 44 64 94 90 208 218 171 184 ...
##  $ STDAT0      : chr  "5" "25" "45" "65" ...
##  $ STDAT5      : chr  "6" "26" "46" "66" ...
##  $ FDAT0       : chr  "7" "27" "47" "67" ...
##  $ FDAT5       : chr  "8" "28" "48" "68" ...
##  $ INTER0      : num  9 29 49 69 120 125 103 119 125 189 ...
##  $ INTER5      : num  10 30 50 70 107 118 102 109 103 190 ...
##  $ MAXT        : num  11 31 51 71 19.3 ...
##  $ MDAT        : chr  "12" "32" "52" "72" ...
##  $ SUMT0       : num  13 33 53 73 315 ...
##  $ SUMT5       : num  14 34 54 74 308 ...
##  $ T220        : num  15 35 55 75 315 ...
##  $ T225        : num  16 36 56 76 308 ...
##  $ FT220       : num  17 37 57 77 315 ...
##  $ FT225       : num  18 38 58 78 308 ...
##  $ SPEEDT      : num  19 39 59 79 -0.706 ...
##  $ SUMPREC     : num  20 40 60 80 294 ...
## elapsed time is 4.200000 seconds 
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/yenisei/23657099999 NOYABR' SK.txt"
## The number of deleted rows by column precipitation= 189 
## The number of deleted rows by column temp= 0 
##      Day Month Year PRECIP  TMEAN
## 1338  26    12 2015   0.25 -29.11
## 1339  27    12 2015   0.00 -29.17
## 1340  28    12 2015   0.25 -28.72
## 1341  29    12 2015   0.00 -29.11
## 1342  30    12 2015   0.51 -24.22
## 1343  31    12 2015   0.25 -26.11
## 'data.frame':	1154 obs. of  5 variables:
##  $ Day   : int  25 26 27 28 29 30 8 10 11 12 ...
##  $ Month : int  4 4 4 4 4 4 5 5 5 5 ...
##  $ Year  : int  2012 2012 2012 2012 2012 2012 2012 2012 2012 2012 ...
##  $ PRECIP: num  0 0 0 0 0 0 0 0 0 0 ...
##  $ TMEAN : num  -8.67 -7.89 -8.28 -6.72 -2.17 -0.17 -5.78 5.5 8.56 10.5 ...
## NULL
##      PRECIP            TMEAN        
##  Min.   :  0.000   Min.   :-46.610  
##  1st Qu.:  0.000   1st Qu.:-13.170  
##  Median :  0.250   Median : -1.220  
##  Mean   :  1.573   Mean   : -2.574  
##  3rd Qu.:  1.270   3rd Qu.:  9.780  
##  Max.   :109.980   Max.   : 25.170  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 2012 Observation= 198 **********************
## ****************Year= 2013 Observation= 323 **********************
## ****************Year= 2014 Observation= 281 **********************
## ****************Year= 2015 Observation= 352 **********************
## 
## 'data.frame':	4 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365"
##  $ Year        : int  2012 2013 2014 2015
##  $ StartD      : num  9 141 108 115
##  $ EndD        : num  109 243 204 250
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
## elapsed time is 2.310000 seconds 
## [1] "***************************************************************"
## [1] "C:/Users/IVA/Dropbox/24516/transect/cli/yenisei/23788099999 KUZ' MOVKA.txt"
## The number of deleted rows by column precipitation= 559 
## The number of deleted rows by column temp= 0 
##       Day Month Year PRECIP  TMEAN
## 10701  25    12 2015   0.51 -33.06
## 10703  27    12 2015   2.03 -13.50
## 10704  28    12 2015   7.11  -8.00
## 10705  29    12 2015   1.27 -13.56
## 10706  30    12 2015   0.76 -14.17
## 10707  31    12 2015   0.76 -19.56
## 'data.frame':	10148 obs. of  5 variables:
##  $ Day   : int  1 18 24 25 27 10 13 14 15 19 ...
##  $ Month : int  2 2 2 2 2 3 3 3 3 3 ...
##  $ Year  : int  1958 1958 1958 1958 1958 1958 1958 1958 1958 1958 ...
##  $ PRECIP: num  0 0 0 0 0 2.03 0 0 0.76 0 ...
##  $ TMEAN : num  -34.2 -44.7 -37.4 -30.3 -32.9 ...
## NULL
##      PRECIP           TMEAN        
##  Min.   :  0.00   Min.   :-55.500  
##  1st Qu.:  0.00   1st Qu.:-17.625  
##  Median :  0.00   Median : -2.030  
##  Mean   :  2.28   Mean   : -5.347  
##  3rd Qu.:  2.03   3rd Qu.:  8.670  
##  Max.   :150.11   Max.   : 26.000  
## [1] "***************************************************************"
## Start eval16CliPars
## ****************Year= 1958 Observation= 44 **********************
## #################### Skip a year!!!! 
## ****************Year= 1959 Observation= 104 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1959
```

```
## #################### Skip a year!!!! 
## ****************Year= 1960 Observation= 120 **********************
## WARNING: T2205 num_days=  173 lenYear=  120  
## WARNING: T2205 num_days=  173 lenYear=  120  
## WARNING: FT2205 num_days=  173 lenYear=  120  
## WARNING: FT2205 seasonBegin=  61 seasonEnd=  109  
## WARNING: FT2205 num_days=  173 lenYear=  120  
## WARNING: FT2205 seasonBegin=  61 seasonEnd=  109  
## ****************Year= 1961 Observation= 196 **********************
## ****************Year= 1962 Observation= 141 **********************
## WARNING: T2205 num_days=  172 lenYear=  141  
## WARNING: T2205 num_days=  172 lenYear=  141  
## WARNING: FT2205 num_days=  172 lenYear=  141  
## WARNING: FT2205 seasonBegin=  71 seasonEnd=  128  
## WARNING: FT2205 num_days=  172 lenYear=  141  
## WARNING: FT2205 seasonBegin=  71 seasonEnd=  128  
## ****************Year= 1963 Observation= 67 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1963
```

```
## #################### Skip a year!!!! 
## ****************Year= 1964 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1964
```

```
## #################### Skip a year!!!! 
## ****************Year= 1965 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1965
```

```
## #################### Skip a year!!!! 
## ****************Year= 1966 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1966
```

```
## #################### Skip a year!!!! 
## ****************Year= 1967 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1967
```

```
## #################### Skip a year!!!! 
## ****************Year= 1968 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1968
```

```
## #################### Skip a year!!!! 
## ****************Year= 1969 Observation= 351 **********************
## ****************Year= 1970 Observation= 350 **********************
## ****************Year= 1971 Observation= 177 **********************
## ****************Year= 1972 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1972
```

```
## #################### Skip a year!!!! 
## ****************Year= 1973 Observation= 302 **********************
## ****************Year= 1974 Observation= 327 **********************
## ****************Year= 1975 Observation= 356 **********************
## ****************Year= 1976 Observation= 342 **********************
## ****************Year= 1977 Observation= 325 **********************
## ****************Year= 1978 Observation= 324 **********************
## ****************Year= 1979 Observation= 333 **********************
## ****************Year= 1980 Observation= 338 **********************
## ****************Year= 1981 Observation= 345 **********************
## ****************Year= 1982 Observation= 321 **********************
## ****************Year= 1983 Observation= 317 **********************
## ****************Year= 1984 Observation= 300 **********************
## ****************Year= 1985 Observation= 347 **********************
## ****************Year= 1986 Observation= 339 **********************
## ****************Year= 1987 Observation= 353 **********************
## ****************Year= 1988 Observation= 361 **********************
## ****************Year= 1989 Observation= 356 **********************
## ****************Year= 1990 Observation= 357 **********************
## ****************Year= 1991 Observation= 302 **********************
## ****************Year= 1992 Observation= 227 **********************
## ****************Year= 1993 Observation= 348 **********************
## ****************Year= 1994 Observation= 311 **********************
## ****************Year= 1995 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1995
```

```
## #################### Skip a year!!!! 
## ****************Year= 1996 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1996
```

```
## #################### Skip a year!!!! 
## ****************Year= 1997 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1997
```

```
## #################### Skip a year!!!! 
## ****************Year= 1998 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1998
```

```
## #################### Skip a year!!!! 
## ****************Year= 1999 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 1999
```

```
## #################### Skip a year!!!! 
## ****************Year= 2000 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2000
```

```
## #################### Skip a year!!!! 
## ****************Year= 2001 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2001
```

```
## #################### Skip a year!!!! 
## ****************Year= 2002 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2002
```

```
## #################### Skip a year!!!! 
## ****************Year= 2003 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2003
```

```
## #################### Skip a year!!!! 
## ****************Year= 2004 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2004
```

```
## #################### Skip a year!!!! 
## ****************Year= 2005 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2005
```

```
## #################### Skip a year!!!! 
## ****************Year= 2006 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2006
```

```
## #################### Skip a year!!!! 
## ****************Year= 2007 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2007
```

```
## #################### Skip a year!!!! 
## ****************Year= 2008 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2008
```

```
## #################### Skip a year!!!! 
## ****************Year= 2009 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2009
```

```
## #################### Skip a year!!!! 
## ****************Year= 2010 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2010
```

```
## #################### Skip a year!!!! 
## ****************Year= 2011 Observation= 0 **********************
```

```
## Warning in seasonBG(data.cli, period[i]): Invalid begin day Year= 2011
```

```
## #################### Skip a year!!!! 
## ****************Year= 2012 Observation= 298 **********************
## ****************Year= 2013 Observation= 353 **********************
## ****************Year= 2014 Observation= 364 **********************
## ****************Year= 2015 Observation= 352 **********************
## 
## 'data.frame':	58 obs. of  20 variables:
##  $ Station_Code: chr  "23365" "23365" "23365" "23365" ...
##  $ Year        : int  1958 1959 1960 1961 1962 1963 1964 1965 1966 1967 ...
##  $ StartD      : num  -9999 -9999 61 108 71 ...
##  $ EndD        : num  4 24 109 192 128 104 124 144 164 184 ...
##  $ STDAT0      : chr  "5" "25" "18-5-1960" "11-6-1961" ...
##  $ STDAT5      : chr  "6" "26" "31-5-1960" "21-6-1961" ...
##  $ FDAT0       : chr  "7" "27" "3-10-1960" "13-9-1961" ...
##  $ FDAT5       : chr  "8" "28" "3-10-1960" "13-9-1961" ...
##  $ INTER0      : num  9 29 138 94 120 109 129 149 169 189 ...
##  $ INTER5      : num  10 30 138 94 107 110 130 150 170 190 ...
##  $ MAXT        : num  11 31 19.3 18.9 21 ...
##  $ MDAT        : chr  "12" "32" "27-7-1960" "23-6-1961" ...
##  $ SUMT0       : num  13 33 527 1163 684 ...
##  $ SUMT5       : num  14 34 507 1080 629 ...
##  $ T220        : num  15 35 527 984 684 ...
##  $ T225        : num  16 36 507 901 629 ...
##  $ FT220       : num  17 37 527 189 684 ...
##  $ FT225       : num  18 38 507 189 629 ...
##  $ SPEEDT      : num  19 39 -0.66925 0.00662 -0.40495 ...
##  $ SUMPREC     : num  20 40 364 831 672 ...
## elapsed time is 18.660000 seconds
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
SA472 <- getCliStation(paste0(mm_path, "/cli/altai/"), altai.files[4])
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
# http://adv-r.had.co.nz/Exceptions-Debugging.html#debugging-techniques
```











