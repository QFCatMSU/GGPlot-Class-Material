{
  source(file="scripts/reference.r");  
  weatherData = read.csv(file="data/LansingNOAA2016-2.csv", 
                         stringsAsFactors = FALSE);
  
  weatherData[,"precipNum"] = weatherData[,"precip"];

  dates = as.Date(weatherData[,"dateYr"]); # save the date column to a vector
  months = format(dates, format="%b");     # extract the month -- save to vector
  weatherData[,"month"] = months;          # save months to data frame as new column

  a = by(weatherData$maxTemp, weatherData$month, mean);
  c = summary(as.factor(weatherData$month));
  b = a[weatherData$month]/ c[weatherData$month];
  f = 
  d= ecdf(weatherData$tempDept);
 
  thePlot = ggplot(data=weatherData) +
    geom_col(mapping=aes(x=month, y=maxTemp, fill=tempDept),
             width=0.5) +
    scale_fill_gradientn(colors=c(rgb(red=0, green=0, blue=1),
                                  rgb(red=.5, green=.5, blue=.5),
                                  rgb(red=1, green=0, blue=0),
                                  rgb(red=1, green=1, blue=0)),
                         values=c(0,d(0),.95, 1)) +
    scale_x_discrete(limits = month.abb) +
    theme_bw() +
    labs(title = "Monthly Temperatures",
         subtitle = "Lansing, Michigan: 2016",
         x = "Month",
         y = "Degrees Total (Fahrenheit)");
  plot(thePlot);
}  