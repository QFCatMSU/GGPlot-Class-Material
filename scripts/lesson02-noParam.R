{
  rm(list=ls());                         # clear Console Window
  options(show.error.locations = TRUE);  # show line numbers on error
  library(package=ggplot2);              # include all GGPlot2 functions
  
  # read in the lines of code from helper.r
  source("scripts/helper.r");   

  # read in CSV file and save the content to packageData
  packageData = read.csv("data/CRANpackages.csv");
  
  #### Part 1: Create a scatterplot without any parameters names ####
  plotData = ggplot( packageData ) + 
    geom_point( aes(Date, Packages) );
  plot(plotData);
}