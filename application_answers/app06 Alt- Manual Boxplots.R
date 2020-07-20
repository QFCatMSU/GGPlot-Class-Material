{
  source(file="scripts/reference.R");  
  weatherData = read.csv(file="data/LansingNOAA2016.csv", 
                         stringsAsFactors = FALSE);
  
  #### Part 1: Create a pressure level column
  
  # find the 20%, 40%, 60%, and 80% quantile values of "stnPRessure" column
  # so, pressureQuant will be a vector with 4 values
  pressureQuant = quantile(weatherData$stnPressure,    
                           probs=c(.20, .40, .60, .80));

  ## Creating a new column, called pressureLevel,
  #  that gives relative pressure for the day (based on the quantile results)
  for(day in 1:nrow(weatherData))  # the variable day will take on each value from 1 to 366
  {
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
  
  #### Manually making the "Very Low" box  
  
  # Find the indices in pressureLevel set to "Very Low"
  yIndex = which(weatherData$pressureLevel=="Very Low"); 
  
  # Create a vector of wind Speed values when pressure is "Very Low" (note the length of this vector)
  y = weatherData$windSusSpeed[yIndex];   # maybe this should be called yReduced?
  
  #### find the 1/4 and 3/4 quantiles of the vector
  y25 = quantile(y, 0.25);
  y75 = quantile(y, 0.75);
  
  # interquantile range -- sets the whiskers of the plot
  IQR = y75 - y25;
  
  # Find the Low and High point of the whiskers (beyond are outliers) 
  whiskerHigh = y75 + 1.5*IQR;
  whiskerLow = y25 - 1.5*IQR;
  
  ##### Plot here #######
  
  # The high and low whisker points are the closest values that do not go beyond 
  # the whiskers.  So, we need to find the closest point to the whisker ends 
  yHigh = y[y > y75 & y <= whiskerHigh]; # give y values between 3/4 and high whisker point
  whiskerHigh2 = max(yHigh);             # maximum of these values (becomes the high whisker)
  yLow = y[y >= whiskerLow & y < y25];   # give y values between low whisker point and 1/4
  whiskerLow2 = min(yLow);               # minimum of these values (becomes the low whisker)
  
  ##### Plot here ######
  
  ### Labeling the high outliers with the dates (we know there are no low outliers)
  outlierValues = y[y > whiskerHigh2];           # outliers are y values higher than whisker high      
  outlierIndex = yIndex[y > whiskerHigh2];       # the index of the outlier from the full data
  outlierDates = weatherData$date[outlierIndex]; # get the dates for the index values
  
  #### Simpler plot
  plot1 = ggplot() +   # no data because we are not asking GGPlot to use the dataset
    geom_boxplot(mapping=aes(x=1, 
                             ymin = whiskerLow2, 
                             lower = y25, 
                             middle = median(y), 
                             upper = y75, 
                             ymax = whiskerHigh2),
                 stat="identity") +
    geom_point(mapping = aes(x=1, y=outlierValues),
               color= "orange") + 
    geom_text(mapping = aes(x=1, y=outlierValues, label=outlierDates),  # position at outlier value
              nudge_x = 0.05) +
    scale_y_continuous(limits = c(min(y), max(y))) +
    scale_x_continuous(breaks = c(1),            # x=1, next box would be put at x=2
                       labels = "Very Low");     # replace number with label
  plot(plot1);
  
  
  #### Same data -- more complex features in this plot
  plot2=ggplot() +   # no data because we are not asking GGPlot to use the dataset
    geom_boxplot(mapping=aes(x=1, 
                             ymin = whiskerLow2, 
                             lower = y25, 
                             middle = median(y), 
                             upper = y75, 
                             ymax = whiskerHigh2),
                 stat="identity") +
    geom_point(mapping = aes(x=1, y=outlierValues),
               shape = "\u0259",   # unicode value
               size=4,
               color= rgb(red=0.8, green=0.4, blue=0)) + # red and some green make orange
    geom_text(mapping = aes(x=1, y=outlierValues, label=outlierDates),
              nudge_x = -0.05 + 0.10*outlierValues%%2) + # staggers position of label based on enen/odd numbers
    scale_y_continuous(limits = c( min(y)-5, max(y)+5 )) +  # added 5px of padding
    scale_x_continuous(breaks = c(1),            # x=1, next box would be put at x=2
                       labels = "Very Low");     # replace number with label
  plot(plot2);
  
  

  
  
  # create the other 4 plots
  # add titles, labels to the plots
  # change style
  # add mean points to the plots
  # do everything with a for()
}  