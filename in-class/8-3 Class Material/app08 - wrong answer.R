{
  source( file="scripts/reference.R" ); 
  weatherData = read.csv( file="data/LansingNOAA2016-3.csv", 
                          stringsAsFactors = FALSE );
  
  dates = as.Date(weatherData$dateYr);     # save the date column to a vector
  months = format(dates, format="%b");     # extract the month -- save to vector
  weatherData$month = months;              # save months to data frame as new column
  
  # this plot is overlaying the stacked blue values on the stacked red values
  thePlot = ggplot(data=weatherData) +
    geom_col(mapping=aes(x=month, y=heatDays), 
             fill = "red",    # background color
             width=0.4)  +  
    geom_col(mapping=aes(x=month, y=coolDays), 
             color = "blue",  # outline color
             alpha = 0,       # transparent background
             width=0.4) +
    scale_x_discrete(limits = month.abb) +        # month.abb = c("Jan", "Feb"...)
    theme_bw() +
    labs(title = "Heating and Cooling Days",
         subtitle = "without position_nudge",
         x = "Month",
         y = "Cumulative Heat/Cool Days");
  plot(thePlot);
  
  
  # this plot is overlaying values within each color -- it is not stacking them...
  # what you see is the highest value for each month
  thePlot = ggplot(data=weatherData) +
    geom_col(mapping=aes(x=month, y=heatDays), 
             position=position_nudge(x=-0.2),     # don't need after_stat()!
             fill = "red",    # background color
             width=0.4)  +  
    geom_col(mapping=aes(x=month, y=coolDays), 
             position=position_nudge(x=0.2),
             color = "blue",  # outline color
             alpha = 0,       # transparent background
             width=0.4) +
    scale_x_discrete(limits = month.abb) +        # month.abb = c("Jan", "Feb"...)
    theme_bw() +
    labs(title = "Heating and Cooling Days",
         subtitle = "with position_nudge",
         x = "Month",
         y = "Cumulative Heat/Cool Days");
  plot(thePlot);
}

