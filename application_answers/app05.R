{
  source( file="scripts/reference.R" ); 
  weatherData = read.csv( file="data/LansingNOAA2016-2.csv", 
                          stringsAsFactors = FALSE );
  
  theDate = weatherData[ , "dateYr"];               # save date column to vector
  
  #### Get the index values for each season
  JanFeb = which(theDate < as.Date("03-01-2016", format="%m-%d-%Y"));
  MarApr = which(theDate >= as.Date("03-01-2016", format="%m-%d-%Y") &
                 theDate < as.Date("05-01-2016", format="%m-%d-%Y"));
  MayJun = which(theDate >= as.Date("05-01-2016", format="%m-%d-%Y") &
                 theDate < as.Date("07-01-2016", format="%m-%d-%Y"));
  JulAug = which(theDate >= as.Date("07-01-2016", format="%m-%d-%Y") &
                 theDate < as.Date("09-01-2016", format="%m-%d-%Y"));
  SepOct = which(theDate >= as.Date("09-01-2016", format="%m-%d-%Y") &
                 theDate < as.Date("11-01-2016", format="%m-%d-%Y"));
  NovDec = which(theDate >= as.Date("11-01-2016", format="%m-%d-%Y"));

  #### Create a biMonth column in weatherData
  weatherData[, "biMonth"] = "";     # create a new column called season
  
  # set the values in the new column to one of the biMonths
  weatherData[JanFeb, "biMonth"] = "JanFeb";  
  weatherData[MarApr, "biMonth"] = "MarApr";  
  weatherData[MayJun, "biMonth"] = "MayJun";  
  weatherData[JulAug, "biMonth"] = "JulAug";  
  weatherData[SepOct, "biMonth"] = "SepOct";  
  weatherData[NovDec, "biMonth"] = "NovDec";  
  
  plotData = ggplot( data=weatherData ) +
    geom_histogram(mapping=aes(x=relHum, y=..count..),
                   bins=40,
                   color="grey20",
                   fill="darkblue") +
    theme_classic() +
    labs(title = "Relative humidity histogram",
         subtitle = "Lansing, Michigan: 2016",
         x = "Average Humidity (%)",
         y = "Count");
  plot(plotData);

  # create a factor for biMonth column so that they are plotted in order or month
  # as opposed to alphabetical order (this is only need for the facet, not
  # for the stacked histogram) -- this is not in the lesson but will be added
  # at some point
  weatherData$biMonth = factor(weatherData$biMonth,
                               levels = c("JanFeb","MarApr","MayJun",
                                          "JulAug","SepOct","NovDec"));
  
  plotData = ggplot( data=weatherData ) +
    geom_histogram(mapping=aes(x=relHum, y=..count..),
                   bins=40,
                   color="grey20",
                   fill="darkblue") +
    theme_classic() +
    facet_grid( facet= biMonth ~ .) +
    labs(title = "Relative humidity histogram",
         subtitle = "Lansing, Michigan: 2016",
         x = "Average Humidity (%)",
         y = "Count");
  plot(plotData);

  plotData = ggplot( data=weatherData ) +
    geom_histogram(mapping=aes(x=relHum, y=..count.., fill=biMonth),
                   bins=40, color="grey20", position="stack") +
    theme_classic() +
    theme(legend.position=c(x=0.10, y=0.70)) +
    geom_vline(mapping=aes(xintercept=mean(weatherData[JanFeb, "relHum"])),
               color="lightblue",
               size=0.7) +
    geom_vline(mapping=aes(xintercept=mean(weatherData[JulAug, "relHum"])),
               color="red",
               size=0.7) +
    labs(title = "Relative humidity histogram",
         subtitle = "Lansing, Michigan: 2016",
         x = "Average Humidity (%)",
         y = "Count");
  plot(plotData);
}