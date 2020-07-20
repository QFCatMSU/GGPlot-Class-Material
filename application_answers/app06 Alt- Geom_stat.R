{
  source(file="scripts/reference.R");  
  weatherData = read.csv(file="data/LansingNOAA2016-3.csv", 
                         stringsAsFactors = FALSE);
  
  #### Part 1: Create a wind direction column
  pressureQuant = quantile(weatherData[,"stnPressure"], 
                           probs=c(.20,.40, .60, .80));

  for(day in 1:nrow(weatherData))
  {
    ## Adding a column that gives relative wind speed for the day
    # Winds less than 6.4 miles/hour -- label as "Low"
    if(weatherData[day,"stnPressure"] <= pressureQuant[1])
    {
      weatherData[day,"pressureLevel"] = "Very Low";
    }
    # Winds greater than 10.2 miles/hour -- label as "High"
    else if(weatherData[day,"stnPressure"] <= pressureQuant[2])
    {
      weatherData[day,"pressureLevel"] = "Low";
    }
    else if(weatherData[day,"stnPressure"] <= pressureQuant[3])
    {
      weatherData[day,"pressureLevel"] = "Medium";
    }
    else if(weatherData[day,"stnPressure"] <= pressureQuant[4])
    {
      weatherData[day,"pressureLevel"] = "High";
    }
    else
    {
      weatherData[day,"pressureLevel"] = "Very High";
    }
  }
  
  #### Part 2: Boxplot of the change in max temp vs wind direction
  
  # index values for the windSusSpeed column in descending order 
  #speedOrderedIndex = order(weatherData$windSusSpeed, decreasing=TRUE);
  # get the three highest wind speeds
  #highWindSpeeds = weatherData$windSusSpeed[speedOrderedIndex[1:3]];
  # get the dates for the three highest wind speeds
  #highWindDates = weatherData$date[speedOrderedIndex[1:3]];

  pressureFact = factor(weatherData$pressureLevel,
                       levels=c("Very Low", "Low", "Medium", "High", "Very High"));
  
  thePlot = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=pressureFact, y=windSusSpeed),
                 outlier.shape = 24, 
                 outlier.fill = "red", 
                 outlier.size = 3) +
    theme_bw() +
    # annotate(geom="text", x=1.3, y=highWindSpeeds[1], color="blue",   
    #          label=highWindDates[1] ) +
    # annotate(geom="text", x=0.7, y=highWindSpeeds[2], color="darkgreen",   
    #          label=highWindDates[2] ) +
    # annotate(geom="text", x=1.3, y=highWindSpeeds[3], color="red",   
    #          label=highWindDates[3] ) +
    labs(title = "Wind Speeds vs. Pressure Levels",
         subtitle = "Lansing, Michigan: 2016",
         x = "Pressure Level",
         y = "Wind Speeds");

  # extract the build data from thePlot 
  buildData = ggplot_build(thePlot)$data;
  
  # contains info for drawing the box on the plot
  boxInfo = buildData[[1]];
  
  # get the outliers from box one
  box1Outliers = boxInfo$outliers[[1]];
  
  # annotate the outliers on the plot
  speedOrderedIndex = order(weatherData$windSusSpeed, decreasing=TRUE);
  
  for (i in 1: length(box1Outliers))
  {
    thePlot = thePlot + annotate(geom="text",
                                 x=0.7 + 0.6*(i %% 2),  # staggers the labels
                                 y=box1Outliers[i], 
                                 color=rgb(red = floor((i %% 3) / 2),
                                           green = floor(((i+1) %% 3) /2 ),   
                                           blue = floor(((i+2) %% 3) /2)),   
                                 label=box1Outliers[i]); # weatherData$date[speedOrderedIndex[i]] );
  }
  plot(thePlot);
}  