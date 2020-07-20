{
  source(file="scripts/reference.R");  
  weatherData = read.csv(file="data/LansingNOAA2016.csv", 
                         stringsAsFactors = FALSE);
  
  ###############################
  # This code is functionally the same as in app06.r but uses a different method
  # for doing for loops -- a method I do not recommend
  ###############################
  
  #### Part 1: Create a pressure level column ####
  
  # find the 20%, 40%, 60%, and 80% quantile values of "stnPressure" column
  # so, pressureQuant will be a vector with 4 values
  pressureQuant = quantile(weatherData$stnPressure,    
                           probs=c(.20, .40, .60, .80));

  # "val" will take on each of the 366 values in the "day" column
  #  so, this for loop will execute 366 times for each value in the "day" column
  #  This is not the preferred way to do for loops -- but you often see it done this way
  
  day = 1;    # you still need a count value...
  for(val in weatherData$stnPressure)  # checking each values in stnPressure column
  {
    if(val <= pressureQuant[1])
    {
      weatherData$pressureLevel[day] = "Very Low";
    }
    else if(val <= pressureQuant[2])
    {
      weatherData$pressureLevel[day] = "Low";
    }
    else if(val <= pressureQuant[3])
    {
      weatherData$pressureLevel[day] = "Medium";
    }
    else if(val <= pressureQuant[4])
    {
      weatherData$pressureLevel[day] = "High";
    }
    else
    {
      weatherData$pressureLevel[day] = "Very High";
    }
    day = day +1; # increment for the next loop (each val represents a new day)
  }
  
  #### Part 2: Boxplot of the wind speed vs pressure level ####
  
  #### For the three outliers...
  # index values for the windSusSpeed column in descending order 
  descendingIndex = order(weatherData$windSusSpeed, decreasing=TRUE);
  threeHigh = descendingIndex[1:3];   # the indeices the of three highest values
  # get the three highest wind speeds
  highWindSpeeds = weatherData$windSusSpeed[threeHigh];
  # get the dates for the three highest wind speeds
  highWindDates = weatherData$date[threeHigh];
  
  # Force the order by level (otherwise, it will be alphabetical)
  pressureFact = factor(weatherData$pressureLevel,
                        levels=c("Very Low", "Low", "Medium", "High", "Very High"));
  
  
  thePlot = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=pressureFact, y=windSusSpeed),
                 coef = 1.5,  # interquartile range (IQR) -- default is 1.5 (so, this changes nothing)
                 outlier.shape = 24, 
                 outlier.fill = "red", 
                 outlier.size = 3) +
    theme_bw() +
    labs(title = "Wind Speeds vs. Pressure Levels",
         subtitle = "Lansing, Michigan: 2016",
         x = "Pressure Level",
         y = "Wind Speeds")  +
    # the three annotate() are for the three outliers
    annotate(geom="text", 
             x=1.3, 
             y=highWindSpeeds[1], 
             color="blue",   
             label=highWindDates[1] ) +
    annotate(geom="text", 
             x=0.7, 
             y=highWindSpeeds[2], 
             color="darkgreen",   
             label=highWindDates[2] ) +
    annotate(geom="text", 
             x=1.3, 
             y=highWindSpeeds[3], 
             color="red",   
             label=highWindDates[3] );
  plot(thePlot);
}  