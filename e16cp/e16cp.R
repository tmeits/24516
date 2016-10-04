## For each year-written function to calculate the 16 climatic characteristics

#### This allowed to characterize each growing season 16-dimensional vector (Shishov V. V. table. 2.7.1, Chapter 2, p. 194)

***
### Name   : Uses of a method main a component and the discriminant analysis for reconstruction of thermal characteristics of a season of growth on cellular measurements of annual growth rings.
***
#### Author : Iljin Victor,  Date   : 31/09/2016

```{r e16cp}

## System reads
#
get_os <- function(){
  sysinf <- Sys.info()
  if (!is.null(sysinf)){
    os <- sysinf['sysname']
    if (os == 'Darwin')
      os <- "osx"
  } else { ## mystery machine
    os <- .Platform$OS.type
    if (grepl("^darwin", R.version$os))
      os <- "osx"
    if (grepl("linux-gnu", R.version$os))
      os <- "linux"
  }
  tolower(os)
}
get_os()

# Installation of a working directory
getworkdir <- function(){
  if(R.version$os == "linux-gnu") { 
      return('/home/larisa/Dropbox/24516/')
  }
  else-if (R.version$os == "mingw32") {
      return("Z:/home/larisa/Dropbox/24516/eval16clipars/")
  }
  else return('C:/Users/IVA/Dropbox/24516/')
}
mm_path <- getworkdir()
mm_path <- "C:/Users/IVA/Dropbox/24516/"

setwd(mm_path)

# Read datasets
# Work with weather data <http://aisori.meteo.ru/ClimateR> [R]
sm.cli <- read.csv(paste0(mm_path, "cli/SCH231.txt"), header = FALSE, sep = ";", 
    dec = ".")  # read Climate
sm.cli <- sm.cli[-c(5, 7, 9, 11, 13, 14)]  # we delete excess columns
sm.cli <- setNames(sm.cli, c("Station", "Year", "Month", "Day", "TMIN", "TMEAN", 
    "TMAX", "PRECIP")) # Assign columns names
# 53.42N 91.42E
Minusinsk.cli <- sm.cli[sm.cli$Station == 29866, ]

# Read data file VS-model
schc <- read.csv(paste(mm_path, "1936_2009.dat", sep = ""), header = TRUE, 
    sep = "", dec = ".")
head(schc)
str(schc)
schc <- schc[-c(2,3,4,5,6,9,10,11,12,13)]
head(schc)
str(schc)

# The calculation of duration in days growing season
cat("The calculation of duration in days growing season\n", schc$EG1-schc$BG1,"\n")


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
cat("EVAL16CLIPARS Done.")
```

```{r writenewdatasets}
# Write to file - format data.frame
write_eval_clipars <- function(filename.full, df.eval) {
    write.table(file = filename.full, df.eval, row.names = FALSE, sep = ";", quote = FALSE, 
        eol = "\n", na = "NA", dec = ".", col.names = TRUE)
}
# write_eval_clipars(paste(mm_path, 'e16cp.csv', sep = ''), E)

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
# file:///home/larisa/Dropbox/24516/eval16clipars/e16cp.html
# require(knitr); knit2html('Z:/home/larisa/Dropbox/24516/eval16clipars/e16cp.R')
# http://www.biostat.jhsph.edu/~rpeng/docs/R-debug-tools.pdf
```




















