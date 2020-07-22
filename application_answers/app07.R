{
  source(file="scripts/reference.R");  
  weatherData = read.csv(file="data/LansingNOAA2016-3.csv");

  humidityQuant = quantile(weatherData[,"relHum"], probs=c(.30,.70));
  
  for(day in 1:nrow(weatherData))
  {
    if(weatherData[day,"relHum"] <= humidityQuant[1])
    {
      weatherData[day,"humidityLevel"] = "Low";
    }
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
      theme(strip.text = element_text(size=9, color="darkgreen"),
            strip.background = element_rect(colour="gray", fill="transparent")) +  # could use color instead of transprent
      facet_grid(facets=.~factor(windSpeedLevel,
                                 levels=c("Low", "Medium", "High")),
                 labeller=as_labeller(windLabels)) +
      scale_x_discrete(limits = c("Low","Medium", "High")) +
      labs(title = "Change in Temperature vs. Wind Direction",
           subtitle = "Lansing, Michigan: 2016",
           x = "Humidity Levels",
           y = "Pressure",
           fill = "Wind Direction");   # changes the legend title
  
   plot(thePlot);

}  