{
  source(file="scripts/reference.R");  
  weatherData = read.csv(file="data/LansingNOAA2016.csv", 
                         stringsAsFactors = FALSE);
  
  #### Part 1: Create a wind direction column
  pressureQuant = quantile(weatherData[,"stnPressure"], 
                           probs=c(.20,.40, .60, .80));

  for(day in 1:nrow(weatherData))
  {
    ## Adding a column that gives relative wind speed for the day
    if(weatherData$stnPressure[day] <= pressureQuant[1])
    {
      weatherData$pressureLevel[day] = "Very Low";
    }
    else if(weatherData$stnPressure[day] <= pressureQuant[2])
    {
      weatherData$pressureLevel[day] = "Low";
    }
    else if(weatherData$stnPressure[day] <= pressureQuant[3])
    {
      weatherData$pressureLevel[day] = "Medium";
    }
    else if(weatherData$stnPressure[day] <= pressureQuant[4])
    {
      weatherData$pressureLevel[day] = "High";
    }
    else
    {
      weatherData$pressureLevel[day] = "Very High";
    }
  }
  
  
  #### Manually find the quantiles
  yIndices = which(weatherData$pressureLevel=="Very Low"); 
  y = weatherData$windSusSpeed[yIndices];
  y25 = quantile(y, 0.25);
  y75 = quantile(y, 0.75);
  
  IQR = y75 - y25;
  
  outlierHigh = y75 + 1.5*IQR;
  outlierLow = y25 - 1.5*IQR;
  
  # does not handle if there are no values...
  maxWhisker = max(y[which(y <= outlierHigh & y > y75)]);
  minWhisker = min(y[which(y >= outlierLow & y < y25)]);
  
  outlierIndexMax = which(y > outlierHigh);
  outlierValues = y[outlierIndexMax];
  outlierIndices = yIndices[outlierIndexMax];
  outlierDates = weatherData$date[outlierIndices];
  
  padding = 5;
  
  a=ggplot() +   # no data because we are not asking GGPlot to use the dataset
    geom_boxplot(mapping=aes(x=1, 
                             ymin = minWhisker, 
                             lower = y25, 
                             middle = median(y), 
                             upper = y75, 
                             ymax = maxWhisker),
                 stat="identity") +
    geom_point(mapping = aes(x=1, y=outlierValues),
               shape = "\u0259",
               size=4,
               color= rgb(red=0.8, green=0.4, blue=0)) + # red and part green make orange
    geom_text(mapping = aes(x=1, y=outlierValues, label=outlierDates),
              nudge_x = -0.05 + 0.10*outlierValues%%2) +
    scale_y_continuous(limits = c( min(y)-padding, max(y)+padding )) +
    scale_x_continuous(breaks = c(1),            # x=1, next box would be put at x=2
                       labels = "Very Low");     # replace number with label
  plot(a);
  
  
  #### Simplified
  b=ggplot() +   # no data because we are not asking GGPlot to use the dataset
    geom_boxplot(mapping=aes(x=1, 
                             ymin = minWhisker, 
                             lower = y25, 
                             middle = median(y), 
                             upper = y75, 
                             ymax = maxWhisker),
                 stat="identity") +
    geom_point(mapping = aes(x=1, y=outlierValues),
               color= "orange") + 
    geom_text(mapping = aes(x=1, y=outlierValues, label=outlierDates),
              nudge_x = 0.05) +
    scale_y_continuous(limits = c(min(y), max(y))) +
    scale_x_continuous(breaks = c(1),            # x=1, next box would be put at x=2
                       labels = "Very Low");     # replace number with label
  plot(b);
  
  
  # create the other 4 plots
  # add titles, labels to the plots
  # change style
  # add mean points to the plots
  # do everything with a for()
}  