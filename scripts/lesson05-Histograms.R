{
  source( file="scripts/reference.R" ); 
  weatherData = read.csv( file="data/LansingNOAA2016.csv", 
                          stringsAsFactors = FALSE );
  
  #### Part 1: Add year to date vector and save back to data frame
  theDate = weatherData$date;                     # save date column to vector
  theDate = paste(theDate, "-2016", sep="");      # append -2016 to vector
  theDate = as.Date(theDate, format="%m-%d-%Y");  # format vector as Date
  weatherData$dateYr = theDate;                   # save vector to Data Frame
  
  #### Part 2: Get the index values for each season
  springIndex = which(theDate > as.Date("03-21-2016", format="%m-%d-%Y") &
                      theDate <= as.Date("06-21-2016", format="%m-%d-%Y"));
  
  summerIndex = which(theDate > as.Date("06-21-2016", format="%m-%d-%Y") &
                      theDate <= as.Date("09-21-2016", format="%m-%d-%Y"));
  
  fallIndex = which(theDate > as.Date("09-21-2016", format="%m-%d-%Y") &
                    theDate <= as.Date("12-21-2016", format="%m-%d-%Y"));
  
  ## Using an OR ( | ) condition for winter dates
  winterIndex = which(theDate > as.Date("12-21-2016", format="%m-%d-%Y") |
                      theDate <= as.Date("03-21-2016", format="%m-%d-%Y"));
  
  #### Part 3: Create a season column in weatherData
  weatherData$season = "";     # create a new column called season
  
  # set the values in the new column to one of the seasons
  weatherData$season[springIndex] = "Spring";  # set index 82-173 to spring 
  weatherData$season[summerIndex] = "Summer";  # set index 174-265 to summer
  weatherData$season[fallIndex] = "Fall";      # set index 266-356 to fall
  weatherData$season[winterIndex] = "Winter";  # set 1-81, 357-366 to winter
  
  #### Part 4: Create a histogram of temperatures for the year
  plotData = ggplot( data=weatherData ) +
    geom_histogram( mapping=aes(x=avgTemp, y=..count..) );
  plot(plotData);

  #### Part 5: Parameter changes to the histogram
  plotData = ggplot( data=weatherData ) +
    geom_histogram( mapping=aes(x=avgTemp, y=..count..),
                    bins=40, 
                    color="grey20", 
                    fill="darkblue");
  plot(plotData);

  #### Part 6: Change theme, add titles and labels
  plotData = ggplot( data=weatherData ) +
    geom_histogram(mapping=aes(x=avgTemp, y=..count..),
                   bins=40, 
                   color="grey20", 
                   fill="darkblue") +
    theme_classic() +
    labs(title = "Temperature Histogram",
         subtitle = "Lansing, Michigan: 2016",
         x = "Average Temp (Fahrenheit)",
         y = "Count");
  plot(plotData);

  #### Part 7: Using binwidths and density
  plotData = ggplot( data=weatherData ) +
    geom_histogram(mapping=aes(x=avgTemp, y=..density..),
                   binwidth=4, 
                   color="grey20", 
                   fill="darkblue") +
    theme_classic() +
    labs(title = "Temperature Histogram",
         subtitle = "Lansing, Michigan: 2016",
         x = "Average Temp (Fahrenheit)",
         y = "Density");
  plot(plotData);

  #### Part 8: Add vertical lines representing mean and median
  plotData = ggplot( data=weatherData ) +
    geom_histogram(mapping=aes(x=avgTemp, y=..density..),
                   binwidth=4, 
                   color="grey20", 
                   fill="darkblue") +
    geom_vline(mapping=aes(xintercept=mean(avgTemp)),
               color="red", 
               size=1.2) +
    geom_vline(mapping=aes(xintercept=median(avgTemp)),
               color="green", 
               size=1.2) +
    theme_classic() +
    labs(title = "Temperature Histogram",
         subtitle = "Lansing, Michigan: 2016",
         x = "Average Temp (Fahrenheit)",
         y = "Density");
  plot(plotData);

  #### Part 9: Create a histogram for each season (faceting)
  plotData = ggplot( data=weatherData ) +
    geom_histogram(mapping=aes(x=avgTemp, y=..count..),
                   bins=40, 
                   color="grey20", 
                   fill="darkblue") +
    theme_classic() +
    facet_grid( facet= season ~ .) +
    labs(title = "Temperature Histogram",
         subtitle = "Lansing, Michigan: 2016",
         x = "Average Temp (Fahrenheit)",
         y = "Count");
  plot(plotData);

  #### Part 10: Create a stacked histogram for each season
  plotData = ggplot( data=weatherData ) +
    geom_histogram(mapping=aes(x=avgTemp, y=..count.., fill=season),
                   bins=40, 
                   color="grey20", 
                   position="stack") +
    theme_classic() +
    labs(title = "Temperature Histogram",
         subtitle = "Lansing, Michigan: 2016",
         x = "Average Temp (Fahrenheit)",
         y = "Count");
  plot(plotData);

  #### Part 11: Remove legend
  plotData = ggplot( data=weatherData ) +
    geom_histogram(mapping=aes(x=avgTemp, y=..count.., fill=season),
                   bins=40,
                   color="grey20",
                   position="stack") +
    theme_classic() +
    theme(legend.position="none") +
    labs(title = "Temperature Histogram",
         subtitle = "Lansing, Michigan: 2016",
         x = "Average Temp (Fahrenheit)",
         y = "Count");
  plot(plotData);

  #### Part 12: Reposition legend
  plotData = ggplot( data=weatherData ) +
    geom_histogram(mapping=aes(x=avgTemp, y=..count.., fill=season),
                   bins=40, 
                   color="grey20", 
                   position="stack") +
    theme_classic() +
    theme(legend.position=c(x=0.15, y=0.75)) +
    labs(title = "Temperature Histogram",
         subtitle = "Lansing, Michigan: 2016",
         x = "Average Temp (Fahrenheit)",
         y = "Count");
  plot(plotData);

  #### End of Code: Save the modified data frame to a new CSV file
  write.csv(weatherData, file="data/LansingNOAA2016-2.csv");
}