{
  source(file="scripts/reference.R");  
  weatherData = read.csv(file="data/LansingNOAA2016-2.csv", 
                         stringsAsFactors = FALSE);
  
  #### Part 1: Create a wind direction column
  windSpeedQuant = quantile(weatherData$windSpeed, probs=c(.30, .70));
  
  for(day in 1:nrow(weatherData))
  {
    ## Adding a column that gives relative wind speed for the day
    # Winds less than 6.4 miles/hour -- label as "Low"
    if(weatherData$windSpeed[day] <= windSpeedQuant[1])
    {
      weatherData$windSpeedLevel[day] = "Low";
    }
    # Winds greater than 10.2 miles/hour -- label as "High"
    else if(weatherData$windSpeed[day] >= windSpeedQuant[2])
    {
      weatherData$windSpeedLevel[day] = "High";
    }
    else # wind speeds between 6.4 and 10.2 miles/hour -- label as "Medium"
    {
      weatherData$windSpeedLevel[day] = "Medium";
    }
  }
  for(day in 1:nrow(weatherData))
  {
    ## Adding a column that gives the cardinal wind direction
    # if the direction is greater than 315 OR less than 45 degrees
    if(weatherData$windSusDir[day] >= 315 ||
       weatherData$windSusDir[day] < 45)
    {
      weatherData$windDir[day] = "North";
    }
    # if the direction is greater than 45 AND less than 135 degrees
    else if(weatherData$windSusDir[day] >= 45 &&
            weatherData$windSusDir[day] < 135)
    {
      weatherData$windDir[day] = "East";
    }
    # if the direction is greater than 135 AND less than 225 degrees
    else if(weatherData$windSusDir[day] >= 135 &&
            weatherData$windSusDir[day] < 225)
    {
      weatherData$windDir[day] = "South";
    }
    else # the directions is between 225 and 315 degrees
    {
      weatherData$windDir[day] = "West";
    }
  }
  for(day in 1:nrow(weatherData))
  {
    ### Adding a changeMaxTemp column
    if(day == 1)
    {
      weatherData$changeMaxTemp[day] = NA;
    }
    else
    {
      weatherData$changeMaxTemp[day] = weatherData$maxTemp[day] -
                                       weatherData$maxTemp[day-1];
    }
  }

  write.csv(weatherData, file="data/LansingNOAA2016-3.csv");

  #### Part 2: Boxplot of the change in max temp vs wind direction
  thePlot = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDir, y=changeMaxTemp),
                 notch=TRUE) +
    theme_bw() +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)");
  plot(thePlot);

  #### Part 3: Violin plot of  max temp vs wind direction
  thePlot = ggplot(data=weatherData) +
    geom_violin(mapping=aes(x=windDir, y=changeMaxTemp), na.rm=TRUE) +
    theme_bw() +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)");
  plot(thePlot);

  #### Part 4: Add error bars
  thePlot = ggplot(data=weatherData) +
    stat_boxplot(mapping=aes(x=windDir, y=changeMaxTemp), na.rm=TRUE,
                 geom = "errorbar", width = 0.2) +
    geom_boxplot(mapping=aes(x=windDir, y=changeMaxTemp), na.rm=TRUE) +
    theme_bw() +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)");
  plot(thePlot);

  #### Part 5: Reorder the x-axis (factors)
  windDirFact = factor(weatherData$windDir,
                       levels=c("North", "East", "South", "West"));

  thePlot = ggplot(data=weatherData) +
    stat_boxplot(mapping=aes(x=windDirFact, y=changeMaxTemp), na.rm=TRUE,
                 geom = "errorbar", width = 0.2, show.legend = TRUE) +
    geom_boxplot(mapping=aes(x=windDirFact, y=changeMaxTemp), na.rm=TRUE) +
    theme_bw() +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)");
  plot(thePlot);

  ### Part 6: Modify outliers
  thePlot = ggplot(data=weatherData) +
    stat_boxplot(mapping=aes(x=windDirFact, y=changeMaxTemp), na.rm=TRUE,
                 geom = "errorbar", width = 0.2) +
    geom_boxplot(mapping=aes(x=windDirFact, y=changeMaxTemp), na.rm=TRUE,
                 outlier.shape = "@", outlier.color = "red",
                 outlier.alpha = 0.6, outlier.size = 4 ) +
    theme_bw() +
    scale_x_discrete(limits = c("North", "East", "South", "West")) +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)");
  plot(thePlot);

  ### Part 7: Add mean and median text
  northVals=which(weatherData$windDir == "North");
  southVals=which(weatherData$windDir == "South");

  northMed = median(weatherData[northVals,"changeMaxTemp"], na.rm=TRUE);
  southMed = median(weatherData[southVals,"changeMaxTemp"], na.rm=TRUE);

  thePlot = ggplot(data=weatherData) +
    stat_boxplot(mapping=aes(x=windDirFact, y=changeMaxTemp), na.rm=TRUE,
                 geom = "errorbar", width = 0.2) +
    geom_boxplot(mapping=aes(x=windDirFact, y=changeMaxTemp), na.rm=TRUE,
                 outlier.shape = NA) +
    annotate(geom="text", x=1, y=20, color="blue",    # North Median
             label=paste("median:", northMed) ) +
    annotate(geom="text", x=3, y=-10, color="red",    # South Median
             label=paste("median:", southMed) ) +
    theme_bw() +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)");
  plot(thePlot);
}  