## For each year-written function to calculate the 16 climatic characteristics

#### This allowed to characterize each growing season 16-dimensional vector (Shishov V. V. table. 2.7.1, Chapter 2, p. 194)

***
### Name   : Uses of a method main a component and the discriminant analysis for reconstruction of thermal characteristics of a season of growth on cellular measurements of annual growth rings.
***
#### Author : Iljin Victor,  Date   : 31/09/2016

```{r e16cp}

## Set work path
getOsVersion <- function(){
  sysinf <- Sys.info()
  if (!is.null(sysinf)){
    osVersion <- sysinf["version"]
  } 
  else { 
    stop("mystery machine")
  }
  return(osVersion)
}
getOsVersion()

# Installation of a working directory
setWorkDir <- function(osVersion) {
    if (osVersion == "build 2600, Service Pack 3") {
        setwd("Z:/home/larisa/Dropbox/24516/eval16clipars/")
    } else if (osVersion == "#32-Ubuntu SMP Fri Apr 16 08:10:02 UTC 2010") {
        setwd("/home/larisa/Dropbox/24516/eval16clipars/")
    } else if (osVersion == "build 7601, Service Pack 1") {
        setwd("C:/Users/IVA/Dropbox/24516/eval16clipars/")
    } else stop("mystery...")  # add other osVersion
    return(getwd())
}
setWorkDir(getOsVersion())
mm_path <- setWorkDir(getOsVersion())
mm_path

## Read datasets
# Work with weather data <http://aisori.meteo.ru/ClimateR> [R]
readClimateMinusinsk <- function(url){
    sm.cli <- read.csv(url, header = FALSE, sep = ";", 
    dec = ".")  # read Climate
    sm.cli <- sm.cli[-c(5, 7, 9, 11, 13, 14)]  # we delete excess columns
    sm.cli <- setNames(sm.cli, c("Station", "Year", "Month", "Day", "TMIN", "TMEAN", 
    "TMAX", "PRECIP")) # Assign columns names
    # 53.42N 91.42E
    Minusinsk.cli <- sm.cli[sm.cli$Station == 29866, ]
    return(Minusinsk.cli)
}
Minusinsk.cli <- readClimateMinusinsk(paste0(mm_path, "/cli/SCH231.txt"))
head(Minusinsk.cli)
str(Minusinsk.cli)
summary(Minusinsk.cli)
sum(is.na(Minusinsk.cli))
mean(is.na(Minusinsk.cli))

# Read data file VS-model
readCliBE <- function(url) {
   schc <- read.csv(url, header = TRUE, 
    sep = "", dec = ".")
    return(schc)
}

schc <-  readCliBE(paste0(mm_path, "/1936_2009.dat"))
head(schc)
str(schc)
schc <- schc[-c(2,3,4,5,6,9,10,11,12,13)]
head(schc)
str(schc)

# The calculation of duration in days growing season
cat("The calculation of duration in days growing season\n", schc$EG1-schc$BG1,"\n")
summary(schc$EG1-schc$BG1)

## Utility functions
# Reading climatic data in one year
get_one_year <- function(years, now) {
    return(years[years$Year == now, ])
}
Y64 <- get_one_year(Minusinsk.cli, 1964) # test
head(Y64)
summary(Y64[, 5:8])

# Reading of results VS model values for the beginning and end of the growing
# season for all mod. years
season_growth <- function(sgs, s.year) {
    return(c(sgs[sgs$year == s.year, ]$BG1, sgs[sgs$year == s.year, ]$EG1))
}
S64 <- season_growth(schc, 1964)
cat("Reading of results VS model ", S64, "\n")

# a function which converts date in number of days from the beginning of the
# year
num_days <- function(year, month, day) {
    D1 <- as.Date(paste(year, "-1-1", sep = ""))
    asd <- as.Date(paste(year, "-", month, "-", day, sep = ""))
    return(as.numeric(difftime(asd, D1, units = "day")))
}
ND <- num_days(1964, 6, 22)
cat("NumDay=", ND, "\n")

# Convert a vector of Year-Month-Day into a string suitable for
# reverse-conversion
date2string <- function(cDate) {
    sD <- paste(cDate[1], "-", cDate[2], "-", cDate[3], sep = "")  #; print(sD)
    D <- as.Date(sD)  # при неправильной дате выбросится исключение
    return(sD)
}
DS <- date2string(c(2007, 11, 12))
cat("Convert data as strung= ", DS, "\n")

```
### Main functions

```{r Main16}
## Main functions
# Speed of rise in temperature
SPEEDT <- function(data.cli, data.calc = FALSE, s.year = 1964) {
    return(round(rnorm(n = 1, mean = 5, sd = 1), digits = 2))  # Degrees a tseltion in a year?
}
S <- SPEEDT(Minusinsk.cli)
cat("SPEED= ", S, "\n")

# The sum of temperatures from 22 June to transition through 0C at the end of
# the season/temperatures from June 22 to transition through 5C at the end of
# the season
FT2205 <- function(data.cli, data.calc, s.year, temp.c = 0) {
    year <- get_one_year(data.cli, s.year)
    year <- na.omit(year)
    sg <- season_growth(data.calc, s.year)
    nd <- num_days(s.year, 6, 22)
    sum_temp <- 0
    for (i in nd:sg[2]) {
        if (year[i, ]$TMEAN > temp.c) {
            sum_temp <- sum_temp + year[i, ]$TMEAN
        }
    }
    return(sum_temp)
}
sum_temp0 <- FT2205(Minusinsk.cli, schc, 1965, 0)
sum_temp5 <- FT2205(Minusinsk.cli, schc, 1965, 5)
cat("FT2205= ", sum_temp0, sum_temp5, "\n")

# The sum of temperatures above 0C until June 22/the Sum of temperatures above
# 5C until June 22
T2205 <- function(data.cli, data.calc, s.year, temp.c = 0) {
    year <- get_one_year(data.cli, s.year)
    year <- na.omit(year)
    nd <- num_days(s.year, 6, 22)
    sum_temp <- 0
    for (i in 1:nd) {
        if (year[i, ]$TMEAN > temp.c) {
            sum_temp <- sum_temp + year[i, ]$TMEAN
        }
    }
    return(sum_temp)
}
sum_temp0 <- T2205(Minusinsk.cli, schc, 1965, 0)
sum_temp5 <- T2205(Minusinsk.cli, schc, 1965, 5)
cat("T2205= ", sum_temp0, sum_temp5, "\n")

# The sum of temperatures more 0C - the Sum of temperatures more than 5C
SUMT0 <- function (data.cli, data.calc, s.year, temp.c = 0) {
  year <- get_one_year(data.cli, s.year)
  year <- na.omit(year)
  sum_temp <- 0
  for(i in 1: length(year[, 1])) {
    if(year[i, ]$TMEAN > temp.c) {
      sum_temp <- sum_temp + year[i, ]$TMEAN
    }
  }
  return(sum_temp)
}
# test
sum_temp0 <- SUMT0(Minusinsk.cli, schc, 1963, 0)
sum_temp5 <- SUMT0(Minusinsk.cli, schc, 1963, 5)
cat("SUMT0= ", sum_temp0, sum_temp5, "\n")

# The date of transition through 0C-5C at the beginning of the growing season
STDAT0 <- function (data.cli, data.calc, s.year, temp.c = 0) {
  year <- get_one_year(data.cli, s.year)
  year <- na.omit(year)
  sg <- season_growth(data.calc, s.year)
  data.0c <- c(1, 1, 1)
  for(i in 1: length(year[, 1])) {
    if(year[i, ]$TMEAN >= temp.c & i >= sg[1]) {
      data.0c[3] <- year[i, ]$Year
      data.0c[2] <- year[i, ]$Month
      data.0c[1] <- year[i, ]$Day
      return(data.0c)
    }
  }
  stop("In the permafrost, the trees do not grow. Check climatico.")
}
R0 <- STDAT0(Minusinsk.cli, schc, 1969)
R5 <- STDAT0(Minusinsk.cli, schc, 1969, temp.c = 11)
cat("STDAT0= ", R0, R5, "\n")

# Date of transition at the end of the season through 0C-5C
FDAT0 <- function (data.cli, data.calc, s.year, temp.c = 0) {
  year <- get_one_year(data.cli, s.year)
  year <- na.omit(year)
  sg <- season_growth(data.calc, s.year)
  data.0c <- c(1, 1, 1)
  for(i in sort(1: length(year[, 1]), decreasing = TRUE)) {
    if(year[i, ]$TMEAN >= temp.c & i <= sg[2]) {
      data.0c[3] <- year[i, ]$Year
      data.0c[2] <- year[i, ]$Month
      data.0c[1] <- year[i, ]$Day
      return(data.0c)
    }
  }
  stop("In the permafrost, the trees do not grow. Check climatico.")
}
R0 <- FDAT0(Minusinsk.cli, schc, 1969)
R5 <- FDAT0(Minusinsk.cli, schc, 1969, 5)
cat("FDAT0= ", R0, R5, "\n")

# The duration of the season from 0C to 0C or 5C to 5C
INTER0 <- function(data.cli, data.calc, s.year, temp.c = 0) {
    year <- get_one_year(data.cli, s.year)
    sg <- season_growth(data.calc, s.year)
    lbeg <- STDAT0(data.cli, data.calc, s.year, temp.c)
    lend <- FDAT0(data.cli, data.calc, s.year, temp.c)
    
    startdate <- as.Date(paste(as.character(lbeg[3]), "-", as.character(lbeg[2]), 
        "-", as.character(lbeg[1]), sep = ""))
    enddate <- as.Date(paste(as.character(lend[3]), "-", as.character(lend[2]), 
        "-", as.character(lend[1]), sep = ""))
    # http://distrland.blogspot.ru/2015/04/r-2-date-base-r.html
    days <- as.numeric(difftime(enddate, startdate, units = "day"))
    return(days)
}
I1 <- INTER0(Minusinsk.cli, schc, 1965, 0)
I2 <- INTER0(Minusinsk.cli, schc, 1966, 0)
I3 <- INTER0(Minusinsk.cli, schc, 1969, 5)
cat("INTER0= ", I1, I2, I3, "\n")

# The amount of precipitation during the growing season
SUMPREC <- function(data.cli, data.calc, s.year) {
    new.year <- na.omit(get_one_year(data.cli, s.year))
    sg <- season_growth(data.calc, s.year)
    
    return(sum(new.year$PRECIP[sg[1]:sg[2]]))
}
SP <- SUMPREC(Minusinsk.cli, schc, 1964)
cat("SUMPREC= ", SP, "\n")

# The maximum temperature
MAXT <- function(data.cli, s.year) {
    TMAX <- data.cli[data.cli$Year == s.year, ]$TMAX
    TMAX <- na.omit(TMAX)
    return(max(TMAX))
}
MT1 <- MAXT(Minusinsk.cli, 1963)
MT2 <- MAXT(Minusinsk.cli, 1996)
cat("MAXT= ", MT1, MT2, "\n")

# Date of the maximum temperature
MDAT <- function(data.cli, s.year) {
  temp.max <- -99
  data.max <- c(1, 1, 1)
  year <- get_one_year(data.cli, s.year)
  year <- na.omit(year)
  for(i in 1: length(year[, 1])) {
    if(year[i, ]$TMAX > temp.max) {
      temp.max <- year[i, ]$TMAX
      data.max[3] <- year[i, ]$Year
      data.max[2] <- year[i, ]$Month
      data.max[1] <- year[i, ]$Day
    }
  }
  #return(list(data.max, temp.max))
  return(data.max)
}
MD <- MDAT(Minusinsk.cli, 1964)
MDS <- date2string(MD)
cat("MDAT= ", MD, MDS, "\n")

```
### EVAL16CLIPARS
``` {r eval16}
EVAL16CLIPARS <- function(data.cli, data.calc) {
    l <- length(data.calc[, 1])  # the calculation of the number of observations 
    # the creation of a matrix of l rows and 16 columns
    m16 <- matrix(c(1:(l * 16)), nrow = l, ncol = 16, byrow = TRUE)
    m16.df <- as.data.frame(m16)  #  converted to dataframe
    # assign names to the columns
    df16 <- setNames(m16.df, c("STDAT0", "STDAT5", "FDAT0", "FDAT5", "INTER0", 
        "INTER5", "MAXT", "MDAT", "SUMT0", "SUMT5", "T220", "T225", "FT220", "FT225", 
        "SPEEDT", "SUMPREC"))
    # the task is to determine the data type of each column
    df16$STDAT0 <- as.character(df16$STDAT0)
    df16$STDAT5 <- as.character(df16$STDAT5)
    df16$FDAT0 <- as.character(df16$FDAT0)
    df16$FDAT5 <- as.character(df16$FDAT5)
    df16$MDAT <- as.array(df16$MDAT)
    
    for (i in 1:l) {
        # The date of transition through 0C at the beginning of the growing season STDAT0
        D <- STDAT0(data.cli, data.calc, data.calc$year[i])
        df16$STDAT0[i] <- date2string(D)
        # The date of transition through 5C in the beginning of the growing season STAT5
        D <- STDAT0(data.cli, data.calc, data.calc$year[i], 11)
        df16$STDAT5[i] <- date2string(D)
        # Date of transition at the end of the season after 0 - 5
        D <- FDAT0(data.cli, data.calc, data.calc$year[i])
        df16$FDAT0[i] <- date2string(D)
        D <- FDAT0(data.cli, data.calc, data.calc$year[i], 5)
        df16$FDAT5[i] <- date2string(D)
        # The maximum temperature
        df16$MAXT[i] <- MAXT(data.cli, data.calc$year[i])
        # Date of the maximum temperature
        D <- MDAT(data.cli, data.calc$year[i])
        df16$MDAT[i] <- date2string(D)
        # The duration of the season from 0C to 0C, 5C to 5C
        SL <- INTER0(data.cli, data.calc, data.calc$year[i])
        df16$INTER0[i] <- SL
        df16$INTER5[i] <- INTER0(data.cli, data.calc, data.calc$year[i], temp.c = 5)
        # The sum of temperatures more 0C, 5C 
        df16$SUMT0[i] <- SUMT0(data.cli, data.calc, data.calc$year[i])
        df16$SUMT5[i] <- SUMT0(data.cli, data.calc, data.calc$year[i], 5)
        # The sum of temperatures above 0C-5C until June 22
        df16$T220[i] <- T2205(data.cli, data.calc, data.calc$year[i])
        df16$T225[i] <- T2205(data.cli, data.calc, data.calc$year[i], 5)
        # The sum of temperatures from 22 June to go through 0o at the end of the season
        df16$FT220[i] <- FT2205(data.cli, data.calc, data.calc$year[i])
        df16$FT225[i] <- FT2205(data.cli, data.calc, data.calc$year[i], temp.c = 5)
        # The rate of temperature rise of (Скорость подъема температуры)
        df16$SPEEDT[i] <- SPEEDT(data.cli, data.calc, data.calc$year[i])
        # Сумма осадков в течение сезона роста
        df16$SUMPREC[i] <- SUMPREC(data.cli, data.calc, data.calc$year[i])
    }
    # the estimated return table from function
    return(df16)
}
```
### Results of calculation
  + Structure of the table of results
  + First 6 lines
  + Descriptive statisticians (one line one year)
```{r}
E <- EVAL16CLIPARS(Minusinsk.cli, schc)
str(E)
head(E)
summary(E)
cat("EVAL16CLIPARS Done.")

```
### Write to file - format data.frame (e16cp.csv)
```{r writenewdatasets}
# Write to file - format data.frame
write_eval_clipars <- function(filename.full, df.eval) {
    write.table(file = filename.full, df.eval, row.names = FALSE, sep = ";", quote = FALSE, 
        eol = "\n", na = "NA", dec = ",", col.names = TRUE)
}
write_eval_clipars(paste(mm_path, '/e16cp.csv', sep = ''), E)

```

``` {r sysadmn}
## SysAdmins
# knitr: run all chunks in an Rmarkdown document
# http://stackoverflow.com/questions/24753969/knitr-run-all-chunks-in-an-rmarkdown-document
runAllChunks <- function(rmd, envir = globalenv()) {
    tempR <- tempfile(tmpdir = ".", fileext = ".R")
    on.exit(unlink(tempR))
    knitr::purl(rmd, output = tempR)
    sys.source(tempR, envir = envir)
    unlink(tempR)
}

#runAllChunks("e16cp1.R")

```
#### Tips
```{r tips}
# file:///home/larisa/Dropbox/24516/eval16clipars/e16cp.html
# require(knitr); knit2html('Z:/home/larisa/Dropbox/24516/eval16clipars/e16cp.R')
# http://www.biostat.jhsph.edu/~rpeng/docs/R-debug-tools.pdf
# http://tukachev.flogiston.ru/blog/?p=1352
#  http://kpfu.ru/docs/F568269105/metodichka_R_1.pdf
#  http://shelly.kpfu.ru/e-ksu/docs/F1594376599/%ec%e5%f2%ee%e4%e8%f7%ea%e0_R_2.pdf
#  http://herba.msu.ru/shipunov/software/r/cbook.pdf
#  http://gis-lab.info/docs/books/moskalev2010_statistical_analysis_with_r.pdf
#  https://dl.dropboxusercontent.com/u/7521662/Zaryadov%20%282010%29%20Intro%20to%20R.pdf
#  http://www.unn.ru/pages/e-library/methodmaterial/2010/3.pdf
#
```




















