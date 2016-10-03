#===============================================================================
# Name   : R script 
# Author : https://gist.github.com/hrbrmstr
# Date   : 31/01/2014 19:48:33
# Version: v3
# URL    : https://gist.githubusercontent.com/hrbrmstr/96b136bdfb74ffc258e2/raw/98c89b67f9f3c1a01cb206551e7bab704a01d368/daylight.R
#===============================================================================

library(maptools)
library(ggplot2)
library(gridExtra)
library(scales)

ephemeris <- function(lat, lon, date, span = 1, tz = "UTC") {
    
    lon.lat <- matrix(c(lon, lat), nrow = 1)
    
    # using noon gets us around daylight saving time issues
    day <- as.POSIXct(sprintf("%s 12:00:00", date), tz = tz)
    sequence <- seq(from = day, length.out = span, by = "days")
    
    sunrise <- sunriset(lon.lat, sequence, direction = "sunrise", POSIXct.out = TRUE)
    sunset <- sunriset(lon.lat, sequence, direction = "sunset", POSIXct.out = TRUE)
    solar_noon <- solarnoon(lon.lat, sequence, POSIXct.out = TRUE)
    
    data.frame(date = as.Date(sunrise$time), sunrise = as.numeric(format(sunrise$time, 
        "%H%M")), solarnoon = as.numeric(format(solar_noon$time, "%H%M")), sunset = as.numeric(format(sunset$time, 
        "%H%M")), day_length = as.numeric(sunset$time - sunrise$time))
    
}

print(ephemeris(43.071755, -70.762553, "2014-10-31", 10, tz="America/New_York"))

suncalc <- function(d, Lat = 0, Long = 0, UTC = TRUE) {
    ## d is the day of year Lat is latitude in decimal degrees Long is longitude in decimal
    ## degrees (negative == West)
    
    ## This method is copied from: Teets, D.A. 2003. Predicting sunrise and sunset times.
    ## The College Mathematics Journal 34(4):317-321.
    
    ## At the default location the estimates of sunrise and sunset are within seven minutes
    ## of the correct times (http://aa.usno.navy.mil/data/docs/RS_OneYear.php) with a mean
    ## of 2.4 minutes error.
    
    ## Function to convert degrees to radians
    rad <- function(x) pi * x/180
    
    ## Radius of the earth (km)
    R = 6378
    
    ## Radians between the xy-plane and the ecliptic plane
    epsilon = rad(23.45)
    
    ## Convert observer's latitude to radians
    L = rad(Lat)
    
    ## Calculate offset of sunrise based on longitude (min) If Long is negative, then the
    ## mod represents degrees West of a standard time meridian, so timing of sunrise and
    ## sunset should be made later.
    if (UTC) {
        timezone = 0
    } else {
        timezone = -4 * (abs(Long)%%15) * sign(Long)
    }
    
    ## The earth's mean distance from the sun (km)
    r = 149598000
    
    theta = 2 * pi/365.25 * (d - 80)
    
    z.s = r * sin(theta) * sin(epsilon)
    r.p = sqrt(r^2 - z.s^2)
    
    t0 = 1440/(2 * pi) * acos((R - z.s * sin(L))/(r.p * cos(L)))
    
    ## a kludge adjustment for the radius of the sun
    that = t0 + 5
    
    ## Adjust 'noon' for the fact that the earth's orbit is not circular:
    n = 720 - 10 * sin(4 * pi * (d - 80)/365.25) + 8 * sin(2 * pi * d/365.25)
    
    ## now sunrise and sunset are:
    if (UTC) {
        sunrise = (n - that)/60
        sunset = (n + that)/60
    } else {
        sunrise = (n - that + timezone)/60
        sunset = (n + that + timezone)/60
    }
    
    return(list(sunrise = sunrise, sunset = sunset))
}

t <- Sys.time() + seq(-3600 * 12, 3600 * 12, , by = 600)
t0 = as.POSIXlt(Sys.time(), tz = "UTC")
sun = suncalc(t0[["yday"]], UTC = TRUE)

# https://tools.wmflabs.org/geohack/geohack.php?language=ru&pagename=%D0%9C%D0%B0%D0%BB%D0%B0%D1%8F_%D0%9C%D0%B8%D0%BD%D1%83%D1%81%D0%B0&params=53.729078_0_0_N_91.789351_0_0_E_scale:100000
suncalc(1, 53.43, 91.47)




