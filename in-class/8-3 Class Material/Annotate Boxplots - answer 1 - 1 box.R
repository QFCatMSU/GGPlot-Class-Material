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
  
  # Get the y values
  y = weatherData$relHum[weatherData$precipitation==0];   
  yMed = median(y);
  yMean = mean(y);
  ySD = sd(y);
  
  #### find the 1st and 3rd quartiles (0.25 and 0.75 quantiles) of the vector
  y25 = quantile(y, probs = 0.25);
  y75 = quantile(y, probs = 0.75);

  # interquartile range -- the size of the box and used to find whiskers
  IQR = y75 - y25;

  # Find the low and high point of the whiskers (beyond are outliers)
  whiskerHighTemp = y75 + 1.5*IQR;   # 1.5 is default multiplier used in GGPlot
  whiskerLowTemp = y25 - 1.5*IQR;
  
  # The high and low whisker points are the closest values to the whisker ends that  
  # do not go beyond the whisker ends.  
  yHigh = y[y > y75 & y <= whiskerHighTemp]; # y such that y is between 3/4 and high whisker point
  whiskerHigh = max(yHigh);                  # maximum of these values (becomes the high whisker point)
  yLow = y[y >= whiskerLowTemp & y < y25];   # y such that y is between low whisker point and 1/4
  whiskerLow = min(yLow);                    # minimum of these values (becomes the low whisker point)

  ##### Manually plot humidity vs precipitation ######
  plot2 = ggplot() +
          theme_bw() +
    
    labs(title = "Relative Humidity vs. Precipitation",
         subtitle = "Lansing, Michigan: 2016",
         x = "Precipitation",
         y = "Humidity") +

    scale_x_continuous(breaks = c(1,2),
                       labels = c("Precip", "No Precip")) +

    # box (1st quarter to 3rd quarter)
    annotate(geom="rect",
             xmin = 0.7, xmax = 1.3, 
             ymin = y25, ymax = y75,
             fill = "transparent",
             color = "black") +
    
    # median line
    annotate(geom="segment",
             x = 0.7, xend=1.3,
             y = yMed, yend=yMed) +
  
    # high whisker
    annotate(geom="segment",
             x = 1, xend=1,
             y = y75, yend=whiskerHigh) +  
    
    #low whisker
    annotate(geom="segment",
             x = 1, xend=1,
             y = y25, yend=whiskerLow) + 
    
    # mean line
    annotate(geom="segment",
             x=0.8, xend=1.2,       # high and low x points for line
             y=yMean, yend=yMean,   # high and low y points for line
             color = "blue") +

    # SD text
    annotate(geom="text",
             x = 1,
             y = c(yMean+ySD, yMean-ySD),
             label = "1 SD",
             color = "blue");

  plot(plot2);
}  