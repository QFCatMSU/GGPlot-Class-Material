{
  rm(list=ls());                         # clear Environment tab
  options(show.error.locations = TRUE);  # show line numbers on error
  library(package=ggplot2);              # get the GGPlot package
  library(package=ggforce);              # for geom_circle, geom_ellipse

  # read in CSV file and save the content to weatherData
  weatherData = read.csv(file="data/Lansing2016NOAA.csv", 
                         stringsAsFactors = FALSE);  # for people still using R v3

  #### Part 1a: mapping from the data frame ####
  plot1a = ggplot(data=weatherData) +   # set up data frame for the canvas 
     theme_bw() +
     geom_point(mapping=aes(x=avgTemp,y=relHum),
                color="red") +
     labs(title="Humidity vs Temperature",
          x = "Average Temperature",
          y = "Relative Humidity");
  plot(plot1a);

  #### Part 1b: Remove data frame -- get an error ####
  ## Error: object 'avgTemp' not found (if you run plot(plot1b) )
  plot1b = ggplot() +    # no data frame in canvas
     theme_bw() +
     geom_point(mapping=aes(x=avgTemp,y=relHum), 
                color="green") +
     labs(title="Humidity vs Temperature",
          x = "Average Temperature",
          y = "Relative Humidity");
#  plot(plot1b); 

  #### Part 1c: Use data frame in mapping -- works fine ####
  plot1c = ggplot() + 
     theme_bw() +
     geom_point(mapping=aes(x=weatherData$avgTemp,y=weatherData$relHum),  
                color="red") +
     labs(title="Humidity vs Temperature",
          x = "Average Temperature",
          y = "Relative Humidity");
  plot(plot1c); 
  
  #### Part 1d: Put data frame back -- causes a warning ####
  ## Warning: Use of `weatherData$avgTemp` is discouraged. Use `avgTemp` instead. 
  plot1d = ggplot(data=weatherData) + 
     theme_bw() +
     geom_point(mapping=aes(x=weatherData$avgTemp,y=weatherData$relHum),  
                color="purple") +
     labs(title="Humidity vs Temperature",
          x = "Average Temperature",
          y = "Relative Humidity");
  plot(plot1d); 
  
  
  #### Factoring  -- without using the data frame
  windDirOrdered = factor(weatherData$windDir,
                          levels=c("North", "South", "East", "West")); #order of wind direction
  
  plot2a = ggplot() +
    theme_bw() +
    geom_point(mapping=aes(x=weatherData$avgTemp, y=weatherData$relHum,
                           color = weatherData$season)) + 
    facet_grid(rows = windDirOrdered) + 
    labs(title="Humidity vs Temperature",
         x = "Average Temperature",
         y = "Relative Humidity");
  plot(plot2a);
  
  #### Factoring  -- using the data frame  
#  weatherData$windDirOrdered = windDirOrdered;
  
  plot2b = ggplot(data=weatherData) +
    theme_bw() +
    # note that RStudio also flags these var...
    geom_point(mapping=aes(x=avgTemp, y=relHum, color=season)) +
    facet_grid(rows = windDirOrdered) + 
    labs(title="Humidity vs Temperature",
         x = "Average Temperature",
         y = "Relative Humidity");
  plot(plot2b);
  
  #### This will cause an error if you execute plot(plot3a)
  ## Error: Aesthetics must be either length 1 or the same as the data (366): x and y
  plot3a = ggplot(data=weatherData) +
    theme_bw() +
    geom_point(mapping=aes(x=1:1000, y=sqrt(1:1000)),
               color="red");
  #plot(plot3a);
  
  
  #### This is fine -- but weird
  plot3b = ggplot() +
    theme_bw() +
    geom_point(mapping=aes(x=1:1000, y=sqrt(1:1000), color=6));
  plot(plot3b);
  
  #### This is better
  plot3c = ggplot() +
    theme_bw() +
    geom_line(mapping=aes(x=1:1000, y=sqrt(1:1000)),
              color = "red");
  plot(plot3c);
  
    #### This is better
  plot3d = ggplot() +
    theme_bw() +
    geom_segment(mapping=aes(x=101:110, y=sqrt(101:110), xend=111:120, yend=4),
              color = "red",
              size=4,
              lineend="round");
  plot(plot3d);
  
    #### This is better
  plot3e = ggplot() +
    theme_bw() +
    geom_polygon(mapping=aes(x=c(10,20,30,40), y=c(30,20,35,80)),
              color = "red",
              size=4,
              linetype=4);
  plot(plot3e);
  
  
  
}