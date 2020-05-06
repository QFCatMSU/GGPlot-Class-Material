{
  source(file="scripts/reference.R");  
  weatherData = read.csv(file="data/LansingNOAA2016-3.csv");
  
  #### Part 1: A different way to arrange x-axis values
  thePlot = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDir, y=changeMaxTemp), na.rm=TRUE) +
    scale_x_discrete(limits=c("North", "East", "South", "West")) +
    theme_bw() +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)");
  plot(thePlot);

  ### Part 4: Adding color and changing title
  thePlot = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDir, y=changeMaxTemp,
                             fill=factor(windSpeedLevel,
                                         levels=c("Low", "Medium", "High"))),
                 na.rm=TRUE) +
    theme_bw() +
    scale_x_discrete(limits = c("North", "East", "South", "West")) +
    scale_fill_manual(values = c(rgb(red=1, green=1, blue=0),        # low
                                 rgb(red=1, green=0.2, blue=0),      # medium
                                 rgb(red=0.5, green=0, blue=0.8))) +  # high
                        labs(title = "Change in Temperature vs. Wind Direction",
                             subtitle = "Lansing, Michigan: 2016",
                             x = "Wind Direction",
                             y = "Degrees (Fahrenheit)",
                             fill = "Wind Speeds");   # changes the legend title
                      plot(thePlot);
                      
  ### Extension: Setting quantile values
  lowVal = findQuants(yVar=weatherData$changeMaxTemp,
                      xVar=weatherData$windDir,
                      factors=c("North", "East", "South", "West"),
                       percentile=0.35);

  highVal = findQuants(yVar=weatherData$changeMaxTemp,
                       xVar=weatherData$windDir,
                       factors=c("North", "East", "South", "West"),
                       percentile=0.65);

  #### Extension: Applying quantile values
  thePlot = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDir, y=changeMaxTemp), 
                 na.rm=TRUE,
                 lower=lowVal, 
                 upper=highVal) +
    scale_x_discrete(limits=c("North", "East", "South", "West")) +
    theme_bw() +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)");
  plot(thePlot);

  #### Part 2: Group boxplots by wind speed levels
  thePlot = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDir, y=changeMaxTemp,
                             fill=windSpeedLevel),
                 na.rm=TRUE) +
    scale_x_discrete(limits=c("North", "East", "South", "West")) +
    theme_bw() +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)");
    plot(thePlot);

  ### Part 3: Reorder grouping
  thePlot = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDir, y=changeMaxTemp,
                             fill=factor(windSpeedLevel,
                                  levels=c("Low", "Medium", "High"))),
                 na.rm=TRUE) +
    scale_x_discrete(limits=c("North", "East", "South", "West")) +
    theme_bw() +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)");
  plot(thePlot);

  ### Part 4: Adding color and changing title
  thePlot = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDir, y=changeMaxTemp,
                             fill=factor(windSpeedLevel,
                                  levels=c("Low", "Medium", "High"))),
                 na.rm=TRUE) +
    theme_bw() +
    scale_fill_manual(values = c("#ffff00", "#ff3300", "#8800aa")) +
    scale_x_discrete(limits=c("North", "East", "South", "West")) +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)",
         fill = "Wind Speeds");
  plot(thePlot);

  #### Part 5: Using facets vertically
  thePlot = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDir, y=changeMaxTemp), 
                 na.rm=TRUE) +
    theme_bw() +
    scale_x_discrete(limits=c("North", "East", "South", "West")) +
    facet_grid(facets=windSpeedLevel ~ .) +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)");
  plot(thePlot);

  #### Part 6: Using facets horizontally
  thePlot = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDir, y=changeMaxTemp), 
                 na.rm=TRUE) +
    theme_bw() +
    scale_x_discrete(limits=c("North", "East", "South", "West")) +
    facet_grid(facets= . ~ windSpeedLevel) +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)");
  plot(thePlot);

  #### Part 7: Ordering facets
  thePlot = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDir, y=changeMaxTemp), 
                 na.rm=TRUE) +
    theme_bw() +
    facet_grid(facets= .~factor(windSpeedLevel,
                              levels=c("Low", "Medium", "High"))) +
    scale_x_discrete(limits=c("North", "East", "South", "West")) +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)");
  plot(thePlot);

  ### Part 8: Filling and coloring facets
  thePlot = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDir, y=changeMaxTemp), 
                 na.rm=TRUE,
                 color="blue",
                 fill="red") +
    theme_bw() +
    scale_x_discrete(limits=c("North", "East", "South", "West")) +
    facet_grid(facets=.~factor(windSpeedLevel,
                        levels=c("Low", "Medium", "High"))) +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)");
  plot(thePlot);

  ### Part 9: Filling and coloring facets with different colors
  thePlot = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDir, y=changeMaxTemp), 
                 na.rm=TRUE,
                 color=c("blue", rep("black", 3),
                         "green", rep("black", 3),
                         "orange", rep("black", 3)),
                 fill=c(rep(NA, 8), rep("red", 3), NA)) +
    theme_bw() +
    scale_x_discrete(limits=c("North", "East", "South", "West")) +
    facet_grid(facets=.~factor(windSpeedLevel,
                               levels=c("Low", "Medium", "High"))) +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)");
  plot(thePlot);


  #### Part 10: Changing facet labels
  windLabels = c(Low = "Light Winds",
                 Medium = "Medium Winds",
                 High = "Strong Winds");

  thePlot = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDir, y=changeMaxTemp),
                 na.rm=TRUE,
                 color=c("blue", rep("black", 3),
                         "green", rep("black", 3),
                         "orange", rep("black", 3)),
                 fill=c(rep(NA, 8), rep("red", 3), NA)) +
    theme_bw() +
    facet_grid(facets=.~factor(windSpeedLevel,
                               levels=c("Low", "Medium", "High")),
               labeller=as_labeller(windLabels)) +
    scale_x_discrete(limits=c("North", "East", "South", "West")) +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Degrees (Fahrenheit)");
  plot(thePlot);
}  