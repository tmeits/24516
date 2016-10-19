#===============================================================================
# Name   : Set the absolute path of the project to dropbox for different workstations
# Author : IVA
# Date   : 18.10/2016
#===============================================================================

## Set work path
getOsVersion <- function() {
    sysinf <- Sys.info()
    if (!is.null(sysinf)) 
        osVersion <- sysinf["version"] else stop("mystery machine...")
    return(osVersion)
}
getOsVersion()

# Installation of a working directory
setWorkDir <- function(osVersion) {
    if (osVersion == "build 2600, Service Pack 3") 
        setwd("Z:/home/larisa/Dropbox/24516/transect/")
    else if (osVersion == "#32-Ubuntu SMP Fri Apr 16 08:10:02 UTC 2010")
        setwd("/home/larisa/Dropbox/24516/transect/")
    else if (osVersion == "build 7601, Service Pack 1")
        setwd("C:/Users/IVA/Dropbox/24516/transect/") else stop("mystery...")
    return(getwd())
}
mm_path <- setWorkDir(getOsVersion())
mm_path



