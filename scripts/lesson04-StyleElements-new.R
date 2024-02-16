{
  rm(list=ls());                         # clear Environment tab
  options(show.error.locations = TRUE);  # show line numbers on error
  library(package=ggplot2);              # get the GGPlot package

  # read in CSV file and save the content to weatherData
  weatherData = read.csv(file="data/Lansing2016NOAA.csv", 
                         stringsAsFactors = FALSE);  # for people still using R v3
  
  #### Part 0: Will work if your Run -- but not well-structured! ####
  ggplot( data=weatherData ) +
    geom_point( mapping=aes(x=avgTemp, y=relHum, color=season, size=precip2)) +
    theme_bw() +
    labs(title = "Humidity vs. Temperature",
         subtitle = "Lansing, Michigan: 2016",
         x = "Temperature (\u00B0F)",  # 00B0 is the degree symbol
         y = "Humidity (\u0025)")
  
  #### Part 1: Mapping the points (with some Unicode added) ####
  plot1 = ggplot( data=weatherData ) +
    geom_point( mapping=aes(x=avgTemp, y=relHum, color=season, size=precip2)) +
    theme_bw() +
    labs(title = "Humidity vs. Temperature",
         subtitle = "Lansing, Michigan: 2016",
         x = "Temperature (\u00B0F)",  # 00B0 is the degree symbol
         y = "Humidity (\u0025)");     # 0025 is the percentage symbol
  plot(plot1);
  
  #### Part 2: Styling the points ####
  plot2 = ggplot( data=weatherData ) +
    geom_point( mapping=aes(x=avgTemp, y=relHum),
                color="darkgreen",
                size=2.5,
                shape=17 ) +
    theme_bw() +
    labs(title = "Humidity vs. Temperature",
         subtitle = "Lansing, Michigan: 2016",
         x = "Temperature (F)",
         y = "Humidity (%)");
  plot(plot2);
  
  #### Part 3: Overriding mapped styles ####
  plot3 = ggplot( data=weatherData ) +
    geom_point( mapping=aes(x=avgTemp, y=relHum, color=season, size=precip2),
                color="darkgreen", # this overrides the color mapping
                shape=17 ) +
    theme_bw() +
    labs(title = "Humidity vs. Temperature",
         subtitle = "Lansing, Michigan: 2016",
         x = "Temperature (F)",
         y = "Humidity (%)");
  plot(plot3);
  
  #### Part 4: Make points semi-transparent ####
  plotData = ggplot( data=weatherData ) +
    geom_point( mapping=aes(x=avgTemp, y=relHum),
                color="darkgreen",
                size=2.5,
                shape=17,
                alpha = 0.4 ) +
    theme_bw() +
    labs(title = "Humidity vs. Temperature",
         subtitle = "Lansing, Michigan: 2016",
         x = "Temperature (F)",
         y = "Humidity (%)");
  plot(plotData);
  
  #### Part 5: Add lines to a plot ####
  plot5 = ggplot(data=weatherData) +
    geom_line(mapping=aes(x=1:nrow(weatherData), y=maxTemp)) +
    geom_line(mapping=aes(x=1:nrow(weatherData), y=minTemp)) +
    theme_bw() +
    labs(title = "Temperature throughout the year",
         subtitle = "Lansing, Michigan: 2016",
         x = "Day (row) number",
         y = "Temperature (F)");
  plot(plot5);
  
  #### Part 6: Add colors by name and using rgb() ###
  plot6 = ggplot(data=weatherData) +
    geom_line(mapping=aes(x=1:nrow(weatherData), y=maxTemp),
              color="violetred1") +
    geom_line(mapping=aes(x=1:nrow(weatherData), y=minTemp), 
              color=rgb(red=0.4, green=0.7, blue=0.9)) + 
    
    theme_bw() +
    labs(title = "Temperature vs. Date",
         subtitle = "Lansing, Michigan: 2016",
         x = "Date",
         y = "Temperature (F)");
  plot(plot6);
  
  #### Part 7: Add smoothing function ###
  plot7 = ggplot(data=weatherData) +
    geom_line(mapping=aes(x=1:nrow(weatherData), y=maxTemp),
              color="violetred1") +
    geom_line(mapping=aes(x=1:nrow(weatherData), y=minTemp), 
              color=rgb(red=0.4, green=0.7, blue=0.9)) +  
    theme_bw() +
    geom_smooth(mapping=aes(x=1:nrow(weatherData), y=avgTemp),
                method="loess",
                color=rgb(red=1, green=0.5, blue=0),  # orange
                linetype=4,
                size=2, 
                fill="lightgreen") +
    labs(title = "Temperature throughout the year",
         subtitle = "Lansing, Michigan: 2016",
         x = "Day (row) number",
         y = "Temperature (F)");
  plot(plot7);
  
  #### Part 8: Changing component text ####
  
  
  plot8 = ggplot( data=weatherData ) +
    geom_point( mapping=aes(x=avgTemp, y=relHum),
                color="darkgreen",
                size=2.5,
                shape=17,
                alpha = 0.4 ) +
    theme_bw() +
    labs(title = "Humidity vs. Temperature",
         subtitle = "Lansing, Michigan: 2016",
         x = "Temperature (F)",
         y = "Humidity (%)") +
    
    theme(axis.title.x=element_text(size=14, color="orangered2"),
          axis.title.y=element_text(size=14, color="orangered4"),
          plot.title=element_text(size=18, face="bold",
                                  color ="darkblue"),
          plot.subtitle=element_text(size=10, face="bold.italic",
                                     color ="brown", family="serif"));
  plot(plot8);
  
  #### Part 9: Changing component lines ####
  
  
  plot9 = ggplot(data=weatherData) +
    geom_line(mapping=aes(x=1:nrow(weatherData), y=maxTemp),
              color="violetred1") +
    geom_line(mapping=aes(x=1:nrow(weatherData), y=minTemp), 
              color=rgb(red=0.4, green=0.7, blue=0.9)) + 
    
    theme_bw() +
    geom_smooth(mapping=aes(x=1:nrow(weatherData), y=avgTemp),
                method="loess",
                color=rgb(red=1, green=0.5, blue=0),
                linetype=4,
                size=2, 
                fill="lightgreen") +
    labs(title = "Temperature throughout the year",
         subtitle = "Lansing, Michigan: 2016",
         x = "Day (row) number",
         y = "Temperature (F)") +
    theme(axis.ticks = element_line(color="red", size=1),
          panel.grid.minor = element_line(color="grey75", linetype=4),
          panel.grid.major = element_line(color="grey75"));
  plot(plot9);
  
  #### Part 10: Modifying rectangular components ####
  plot10 = ggplot( data=weatherData ) +
    geom_point( mapping=aes(x=avgTemp, y=relHum, color=season, size=precip2)) +
    theme_minimal() +
    labs(title = "Humidity vs. Temperature",
         subtitle = "Lansing, Michigan: 2016",
         x = "Temperature (F)",
         y = "Humidity (%)") +
    theme( axis.text.x=element_text(angle=90, vjust=0.5) ,
           legend.background = element_rect(color="blue", fill="grey90",
                                            size=1),
           panel.background = element_rect(fill="grey10", color="red")); 
  plot(plot10);
  
  #### Part 11: Using rgb() and Unicode ####
  plot11 = ggplot( data=weatherData ) +
    geom_point( mapping=aes(x=avgTemp, y=relHum),
                color=rgb(red=0.7, green=0.5, blue=0),
                size=3,
                shape="\u00A5" ) +  # \u means Unicode number ...
    theme_bw() +
    labs(title = "Humidity vs. Temperature",
         subtitle = "Lansing, Michigan: 2016",
         x = "Temperature (F)",
         y = "Humidity (%)");
  plot(plot11);
}