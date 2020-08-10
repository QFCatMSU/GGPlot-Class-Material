{
  source(file="scripts/reference.R");  # this line will be in all your scripts
  weatherData = read.csv(file="data/LansingNOAA2016-3.csv", 
                         stringsAsFactors = FALSE);

  # create a numeric precipitation column
  precipNum = weatherData$precip;
  precipNum[which(precipNum == "T")] = 0.005;
  weatherData$precipNum = as.numeric(precipNum);
  
  # color mapping -- using season, a discrete variable
  plot1 = ggplot(data=weatherData) +
    geom_point(mapping=aes(x=avgTemp, y=relHum,
                           color=season)) +
    labs(title = 'Humidity (y) vs. Temperature (x) by Season (color)',
         subtitle = 'Lansing, MI - 2016',
         x = 'Average Temperature', 
         y = 'Humidity') +
    theme_bw();
  plot(plot1);
  
  # color mapping -- using precipNum, a continuous variable 
  # color becomes a gradient when using continuous variables
  plot1b = ggplot(data=weatherData) +
    geom_point(mapping=aes(x=avgTemp, y=relHum,
                           color=precipNum)) +
    labs(title = 'Humidity (y) vs. Temperature (x) by Precipitation (color)',
         subtitle = 'Lansing, MI - 2016',
         x = 'Average Temperature', 
         y = 'Humidity') +
    theme_bw();
  plot(plot1b);
  
  # shape mapping using season -- shape has to be a discrete variable
  plot2 = ggplot(data=weatherData) +
    geom_point(mapping=aes(x=avgTemp, y=relHum,
                           shape=season)) +
    labs(title = 'Humidity (y) vs. Temperature (x) by Season (shape)',
         subtitle = 'Lansing, MI - 2016',
         x = 'Average Temperature', 
         y = 'Humidity') +
    theme_bw();
  plot(plot2);
 
  # size mapping using precipitation -- size should use a continuous variable
  # you will get a warning if you use a discrete variable for size
  plot3 = ggplot(data=weatherData) +
    geom_point(mapping=aes(x=avgTemp, y=relHum,
                           size=precipNum)) +
    labs(title = 'Humidity (y) vs. Temperature (x) by Precipiation (size)',
         subtitle = 'Lansing, MI - 2016',
         x = 'Average Temperature', 
         y = 'Humidity') +
    theme_bw();
  plot(plot3);
  
  # alpha (transparency) mapping using precipitation
  # alpha should be a continuous variable (get warning if you use a discrete var)
  plot4 = ggplot(data=weatherData) +
    geom_point(mapping=aes(x=avgTemp, y=relHum,
                           alpha=precipNum)) +
    labs(title = 'Humidity (y) vs. Temperature (x) by Precipitation (alpha)',
         subtitle = 'Lansing, MI - 2016',
         x = 'Average Temperature', 
         y = 'Humidity') +
    theme_bw();
  plot(plot4);
  
  ## other mappings:
  # fill (background color) -- use in bar, histogram, and box plots
}