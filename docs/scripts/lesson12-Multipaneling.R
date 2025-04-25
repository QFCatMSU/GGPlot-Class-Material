{
  rm(list=ls());                         # clear Environment tab
  options(show.error.locations = TRUE);  # show line numbers on error
  library(package=ggplot2);              # get the GGPlot package
  library(package=gridExtra);            # for multipaneling
  
  weatherData = read.csv(file="data/Lansing2016NOAA.csv", 
                       stringsAsFactors = FALSE);

  #### Part 1: using grep to find days with a specific weather event
  rainyDays = grep(weatherData$weatherType, pattern="RA");   # any day with rain
  breezyDays = grep(weatherData$weatherType, pattern="BR");  # any breezy day

  #### Part 2: Scatterplot for Humidity vs. Temperature on breezy days
  plotA = ggplot(data=weatherData[breezyDays,]) +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    theme_classic() +
    labs(title = "Humidity vs. Temperature (Breezy Days)",
         subtitle = "Lansing, Michigan: 2016",
         x = "Degrees (Fahrenheit)",
         y = "Relative Humidity");
  plot(plotA);

  #### Part 3: Combine weather events using set operations
  rainyAndBreezy = intersect(rainyDays, breezyDays);
  rainyOrBreezy = union(rainyDays, breezyDays);
  rainyNotBreezy = setdiff(rainyDays, breezyDays);
  breezyNotRainy = setdiff(breezyDays, rainyDays);

  #### Part 3b: Invert a condition using setDiff
  notRainyAndNotBreezy = setdiff(1:nrow(weatherData), rainyOrBreezy);
  
  #### Part 4: Creating plots for all rainy day/breezy day combinations
  # The plot data is being created but it is not being rendered here #
  plotB = ggplot(data=weatherData[rainyDays,]) +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    theme_classic() +
    labs(title = "Humidity vs. Temperature (Rainy Days)",
         subtitle = "Lansing, Michigan: 2016",
         x = "Degrees (Fahrenheit)",
         y = "Relative Humidity");

  plotC = ggplot(data=weatherData[rainyAndBreezy,]) +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    theme_classic() +
    labs(title = "Hum vs. Temp (Rainy AND Breezy)",
         subtitle = "Lansing, Michigan: 2016",
         x = "Degrees (Fahrenheit)",
         y = "Relative Humidity");

  plotD = ggplot(data=weatherData[rainyOrBreezy,]) +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    theme_classic() +
    labs(title = "Hum vs. Temp (Rainy OR Breezy)",
         subtitle = "Lansing, Michigan: 2016",
         x = "Degrees (Fahrenheit)",
         y = "Relative Humidity");

  plotE = ggplot(data=weatherData[rainyNotBreezy,]) +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    theme_classic() +
    labs(title = "Hum vs. Temp (Rainy and NOT Breezy)",
         subtitle = "Lansing, Michigan: 2016",
         x = "Degrees (Fahrenheit)",
         y = "Relative Humidity");

  plotF = ggplot(data=weatherData[breezyNotRainy,]) +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    theme_classic() +
    labs(title = "Hum vs. Temp (Breezy and NOT Rainy)",
         subtitle = "Lansing, Michigan: 2016",
         x = "Degrees (Fahrenheit)",
         y = "Relative Humidity");

  ### Part 5: Arranging plots on one canvas by rows
  multi1=arrangeGrob(plotA, plotB, plotC, plotD, plotE, plotF,
                     nrow=3);
  plot(multi1);

  #### Part 6: Arranging plots on canvas by columns
  multi2=arrangeGrob(plotF, plotE, plotD, plotB, plotA,
                     ncol=3);
  plot(multi2);

  ### Part 7: Customize arrangements using a matrix
  multi3=arrangeGrob(plotA, plotB, plotC, plotD, plotE, plotF,
                     layout_matrix = rbind(c(4,5,6),   # plotD, plotE, plotF 
                                           c(3,2,1))); # plotC, plotB, plotA
  plot(multi3);

  ### Part 8: Add empty spaces to customized arrangement
  multi4=arrangeGrob(plotC, plotD, plotE,
                     layout_matrix = rbind(c(NA,1,2),   # none, plotC, plotD
                                           c(3,NA,NA)));# plotE, none, none
  plot(multi4);

  #### Part 9: Extending plots across rows and columns
  multi5=arrangeGrob(plotA, plotB, plotC, plotD,
                     layout_matrix = rbind(c(1,1,2),
                                           c(1,1,NA),
                                           c(4,3,3),
                                           c(4,NA,NA)));
  plot(multi5);

  #### Part 10a: Unused plot error (plotB, #2, not used)
  issue1 = arrangeGrob(plotA, plotB, plotC, plotD, plotE,
                       layout_matrix = rbind(c(1,1,5),
                                             c(1,1,NA),
                                             c(4,3,3),
                                             c(4,NA,NA)));
  # plot(issue1);  # Error in t:b : NA/NaN argument

  # #### Part 10b: Causes invalid index error (there is no 5th plot)
  issue2 = arrangeGrob(plotA, plotB, plotC, plotD,
                     layout_matrix = rbind(c(1,1,5),
                                           c(1,1,NA),
                                           c(4,3,2),
                                           c(4,NA,NA)));
  plot(issue2);
   
  #### Part 10c: plotA stretches across 2 rows and 2 columns
  issue3 = arrangeGrob(plotA, plotB,
                       layout_matrix = rbind(c(1,NA,2),
                                             c(NA,1,NA)));
  plot(issue3);

  #### Part 10d: Plot  overlaps plot 1 in top-right corner
  issue4 = arrangeGrob(plotA, plotB,
                       layout_matrix = rbind(c(1,NA,2),
                                             c(NA,NA,1)));
  plot(issue4);

  #### Part 10e: Plot 1 hidden behind plot 2
  issue5 = arrangeGrob(plotA, plotB,
                       layout_matrix = rbind(c(2,NA,1),
                                             c(NA,NA,2)));
  plot(issue5);

  # #### Part 10f: This arrangement gives inconsistent results
  #                - sometimes gives time elapsed warning
  #                - sometimes it just plots #1
  issue6 = arrangeGrob(plotA, plotB, plotC, plotD,
                       layout_matrix = rbind(c(1,1,4),
                                             c(1,1,NA),
                                             c(4,3,2),
                                             c(4,NA,NA)));
  plot(issue6);
  
  # Used to occasionally give the warning:
  # In unique.default(lengths(x)) : reached elapsed time limit

  #### Extension: Adding labels to a grob:
  multi1Lab=arrangeGrob(plotA, plotB, plotC, plotD, plotE, plotF,
                     nrow=3,
                     top="top label", 
                     bottom = grid::textGrob("bottom label", 
                                             gp=grid::gpar(col="blue", fontsize=40)),
                     right="right label",
                     left= grid::textGrob("left label", 
                                         gp=grid::gpar(col="red", fontsize=20)));
  plot(multi1Lab);
  pa = ggplotGrob(plotA)
  
  #### Extension: Adding labels to a grob:
  multi1Lab=arrangeGrob(plotA, plotB, plotC, plotD, plotE, plotF,
                        nrow=3, 
                        padding = unit(c(,10), "cm"),
                        top="top label", 
                        bottom = grid::textGrob("bottom label", 
                                                gp=grid::gpar(col="blue", fontsize=40)),
                        right=pa,
                        left= grid::textGrob("                   left label", rot=90,
                                             gp=grid::gpar(col="red", fontsize=20)));
  
  grid::grid.newpage() # stops labels from printing multiple times
  grid::grid.draw(multi1Lab)
}