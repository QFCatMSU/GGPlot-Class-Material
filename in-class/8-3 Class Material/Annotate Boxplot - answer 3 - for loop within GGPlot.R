{
  source(file="scripts/reference.R");  
  weatherData = read.csv(file="data/LansingNOAA2016.csv", 
                         stringsAsFactors = FALSE);
  
  #### Create a column the give whether there was precipitation
  
  #### grepl produces a Boolean vector the same length as the data: 
  #      values are TRUE if they contain RA or SN, FALSE otherwise
  daysWithPrecip = grepl(x=weatherData$weatherType, pattern="RA|SN");
  
  # days will take values from 1 to 366 (the number of rows)
  for(day in 1:nrow(weatherData))  
  {
    if(daysWithPrecip[day] == TRUE)  # day had either RA or SN
    {
      weatherData$precipitation[day] = 1;   # set precip to 1
    }
    else   # day had neither RA nor SN
    {
      weatherData$precipitation[day] = 0;   # set precip to 0
    }
  }

  # GGPlot cannot factor a numeric column -- need to convert column to string (characters)
  weatherData$precipitation = as.character(weatherData$precipitation);
  
  # Have GGPlot make boxes 
  plot1 = ggplot(data=weatherData) +   
    geom_boxplot(mapping=aes(x=precipitation, y=relHum)) +
    theme_bw() +
    scale_x_discrete(labels=c("No Precip", "Precip")) +
    labs(title = "Relative Humidity vs. Precipitation",
         subtitle = "Lansing, Michigan: 2016",
         x = "Precipitation",
         y = "Humidity");
  plot(plot1);
  
  y25 = y75 = whiskerHigh = whiskerLow = yMed = yMean = ySD = c();
  for(i in 1:2)
  {
    # Get the y values
    y = weatherData$relHum[weatherData$precipitation==(i-1)];   
    yMed[i] = median(y);
    yMean[i] = mean(y);
    ySD[i] = sd(y);
    
    #### find the 1st and 3rd quartiles (0.25 and 0.75 quantiles) of the vector
    y25[i] = quantile(y, probs = 0.25);
    y75[i] = quantile(y, probs = 0.75);
  
    # interquartile range -- the size of the box and used to find whiskers
    IQR = y75[i] - y25[i];
  
    # Find the low and high point of the whiskers (beyond are outliers)
    whiskerHighTemp = y75[i] + 1.5*IQR;   # 1.5 is default multiplier used in GGPlot
    whiskerLowTemp = y25[i] - 1.5*IQR;
    
    # The high and low whisker points are the closest values to the whisker ends that  
    # do not go beyond the whisker ends.  
    yHigh = y[y > y75[i] & y <= whiskerHighTemp]; # y such that y is between 3/4 and high whisker point
    whiskerHigh[i] = max(yHigh);             # maximum of these values (becomes the high whisker point)
    yLow = y[y >= whiskerLowTemp & y < y25[i]];   # y such that y is between low whisker point and 1/4
    whiskerLow[i] = min(yLow);               # minimum of these values (becomes the low whisker point)
  } 

  ##### Manually plot humidity vs precipitation ######
  plot2 = ggplot() +
          theme_bw() +
    
    labs(title = "Relative Humidity vs. Precipitation",
         subtitle = "Lansing, Michigan: 2016",
         x = "Precipitation",
         y = "Humidity") +

    scale_x_continuous(breaks = c(1,2),
                       labels = c("Precip", "No Precip"));
  
    for(i in 1:2)
    {
      plot2 = plot2 +
        
      # IQR
      annotate(geom="rect",
               xmin = i-1+0.7, xmax = i-1+1.3, 
               ymin = y25[i], ymax = y75[i],
               fill = "transparent",
               color = "black") +
        
      # median line
      annotate(geom="segment",
               x = i-1+0.7, xend=i-1+1.3,
               y = yMed[i], yend=yMed[i]) +
    
      # high whisker
      annotate(geom="segment",
               x = i, xend = i,
               y = y75[i], yend=whiskerHigh[i]) +  
      
      #low whisker
      annotate(geom="segment",
               x = i, xend=i,
               y = y25[i], yend=whiskerLow[i]) + 
      
      # mean line
      annotate(geom="segment",
               x=i-1+0.8, xend=i-1+1.2,             # high and low x points for line
               y=yMean[i], yend=yMean[i],   # high and low y points for line
               color = "blue") +
  
      # SD text
      annotate(geom="text",
               x = i,
               y = c(yMean[i]+ySD[i], yMean[i]-ySD[i]),
               label = "1 SD",
               color = "blue");
    }

  plot(plot2);
}  