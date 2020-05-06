{
  source(file="scripts/reference.R");  
  weatherData = read.csv(file="data/LansingNOAA2016-3.csv", 
                       stringsAsFactors = FALSE);
  
  #### Part 1: Create a Humidity vs. Temperature scatterplot
  thePlot = ggplot(data=weatherData) +
            geom_point(mapping=aes(x=avgTemp, y=relHum)) +
            theme_bw() +
            theme(panel.grid.major = element_blank(), 
                  panel.grid.minor = element_blank()) +
            labs(title = "Humidity vs. Tempertaure",
                 subtitle = "Lansing, Michigan: 2016",
                 x = "Degrees (Fahrenheit)",
                 y = "Relative Humidity");
  plot(thePlot);

  #### Part 2: Use dates instead of points
  thePlot = ggplot(data=weatherData) +
    geom_text(mapping=aes(x=avgTemp, y=relHum, label=dateYr)) +
    theme_bw() +
    theme(panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank()) +
    labs(title = "Humidity vs. Temperature",
         subtitle = "Lansing, Michigan: 2016",
         x = "Degrees (Fahrenheit)",
         y = "Relative Humidity");
  plot(thePlot);

  #### Part 3: Reformat the date labels
  thePlot = ggplot(data=weatherData) +
    geom_text(mapping=aes(x=avgTemp, y=relHum, label=date), 
              color="darkgreen", 
              size=2.5) +
    theme_bw() +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank()) +
    labs(title = "Humidity vs. Temperature",
         subtitle = "Lansing, Michigan: 2016",
         x = "Degrees (Fahrenheit)",
         y = "Relative Humidity");
  plot(thePlot);

  #### Part 4: Add gradient (also adds a legend)
  thePlot = ggplot(data=weatherData) +
    geom_text(mapping=aes(x=avgTemp, y=relHum, 
                          color=1:nrow(weatherData), label=date),
              size=2.5) +
    theme_bw() +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank()) +
    labs(title = "Humidity vs. Temperature",
         subtitle = "Lansing, Michigan: 2016",
         x = "Degrees (Fahrenheit)",
         y = "Relative Humidity");
  plot(thePlot);

  #### Part 5: Change the gradient colors
  thePlot = ggplot(data=weatherData) +
    geom_text(mapping=aes(x=avgTemp, y=relHum,
                          color=1:nrow(weatherData), label=date),
              size=2.5) +
    scale_color_gradientn(colors=c("blue","green","red","brown","blue")) +
    theme_bw() +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank()) +
    labs(title = "Humidity vs. Temperature",
         subtitle = "Lansing, Michigan: 2016",
         x = "Degrees (Fahrenheit)",
         y = "Relative Humidity");
  plot(thePlot);

  #### Part 6: Add breaks and labels to the legend
  thePlot = ggplot(data=weatherData) +
    geom_text(mapping=aes(x=avgTemp, y=relHum,
                          color=1:nrow(weatherData), label=date),
              size=2.5) +
    scale_color_gradientn(colors=c("blue","green","red","brown","blue"),
                          breaks=c(91, 183, 274),
                          labels=c("Spring", "Summer", "Fall")) +
    theme_bw() +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank()) +
    labs(title = "Humidity vs. Temperature",
         subtitle = "Lansing, Michigan: 2016",
         x = "Degrees (Fahrenheit)",
         y = "Relative Humidity");
  plot(thePlot);

  #### Part 7: Modify size and title of legend
  thePlot = ggplot(data=weatherData) +
    geom_text(mapping=aes(x=avgTemp, y=relHum,
                          color=1:nrow(weatherData), label=date),
              size=2.5) +
    scale_color_gradientn(colors=c("blue","green","red","brown","blue"),
                          breaks=c(91, 183, 274),
                          labels=c("Spring", "Summer", "Fall")) +
    theme_bw() +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          legend.key.height = unit(40, units="pt")) +
    labs(title = "Humidity vs. Temperature",
         subtitle = "Lansing, Michigan: 2016",
         x = "Degrees (Fahrenheit)",
         y = "Relative Humidity",
         color = "Seasons");
  plot(thePlot);

  #### Part 8: Using grep to find indexes
  springIndex = grep(weatherData$date, pattern="3-21");
  summerIndex = grep(weatherData$date, pattern="6-21");
  fallIndex = grep(weatherData$date, pattern="9-21");
  winterIndex = grep(weatherData$date, pattern="12-21");

  #### Part 9: Add seasons to legend
  thePlot = ggplot(data=weatherData) +
    geom_text(mapping=aes(x=avgTemp, y=relHum,
                          color=1:nrow(weatherData), label=date),
              size=2.5) +
    scale_color_gradientn(colors=c("blue","green","red","brown","blue"),
                          breaks=c(winterIndex, springIndex,
                                   summerIndex, fallIndex),
                          labels=c("winter","spring","summer","fall")) +
    theme_bw() +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          legend.key.height = unit(40, units="pt")) +
    labs(title = "Humidity vs. Temperature",
         subtitle = "Lansing, Michigan: 2016",
         x = "Degrees (Fahrenheit)",
         y = "Relative Humidity",
         color = "Seasons");
  plot(thePlot);

  #### Part 10: Change gradient breaks
  thePlot = ggplot(data=weatherData) +
    geom_text(mapping=aes(x=avgTemp, y=relHum,
                          color=1:nrow(weatherData), label=date),
              size=2.5) +
    scale_color_gradientn(colors=c("blue","green","red","brown","blue"),
                          values=c(0, 0.2, 0.55, 0.85, 1),
                          breaks=c(winterIndex, springIndex,
                                   summerIndex, fallIndex),
                          labels=c("winter","spring","summer","fall")) +
    theme_bw() +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          legend.key.height = unit(25, units="pt")) +
    labs(title = "Humidity vs. Temperature",
         subtitle = "Lansing, Michigan: 2016",
         x = "Degrees (Fahrenheit)",
         y = "Relative Humidity",
         color = "Seasons");
  plot(thePlot);

  #### Part 11: Change legend position
  thePlot = ggplot(data=weatherData) +
    geom_text(mapping=aes(x=avgTemp, y=relHum,
                          color=1:nrow(weatherData), label=date),
              size=2.5) +
    scale_color_gradientn(colors=c("blue","green","red","brown","blue"),
                          values=c(0, 0.2, 0.55, 0.85, 1),
                          breaks=c(winterIndex, springIndex,
                                   summerIndex, fallIndex),
                          labels=c("winter","spring","summer","fall")) +
    theme_bw() +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          legend.key.height = unit(15, units="pt"),
          legend.key.width = unit(40, units="pt"),
          legend.direction = "horizontal",
          legend.position = c(0.25, 0.08)) +
    labs(title = "Humidity vs. Temperature",
         subtitle = "Lansing, Michigan: 2016",
         x = "Degrees (Fahrenheit)",
         y = "Relative Humidity",
         color = "");
  plot(thePlot);
}

