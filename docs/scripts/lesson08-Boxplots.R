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
    geom_boxplot(mapping=aes(x=windDir, y=changeMaxTemp)) +
    theme_bw() +
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
    geom_boxplot(mapping=aes(x=changeMaxTemp, y=windDir)) +
    theme_bw() +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Change in Temperature (\u00B0F)");
  plot(plot3);
  
  set.seed(seed=12);
  ### Part 4: Add points in jittered form ####
  plot4 = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(y=windDir, x=changeMaxTemp)) +
    geom_jitter(mapping=aes(y=windDir, x=changeMaxTemp), 
                height=0.3,   # range of random vertical component (-0.3 -> 0.3)
                width = 0,    # no random horizontal component
                alpha=0.2,    # make points semi-transparent
                color="blue") + 
    theme_bw() +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Change in Temperature (\u00B0F)");
  plot(plot4);
  
  #### Part 5: Map color to windSpeed(s)
  # windSpeedOrdered = factor(weatherData$windSpeedLevel,
  #                         levels=c("Low", "Medium", "High"));
  
  # A Boxplot with a mapping ####
  plot5 = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDirOrdered, y=changeMaxTemp, fill=windSpeedLevel),
                 na.rm = TRUE) +  # gets rid of warning about non-finite values
    theme_bw() +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)",
         fill = "Wind Speed");
  plot(plot5);
  
  #### Part 6: Same boxplot faceted by wind speed instead of mapped ####
  plot6 = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDirOrdered, y=changeMaxTemp),
                 na.rm = TRUE) +  
    theme_bw() +
    facet_grid( cols=vars(windSpeedLevel)) + 
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)");
  plot(plot6);
  
  #### Part 7: violin plot ####
  plot7 = ggplot(data=weatherData) +
    geom_violin(mapping=aes(x=windDirOrdered, y=changeMaxTemp),
                na.rm = TRUE) +
    theme_bw() +
    facet_grid( cols=vars(windSpeedLevel)) +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)");
  plot(plot7);
  
  #### Part 8: Manually setting colors (not mapped!) ####
  plot8 = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDirOrdered, y=changeMaxTemp),
                 na.rm = TRUE,   # gets rid of warning about non-finite values
                 color = "brown",
                 fill = "grey70") +
    theme_bw() +
    facet_grid( cols=vars(windSpeedLevel)) +  
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)",
         fill="Wind Speed");
  plot(plot8);

  
  #### Part 9: Manually setting all 12 boxes (not mapped!) ####
  # there are 12 boxes to color so we need a vector with 12 colors:
  boxColors = c("blue", "blue", "blue", "brown",
                "brown", "brown", "brown", "brown",
                "brown", "brown", "brown", "brown");
  
  ### same vector as above -- uses repeat function: 
  boxColors = c(rep("blue", 3),
                rep("brown", 9));
  
  plot9 = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDirOrdered, y=changeMaxTemp),
                 na.rm = TRUE,  
                 color = boxColors,
                 fill = "grey70") +
    theme_bw() +
    facet_grid( cols=vars(windSpeedLevel)) +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)");
  plot(plot9);

  #### Part 10: Messing with the outliers ####
  plot10 = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDirOrdered, y=changeMaxTemp),
                 na.rm = TRUE,   # gets rid of warning about non-finite values
                 color = boxColors,
                 fill = "grey50",
                 outlier.color = rgb(red=0, green=0.3, blue=0),
                 outlier.shape = "\u053e") +
    theme_bw() +
    facet_grid( cols=vars(windSpeedLevel)) +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)");
  plot(plot10);
  
  ### Part 11: Changing facet labels
  windLabels = c(Low = "Light Winds",
                 Medium = "Medium Winds",
                 High = "Strong Winds");

  plot11 = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDirOrdered, y=changeMaxTemp),
                 na.rm = TRUE,   # gets rid of warning about non-finite values
                 color = boxColors,
                 fill = "grey50",
                 outlier.color = rgb(red=0, green=0.3, blue=0),
                 outlier.shape = "\u053e") +
    theme_bw() +
    facet_grid( cols=vars(windSpeedLevel),
                labeller=as_labeller(windLabels)) +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)");
  plot(plot11);

  #### Extension -- Error bars  ####
  plotA = ggplot(data=weatherData) +          
      stat_boxplot(mapping=aes(x=windDirOrdered, y=changeMaxTemp),
                   na.rm=TRUE,
                   geom = "errorbar",   # adds the whisker ends
                   width = 0.2,         # width of whisker ends (0 to 1)
                   color = boxColors) + # keep ends the same color as whiskers
      geom_boxplot(mapping=aes(x=windDirOrdered, y=changeMaxTemp),
                   na.rm = TRUE,  
                   color = boxColors,
                   fill = "grey50",
                   outlier.color = rgb(red=0, green=0.3, blue=0),
                   outlier.shape = "\u053e") +
      theme_bw() +
      facet_grid( cols=vars(windSpeedLevel)) +
      labs(title = "Change in Temperature vs. Wind Direction",
           subtitle = "Lansing, Michigan: 2016",
           x = "Wind Direction",
           y = "Degrees (Fahrenheit)");
    plot(plotA);
}