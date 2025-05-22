{
  rm(list=ls());                         # clear Environment tab
  options(show.error.locations = TRUE);  # show line numbers on error
  library(package=ggplot2);              # get the GGPlot package
  
  source(file="scripts/ggplot_theming.r"); # themes defined in another script
  
  # read in CSV file and save the content to weatherData
  weatherData = read.csv(file="data/Lansing2016NOAA.csv", 
                         stringsAsFactors = FALSE);  
  
  #### Part 1: From last lesson ###
  plot1 = ggplot(data=weatherData) +
    geom_line(mapping=aes(x=1:nrow(weatherData), y=maxTemp),
              color="violetred1") +
    geom_line(mapping=aes(x=1:nrow(weatherData), y=minTemp),
              color=rgb(red=0.4, green=0.7, blue=0.9)) +
    geom_smooth(mapping=aes(x=1:nrow(weatherData), y=avgTemp),
                method="loess",
                color=rgb(red=1, green=0.5, blue=0), # orange
                linetype=4,
                linewidth=2,
                fill="lightgreen") +
    theme_bw() +
    labs(title = "Temperature throughout the year",
         subtitle = "Lansing, Michigan: 2016",
         x = "Day (row) number",
         y = "Temperature (F)");
  plot(plot1);
  
  #### Part 1: Add year to date values ####
  # a) save the date vector from the data frame to the variable theDate
  theDate1 = weatherData$date; 
  # theDate1 = weatherData[["date"]];  # equivalent to previous line
  # theDate1 = weatherData[ , "date"]; # equivalent to previous 2 lines in base R not equivalent in TidyVerse
  
  # b) need a year in the date before formatting--
  #    append (paste) "-2016" to all values in theDate
  theDate2 = paste(theDate1, "-2016", sep="");
  # theDate2 = paste(theDate1, "2016", sep="-"); # functionally equivalent to previous line
  # theDate2 = paste(theDate1, "16", sep="-20"); # also equivalent 
  
  # c) Save the values in Date format
  theDate3 = as.Date(theDate2, format="%m-%d-%Y");

  # d) Save theDate back to the data frame as a new column
  weatherData$dateYr = theDate3;  
  # weatherData[["dateYr"]] = theDate3;  # equivalent to previous line
  # weatherData[, "dateYr"] = theDate3;  # equivalent to previous 2 lines

  #### Part 2: Use Dates on x-axis ###
  plot2 = ggplot(data=weatherData) +
    geom_line(mapping=aes(x=dateYr, y=maxTemp),
              color="violetred1") +
    geom_line(mapping=aes(x=dateYr, y=minTemp),
              color=rgb(red=0.4, green=0.7, blue=0.9)) +
    geom_smooth(mapping=aes(x=dateYr, y=avgTemp),
                method="loess",
                color=rgb(red=1, green=0.5, blue=0), # orange
                linetype=4,
                linewidth=2,
                fill="lightgreen") +
    theme_bw() +
    labs(title = "Temperature throughout the year",
         subtitle = "Lansing, Michigan: 2016",
         x = "Day (row) number",
         y = "Temperature (F)");
  plot(plot2);
  
  #### Part 3: Move x to canvas --
  ###   only works because EVERY geom uses dateYr
  plot3= ggplot(data=weatherData, mapping=aes(x=dateYr)) +  # x mapping here
    geom_line(mapping=aes(y=maxTemp),   # no x-mapping here
              color="violetred1") +
    geom_line(mapping=aes(y=minTemp),   # no x-mapping here
              color=rgb(red=0.4, green=0.7, blue=0.9)) +
    geom_smooth(mapping=aes(y=avgTemp), # no x-mapping here
                method="loess",
                color=rgb(red=1, green=0.5, blue=0), # orange
                linetype=4,
                linewidth=2,
                fill="lightgreen") +
    theme_bw() +
    labs(title = "Temperature throughout the year",
         subtitle = "Lansing, Michigan: 2016",
         x = "Day (row) number",
         y = "Temperature (F)");
  plot(plot3);

  #### Part 4: Convert date format and date breaks
  plot4= ggplot(data=weatherData, mapping=aes(x=dateYr)) +
    geom_line(mapping=aes(y=maxTemp),
              color="violetred1") +
    geom_line(mapping=aes(y=minTemp),
              color=rgb(red=0.4, green=0.7, blue=0.9)) +
    geom_smooth(mapping=aes(y=avgTemp),
                method="loess",
                color=rgb(red=1, green=0.5, blue=0), # orange
                linetype=4,
                linewidth=2,
                fill="lightgreen") +
    scale_x_date(date_breaks = "5 weeks",
                 date_labels =  "%m/%d") +
    theme_bw() +
    labs(title = "Temperature throughout the year",
         subtitle = "Lansing, Michigan: 2016",
         x = "Day (row) number",
         y = "Temperature (F)");
  plot(plot4);

  #### Part 5: Add theme component
  plot5= ggplot(data=weatherData, mapping=aes(x=dateYr)) +
    geom_line(mapping=aes(y=maxTemp),
              color="violetred1") +
    geom_line(mapping=aes(y=minTemp),
              color=rgb(red=0.4, green=0.7, blue=0.9)) +
    geom_smooth(mapping=aes(y=avgTemp),
                method="loess",
                color=rgb(red=1, green=0.5, blue=0), # orange
                linetype=4,
                linewidth=2,
                fill="lightgreen") +
    scale_x_date(date_breaks = "5 weeks",
                 date_labels =  "%m/%d") +
    theme_bw() +
    theme(panel.background = element_rect(fill="grey25",
                                          linewidth=2, color="grey0"),
          panel.grid.minor = element_line(color="grey50", linetype=4),
          panel.grid.major = element_line(color="grey100"),
          plot.background = element_rect(fill = "lightgreen"),
          plot.title = element_text(hjust = 0.45),
          plot.subtitle = element_text(hjust = 0.42),
          axis.text = element_text(color="blue", family="mono", size=9)) +
    labs(title = "Temperature throughout the year",
         subtitle = "Lansing, Michigan: 2016",
         x = "Day (row) number",
         y = "Temperature (F)");
  plot(plot5);
  
  #### Part 6: Use a theme saved elsewhere
  plot6= ggplot(data=weatherData, mapping=aes(x=dateYr)) +
    geom_line(mapping=aes(y=maxTemp),
              color="violetred1") +
    geom_line(mapping=aes(y=minTemp),
              color=rgb(red=0.4, green=0.7, blue=0.9)) +
    geom_smooth(mapping=aes(y=avgTemp),
                method="loess",
                color=rgb(red=1, green=0.5, blue=0), # orange
                linetype=4,
                linewidth=2,
                fill="lightgreen") +
    scale_x_date(date_breaks = "5 weeks",
                 date_labels =  "%m/%d") +
    theme_ugly() +
    labs(title = "Temperature throughout the year",
         subtitle = "Lansing, Michigan: 2016",
         x = "Day (row) number",
         y = "Temperature (F)");
  plot(plot6);
  
  #### Part 7: Include geom defaults in theme 
  modifyGeoms();   # function that changes the geoms
  
  plot7= ggplot(data=weatherData, mapping=aes(x=dateYr)) +
    geom_line(mapping=aes(y=maxTemp)) +
    geom_line(mapping=aes(y=minTemp)) +
    geom_smooth(mapping=aes(y=avgTemp),
                method="loess") +
    scale_x_date(date_breaks = "5 weeks",
                 date_labels = "%m/%d") +
    theme_ugly() +
    labs(title = "Temperature throughout the year",
         subtitle = "Lansing, Michigan: 2016",
         x = "Day (row) number",
         y = "Temperature (F)");
  plot(plot7);
 
  #### Part 8: The defaults in GGPlot have been changed and will persist
  plot8= ggplot(data=weatherData, mapping=aes(x=dateYr)) +
    geom_line(mapping=aes(y=maxTemp)) +
    geom_line(mapping=aes(y=minTemp)) +
    geom_smooth(mapping=aes(y=avgTemp),
                method="loess") +
    scale_x_date(date_breaks = "5 weeks",
                 date_labels =  "%m/%d") +
    labs(title = "Temperature throughout the year",
         subtitle = "Lansing, Michigan: 2016",
         x = "Day (row) number",
         y = "Temperature (F)");
  plot(plot8); 
  
  #### Part 9: Until you remove/reload GGPlot (or restart R) 
  detach("package:ggplot2", unload = TRUE);   # remove ggplot package from session
  library(package="ggplot2");                 # reload package ggplot
  
  plot9= ggplot(data=weatherData, mapping=aes(x=dateYr)) +
    geom_line(mapping=aes(y=maxTemp)) +
    geom_line(mapping=aes(y=minTemp)) +
    geom_smooth(mapping=aes(y=avgTemp),
                method="loess") +
    scale_x_date(date_breaks = "5 weeks",
                 date_labels =  "%m/%d") +
    labs(title = "Temperature throughout the year",
         subtitle = "Lansing, Michigan: 2016",
         x = "Day (row) number",
         y = "Temperature (F)");
  plot(plot9); 
}  