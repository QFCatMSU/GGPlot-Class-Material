{ 
  rm(list=ls());                         # clear Console Window
  options(show.error.locations = TRUE);  # show line numbers on error
  library(package=ggplot2);              # include all GGPlot2 functions
  
  weatherData = read.csv(file="data/lesson01.csv");
  
  #### Labels for the facets of the plot
  windLabels = c(Low = "Light Winds",
                 Medium = "Medium Winds",
                 High = "Strong Winds");
  
  #### Boxplots of Change in Temperature vs. Wind Direction 
  #           at different wind speeds
  thePlot = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDir, y=changeMaxTemp), 
                 na.rm=TRUE,
                 color=c("purple", rep("grey", 3),
                         "green", rep("lightgrey", 3),
                         "brown", rep("darkgrey", 3)),
                 fill=c(rep(NA, 8), rep("yellow", 3), NA)) +
    theme_bw() +
    facet_grid(facets=.~factor(windSpeedLevel,
                               levels=c("Low", "Medium", "High")),
               labeller=as_labeller(windLabels)) +
    scale_x_discrete(limits=c("North", "East", "South", "West")) +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)");
  plot(thePlot);
}  