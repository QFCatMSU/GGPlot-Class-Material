{
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
    labs(title = "Humidity vs. Temperature (Breezy Days)",
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
    labs(title = "Humidity vs. Temperature (Rainy Days)",
         subtitle = "Lansing, Michigan: 2016",
         x = "Degrees (Fahrenheit)",
         y = "Relative Humidity");

  plot3 = ggplot(data=weatherData[rainyAndBreezy,]) +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    theme_classic() +
    labs(title = "Hum vs. Temp (Rainy AND Breezy)",
         subtitle = "Lansing, Michigan: 2016",
         x = "Degrees (Fahrenheit)",
         y = "Relative Humidity");

  plot4 = ggplot(data=weatherData[rainyOrBreezy,]) +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    theme_classic() +
    labs(title = "Hum vs. Temp (Rainy OR Breezy)",
         subtitle = "Lansing, Michigan: 2016",
         x = "Degrees (Fahrenheit)",
         y = "Relative Humidity");

  plot5 = ggplot(data=weatherData[rainyNotBreezy,]) +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    theme_classic() +
    labs(title = "Hum vs. Temp (Rainy and NOT Breezy)",
         subtitle = "Lansing, Michigan: 2016",
         x = "Degrees (Fahrenheit)",
         y = "Relative Humidity");

  plot6 = ggplot(data=weatherData[breezyNotRainy,]) +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    theme_classic() +
    labs(title = "Hum vs. Temp (Breezy and NOT Rainy)",
         subtitle = "Lansing, Michigan: 2016",
         x = "Degrees (Fahrenheit)",
         y = "Relative Humidity");

  ### Part 5: Arranging plots on one canvas by rows
  grid.arrange(plot1, plot2, plot3, plot4, plot5, plot6,
               nrow=3);

  #### Part 6: Arranging plots on canvas by columns
  grid.arrange(plot6, plot5, plot4, plot2, plot1,
               ncol=3);

  ### Part 7: Customize arrangements using a matrix
  grid.arrange(plot1, plot2, plot3, plot4, plot5, plot6,
               layout_matrix = rbind(c(4,5,6),
                                     c(3,2,1)));

  ### Part 8: Add empty spaces to customized arrangement
  grid.arrange(plot3, plot4, plot5,
               layout_matrix = rbind(c(NA,1,2),
                                     c(3,NA,NA)));

  #### Part 9: Extending plots across rows and columns
  grid.arrange(plot1, plot2, plot3, plot4,
               layout_matrix = rbind(c(1,1,2),
                                     c(1,1,NA),
                                     c(4,3,3),
                                     c(4,NA,NA)));

  # #### Part 10a: Unused plot error (plot2 not used)
  # grid.arrange(plot1, plot2, plot3, plot4, plot5,
  #              layout_matrix = rbind(c(1,1,5),
  #                                    c(1,1,NA),
  #                                    c(4,3,3),
  #                                    c(4,NA,NA)));
  # 
  # #### Part 10b: Causes invalid index error (there is no 5th plot)
  # grid.arrange(plot1, plot2, plot3, plot4,
  #              layout_matrix = rbind(c(1,1,5),
  #                                    c(1,1,NA),
  #                                    c(4,3,2),
  #                                    c(4,NA,NA)));
  # 
  #### Part 10c: Plot1 stretches across 2 rows and 2 columns
  grid.arrange(plot1, plot2,
               layout_matrix = rbind(c(1,NA,2),
                                     c(NA,1,NA)));

  #### Part 10d: Plot  overlaps plot 1 in top-right corner
  grid.arrange(plot1, plot2,
               layout_matrix = rbind(c(1,NA,2),
                                     c(NA,NA,1)));

  #### Part 10e: Plot 1 hidden behind plot 2
  grid.arrange(plot1, plot2,
               layout_matrix = rbind(c(2,NA,1),
                                     c(NA,NA,2)));

  # #### Part 10f: This arrangement gives inconsistent results
  #                - sometimes gives time elapsed warning
  #                - sometimes it just plots #1
  # grid.arrange(plot1, plot2, plot3, plot4,
  #              layout_matrix = rbind(c(1,1,4),
  #                                    c(1,1,NA),
  #                                    c(4,3,2),
  #                                    c(4,NA,NA)));
}