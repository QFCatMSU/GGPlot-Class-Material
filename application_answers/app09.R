{
  source(file="scripts/reference.R");  
  weatherData = read.csv(file="data/LansingNOAA2016-3.csv", 
                       stringsAsFactors = FALSE);

  # go through all rows in weatherData
  for(i in 1:nrow(weatherData))
  {
    # if the value is T, change to 0.05
    if(weatherData[i,"precip"] == "T")
    {
      weatherData[i,"precipNum"] = 0.005;
    }
    else
    {
      weatherData[i,"precipNum"] = weatherData[i,"precip"];
    }
  }
  weatherData$precipNum = as.numeric(weatherData$precipNum);
  
  rainyDays = which(weatherData$precipNum > 0);
  
  #### Part 11: Change legend position
  thePlot = ggplot(data=weatherData[rainyDays,]) +
    geom_text(mapping=aes(x=relHum, y=precipNum,
                          color=maxTemp, label=avgTemp),
              size=3.5) +
    scale_color_gradientn(colors=c("blue","darkgreen","red")) +
    theme_bw() +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          legend.key.height = unit(15, units="pt"),
          legend.key.width = unit(40, units="pt"),
          legend.direction = "horizontal",
          legend.position = c(0.17, 0.93)) +
    scale_y_continuous(trans="log10") +
    labs(title = "Precipitation vs. Humidity",
         subtitle = "Lansing, Michigan: 2016",
         x = "Humidity",
         y = "Precipitation",
         color = "");
  plot(thePlot);
  
 
}

