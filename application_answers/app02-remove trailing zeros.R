{
  # read in the lines of code from helper.r
  source(file="scripts/reference.r"); 

  # read in CSV file and save the content to packageData
  packageData = read.csv(file="data/accdeaths.csv");
  
  plotData = ggplot( data=packageData ) +
    geom_point( mapping=aes(x=time, y=value) ) +
    ggtitle( label="Accidental deaths in US 1973-1978" ) +
    # labels "renames" the axis tick values and for unknown reasons removes the trailing zeros
    scale_x_continuous( breaks = seq(from=1973, to=1978, by=.5),   # where the breaks are
                        labels = seq(from=1973, to=1978, by=.5)) + # how the breaks are labelled
    scale_y_continuous( breaks = seq(from=5000, to=15000, by=2000) ) +
    theme( axis.text.x=element_text(angle=45, hjust=1) );
  plot(plotData);
}