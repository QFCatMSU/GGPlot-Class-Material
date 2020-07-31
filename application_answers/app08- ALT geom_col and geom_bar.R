{
  source( file="scripts/reference.R" ); 
  library(reshape);
  weatherData = read.csv( file="data/LansingNOAA2016-3.csv", 
                          stringsAsFactors = FALSE );
  
  dates = as.Date(weatherData$dateYr);     # save the date column to a vector
  months = format(dates, format="%b");     # extract the month -- save to vector
  weatherData[,"month"] = months;          # save months to data frame as new column
  
  heatDayList = aggregate(formula=coolDays~month, 
                          data=weatherData, 
                          FUN=sum);
  coolDayList = aggregate(formula=heatDays~month, 
                          data=weatherData, 
                          FUN=sum);
  allDaysList = merge(heatDayList, coolDayList);
  
  # geom_col method
  thePlot = ggplot(allDaysList) +
    geom_col(mapping=aes(x=month, y=heatDays),
             width=0.4,
             fill= "red",
             position=position_nudge(x=-0.2))  +
    geom_col(mapping=aes(x=month, y=coolDays),
             width=0.4,
             fill= "blue",
             position=position_nudge(x=0.2))  +
    scale_x_discrete(limits = month.abb) +
    theme_bw() +
    labs(title = "Heating and Cooling Days",
         subtitle = "Lansing, Michigan: 2016",
         x = "Month",
         y = "Cumulative Heat/Cool Days");
  plot(thePlot);
  
  # geom_bar method
  meltedDF = melt(allDaysList, id="month");

  thePlot = ggplot(data=meltedDF) +
    geom_bar(mapping=aes(x=month, y=value, fill=variable),
             stat="identity",
             width=0.5,
             position=after_stat(position_dodge()))  +
    scale_x_discrete(limits = month.abb) +
    scale_fill_manual(values=c("blue", "red")) +
    theme_bw() +
    labs(title = "Heating and Cooling Days",
         subtitle = "Lansing, Michigan: 2016",
         x = "Month",
         y = "Cumulative Heat/Cool Days");
  plot(thePlot);
}

