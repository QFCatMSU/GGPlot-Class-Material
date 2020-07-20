{
  source(file="scripts/reference.R");  
  weatherData = read.csv(file="data/LansingNOAA2016.csv", 
                         stringsAsFactors = FALSE);
  
  #### Part 1: Create a pressure level column
  
  # find the 20%, 40%, 60%, and 80% quantile values of "stnPressure" column
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
  
  #### Manually making the "Very Low" box (only 1 box -- not all 5)  
  
  # Find the indices in pressureLevel that are set to "Very Low"
  yIndex = which(weatherData$pressureLevel=="Very Low"); 
  
  # Create a vector of wind Speed values when pressure is "Very Low" 
  y = weatherData$windSusSpeed[yIndex];   # length of vector is 76
  
  #### find the 1/4 and 3/4 quantiles of the vector
  y25 = quantile(y, probs = 0.25);
  y75 = quantile(y, probs = 0.75);
  
  # interquantile range -- the size of the box and used to find whiskers
  IQR = y75 - y25;
  
  # Find the low and high point of the whiskers (beyond are outliers) 
  whiskerHigh = y75 + 1.5*IQR;   # 1.5 is default multiplier used in GGPlot 
  whiskerLow = y25 - 1.5*IQR;
  
  ##### First Plot -- manually entered values, has issue with whiskers ######
  
  # The lower whisker will not be plotted because it is "beyond" the lowest 
  #   y-value (i.e., there are no low outliers).  That is what the warning message
  #   "Removed 1 rows containing missing values (geom_segment)" says.
  #   This is a bug in GGPlot as you are manually entering point and GGPlot should not care
  
  plot1 = ggplot() +   # no data because we are not asking GGPlot to use a dataset
    geom_boxplot(stat="identity", # this is what tells GGPlot that values are manually entered
                 mapping=aes(x=1, # manually entering values - first box at x=1
                             ymin = whiskerLow,     # 
                             lower = y25,           # You find these y-values in 
                             middle = median(y),    # "Computed Variables" section 
                             upper = y75,           # when searching for geom_boxplot
                             ymax = whiskerHigh)) + #  
    scale_y_continuous(limits = c(min(y), max(y))) +
    scale_x_continuous(breaks = c(1),            # break at x=1, next box would be put at x=2
                       labels = "Very Low") +    # replace number with label
    labs(title = "Humidity vs Precip Take 1",
         subtitle = "Whiskers not standard, lost the lower whisker");
  plot(plot1);
  
  # The high and low whisker points are the closest values to the whisker ends that  
  # do not go beyond the whisker ends.  
  yHigh = y[y > y75 & y <= whiskerHigh]; # y such that y is between 3/4 and high whisker point
  whiskerHigh2 = max(yHigh);             # maximum of these values (becomes the high whisker point)
  yLow = y[y >= whiskerLow & y < y25];   # y such that y is between low whisker point and 1/4
  whiskerLow2 = min(yLow);               # minimum of these values (becomes the low whisker point)
  
  ##### Second Plot - fix the whiskers ######
  # This plot sets the whisker ends to the y value that is closest without going beyond
  # (whiskerHigh2 instead of whiskerHigh)
  plot2 = ggplot() +   # no data because we are not asking GGPlot to use a dataset
    geom_boxplot(stat="identity", # this is what tells GGPlot that values are manually entered
                 mapping=aes(x=1, # manually entering values - first box at x=1
                             ymin = whiskerLow2,    # 
                             lower = y25,           # You find these y-values in 
                             middle = median(y),    # "Computed Variables" section 
                             upper = y75,           # when searching for geom_boxplot
                             ymax = whiskerHigh2)) +#  
    scale_y_continuous(limits = c(min(y), max(y))) +
    scale_x_continuous(breaks = c(1),            # break at x=1, next box would be put at x=2
                       labels = "Very Low") +    # replace number with label
    labs(title = "Humidity vs Precip Take 2",
         subtitle = "Whisker ends now standard -- missing outliers");
  plot(plot2);

  ## Labeling the high outliers with the dates (we know there are no low outliers)
  outlierValues = y[y > whiskerHigh2];           # outliers are y values higher than whisker high      
  outlierIndex = yIndex[y > whiskerHigh2];       # the index of the outlier from the full data
  outlierDates = weatherData$date[outlierIndex]; # get the dates for the index values
  
  #### Third plot -- labeling the outliers with dates ####
  plot3 = ggplot() +   # no data because we are not asking GGPlot to use the dataset
    geom_boxplot(stat="identity", # this is what tells GGPlot that values are manually entered
                 mapping=aes(x=1, # manually entering values - first box at x=1
                             ymin = whiskerLow2,    # 
                             lower = y25,           # You find these y-values in 
                             middle = median(y),    # "Computed Variables" section 
                             upper = y75,           # when searching for geom_boxplot
                             ymax = whiskerHigh2)) +#  
    geom_point(mapping = aes(x=1, y=outlierValues),
               color= "orange") + 
    geom_text(mapping = aes(x=1, y=outlierValues, label=outlierDates),  # position at outlier value
              nudge_x = 0.05) +
    scale_y_continuous(limits = c(min(y), max(y))) +
    scale_x_continuous(breaks = c(1),            # x=1, next box would be put at x=2
                       labels = "Very Low") +    # replace number with label
    labs(title = "Humidity vs Precip Take 3",
         subtitle = "Outliers labelled");
  plot(plot3);
  
  
  #### Fourth plot - Same plot information with tweaks ####
  # Changes from last plot to this plot:
  #   Changed the outlier points to a unicode character
  #     more info here: https://en.wikipedia.org/wiki/List_of_Unicode_characters
  #   Changed point color using rgb() -- for more info, look up "rgb" in Help tab
  #   Added 5px of padding on y-axis of plot 
  #   Stagger labels so that they do not overlap
  #     this is pretty advanced and involved modulus math
    
  padding = 5; # used in scale_y -- easier to tweak padding if it is a variable
  
  plot4=ggplot() +  
    geom_boxplot(stat="identity", 
                 mapping=aes(x=1, 
                             ymin = whiskerLow2,    
                             lower = y25,          
                             middle = median(y),   
                             upper = y75,           
                             ymax = whiskerHigh2)) +
    geom_point(mapping = aes(x=1, y=outlierValues),
               shape = "\u0259",   # unicode value
               size = 4,
               color = rgb(red=0.8, green=0.4, blue=0)) +   # red and some green make orange (really!)
    geom_text(mapping = aes(x=1, y=outlierValues, label=outlierDates),
              nudge_x = -0.05 + 0.10*outlierValues%%2) +    # staggers position of label based on even/odd numbers
    scale_y_continuous(limits = c( min(y)- padding, max(y)+padding )) +  # add padding to plot
    scale_x_continuous(breaks = c(1),            
                       labels = "Very Low") +    
    labs(title = "Humidity vs Precip Take 4",
         subtitle = "Fancy tweaks -- same info");
  plot(plot4);

  #### In-class application ####
  # For this application, you may start with any of the four plots above
  
  # 1) create one other box (Low, Medium, High, or Very High)
  # 2) add appropriate labels and titles to the plots
  # 3) change background colors and style to match application 6
  # 4) add the mean points to the two boxes
  # 5) add points at 1 and 2 standard deviations from mean 
  
  # Advanced
  # 1) Put all 5 boxes on canvas manually
  # 2) Put all 5 boxes on canvas using a for loop (very challenging!)
}  