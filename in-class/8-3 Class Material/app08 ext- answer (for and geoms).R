{
  source( file="scripts/reference.R" ); 
  library(reshape);
  weatherData = read.csv( file="data/LansingNOAA2016-3.csv", 
                          stringsAsFactors = FALSE );
  
  # format the dateYr column as a date with just the abbreviated month (%b)
  months = format.Date(weatherData$dateYr, format="%b");
  weatherData$month = months;      # save months to data frame as new column
  
  # 3 vectors we need: months, sum of heatDays, sum of coolDays
  month_unique = unique(months);  # could also use month.abb
  heatDays = rep(0, times=12);              
  coolDays = rep(0, times=12);
  
  # sum up the heatDays and coolDays for each month
  for(i in 1:nrow(weatherData))       # for each day (row)
  {
    for(j in 1:length(month_unique))  # for each month
    {
      # check if the month on the row is the same and the indexed month
      if(weatherData$month[i] == month_unique[j])
      {
        # add the day's value to the total value
        heatDays[j] = heatDays[j] + weatherData$heatDays[i]; 
        coolDays[j] = coolDays[j] + weatherData$coolDays[i]; 
        break;  # break out of the for loop (don't need to check other months)
      }
    }
  }
  
  ## create the data frames
  
  # 3 columns: month, total heatdays, total cooldays
  heatCoolByMonth = data.frame("month" = month_unique, heatDays, coolDays);
  # melted df, 3 columns: month, heatdays/cooldays factor, total value
  meltedDF = data.frame("month" = c(month_unique, month_unique),
                        "variable" = c(rep("heatDays",12), rep("coolDays", 12)),
                        "value" = c(heatDays, coolDays));
  
  #### Four different plots -- same output
  # 1) geom_col() with regular data frame
  # 2) geom_col() with melted data frame
  # 3) geom_bar() with regular data frame
  # 4) geom_bar() with melted data frame
  
  # geom_col method -- unmelted dataframe
  thePlot = ggplot(heatCoolByMonth) +
    # plot the two column separately, nudge them so they are not stacked
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
         subtitle = "geom_col() -- unmelted dataframe",
         x = "Month",
         y = "Cumulative Heat/Cool Days");
  plot(thePlot);
  
  # geom_col method -- melted dataframe
  thePlot = ggplot(meltedDF) +
    # plot values and fill with variable, use dodge so they do not stack 
    geom_col(mapping=aes(x=month, y=value, fill=variable),
             width=0.4,
             position=position_dodge())  +
    scale_x_discrete(limits = month.abb) +
    theme_bw() +
    labs(title = "Heating and Cooling Days",
         subtitle = "geom_col() -- melted dataframe",
         x = "Month",
         y = "Cumulative Heat/Cool Days");
  plot(thePlot);
  
  # geom_bar method -- unmelted dataframe
  thePlot = ggplot(data=heatCoolByMonth) +
    geom_bar(mapping=aes(x=month, y=heatDays),
             stat="identity",  # without this, geom_bar does a count 
             width=0.4, 
             fill="red",
             position = position_nudge(x=0.2)) + 
    geom_bar(mapping=aes(x=month, y=coolDays),
             stat="identity", 
             width=0.4, 
             fill="blue",
             position = position_nudge(x=-0.2)) +  
    scale_x_discrete(limits = month.abb) +
    scale_fill_manual(values=c("red", "blue")) +
    theme_bw() +
    labs(title = "Heating and Cooling Days",
         subtitle = "geom_bar() -- unmelted dataframe",
         x = "Month",
         y = "Cumulative Heat/Cool Days");
  plot(thePlot);
  
  # geom_bar method -- melted dataframe
  thePlot = ggplot(data=meltedDF) +
    geom_bar(mapping=aes(x=month, y=value, fill=variable),
             stat="identity",  # without this, it will do a count (on X or Y)
             width=0.5, 
             position=position_dodge()) + # without this, it will stack
    scale_x_discrete(limits = month.abb) +
    scale_fill_manual(values=c("red", "blue")) +
    theme_bw() +
    labs(title = "Heating and Cooling Days",
         subtitle = "geom_bar() -- melted dataframe",
         x = "Month",
         y = "Cumulative Heat/Cool Days");
  plot(thePlot);
}

