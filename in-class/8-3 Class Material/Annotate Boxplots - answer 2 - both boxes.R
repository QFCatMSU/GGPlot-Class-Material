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
  
  # create all the 2 variable vector needed
  y25 = y75 = whiskerHigh = whiskerLow = yMed = yMean = ySD = c();
  
  for(i in 1:2)
  {
    # Get the y values
    y = weatherData$relHum[weatherData$precipitation==(i-1)]; # i = 1,2; i-1=0,1  
    yMed[i] = median(y);
    yMean[i] = mean(y);
    ySD[i] = sd(y);
    
    #### find the 1st and 3rd quartiles (0.25 and 0.75 quantiles) of the vectors
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
    whiskerHigh[i] = max(yHigh);                  # maximum of these values (becomes the high whisker point)
    yLow = y[y >= whiskerLowTemp & y < y25[i]];   # y such that y is between low whisker point and 1/4
    whiskerLow[i] = min(yLow);                    # minimum of these values (becomes the low whisker point)
  } 

  ##### Use annotate() to create both plots ######
  plot2 = ggplot() +
          theme_bw() +
    labs(title = "Relative Humidity vs. Precipitation",
         subtitle = "Lansing, Michigan: 2016",
         x = "Precipitation",
         y = "Humidity") +

    scale_x_continuous(breaks = c(1,2),
                       labels = c("Precip", "No Precip")) +

    # IQR
    annotate(geom="rect",
             xmin = 0.7, xmax = 1.3, 
             ymin = y25[1], ymax = y75[1],
             fill = "transparent",
             color = "black") +
    annotate(geom="rect",
             xmin = 1.7, xmax = 2.3, 
             ymin = y25[2], ymax = y75[2],
             fill = "transparent",
             color = "black") + 
    
    # median line
    annotate(geom="segment",
             x = 0.7, xend=1.3,
             y = yMed[1], yend=yMed[1]) +
    annotate(geom="segment",
             x = 1.7, xend=2.3,
             y = yMed[2], yend=yMed[2]) +
    
    # high whisker
    annotate(geom="segment",
             x = 1, xend=1,
             y = y75[1], yend=whiskerHigh[1]) +  
    annotate(geom="segment",
             x = 2, xend=2,
             y = y75[2], yend=whiskerHigh[2]) +    
    
    #low whisker
    annotate(geom="segment",
             x = 1, xend=1,
             y = y25[1], yend=whiskerLow[1]) + 
    annotate(geom="segment",
             x = 2, xend=2,
             y = y25[2], yend=whiskerLow[2]) + 
    
    # mean line
    annotate(geom="segment",
             x=0.8, xend=1.2,             # high and low x points for line
             y=yMean[1], yend=yMean[1],   # high and low y points for line
             color = "blue") +
    annotate(geom="segment",
             x=1.8, xend=2.2,             # high and low x points for line
             y=yMean[2], yend=yMean[2],   # high and low y points for line
             color = "blue") +

    # SD text
    annotate(geom="text",
             x = 1,
             y = c(yMean[1]+ySD[1], yMean[1]-ySD[1]),
             label = "1 SD",
             color = "blue") +
    annotate(geom="text",
             x = 2,
             y = c(yMean[2]+ySD[2], yMean[2]-ySD[2]),
             label = "1 SD",
             color = "blue");

  plot(plot2);
}  