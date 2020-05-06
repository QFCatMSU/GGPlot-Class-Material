{
  rm(list=ls());                         # clear Console Window
  options(show.error.locations = TRUE);  # show line numbers on error
  library(package=ggplot2);              # include all GGPlot2 functions
  library(package=gridExtra);            # used in lesson10 - Multipanel Plots
  
  # used in extension for lesson 7 -- Boxplots2
  findQuants = function(yVar, xVar, factors, percentile)
  {
    quants = c();
    for(i in factors)
    {
      quantIndex = which(xVar == i);
      quants[i] = quantile(yVar[quantIndex], percentile, na.rm=TRUE);
    }
    return(quants)
  }
}