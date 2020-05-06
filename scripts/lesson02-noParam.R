{
  # read in the lines of code from reference.r
  source("scripts/reference.r");   

  # read in CSV file and save the content to packageData
  packageData = read.csv("data/CRANpackages.csv");
  
  #### Part 1: Create a scatterplot without any parameters names ####
  plotData = ggplot( packageData ) + 
    geom_point( aes(Date, Packages) );
  plot(plotData);
}