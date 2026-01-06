{
  rm(list=ls());                         # clear Environment tab
  options(show.error.locations = TRUE);  # show line numbers on error
  library(package=ggplot2);              # get the GGPlot package

  ### Use application from boxplots2 ####
  
  ### Computed variables -- do with geom_text (2 lessons?) ###
  
  # read in CSV file and save the content to weatherData
  weatherData = read.csv(file="data/Lansing2016NOAA.csv", 
                         stringsAsFactors = FALSE);  # for people still using R v3
  
  #### Part 1: Factoring the values in season ####
  seasonOrdered = factor(weatherData$season,
                         levels=c("Spring", "Summer", "Fall", "Winter"));

  # Note that, in a mapping, the plot component will first check the columns 
  # of the data frame (avgTemp).  Then it will check the Environment (seasonOrdered)

  #### Histogram with factored seasons ####
  plot1 = ggplot( data=weatherData ) +
    geom_histogram( mapping=aes(x=avgTemp, fill=seasonOrdered),
                    color="black") +  # outline color -- not mapped
    theme_bw() +
    scale_fill_manual(values=c("lightgreen", "pink", 
                               "lightyellow", "lightblue")) +
    labs(title = "Temperature (\u00B0F)",
         subtitle = "Lansing, Michigan: 2016",
         x = "Temperature (\u00B0F)",  
         fill = "Seasons");     
  plot(plot1);

  #### Part 2: Faceting the histogram ####
  plot2 = ggplot( data=weatherData ) +
    geom_histogram( mapping=aes(x=avgTemp),
                    color="black") +  
    theme_bw() +
    facet_grid( rows=vars(season) ) + # vars() checks the data frame
    labs(title = "Temperature (\u00B0F)",
         subtitle = "Lansing, Michigan: 2016",
         x = "Temperature (\u00B0F)");     
  plot(plot2);

  #### Part 3: Reordering the seasons ####
  # Need to put seasonOrdered in the data frame
  weatherData$seasonOrdered = seasonOrdered;
  
  # Use seasonOrdered (from the data frame) instead of season
  plot3 = ggplot( data=weatherData ) +
    geom_histogram( mapping=aes(x=avgTemp),
                    color="black") +  
    theme_bw() +
    facet_grid( rows=vars(seasonOrdered) ) + 
    labs(title = "Temperature (\u00B0F)",
         subtitle = "Lansing, Michigan: 2016",
         x = "Temperature (\u00B0F)");     
  plot(plot3);
  
  #### Part 4: Reversing the facet equation ####
  plot4 = plot3 +
    facet_grid( cols=vars(seasonOrdered));
  plot(plot4);

  #### Part 5: Adding color and switching to a density plot ####
  plot5 = ggplot( data=weatherData ) +
    geom_density( mapping=aes(x=avgTemp, fill=season),
                  color="black") +  
    theme_bw() +
    facet_grid( cols=vars(seasonOrdered)) +  # season has to be in the data frame
    labs(title = "Temperature (\u00B0F)",
         subtitle = "Lansing, Michigan: 2016",
         x = "Temperature (\u00B0F)");     
  plot(plot5);
  
  #### Part 6: Faceting a scatterplot ####  
  plot6 = ggplot( data=weatherData ) +
    geom_point( mapping=aes(x=avgTemp, y=relHum)) +  
    theme_bw() +
    facet_grid( rows = vars(seasonOrdered) ) +  
    labs(title = "Temperature (\u00B0F)",
         subtitle = "Lansing, Michigan: 2016",
         x = "Temperature (\u00B0F)");     
  plot(plot6);
  
  #### Part 6b: Faceting a barplot ####  
  plot6b = ggplot( data=weatherData ) +
    geom_bar( mapping=aes(x=avgTemp)) +  
    theme_bw() +
    facet_grid( rows = vars(seasonOrdered) ) +  
    labs(title = "Temperature (\u00B0F)",
         subtitle = "Lansing, Michigan: 2016",
         x = "Temperature (\u00B0F)");     
  plot(plot6b);
  
  ### Part 7: Boxplots ####
  ### Re-order the directions on the x-axis using factor(s)
  windDirOrdered = factor(weatherData$windDir,
                       levels=c("North", "East", "South", "West"));
  
  #### A Boxplot ####
  plot7 = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDirOrdered, y=changeMaxTemp)) +
    theme_bw() +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Change in Temperature (\u00B0F)");
  plot(plot7);
  
  #### Part 8: Map color to windSpeed(s)
  # windSpeedOrdered = factor(weatherData$windSpeedLevel,
  #                         levels=c("Low", "Medium", "High"));
  
  # A Boxplot with a mapping ####
  plot8 = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDirOrdered, y=changeMaxTemp, fill=windSpeedLevel),
                 na.rm = TRUE) +  # gets rid of warning about non-finite values
    theme_bw() +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)",
         fill = "Wind Speed");
  plot(plot8);
  
  #### Part 9: Same boxplot faceted by wind speed instead of mapped ####
  plot9 = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDirOrdered, y=changeMaxTemp),
                 na.rm = TRUE) +  
    theme_bw() +
    facet_grid( cols=vars(windSpeedLevel)) + 
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)");
  plot(plot9);
  
  #### Part 10: violin plot (make this earlier!) ####
  plot10 = ggplot(data=weatherData) +
    geom_violin(mapping=aes(x=windDirOrdered, y=changeMaxTemp),
                na.rm = TRUE) +
    theme_bw() +
    facet_grid( cols=vars(windSpeedLevel)) +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)");
  plot(plot10);
  
  #### Part 11: Manually setting colors (not mapped!) ####
  plot11 = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDirOrdered, y=changeMaxTemp),
                 na.rm = TRUE,   # gets rid of warning about non-finite values
                 color = "brown",
                 fill = "grey70") +
    theme_bw() +
    facet_grid( cols=vars(windSpeedLevel)) +  
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)");
  plot(plot11);

  
  #### Part 12: Manually setting all 12 boxes (not mapped!) ####
  # there are 12 boxes to color so we need a vector with 12 colors:
  boxColors = c("blue", "blue", "blue", "brown",
                "brown", "brown", "brown", "brown",
                "brown", "brown", "brown", "brown");
  
  ### same vector as above -- uses repeat function: 
  boxColors = c(rep("blue", 3),
                rep("brown", 9));
  
  plot12 = ggplot(data=weatherData) +
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
  plot(plot12);

  #### Part 13: Messing with the outliers ####
  plot13 = ggplot(data=weatherData) +
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
  plot(plot13);
  
  #### Part 14: Extension -- Error bars  ####
  plot14 = ggplot(data=weatherData) +          
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
    plot(plot14);
  
  #### App answer to 1 
  weatherData$windSpeedOrdered = factor(weatherData$windSpeedLevel,
                         levels=c("High" , "Medium" , "Low"));  #order of windspeed
  
  weatherData$windDirOrdered = factor(weatherData$windDir,
                          levels=c("North", "South", "East", "West")); #order of wind direction
  
  plotA1 = ggplot( data=weatherData ) +
    geom_point( mapping=aes(x=avgTemp, y=relHum)) + 
    theme_bw() +
    facet_grid( rows = vars(windDirOrdered),
                cols = vars(windSpeedOrdered)) + # set rows and cols variables 
    labs(title = "Temperature (\u00B0F)",
         subtitle = "Lansing, Michigan: 2016",
         x = "Temperature (\u00B0F)",
         y = "Humidity (\u0025)"); 
  plot(plotA1);
  
  #### App answer to 1 
  plotA1b = ggplot( data=weatherData ) +
    geom_point( mapping=aes(x=avgTemp, y=relHum)) + 
    theme_bw() +
    facet_grid( rows = vars(windDirOrdered),
                cols = vars(windSpeedOrdered),
                scale = "free") + # set rows and cols variables 
    labs(title = "Temperature (\u00B0F)",
         subtitle = "Lansing, Michigan: 2016",
         x = "Temperature (\u00B0F)",
         y = "Humidity (\u0025)"); 
  plot(plotA1b);
}