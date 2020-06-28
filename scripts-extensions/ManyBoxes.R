{
  source(file="scripts/reference.R");  
  weatherData = read.csv(file="data/LansingNOAA2016-2.csv", 
                         stringsAsFactors = FALSE);

  ### Added ugliness: this method makes the x-axis continuous -- which does not make a lot sense
  
  #### Dual boxes with different scales
  thePlot = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=0, y=avgTemp), na.rm=TRUE) +
    geom_boxplot(mapping=aes(x=1, y=maxTemp), na.rm=TRUE) +
    geom_boxplot(mapping=aes(x=2, y=(3*windSpeed+5)), na.rm=TRUE) + # scale
    theme_bw() +
    scale_y_continuous(sec.axis = sec_axis(trans= ~ (.-5)/3,        # reverse-scale 
                                           name="Wind Speed (mph)")) + 
    scale_x_continuous(breaks=c(0, 1, 2),
                       labels=c("Avg Temp", "Max Temp", "Wind Speed")) +
    labs(title = "Average Temp and Wind Speed",
         subtitle = "Lansing, Michigan: 2016",
         x = "",
         y = "Temperature (F)");
  plot(thePlot);
}  