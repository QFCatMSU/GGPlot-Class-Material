{
  source(file="scripts/reference.R");  
  weatherData = read.csv(file="data/LansingNOAA2016.csv", 
                         stringsAsFactors = FALSE);
  
  #### Add year to date values --
  #    same as in lesson but using different methods ####
  theDate = weatherData$date;
  theDate = paste(theDate, "2016", sep="-");
  theDate = as.Date(theDate, format="%m-%d-%Y");
  weatherData$dateYr = theDate;
  
  #### Convert max, min, and avg temps to Celsius ####
  maxTemp = weatherData[ , "maxTemp"];
  minTemp = weatherData[ , "minTemp"];
  avgTemp = weatherData[ , "avgTemp"];

  maxTemp = (5/9)*(maxTemp - 32);
  minTemp = (5/9)*(minTemp - 32);
  avgTemp = (5/9)*(avgTemp - 32);

  weatherData[, "maxTempC"] = maxTemp;
  weatherData[, "minTempC"] = minTemp;
  weatherData[, "avgTempC"] = avgTemp;

  ### get the earliest and latest index for the dates that we want to plot
  firstDateIndex = which(weatherData$dateYr == as.Date("2016-03-21")); 
  lastDateIndex = which(weatherData$dateYr == as.Date("2016-09-21")); 
  
  #### Part 8: Scaling discrete values (dates) ###
  # reduce the data set to only the row that have value we want to plot
  plotData = ggplot(data=weatherData[firstDateIndex:lastDateIndex,]) +
    geom_line(mapping=aes(x=dateYr, y=maxTempC),
              color="purple") +
    geom_line(mapping=aes(x=dateYr, y=minTempC), 
              color="brown") +
    geom_smooth(mapping=aes(x=dateYr, y=avgTempC),
                color="black",
                method="loess", 
                linetype=5, 
                fill="lightblue") +
    labs(title = "Temperature in Celsius vs. Date",
         subtitle = "Lansing, Michigan: 2016",
         x = "Date",
         y = "Temperature (C)") +
    # size and color relate to the border, fill is the inside color
    theme(plot.title = element_text(hjust = 1.0),
          plot.subtitle = element_text(hjust = 1.0),
          axis.text.x = element_text(color="blue", family="mono", size=9),
          axis.text.y = element_text(color="red", family="mono", size=9)) +
    scale_y_continuous(limits = c(-15,40),
                       breaks = seq(from=-10, to=35, by=15)) +
    scale_x_date(limits=c(as.Date("2016-03-21"), as.Date("2016-09-21")),
                 date_breaks = "8 weeks", 
                 date_labels = format("%b-%d-%Y"));
  
  plot(plotData);
}  