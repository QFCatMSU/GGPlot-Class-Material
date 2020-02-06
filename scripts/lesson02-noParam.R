{
  # read in the lines of code from helper.r
  source("scripts/helper.r");   

  # read in CSV file and save the content to packageData
  packageData = read.csv("data/CRANpackages.csv");
  
  #### Part 1: Create a scatterplot ####
  plotData = ggplot( packageData ) + 
    geom_point( aes(Date, Packages) );
  plot(plotData);
}