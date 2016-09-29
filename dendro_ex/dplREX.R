# 
require(compiler)
enableJIT(level = 3)
(.packages(all.available=TRUE))

data(co021, package = "dplR")

years <- as.integer(rownames(co021))

co021.subset <- (subset(co021, subset = years >= 1900 & years <= 1950))

co021.subset <- co021.subset[, -c(28, 30, 31)]  ## to remove the following series '645232','646107' and '646118'

EPS.value(co021.subset, stc = c(0, 8, 0))


# choose.files("", filters = Filters[c("zip", "tarball", "All"), ])
# 
# https://github.com/uarun/dotfiles/tree/master/fonts
# https://cran.r-project.org/web/packages/dplR/index.html
# https://cran.r-project.org/web/packages/dplRCon/index.html
# https://cran.r-project.org/web/packages/detrendeR/index.html
# http://www.wine-reviews.net/2009/03/how-to-enable-font-anti-aliasing-in.html
