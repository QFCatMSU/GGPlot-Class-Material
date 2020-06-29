{
  ##### This script will be fixed up and added to lesson 10
  
  source(file="scripts/reference.R");  
  weatherData = read.csv(file="data/LansingNOAA2016-3.csv", 
                       stringsAsFactors = FALSE);

  #### Part 1: using grep to find days with a specific weather event
  rainyDays = grep("RA", weatherData$weatherType);
  breezyDays = grep("BR", weatherData$weatherType);

  #### Part 2: Scatterplot for Humidity vs. Temperature on breezy days
  plot1 = ggplot(data=weatherData[breezyDays,]) +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    theme_classic() +
    labs(title = "plot1",
         subtitle = "Lansing, Michigan: 2016",
         x = "Degrees (Fahrenheit)",
         y = "Relative Humidity");
  plot(plot1);

  #### Part 3: Combine weather events using set operations
  rainyAndBreezy = intersect(rainyDays, breezyDays);
  rainyOrBreezy = union(rainyDays, breezyDays);
  rainyNotBreezy = setdiff(rainyDays, breezyDays);
  breezyNotRainy = setdiff(breezyDays, rainyDays);

  #### Part 4: Creating plots for all rainy day/breezy day combinations
  plot2 = ggplot(data=weatherData[rainyDays,]) +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    theme_classic() +
    labs(title = "plot2",
         subtitle = "Lansing, Michigan: 2016",
         x = "Degrees (Fahrenheit)",
         y = "Relative Humidity");

  plot3 = ggplot(data=weatherData[rainyAndBreezy,]) +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    theme_classic() +
    labs(title = "plot3",
         subtitle = "Lansing, Michigan: 2016",
         x = "Degrees (Fahrenheit)",
         y = "Relative Humidity");

  plot4 = ggplot(data=weatherData[rainyOrBreezy,]) +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    theme_classic() +
    labs(title = "plot4",
         subtitle = "Lansing, Michigan: 2016",
         x = "Degrees (Fahrenheit)",
         y = "Relative Humidity");

  plot5 = ggplot(data=weatherData[rainyNotBreezy,]) +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    theme_classic() +
    theme(axis.title.x=element_blank(),  # remove x-axis components
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank(),
          axis.title.y=element_blank(),  # remove y-axis components
          axis.text.y=element_blank(),
          axis.ticks.y=element_blank());# +
    # labs(title = "plot5",
    #      subtitle = "Lansing, Michigan: 2016",
    #      x = "Degrees (Fahrenheit)",
    #      y = "Relative Humidity");

  plot6 = ggplot(data=weatherData[breezyNotRainy,]) +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    theme_classic() +
    labs(title = "plot6",
         subtitle = "Lansing, Michigan: 2016",
         x = "Degrees (Fahrenheit)",
         y = "Relative Humidity");

  ### Part 7: Customize arrangements using a matrix
  grid.arrange(plot1, plot2, plot3, plot4, plot5, plot6,
               layout_matrix = rbind(c(1,2,3),
                                     c(4,5,6)));
}