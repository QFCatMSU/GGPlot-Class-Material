{
  source( file="scripts/reference.R" ); 
  weatherData = read.csv( file="data/LansingNOAA2016-3.csv", 
                          stringsAsFactors = FALSE );
  
  dates = as.Date(weatherData$dateYr);     # save the date column to a vector
  months = format(dates, format="%b");     # extract the month -- save to vector
  weatherData[,"month"] = months;          # save months to data frame as new column
  
  vect = weatherData$weatherType
  
  vect = substr(vect, start = 1, stop = 2)
  
  thePlot = ggplot(data=weatherData) +
    geom_col(mapping=aes(x=month, y=coolDays, fill=vect),
             width=0.6) +
    scale_x_discrete(limits = month.abb) +
    scale_fill_manual(values = c('cyan4', 'blue', 'deepskyblue', 'cyan', 
                                 'deeppink', 'darkorchid', 'chartreuse', 
                                 'aquamarine2')) +
    theme_bw() +
    labs(title = "Cool Days by Month",
         subtitle = "Lansing, Michigan: 2016",
         x = "Month",
         y = "Cool Days");
  plot(thePlot);
  
  thePlot = ggplot(data=weatherData) +
    geom_col(mapping=aes(x=month, y=heatDays, fill=vect),
             width=0.6) +
    scale_x_discrete(limits = month.abb) +
    scale_fill_manual(values = c('cyan4', 'blue', 'deepskyblue', 'cyan', 
                                 'deeppink', 'darkorchid', 'chartreuse', 
                                 'aquamarine2')) +
    theme_bw() +
    geom_hline(mapping = aes( yintercept= sum(coolDays)),
               color= 'red',
               size=2,
               linetype=2) +
    geom_text(x=7, y=900, label="Total Cool Days", color='red') +
    labs(title = "Heat Days by Month",
         subtitle = "Lansing, Michigan: 2016",
         x = "Month",
         y = "Heat Days");
  plot(thePlot);
  
  monthNum = as.numeric(factor(weatherData$month, 
                               levels=unique(weatherData$month)));
  
  thePlot = ggplot(data=weatherData) +
    geom_col(mapping=aes(x=monthNum -0.2, y=heatDays),  
             fill = "red",
             width=0.4) +
    geom_col(mapping=aes(x=monthNum +0.2, y=coolDays),  
             fill = "blue",
             width=0.4) +
    scale_x_discrete(limits = month.abb) +
    theme_bw() +
    labs(title = "Heating and Cooling Days",
         subtitle = "Lansing, Michigan: 2016",
         x = "Month",
         y = "Cumulative Heat/Cool Days");
  plot(thePlot);
}

