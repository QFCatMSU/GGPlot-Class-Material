{
  rm(list=ls());                         # clear Environment tab
  options(show.error.locations = TRUE);  # show line numbers on error
  library(package=ggplot2);              # get the GGPlot package
  
  ### Use application from boxplots2 ####
  
  ### Computed variables -- do with geom_text (2 lessons?) ###
  
  # read in CSV file and save the content to weatherData
  weatherData = read.csv(file="data/Lansing2016NOAA.csv", 
                         stringsAsFactors = FALSE);  # for people still using R v3
  
  windSpeedLevel_2 = factor(weatherData$windSpeedLevel,
                            levels=c("Low", "Medium", "High"));
  
  windDir_2 = factor(weatherData$windDir,
                     levels=c("North", "East", "South", "West"));
  
  #### Part 10: Modifying rectangular components ####
  plot10 = ggplot( data=weatherData ) +
    geom_point( mapping=aes(x=relHum, y=avgTemp, color=windSpeed, 
                            shape=windDir_2),
                size=4) +
    theme_minimal() +
    labs(title = "Humidity vs Temperature",
         subtitle = "Lansing, Michigan: 2016",
         y = "Temp (F)",
         x = "Humidity (%)") +
    scale_color_gradientn(colors=c("green", "yellow", "purple"),
                          values=c(0,0.2,1)) +
    scale_shape_manual(values=c("~", "%", "@", "*")) +
    scale_x_continuous(breaks = c(50,60,70,80,90)) +
    scale_y_continuous(limits = c(0, 100)) +
    theme( axis.title.x=element_text(size=16),
           axis.title.y=element_text(size=12, angle=0, vjust=0.5),
           plot.title=element_text(size=18, face="bold", hjust=0.5,
                                   color ="darkgreen"),
   #        strip.background = element_rect(fill="pink", color="pink"),
           plot.subtitle=element_text(size=10, face="italic", hjust=0.5),
           axis.line.x.bottom = element_line(size = 2, color = "blue"),
           axis.line.y.left = element_line(size = 2, color = "blue"),
           axis.ticks.y.left = element_line(color="purple", size=5),
           axis.text.x=element_text(angle=270, vjust=0.5, color="maroon",
                                    face="bold") ,
           legend.background = element_rect(color="green", fill="grey90",
                                            size=1, linetype=2),
           legend.key = element_rect(fill="lightblue", color="blue"),
           legend.position="bottom",
           legend.title = element_text(color="brown", face="bold", vjust=.85),
           panel.grid.major = element_line(size=1, color="grey30"),
           panel.grid.minor = element_line(size=.2, linetype=4, color="grey40"),
           plot.background = element_rect(fill="lightyellow"),
           panel.background = element_rect(fill="black"));
  plot(plot10);
}