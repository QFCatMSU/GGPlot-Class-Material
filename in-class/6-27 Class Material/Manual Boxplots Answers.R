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

  #### For box 1
  # Get the y values and basic stats
  y = weatherData$relHum[weatherData$precipitation==0];   
  yMed_1 = median(y);
  yMean_1 = mean(y);
  ySD_1 = sd(y);
  
  #### find the 1st and 3rd quartiles (0.25 and 0.75 quantiles) of the vector
  y25_1 = quantile(y, probs = 0.25);
  y75_1 = quantile(y, probs = 0.75);

  # interquartile range -- the size of the box and used to find whiskers
  IQR = y75_1 - y25_1;

  # Find the low and high point of the whiskers (beyond are outliers)
  whiskerHighTemp = y75_1 + 1.5*IQR;   # 1.5 is default multiplier used in GGPlot
  whiskerLowTemp = y25_1 - 1.5*IQR;
  
  # The high and low whisker points are the closest values to the whisker ends that  
  # do not go beyond the whisker ends.  
  yHigh = y[y > y75_1 & y <= whiskerHighTemp]; # y such that y is between 3/4 and high whisker point
  whiskerHigh_1 = max(yHigh);             # maximum of these values (becomes the high whisker point)
  yLow = y[y >= whiskerLowTemp & y < y25_1];   # y such that y is between low whisker point and 1/4
  whiskerLow_1 = min(yLow);               # minimum of these values (becomes the low whisker point)

  #### For box 2
  # Get the y values and basic stats
  y = weatherData$relHum[weatherData$precipitation==1];
  yMed_2 = median(y);
  yMean_2 = mean(y);
  ySD_2 = sd(y);

  #### find the 1st and 3rd quartiles (0.25 and 0.75 quantiles) of the vector
  y25_2 = quantile(y, probs = 0.25);
  y75_2 = quantile(y, probs = 0.75);

  # interquartile range -- the size of the box and used to find whiskers
  IQR = y75_2 - y25_2;

  # Find the low and high point of the whiskers (beyond are outliers)
  whiskerHighTemp = y75_2 + 1.5*IQR;   # 1.5 is default multiplier used in GGPlot
  whiskerLowTemp = y25_2 - 1.5*IQR;

  # The high and low whisker points are the closest values to the whisker ends that
  # do not go beyond the whisker ends.
  yHigh = y[y > y75_2 & y <= whiskerHighTemp]; # y such that y is between 3/4 and high whisker point
  whiskerHigh_2 = max(yHigh);             # maximum of these values (becomes the high whisker point)
  yLow = y[y >= whiskerLowTemp & y < y25_2];   # y such that y is between low whisker point and 1/4
  whiskerLow_2 = min(yLow);

  ##### Manually plot humidity vs precipitation ######
  plot2 = ggplot() +  
    # first boxplot (no precipitation)
    geom_boxplot(stat="identity",                     # manually enter data
                 mapping=aes(x=1,                     # x-position
                             ymin = whiskerLow_1,    
                             lower = y25_1,       
                             middle = yMed_1, 
                             upper = y75_1,         
                             ymax = whiskerHigh_1)) +
    
    # second boxplot (precipitation)
    geom_boxplot(stat="identity",
                 mapping=aes(x=2,
                             ymin = whiskerLow_2,
                             lower = y25_2,
                             middle = yMed_2,
                             upper = y75_2,
                             ymax = whiskerHigh_2)) +
    
    # mean for 1st box
    annotate(geom="segment", 
             x=0.8, xend=1.2,            # high and low x points for line
             y=yMean_1, yend=yMean_1,  # high and low y points for line
             color = "blue") + 
    
    # mean for 2nd box
    annotate(geom="segment",
             x=1.8, xend=2.2,
             y=yMean_2, yend=yMean_2,
             color = "blue") +
    
    # SD high and low for 1
    annotate(geom="text", 
             x = 1, 
             y = c(yMean_1+ySD_1, yMean_1-ySD_1),
             label = "1 SD",
             color = "blue") + 
    
    # SD high and low for 2
    annotate(geom="text",
             x = 2,
             y = c(yMean_2+ySD_2, yMean_2-ySD_2),
             label = "1 SD",
             color = "blue") +
    
    theme_bw() +
    
    # scale_x_discrete does not work here 
    scale_x_continuous(breaks = c(1,2),    
                       labels = c("Precip", "No Precip")) +   
    
    labs(title = "Relative Humidity vs. Precipitation",
         subtitle = "Lansing, Michigan: 2016",
         x = "Precipitation",
         y = "Humidity");
  plot(plot2);
}  