{
  source(file="scripts/reference.R");  
  weatherData = read.csv(file="data/LansingNOAA2016-3.csv");
  #### Part 1: Create a wind direction column
  # pressureQuant = quantile(weatherData[,"stnPressure"], probs=c(.30,.70));
  humidityQuant = quantile(weatherData[,"relHum"], probs=c(.30,.70));
  
  # for(day in 1:nrow(weatherData))
  # {
  #   ## Adding a column that gives relative wind speed for the day
  #   # Winds less than 6.4 miles/hour -- label as "Low"
  #   if(weatherData[day,"stnPressure"] <= pressureQuant[1])
  #   {
  #     weatherData[day,"pressureLevel"] = "Low";
  #   }
  #   # Winds greater than 10.2 miles/hour -- label as "High"
  #   else if(weatherData[day,"stnPressure"] <= pressureQuant[2])
  #   {
  #     weatherData[day,"pressureLevel"] = "Medium";
  #   }
  #   else
  #   {
  #     weatherData[day,"pressureLevel"] = "High";
  #   }
  # }
  
  for(day in 1:nrow(weatherData))
  {
    ## Adding a column that gives relative wind speed for the day
    # Winds less than 6.4 miles/hour -- label as "Low"
    if(weatherData[day,"relHum"] <= humidityQuant[1])
    {
      weatherData[day,"humidityLevel"] = "Low";
    }
    # Winds greater than 10.2 miles/hour -- label as "High"
    else if(weatherData[day,"relHum"] <= humidityQuant[2])
    {
      weatherData[day,"humidityLevel"] = "Medium";
    }
    else
    {
      weatherData[day,"humidityLevel"] = "High";
    }
  }
  
  windLabels = c(Low = "Light Winds",
                 Medium = "Medium Winds",
                 High = "Strong Winds");
  
  thePlot = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=humidityLevel, y=stnPressure,
                             fill=factor(windDir)),
                 na.rm=TRUE) +
    theme_bw() +
      facet_grid(facets=.~factor(windSpeedLevel,
                                 levels=c("Low", "Medium", "High")),
                 labeller=as_labeller(windLabels)) +
   scale_x_discrete(limits = c("Low","Medium", "High")) +
  #  scale_fill_manual(values = c(rgb(red=1, green=1, blue=0),        # low
  #                               rgb(red=1, green=0.2, blue=0),      # medium
  #                               rgb(red=0.5, green=0, blue=0.8))) +  # high

                        labs(title = "Change in Temperature vs. Wind Direction",
                             subtitle = "Lansing, Michigan: 2016",
                             x = "Humidity Levels",
                             y = "Pressure",
                             fill = "Wind Direction");   # changes the legend title
  
                      plot(thePlot);

}  