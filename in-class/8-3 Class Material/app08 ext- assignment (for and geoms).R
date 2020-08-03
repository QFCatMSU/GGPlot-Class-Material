{
  source( file="scripts/reference.R" ); 
  library(reshape);
  weatherData = read.csv( file="data/LansingNOAA2016-3.csv", 
                          stringsAsFactors = FALSE );
  
  # format the dateYr column as a date with just the abbreviated month (%b)
  months = format.Date(weatherData$dateYr, format="%b");
  weatherData$month = months;      # save months to data frame as new column
  
  ###############################################
  ##### This is the section you will replace ####
  ###############################################
  
  # create the heatDays and CoolDays dataframes
  heatDayList = aggregate(formula=coolDays~month,   # sum up the coolDays
                          data=weatherData,         #  for every month
                          FUN=sum);
  coolDayList = aggregate(formula=heatDays~month,   # sum up the heatDays
                          data=weatherData,         #  for every month
                          FUN=sum);
  
  # merge the two data frame together
  heatCoolByMonth = merge(heatDayList, coolDayList);
  
  # melt the dataframe so it is more GGPlot-friendly
  meltedDF = melt(heatCoolByMonth, id="month");
  
  # Instructions to replace this section:
  #   1) Create three vectors with 12 values each
  #    - one to hold the 12 abbreviated months (Jan, Feb...)
  #    - one to hold the total heatDays for each month
  #    - one to hold the total coolDays for each month
  # 
  #   2) Using for loops (the number of for loops differs based on your strategy...)
  #    - sum up the heatDays and the coolDays for each month
  # 
  #   3) Combine the three vectors into the heatCoolByMonth dataframe
  #    - make sure you name the columns appropriately
  #    
  #   4) Challenge: Create a melted dataframe from the three vectors (there will be 24 rows)
  #    - first column has the 12 months repeated twice
  #    - second column has the value "heatDays" 12 times and "coolDays" 12 times
  #    - third column has the summed vales for heatDays and coolDays based on month 
  #    - call the dataframe meltedDF and name the columns appropriately 
  #
  #   5) Extra: add an unofficial legend to the geom_col() plots using annotate()
  #    - the options for geom are: segment, rect, and text
  
  ###################################
  #### End of section to replace ####
  ###################################
  
  ####
  # Notes: 
  # - geom_col() is functionally equivalent to geom_bar(stat="identity")
  # - with a melted dataframe, you fill one bar with two variable and dodge them
  # - with a regular data frame, you place two bars and nudge them
  
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

