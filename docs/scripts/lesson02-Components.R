{
  # read in the lines of code from reference.r
  source(file="scripts/reference.r");   

  # read in CSV file and save the content to packageData
  packageData = read.csv(file="data/CRANpackages.csv");
  
  #### Part 1: Create a scatterplot ####
  plot1 = ggplot( data=packageData ) + 
    geom_point( mapping=aes(x=Date, y=Packages) );
  plot(plot1);

  #### Part 1b: Same scatterplot without parameters
  #   From here on out, this class uses parameters! ####
  plot1b = ggplot( packageData ) + 
    geom_point( aes(Date, Packages) );
  plot(plot1b);
  
  #### Part 2: Adding layers to the scatterplot ####
  plot2 = ggplot( data=packageData ) +
    geom_point( mapping=aes(x=Date, y=Packages) ) +
    ggtitle( label="Packages in CRAN (2001-2014)" ) +
    scale_y_continuous( breaks = seq(from=0, to=6000, by=500) ) +
    theme( axis.text.x=element_text(angle=90, hjust=1) );
  plot(plot2);
}