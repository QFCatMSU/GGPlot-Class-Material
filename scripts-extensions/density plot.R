{
  rm(list=ls());                         # clear Environment tab
  options(show.error.locations = TRUE);  # show line numbers on error
  library(package=ggplot2);              # get the GGPlot package
  
  # read in CSV file and save the content to weatherData
  weatherData = read.csv(file="data/Lansing2016NOAA.csv", 
                         stringsAsFactors = FALSE);  # for people still using R v3

  
  #### Part 2: Factoring the values in season ####
  seasonOrdered = factor(weatherData$season,
                         levels=c("Spring", "Summer", "Fall", "Winter"));
  
  #### Part 6: Our first histogram -- note there is only an x-mapping ####
  plot6 = ggplot( data=weatherData ) +
    geom_histogram( mapping=aes(x=avgTemp)) +
    theme_bw() +
    labs(title = "Temperature (\u00B0F)",
         subtitle = "Lansing, Michigan: 2016",
         x = "Temperature (\u00B0F)");     
  plot(plot6);
  
  #### Part 7: Mapping fill color in a histogram ####
  plot7 = ggplot( data=weatherData ) +
    geom_histogram( mapping=aes(x=avgTemp, fill=seasonOrdered)) +  
    theme_bw() +
    scale_fill_manual(values=c("lightgreen", "pink", 
                               "lightyellow", "lightblue")) +
    labs(title = "Temperature (\u00B0F)",
         subtitle = "Lansing, Michigan: 2016",
         x = "Temperature (\u00B0F)",  
         fill = "Seasons");     
  plot(plot7);
  
 
}