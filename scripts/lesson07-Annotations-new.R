{
  rm(list=ls());                         # clear Environment tab
  options(show.error.locations = TRUE);  # show line numbers on error
  library(package=ggplot2);              # get the GGPlot package
  library(package=ggforce);              # for geom_circle, geom_ellipse

  # read in CSV file and save the content to weatherData
  weatherData = read.csv(file="data/Lansing2016NOAA.csv", 
                         stringsAsFactors = FALSE);  # for people still using R v3

  ### Part 1: Boxplots ####
  ### Re-order the directions on the x-axis using factor(s)
  windDirOrdered = factor(weatherData$windDir,
                       levels=c("North", "East", "South", "West"));
  
  #### A Boxplot ####
  plot1 = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=windDirOrdered, y=changeMaxTemp),
                 na.rm = TRUE) +
    theme_bw() +
    labs(title = "Change in Temperature vs. Wind Direction",
         subtitle = "Lansing, Michigan: 2016",
         x = "Wind Direction",
         y = "Change in Temperature (\u00B0F)");
  plot(plot1);

  #### Part 2: Get the rendered data for the plot ####
  renderedData = ggplot_build(plot1);
  
  # Extract the outliers from the rendered data
  outliers = renderedData$data[[1]]$outliers;

  #### Part 3: Add text to the plot ####
  plot3 = plot1 + 
    annotate(geom="text",   # type of annotation
             x=1.9,         # x coordinate of annotation
             y=-28,         # y coordinate of annotation
             label="-28",   # the annotation
             color="blue"); # can add style subcomponents
  plot(plot3);
  
  #### Part 4: Add multiple text values to the plot ####
  plot4 = plot1 + 
    annotate(geom="text",  
             x=c(2.9, 3.1, 2.9),        
             y=c(-14,18,17),        
             label=c(-14,18,17),   
             color=c("blue", "red", "red"));
  plot(plot4);
  
  #### Part 5: Add multiple text values from List ####
  # Extract the outlier values from the list
  thirdBoxOutliers = outliers[[3]];
  
  plot5 = plot1 + 
    annotate(geom="text",  
             x=c(2.9, 3.1, 2.9),        
             y=c(-14, 18, 17),        
             label=thirdBoxOutliers,   
             color=c("blue", "red", "red"));
  plot(plot5);
   
  #### Part 6 Get date for highest outlier in West box ####
  
  #### Using code to find the date of the most extreme outlier
  # This is beyond the scope of this lesson but it works
  #
  # Get the index of all days with west winds
  # westWindDays = which(weatherData$windDir == "West");
  # 
  # # find the maximum change in temperature on days with west winds
  # maxTempChange = max(weatherData$changeMaxTemp[westWindDays],
  #                     na.rm = TRUE);  # need to remove NA values
  # 
  # # find the index of the the day that had the max value (28)
  # dayMaxChange = which.max(weatherData$changeMaxTemp[westWindDays]);
  # 
  # # Get the date from the index (2-19)
  # date = weatherData$date[westWindDays[dayMaxChange]];
  
  #### Part 7 Annotate a line and text ####
  plot7 = plot1 + 
    annotate(geom="text",  
             x=3,        
             y=26,    
             label="2-19",         
             color="red") +
    annotate(geom="segment",
             x=3.2, 
             xend=3.95,
             y=26, 
             yend=26);
  plot(plot7);

  #### Part 8 Style the line and add an arrow ####
  plot8 = plot1 + 
    annotate(geom="text",  
             x=3,        
             y=26,    
             label="2-19",   
             color="red") +
    annotate(geom="segment",
             x=3.2, 
             xend=3.95,
             y=26, 
             yend=26,
             color = "red",
             linetype=2,
             size = 0.5,
             arrow = arrow());
  plot(plot8);
  
  
  #### Part 9 Adding a box to the plot ####
  plot9 = plot8 + 
    annotate(geom="rect",
             xmin = 2.8,
             xmax = 3.2,
             ymin = 23.5,
             ymax = 28.5,
             alpha = 0.2,
             linetype=2,
             color = "red",
             fill = "grey80");
  plot(plot9);
  
  #### Part 10: Adding a point to a plot ####
  plot10 =  plot1 +
    annotate(geom="point",
             x = 2,
             y = 25,
             size = 3,
             color =rgb(red=0, green=.3, blue=.7),
             fill = rgb(red=1, green=1, blue=0),
             shape = 24);
  plot(plot10);
  
  #### Part 11: Adding multiple points to a plot ####
  ### data for 5 points
  xVector = c(1, 1.3, 1.6, 1.9, 2.2);
  yVector = c(15, 17, 19, 21, 23);
  pointSize = c(5,4,3,2,1);
  pointFill = c("yellow", "orange", "red", "green", "pink");
  
  ## put in data above, but keep color and shape the same for all points
  plot11 =  plot1 +
    annotate(geom="point",
             x = xVector,
             y = yVector,
             size = pointSize,
             color =rgb(red=0, green=.3, blue=.7), # same for all points
             fill = pointFill,
             shape = 24);                          # same for all points
  plot(plot11);
    
  #### Part 12: Recreate a scatterplot ####
  plot12 = ggplot() + 
    theme_bw() +
     annotate(geom="point",
             x = weatherData$avgTemp,# need to be explicit (because it's not mapped)
             y = weatherData$relHum, # need to be explicit (because it's not mapped)
             size = 3,
             color = "blue",
             fill = "red",
             shape = 21) + 
    labs(title="Scatterplot using annotate",
         x = "Average Temperature",
         y = "Relative Humidity");
  plot(plot12);
     
  #### Part 13: Polygons ####
  plot13 = plot12 +
      annotate(geom="polygon",  # connects all the points
           x = c(60,55,30,35),
           y = c(60,50,40,80),
           color = "blue",
           fill = "green",
           linetype = 4,
           alpha = 0.4);
  plot(plot13);
  
  
  #### Part 14: Add horizontal and vertical lines ####
  # Get the mean average temperature and mean relative humidity
  meanTemp = mean(weatherData$avgTemp);
  meanHum = mean(weatherData$relHum);
  
  # Lines represent the mean average temperature and mean relative humidity
  plot14 = plot12 +
    geom_vline(mapping=aes(xintercept = meanTemp),
               color = "orange",
               size= 2) +
    geom_hline(mapping=aes(yintercept = meanHum),
               color="purple",
               size=2);
  plot(plot14);
  
  
  ##### Part 14b: Using annotate for vertical and horizontal lines (buggy) ####
  plot14b = plot12 +
    annotate(geom="vline",
             xintercept = meanTemp,
             x = meanTemp, # x must be included but is ignored (this is a bug)
             color = "orange",
             size= 2) +
    annotate(geom="hline",
             yintercept = meanHum,
             y = meanHum,  # y must be included but is ignored (this is a bug)
             color = "purple",
             size= 2);
  plot(plot14b);
  
  
  #### Part 15: Add a simple circle ####
  ## The circle is skewed because the plot axes are not the same scale
  plot15 = plot12 +
     # coord_fixed() +  # sets axes to same scale so circle is visually a circle
       geom_circle(mapping=aes(x0 = 50, y0 = 50, r = 10),
                 alpha=0.2,   
                 color = "blue",
                 fill = "green",
                 size=3,
                 linetype=3);
  plot(plot15);
  
  #### Part 16: Add an ellipse ####
  plot16 = plot12 + 
    geom_ellipse(mapping=aes(x0 = 50, y0 = 50, a = 20, b=10, angle=45),
                 alpha=0.2,   
                 color = "blue",
                 fill = "green",
                 size=3,
                 linetype=3);
  plot(plot16);
}