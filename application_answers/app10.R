{
  source( file="scripts/reference.R" ); 
  weatherData = read.csv( file="data/LansingNOAA2016-3.csv", 
                          stringsAsFactors = FALSE );

  # Using grep to find days with a specific weather event
  snowDays = grep(weatherData$weatherType, pattern="RA");  # any day with snow
  tsDays = grep(weatherData$weatherType, pattern="TS");    # any day with thunderstorms
  fogDays = grep(weatherData$weatherType, pattern="FG");   # any day with fog
  
  # calculate average tempDept for the condition
  snowAve = mean(weatherData[snowDays,]$tempDept);
  tsAve = mean(weatherData[tsDays,]$tempDept);
  fogAve = mean(weatherData[fogDays,]$tempDept);
  
  # histogram of snowy days
  hist1 = ggplot( data=weatherData[snowDays,]) + 
    geom_histogram( mapping=aes(x=tempDept, y=..count..),
                    bins=40,
                    color="grey20",
                    fill="darkblue") +
    theme_classic() +
    geom_vline(mapping=aes(xintercept=median(snowAve)),
               color="red",
               size=1) +
    geom_text(x=-5, y=8, label="Average tempDept = 5.01", color='red') +
    labs(title = "TempDept for Snowy Days",
         subtitle = "Lansing, Michigan: 2016",
         x = "Temperature Departure",
         y = "Frequency");
  plot(hist1);
  
  # histogram of days of thunderstorms
  hist2 = ggplot( data=weatherData[tsDays,]) + 
    geom_histogram( mapping=aes(x=tempDept, y=..count..),
                    bins=40,
                    color="grey20",
                    fill="darkblue") +
    theme_classic() +
    geom_vline(mapping=aes(xintercept=median(tsAve)),
               color="red",
               size=1) +
    geom_text(x=-1, y=5, label="Average tempDept = 7.43", color='red') +
    labs(title = "TempDept for Thunderstorm Days",
         subtitle = "Lansing, Michigan: 2016",
         x = "Temperature Departure",
         y = "Frequency");
  plot(hist2);
  
  # histogram of foggy days
  hist3 = ggplot( data=weatherData[fogDays,]) + 
    geom_histogram( mapping=aes(x=tempDept, y=..count..),
                    bins=40,
                    color="grey20",
                    fill="darkblue") +
    theme_classic() +
    geom_vline(mapping=aes(xintercept=median(fogAve)),
               color="red",
               size=1) +
    geom_text(x=-10, y=3, label="Average tempDept = 2.58", color='red') +
    labs(title = "TempDept for Foggy Days",
         subtitle = "Lansing, Michigan: 2016",
         x = "Temperature Departure",
         y = "Frequency");
  plot(hist3);
  
  #Combine event using set operations (have a setdiff() ??)
  snowAndThunderstorms = intersect(snowDays, tsDays); # days with snow AND thunderstorms
  snowOrFog = union(snowDays, fogDays);      # days with snow OR fog
  
  # calculate average tempDept for the condition
  snowAndTSAve = mean(weatherData[snowAndThunderstorms,]$tempDept);
  snowOrFogAve = mean(weatherData[snowOrFog,]$tempDept);
  
  # histogram of snow and thunderstorms
  hist4 = ggplot( data=weatherData[snowAndThunderstorms,]) + 
    geom_histogram( mapping=aes(x=tempDept, y=..count..),
                    bins=40,
                    color="grey20",
                    fill="darkblue") +
    theme_classic() +
    geom_vline(mapping=aes(xintercept=median(snowAndTSAve)),
               color="red",
               size=1) +
    geom_text(x=-2, y=4.5, label="Average tempDept = 7.45", color='red') +
    labs(title = "TempDept for Snow and TS Days",
         subtitle = "Lansing, Michigan: 2016",
         x = "Temperature Departure",
         y = "Frequency");
  plot(hist4);
  
  # histogram of snow or fog
  hist5 = ggplot( data=weatherData[snowOrFog,]) + 
    geom_histogram( mapping=aes(x=tempDept, y=..count..),
                    bins=40,
                    color="grey20",
                    fill="darkblue") +
    theme_classic() +
    geom_vline(mapping=aes(xintercept=median(snowOrFogAve)),
               color="red",
               size=1) +
    geom_text(x=-2, y=4.5, label="Average tempDept = 4.25", color='red') +
    labs(title = "TempDept for Snow or Foggy Days",
         subtitle = "Lansing, Michigan: 2016",
         x = "Temperature Departure",
         y = "Frequency");
  plot(hist5);
  
  # put 5 plots on one canvas with 2 of the plots taking up more than one cell
  grid.arrange(hist1, hist2, hist3, hist4, hist5,
               layout_matrix = rbind(c(1,1,5,5),
                                     c(1,1,NA,NA),
                                     c(4,4,2,2),
                                     c(4,4,3,3)));
}