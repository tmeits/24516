---
title: "Пример использования метода главных компонент и дискриминантного анализа для реконструкции термических характеристик сезона роста по клеточным измерениям годичных колец."
author: "Iljin Victor"
date: '26 августа 2016 г '
output: html_document
---



#### Очистка памяти для новой сессии


```r
clear_all <- function() {
    rm(list = ls())
    cat("\f")  # очистка локальной области видимости
    print(ls())
}
clear_all()
```

```
## character(0)
```

```r
rm(list = ls())
cat("\f")
```


#### Установка абсолютного пути к рабочей директории

```r
getworkdir <- function() {
    if (R.version$os == "linux-gnu") {
        return("/home/larisa/Dropbox/24516/")
    }
    return("C:/Users/IVA/Dropbox/24516/")
}
mm_path <- getworkdir()

setwd(mm_path)
```

#### Чтения файла с данными VS-model
  + BG1 and EG1 (начало и конец сезона роста от Маргариты)
  + Построение графика

```r
schc <- read.csv(paste(getworkdir(), "1936_2009.dat", sep = ""), header = TRUE, sep = "", dec = ".")

head(schc)
```

```
##   year  model   crn    NMOD    NCRN Tmin BG1 EG1 X1 X2  Tem1  Tem2   Gr
## 1 1936 1.3382 1.215  1.5167  1.0642  119 146 271  0  0   5.7 113.2 0.65
## 2 1937 1.2840 0.970  1.2735 -0.1108  123 132 261  0  0   6.7 112.3 0.39
## 3 1938 1.3011 1.227  1.3501  1.1218   93 134 267  0  0  -0.4 110.8 0.22
## 4 1939 1.0002 0.685  0.0010 -1.4776   95 121 274  0  0 -50.4 115.6 0.67
## 5 1940 0.7825 0.718 -0.9752 -1.3193   94 138 264  0  0 -15.9 111.8 0.59
## 6 1941 0.8403 0.818 -0.7164 -0.8397  104 147 257  0  0  19.2 111.7 0.71
```

```r
str(schc)
```

```
## 'data.frame':	74 obs. of  13 variables:
##  $ year : int  1936 1937 1938 1939 1940 1941 1942 1943 1944 1945 ...
##  $ model: num  1.338 1.284 1.301 1 0.782 ...
##  $ crn  : num  1.215 0.97 1.227 0.685 0.718 ...
##  $ NMOD : num  1.517 1.274 1.35 0.001 -0.975 ...
##  $ NCRN : num  1.064 -0.111 1.122 -1.478 -1.319 ...
##  $ Tmin : int  119 123 93 95 94 104 106 102 104 98 ...
##  $ BG1  : int  146 132 134 121 138 147 152 127 144 124 ...
##  $ EG1  : int  271 261 267 274 264 257 264 285 271 262 ...
##  $ X1   : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ X2   : int  0 0 0 0 0 0 0 0 0 0 ...
##  $ Tem1 : num  5.7 6.7 -0.4 -50.4 -15.9 19.2 10.6 -25.7 8.5 -28.5 ...
##  $ Tem2 : num  113 112 111 116 112 ...
##  $ Gr   : num  0.65 0.39 0.22 0.67 0.59 0.71 0.53 0.42 0.48 0.63 ...
```

```r
plot(schc$year, schc$BG1, col = "red", ylim = c(90, 300), ylab = "day", xlab = "year")
lines(schc$year, schc$BG1, col = "red", type = "l")
lines(schc$year, schc$EG1, col = "blue", type = "p")
lines(schc$year, schc$EG1, col = "blue", type = "l")
```

![plot of chunk read_and_plot](figure/read_and_plot-1.png)

```r
schc$EG1 - schc$BG1
```

```
##  [1] 125 129 133 153 126 110 112 158 127 138 135 117 136 138 127 138 127
## [18] 122 121 137 123 116 131 133 126 132 132 125 131 145 129 132 105 119
## [35] 127 120 140 124 128 125 127 121 124 143 120 137 134 107 144 137 132
## [52] 141 123 120 132 135 129 119 138 126 115 155 133 144 128 143 125 136
## [69] 135 133 141 156 130 158
```

#### Чтение размеров клеток по деревьям и годам (малая минуса)
  + таблица с данными кластеризованна на три кластера
  <>


```r
sm <- read.csv(paste(mm_path, 'small_minusa_lda_sep_3.csv', sep = ''), 
               header = TRUE, sep = ";", dec = ",") # Pinus sylvestris L.
# Округлим результаты для лучшего восприятия данных
sm_round <- round(sm, digits = 2)
head(sm_round)
```

```
##   Year    C1    C2    C3    C4    C5    C6    C7    C8    C9   C10   C11
## 1 1964 38.00 42.83 48.59 46.31 45.14 49.14 51.59 48.97 52.34 54.00 51.38
## 2 1964 35.73 35.54 38.85 36.02 37.39 38.61 38.83 38.63 38.95 40.95 44.46
## 3 1964 31.00 35.45 38.27 39.00 41.73 41.45 41.00 41.00 40.18 41.82 43.91
## 4 1964 29.00 29.57 32.29 30.14 29.71 28.29 30.71 33.00 35.29 37.00 34.71
## 5 1964 37.00 37.71 40.00 39.53 39.00 41.82 43.00 44.88 45.00 45.00 45.00
## 6 1965 49.03 50.19 53.00 52.74 50.84 50.77 53.32 49.71 45.42 44.97 47.71
##     C12   C13   C14   C15   C16   C17   C18   C19   C20   C21   C22   C23
## 1 49.38 49.00 45.69 43.00 42.03 40.10 36.52 29.97 23.97 21.38 20.00 20.48
## 2 42.71 40.88 41.12 44.00 42.10 40.66 37.68 34.59 33.51 29.95 24.73 21.00
## 3 43.00 41.55 41.73 43.00 46.00 45.36 43.36 39.00 41.73 41.45 39.91 35.00
## 4 36.29 38.86 32.71 32.43 31.71 28.71 27.00 25.29 23.00 20.14 16.86 15.71
## 5 45.00 45.00 45.00 40.59 39.88 39.00 38.29 37.00 34.65 33.00 25.59 23.76
## 6 47.84 45.16 43.10 41.52 40.48 38.90 35.68 32.77 28.77 25.65 23.58 22.26
##     C24   C25   C26   C27   C28   C29   C30 Class
## 1 22.21 23.17 23.59 20.79 18.86 16.86 13.00     3
## 2 21.59 22.12 21.83 18.02 18.32 18.61 14.07     2
## 3 26.82 22.27 18.73 16.00 15.27 15.00 15.00     2
## 4 14.00 16.14 17.43 15.43 14.29 15.43 13.14     1
## 5 20.00 19.41 18.00 16.94 16.00 13.71 13.00     2
## 6 23.55 24.00 24.84 24.13 21.29 17.26 12.16     3
```
#### Чтение данных из датасета участка Малая Минуса и климатических данных участка Малая Минуса
* Работаем с метеоданными <http://aisori.meteo.ru/ClimateR> в [R]
* Конвертируем данные метеостанции 29866 53.42N 91.42E по температуре для работы в data.frame [R] 
  + Удаляем качество замера
  + Присваиваем столбцам наименования
  + Разделяем по разным таблицам метеостанцию Minusinsk.cli и Hakasskaja.cli 


```r
sm.cli <- read.csv(paste(mm_path, 'cli/SCH231.txt', sep = ''), 
                   header = FALSE, sep = ";", dec = ".") # Climate
sm.cli <- sm.cli[-c(5, 7, 9, 11, 13, 14)] # Удаляем лишние столбцы
sm.cli <- setNames(sm.cli, c("Station", "Year", "Month", "Day",  'TMIN','TMEAN','TMAX','PRECIP'))
# 53.42N 91.42E
Minusinsk.cli <- sm.cli[sm.cli$Station == 29866, ]
# 53.46N 91.19E 
Hakasskaja.cli <- sm.cli[sm.cli$Station == 29862, ]

Minusinsk.cli.1964.2013 <- Minusinsk.cli[
  (Minusinsk.cli$Year >= 1964) & (Minusinsk.cli$Year <= 2013), ]

head(Minusinsk.cli.1964.2013); str(Minusinsk.cli.1964.2013)
```

```
##       Station Year Month Day  TMIN TMEAN  TMAX PRECIP
## 40543   29866 1964     1   1 -23.3 -18.5 -13.9    0.0
## 40544   29866 1964     1   2 -19.7 -17.0 -12.2    0.2
## 40545   29866 1964     1   3 -26.1 -20.0 -15.2    0.1
## 40546   29866 1964     1   4 -17.8  -9.6  -3.1    0.0
## 40547   29866 1964     1   5  -5.5  -3.6  -0.6    0.0
## 40548   29866 1964     1   6  -8.2  -6.5  -2.6    0.0
```

```
## 'data.frame':	18263 obs. of  8 variables:
##  $ Station: int  29866 29866 29866 29866 29866 29866 29866 29866 29866 29866 ...
##  $ Year   : int  1964 1964 1964 1964 1964 1964 1964 1964 1964 1964 ...
##  $ Month  : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ Day    : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ TMIN   : num  -23.3 -19.7 -26.1 -17.8 -5.5 -8.2 -14.4 -17.8 -17.3 -23.7 ...
##  $ TMEAN  : num  -18.5 -17 -20 -9.6 -3.6 -6.5 -11.5 -11.8 -11.3 -17.5 ...
##  $ TMAX   : num  -13.9 -12.2 -15.2 -3.1 -0.6 -2.6 -6.6 -5.2 -2.6 -13.2 ...
##  $ PRECIP : num  0 0.2 0.1 0 0 0 0 0 0 0 ...
```

```r
rm(sm.cli, Hakasskaja.cli, Minusinsk.cli.1964.2013)
```

## Исходные температурные данные сглаживались при помощи метода скользящих средних с окном в 43 дня.

Подобного рода сглаживание проводилось с целью избавления от «случайных» температурных флуктуаций. При дальнейшем увеличении окна внутренняя корреляционная структура полученных характеристик по годам не меняется.

<http://r-analytics.blogspot.ru/2012/09/blog-post_6280.html#.V4WLmPuLYbe>
<http://www.inside-r.org/packages/cran/pracma/docs/movavg>


```r
# > install.packages('pracma') http://matlab.exponenta.ru/curvefitting/3_10.php library(pracma)
source(paste(mm_path, "movavg.R", sep = ""))
source(paste(mm_path, "rand.R", sep = ""))
source(paste(mm_path, "size.R", sep = ""))
# lsb_release -a https://cran.r-project.org/bin/linux/ubuntu/ синтетический тест
X <- seq(0, 5, by = 0.005)
length(X)
```

```
## [1] 1001
```

```r
Y <- X * sin(3 * X) + 2 * randn(size(X))
plot(X, Y, col = "blue")
T <- movavg(Y, 33, type = "t")
T2 <- movavg(Y, 191, type = "t")
lines(X, T, col = "red", lwd = "3")
lines(X, T2, col = "green", lwd = "3")
grid(NA, 5, lwd = 2)
lines(lowess(X, Y, f = 0.05, iter = 4, delta = 0.01 * diff(range(X))), lwd = 5, col = "black")
```

![plot of chunk temperature_smoothed](figure/temperature_smoothed-1.png)

#### Служебные функции

```r
get_one_year <- function(years, now) {
  # Чтение климатических данных за один год
  return(years[years$Year == now, ])
}
Y64 <- get_one_year(Minusinsk.cli, 1964)

season_growth <- function(sgs, s.year) {
  # Чтение из результатов VS-model значений начала и конца сезона роста по всем мод. годам
  return(c(sgs[sgs$year == s.year, ]$BG1, sgs[sgs$year == s.year, ]$EG1))
}
S64 <- season_growth(schc, 1964)
```
#### Для каждого года составленны функции для рассчета 16 климатических характеристик 
  + Это позволило охарактеризовать каждый сезон роста 16-мерным вектором (Шишов В.В. табл. 2.7.1, глава 2)
  + Климатические характеристики, рассчитанные по ежедневным данным температуры и осадков по метеостанции в районе

<http://www.inp.nsk.su/~baldin/DataAnalysis/R/R-03-datatype.pdf>
<http://www.stat.berkeley.edu/classes/s133/dates.html>
<http://www.statmethods.net/advstats/timeseries.html>
<https://lib.ipae.uran.ru/dchrono/>

```r
# Скорость подъема температуры
SPEEDT <- function (data.cli, data.calc, s.year) {
  return(1) # Градусов цельция в год?
}
SPEEDT(Minusinsk.cli, schc, 1965)
```

```
## [1] 1
```

#### функция преобразующая дату в количество дней с начала года

```r
# функция преобразующая дату в количество дней с начала года
num_days <- function(year, month, day) {
    D1 <- as.Date(paste(year, "-1-1", sep = ""))
    asd <- as.Date(paste(year, "-", month, "-", day, sep = ""))
    return(as.numeric(difftime(asd, D1, units = "day")))
}
ND <- num_days(1964, 6, 22)
ND
```

```
## [1] 173
```
#### Преобразование вектора Год-Месяц-День в строку пригодную для обратного преобразования

```r
date2string <- function(cDate) {
  sD <- paste(cDate[1], "-", cDate[2], "-", cDate[3], sep = "") #; print(sD)
  D  <- as.Date(sD) # при неправильной дате выбросится исключение
  return(sD)
}
date2string(c(2007,11,11))
```

```
## [1] "2007-11-11"
```

#### Сумма температур от 22 июня до перехода через 0C в конце сезона/Сумма температур от 22 июня до перехода через 5C в конце сезона

```r
# Сумма температур от 22 июня до перехода через 0C в конце сезона/Сумма температур от 22 июня до перехода через 5C в конце сезона
FT2205 <- function (data.cli, data.calc, s.year, temp.c = 0) {
  year <- get_one_year(data.cli, s.year)
  year <- na.omit(year)
  sg   <- season_growth(data.calc, s.year)
  nd <- num_days(s.year, 6, 22)
  sum_temp <- 0
  for(i in nd: sg[2]) {
    if(year[i, ]$TMEAN > temp.c) {
      sum_temp <- sum_temp + year[i, ]$TMEAN
    }
  }
  return(sum_temp)
}
sum_temp <- FT2205(Minusinsk.cli, schc, 1965, 0); sum_temp
```

```
## [1] 1713.2
```

```r
sum_temp <- FT2205(Minusinsk.cli, schc, 1965, 5); sum_temp
```

```
## [1] 1703.7
```

#### Сумма температур выше 0C до 22 июня/Сумма температур выше 5C до 22 июня

```r
# Сумма температур выше 0C до 22 июня/Сумма температур выше 5C до 22 июня
T2205 <- function (data.cli, data.calc, s.year, temp.c = 0) {
  year <- get_one_year(data.cli, s.year)
  year <- na.omit(year)
  nd <- num_days(s.year, 6, 22)
  sum_temp <- 0
  for(i in 1: nd) {
    if(year[i, ]$TMEAN > temp.c) {
      sum_temp <- sum_temp + year[i, ]$TMEAN
    }
  }
  return(sum_temp)
}
sum_temp <- T2205(Minusinsk.cli, schc, 1965, 0); sum_temp
```

```
## [1] 970.3
```

```r
sum_temp <- T2205(Minusinsk.cli, schc, 1965, 5); sum_temp
```

```
## [1] 917.5
```
####  Сумма температур больше 0C - Сумма температур больше 5C


```r
# Сумма температур больше 0C - Сумма температур больше 5C
SUMT0 <- function(data.cli, data.calc, s.year, temp.c = 0) {
    year <- get_one_year(data.cli, s.year)
    year <- na.omit(year)
    sum_temp <- 0
    for (i in 1:length(year[, 1])) {
        if (year[i, ]$TMEAN > temp.c) {
            sum_temp <- sum_temp + year[i, ]$TMEAN
        }
    }
    return(sum_temp)
}
# test
sum_temp <- SUMT0(Minusinsk.cli, schc, 1963, 0)
sum_temp
```

```
## [1] 2320.4
```

```r
sum_temp <- SUMT0(Minusinsk.cli, schc, 1963, 5)
sum_temp
```

```
## [1] 2193.2
```

#### Дата перехода через 0C-5C в начале сезона роста

```r
# Дата перехода через 0C-5C в начале сезона роста
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
  stop("В вечной мерзлоте деревья не растут. Проверьте климатику.")
}
STDAT0(Minusinsk.cli, schc, 1969)
```

```
## [1]   23    5 1969
```

```r
STDAT0(Minusinsk.cli, schc, 1969, temp.c = 11) # Дата перехода через 5C в начале сезона роста STDAT5
```

```
## [1]   24    5 1969
```
#### Дата перехода в конце сезона через 0C-5C

```r
# Дата перехода в конце сезона через 0C-5C
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
  stop("В вечной мерзлоте деревья не растут. Проверьте климатику.")
}
FDAT0(Minusinsk.cli, schc, 1969)
```

```
## [1]   19    9 1969
```

```r
FDAT0(Minusinsk.cli, schc, 1969, 5)
```

```
## [1]   18    9 1969
```
#### Длительность сезона от 0C до 0C или от 5C до 5C

```r
# Длительность сезона от 0C до 0C или от 5C до 5C
INTER0 <- function (data.cli, data.calc, s.year, temp.c = 0) {
  year <- get_one_year(data.cli, s.year)
  sg   <- season_growth(data.calc, s.year)
  lbeg <- STDAT0(data.cli, data.calc, s.year, temp.c)
  lend <- FDAT0(data.cli, data.calc, s.year, temp.c)

  startdate <- as.Date(paste(as.character(lbeg[3]), "-", as.character(lbeg[2]), "-",
                      as.character(lbeg[1]), sep = ''))
  enddate   <- as.Date(paste(as.character(lend[3]), "-", as.character(lend[2]), "-",
                      as.character(lend[1]), sep = ''))
  # http://distrland.blogspot.ru/2015/04/r-2-date-base-r.html
  days      <- as.numeric(difftime(enddate , startdate, units = "day"))
  
  # install.packages("timeDate")
  # https://journal.r-project.org/archive/2011-1/RJournal_2011-1_Chalabi~et~al.pdf
  return(days)
}
I <- INTER0(Minusinsk.cli, schc, 1965, 0); I
```

```
## [1] 145
```

```r
I <- INTER0(Minusinsk.cli, schc, 1966, 0); I
```

```
## [1] 129
```

```r
I <- INTER0(Minusinsk.cli, schc, 1969, 5); I
```

```
## [1] 118
```
#### Сумма осадков в течение сезона роста

```r
# Сумма осадков в течение сезона роста
SUMPREC <- function (data.cli, data.calc, s.year) {
  new.year <- na.omit(get_one_year(data.cli, s.year))
  sg <- season_growth(data.calc, s.year)
  # print(sg)
  return(sum(new.year$PRECIP[sg[1]: sg[2]]))
}
sum.prec <- SUMPREC(Minusinsk.cli, schc, 1964); sum.prec
```

```
## [1] 159.9
```
#### Максимум температуры

```r
# Максимум температуры
MAXT <- function(data.cli, s.year) {
  return(max(data.cli[data.cli$Year == s.year, ]$TMAX))
}
MAXT(Minusinsk.cli, 1964); MAXT(Minusinsk.cli, 1996)
```

```
## [1] 35.4
```

```
## [1] 36.6
```
#### Дата достижения максимума температуры

```r
# Дата достижения максимума температуры
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
MD <- MDAT(Minusinsk.cli, 1964); MD; date2string(MD)
```

```
## [1]   24    7 1964
```

```
## [1] "24-7-1964"
```
### Климатические характеристики, рассчитанные по ежедневным данным температуры и осадков

```r
# Климатические характеристики, рассчитанные по ежедневным данным температуры и осадков
EVAL16CLIPARS <- function(data.cli, data.calc) {
  l <- length(data.calc[, 1]) # вычисление количества наблюдений
  # создание матрицы из l строк и 16 столбцов
  m16 <- matrix(c(1: (l*16)), nrow = l, ncol = 16, byrow = TRUE)
  m16.df <- as.data.frame(m16) # преобразуем в датафрэйм
  # присваиваем названия столбцам
  df16 <- setNames(m16.df, 
                   c("STDAT0", "STDAT5", "FDAT0", "FDAT5", "INTER0", "INTER5", "MAXT", 
                     "MDAT", "SUMT0", "SUMT5", "T220", "T225", "FT220", "FT225", "SPEEDT", "SUMPREC"))
  # задача определить тип данных каждого столбца
  df16$STDAT0 <- as.character(df16$STDAT0)
  df16$STDAT5 <- as.character(df16$STDAT5)
  df16$FDAT0  <- as.character(df16$FDAT0)
  df16$FDAT5  <- as.character(df16$FDAT5)
  df16$MDAT   <- as.array(df16$MDAT)
  
  for(i in 1: l) {
    # 1 Дата перехода через 0C в начале сезона роста STDAT0
    D <- STDAT0(data.cli, data.calc, data.calc$year[i]);
    df16$STDAT0[i] <- date2string(D);
    # 2 Дата перехода через 5C в начале сезона роста STDAT5
    D <- STDAT0(data.cli, data.calc, data.calc$year[i], 11);
    df16$STDAT5[i] <- date2string(D);
    # Дата перехода в конце сезона через 0 - 5
    D <- FDAT0(data.cli, data.calc, data.calc$year[i])
    df16$FDAT0[i] <- date2string(D);
    D <- FDAT0(data.cli, data.calc, data.calc$year[i], 5)
    df16$FDAT5[i] <- date2string(D);
    # Максимум температуры
    df16$MAXT[i] <- MAXT(data.cli, data.calc$year[i]) 
    # Дата достижения максимума температуры
    D <- MDAT(data.cli, data.calc$year[i])
    df16$MDAT[i] <- date2string(D);
    # Длительность сезона от 0C до 0C, 5C до 5C
    SL <- INTER0(data.cli, data.calc, data.calc$year[i]); df16$INTER0[i] <- SL
    df16$INTER5[i] <- INTER0(data.cli, data.calc, data.calc$year[i], temp.c = 5);
    # Сумма температур больше 0C, 5C
    df16$SUMT0[i] <- SUMT0(data.cli, data.calc, data.calc$year[i])
    df16$SUMT5[i] <- SUMT0(data.cli, data.calc, data.calc$year[i], 5)
    # Сумма температур выше 0C-5C до 22 июня
    df16$T220[i] <- T2205(data.cli, data.calc, data.calc$year[i])
    df16$T225[i] <- T2205(data.cli, data.calc, data.calc$year[i], 5)
    # Сумма температур от 22 июня до перехода через 0о в конце сезона
    df16$FT220[i] <- FT2205(data.cli, data.calc, data.calc$year[i])
    df16$FT225[i] <- FT2205(data.cli, data.calc, data.calc$year[i], temp.c = 5)
    # Скорость подъема температуры
    df16$SPEEDT[i] <- SPEEDT(data.cli, data.calc, data.calc$year[i])
    # Сумма осадков в течение сезона роста
    df16$SUMPREC[i] <- SUMPREC(data.cli, data.calc, data.calc$year[i])
  }
  # возвращаем расчетную таблицу из функции
  return(df16)
}

E <- EVAL16CLIPARS(Minusinsk.cli, schc)
str(E)
```

```
## 'data.frame':	74 obs. of  16 variables:
##  $ STDAT0 : chr  "25-5-1936" "12-5-1937" "14-5-1938" "1-5-1939" ...
##  $ STDAT5 : chr  "25-5-1936" "13-5-1937" "16-5-1938" "1-5-1939" ...
##  $ FDAT0  : chr  "27-9-1936" "18-9-1937" "24-9-1938" "1-10-1939" ...
##  $ FDAT5  : chr  "27-9-1936" "17-9-1937" "23-9-1938" "30-9-1939" ...
##  $ INTER0 : num  125 129 133 153 126 110 112 158 127 138 ...
##  $ INTER5 : num  125 128 132 152 126 110 111 158 126 138 ...
##  $ MAXT   : num  36.8 34.4 32.4 37.7 34.5 34.5 33.7 36.4 35.5 35.3 ...
##  $ MDAT   : chr [1:74(1d)] "1-7-1936" "5-8-1937" "14-7-1938" "13-8-1939" ...
##  $ SUMT0  : num  2217 2288 2392 2609 2515 ...
##  $ SUMT5  : num  2103 2183 2285 2540 2418 ...
##  $ T220   : num  561 699 796 863 863 ...
##  $ T225   : num  508 683 740 838 816 ...
##  $ FT220  : num  1497 1416 1475 1702 1536 ...
##  $ FT225  : num  1497 1413 1469 1700 1536 ...
##  $ SPEEDT : num  1 1 1 1 1 1 1 1 1 1 ...
##  $ SUMPREC: num  349 221 296 217 189 ...
```

```r
head(E)
```

```
##      STDAT0    STDAT5     FDAT0     FDAT5 INTER0 INTER5 MAXT      MDAT
## 1 25-5-1936 25-5-1936 27-9-1936 27-9-1936    125    125 36.8  1-7-1936
## 2 12-5-1937 13-5-1937 18-9-1937 17-9-1937    129    128 34.4  5-8-1937
## 3 14-5-1938 16-5-1938 24-9-1938 23-9-1938    133    132 32.4 14-7-1938
## 4  1-5-1939  1-5-1939 1-10-1939 30-9-1939    153    152 37.7 13-8-1939
## 5 17-5-1940 17-5-1940 20-9-1940 20-9-1940    126    126 34.5  3-8-1940
## 6 27-5-1941 27-5-1941 14-9-1941 14-9-1941    110    110 34.5  7-6-1941
##    SUMT0  SUMT5  T220  T225  FT220  FT225 SPEEDT SUMPREC
## 1 2217.4 2103.3 560.9 507.7 1497.2 1497.2      1   348.7
## 2 2288.2 2183.2 699.1 682.6 1416.2 1412.8      1   221.2
## 3 2391.7 2284.9 795.8 740.3 1475.2 1468.6      1   295.9
## 4 2609.2 2540.1 863.3 838.4 1702.3 1700.0      1   217.4
## 5 2514.9 2418.0 863.4 815.8 1536.5 1536.5      1   188.7
## 6 2436.3 2294.1 799.5 728.5 1454.0 1454.0      1   168.6
```
#### Записываем результаты расчетов в таблицу Excel

```r
write_eval_clipars <- function(filename.full, df.eval) {
    # сохраняем расчетную таблицу в файл
    write.table(file = filename.fill, df.eval, row.names = FALSE, sep = " ", 
        quote = FALSE, eol = "\n", na = "NA", dec = ".", col.names = TRUE)
}
write_eval_clipars(paste(mm_path, "eval_16_cli_pars.csv", sep = ""), E)
```

```
## Error in write.table(file = filename.fill, df.eval, row.names = FALSE, : object 'filename.fill' not found
```
Климатические параметры сопоставлялись с данными по клеточной структуре годичных колец лиственницы (Larix cajanderi, Mayr.), произрастающей в районе нижнего течения р. Индигирки (690 27’-700 30’ с.ш., 1480 07’-1500 27’ в.д.).



Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.

<https://glvrd.ru>
<http://www.bioclass.ru/files/R_0_3.pdf>

read 
<http://distrland.blogspot.ru/2016/05/ggplot2_21.html#more>
<http://distrland.blogspot.ru/2016/05/ggplot2.html#more>
<http://distrland.blogspot.ru/2016/04/k-k-nearest-neighbors-r.html#more>
<http://distrland.blogspot.ru/2016/03/ggplot2.html#more>
<http://distrland.blogspot.ru/2016/02/r-8-yahoo-r.html#more>
<http://distrland.blogspot.ru/2015/02/r.html#more>
<http://distrland.blogspot.ru/2014/12/excel-r.html#more>
<http://distrland.blogspot.ru/2014/12/r.html#more>
