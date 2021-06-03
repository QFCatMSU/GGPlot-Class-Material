{
  source(file="scripts/reference.R");  
  weatherData = read.csv(file="data/LansingNOAA2016.csv", 
                         stringsAsFactors = FALSE);
  
  # Putting four number sign at beginning and end of a line adds it to the "outline" 
  #### Part 1: Create a pressure level column ####
  
  # find the 20%, 40%, 60%, and 80% quantile values of "stnPressure" column
  # so, pressureQuant will be a vector with 4 values
  pressureQuant = quantile(weatherData$stnPressure,    
                           probs=c(.20, .40, .60, .80));

  # the variable day will takes on values from 1 to 366
  # the for loop iterates for each value of day (so, 366 iterations)
  for(day in 1:nrow(weatherData))  
  {
    ## Creating a new column, called pressureLevel,
    #  that gives relative pressure for the day (based on the quantile results)
    
    # if the standard pressure of the day is less than or equal to the 0.20 quantile value
    if(weatherData$stnPressure[day] <= pressureQuant[1])
    {
      weatherData$pressureLevel[day] = "Very Low";  # set the pressure to very low
    }
    # if the standard pressure of the day is less than or equal to the 0.40 quantile value
    else if(weatherData$stnPressure[day] <= pressureQuant[2])
    {
      weatherData$pressureLevel[day] = "Low";       # set the pressure to low
    }
    else if(weatherData$stnPressure[day] <= pressureQuant[3])
    {
      weatherData$pressureLevel[day] = "Medium";
    }
    else if(weatherData$stnPressure[day] <= pressureQuant[4])
    {
      weatherData$pressureLevel[day] = "High";
    }
    else  # all other values
    {
      weatherData$pressureLevel[day] = "Very High";
    }
  }
  
  #### Part 2: Boxplot of the wind speed vs pressure level ####
  
  #### For the three outliers...
  # index values for the windSusSpeed column in descending order 
  descendingIndex = order(weatherData$windSusSpeed, decreasing=TRUE);
  threeHigh = descendingIndex[1:3];   # the indices the of three highest values
  # get the three highest wind speeds
  highWindSpeeds = weatherData$windSusSpeed[threeHigh];
  # get the dates for the three highest wind speeds
  highWindDates = weatherData$date[threeHigh];

  # Force the order by level (otherwise, it will be alphabetical)
  pressureFact = factor(weatherData$pressureLevel,
                       levels=c("Very Low", "Low", "Medium", "High", "Very High"));
  
  thePlot = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=pressureFact, y=windSusSpeed),
                 # coef = 2.5,  # multiplier for interquartile range (IQR) to set whiskers -- default is 1.5 
                 outlier.shape = 24, 
                 outlier.fill = "red", 
                 outlier.size = 3) +
    theme_bw() +
    labs(title = "Wind Speeds vs. Pressure Levels",
         subtitle = "Lansing, Michigan: 2016",
         x = "Pressure Level",
         y = "Wind Speeds");

  
  # ggplot_build presents all the data used in the plot so it can be manually built
  a = ggplot_build(thePlot);
  b = a$data;
  c = b[[1]];
  d = c$outliers;  
  e = d[[1]];      # get data from first boxplot (there are 5 boxplots)
  
  theDate = c();
  nudge = c();
  for(i in 1:length(e))
  {
    highSpeedIndex = which(weatherData$windSusSpeed == e[i]);
    theDate[i] = weatherData$date[highSpeedIndex];
    nudge[i] = 0.3*cos((i%%2)*pi);  # alternate 0.3, -0.3, 0.3, -0.3...
  }
  
  thePlot = thePlot +
    geom_text(data=data.frame(e), 
              mapping=aes(x=1, y=e, label=theDate),
              nudge_x = nudge);

  plot(thePlot);
  
#  outliers = ggplot_build(thePlot)[["data"]][[1]][["outliers"]];

  ##### In-class application #### 
  #  Part 1: Practice with the breakpoints:  
  #    What is the breakpoint doing inside the for loops?
  #      note: you can add/remove breakpoints while debugging (especially useful when in for loops)
  #    Put it two (or more) breakpoints and use Continue
  #  Part 2: Humidity vs Precipitation boxplots
  #    Humidity goes on the y-axis
  #    Two boxes on the x-axis: (1) Days that had precip (2) Days that had no precip
  #    Use "weatherType" column to determine precipitation
  #      days with precip have either "RA" or "SN" in the "weatherType" column
  #    Break down the problem -- try to individually get "RA" and "SN" before trying to combine them
  
}  