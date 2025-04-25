{
  rm(list=ls());                         # clear Environment tab
  options(show.error.locations = TRUE);  # show line numbers on error
  library(package=ggplot2);              # get the GGPlot package

  ### Use application from boxplots2 ####
  
  # read in CSV file and save the content to weatherData
  weatherData = read.csv(file="data/Lansing2016NOAA.csv", 
                         stringsAsFactors = FALSE);  # for people still using R v3
  
  ### Part 1: Boxplot ####
  plot1 = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDir, y=changeMaxTemp),
                 position= position_nudge(x=-.5)) +
    theme_bw() +
    scale_x_discrete(expand=expansion(add=c(1,0)))+
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Change in Temperature (\u00B0F)");
  plot(plot1);
  
  
  ### Part 1: Boxplot ####
  plot1 = ggplot(data=weatherData) +
    geom_violin(mapping=aes(x=windDir, y=changeMaxTemp)) +
    geom_point(mapping=aes(x=windDir, y=changeMaxTemp),
               position = position_jitter(width = 0.2)) +
    theme_bw() +
    scale_x_discrete(expand=expansion(add=c(1,0)))+
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Change in Temperature (\u00B0F)");
  plot(plot1);
  
  ### Re-order the directions on the x-axis using factor(s)
  windDirOrdered = factor(weatherData$windDir,
                          levels=c("North", "East", "South", "West"));
  
  #### A Reordering the Boxplot ####
  plot2 = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDirOrdered, y=changeMaxTemp)) +
    theme_bw() +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Change in Temperature (\u00B0F)");
  plot(plot2);
  
  ### Part 3: Changing Boxplot Axis ####
  plot3 = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDir, y=changeMaxTemp),
                 color = c("red", "green", "blue", "orange"),
                 fill = c("green", "blue", "orange", "red")) +
    theme_bw() +
    scale_x_discrete(breaks=c("North","West"),
      limits=c("North","East","","South", "", "West")) +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Change in Temperature (\u00B0F)");
  plot(plot3);
  
  
  plot5Alt = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDirOrdered, y=changeMaxTemp, 
                             color=windSpeedLevel, fill=windSpeedLevel),
                 na.rm = TRUE) +  # gets rid of warning about non-finite values
    theme_bw() +
    scale_fill_manual(values=c("red", "orange", "purple")) +
    scale_color_manual(values=c("blue", "black", "brown")) +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)",
         fill = "Wind Speed");
  plot(plot5Alt);
}