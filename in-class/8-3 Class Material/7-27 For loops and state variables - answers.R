{
  source(file="scripts/reference.R");  
  weatherData = read.csv(file="data/LansingNOAA2016-3.csv", 
                         stringsAsFactors = FALSE);
 
  ### Replace "T" in precip column with 0.005 using gsub()
  weatherData$precip2 = gsub(x=weatherData$precip, 
                             pattern="T", 
                             replacement="0.005");
  
  ### Probably want the column to be numeric...
  weatherData$precip3 = as.numeric(gsub(x=weatherData$precip, 
                             pattern="T", 
                             replacement="0.005"));
  
  # ### Plot humidity vs. precip2 (precip2 is string value -- this will cause problems!) 
  # thePlot = ggplot(data=weatherData) +
  #   geom_point(mapping=aes(x=relHum, y=precip2)) +
  #   theme_bw() +
  #   labs(title = "Relative Humidity vs. Precipitation",
  #        subtitle = "Lansing, Michigan: 2016",
  #        x = "Humidity",
  #        y = "Precipitation (string/character/factor/categorical values)");
  # plot(thePlot);
  # 
  # 
  # ### Plot humidity vs. precip3 (much better)  
  # thePlot = ggplot(data=weatherData) +
  #   geom_point(mapping=aes(x=relHum, y=precip3)) +
  #   theme_bw() +
  #   labs(title = "Relative Humidity vs. Precipitation",
  #        subtitle = "Lansing, Michigan: 2016",
  #        x = "Humidity",
  #        y = "Precipitation (numeric values)");
  # plot(thePlot);

  # Find which month has the most rain (take one)
  precipEachMonth = c(rep(0,12));   # repeat zero 12 times, so c(0,0,0,0,0,0,0,0,0,0,0,0)
  
  for(i in 1:length(weatherData$precip3))  # go through each rwo (day)
  {
    # check each month and add the precip to the correct month
    if(grepl(x=weatherData$date[i], pattern="01-")) 
    {
      precipEachMonth[1] = precipEachMonth[1] + weatherData$precip3[i];
    }
    else if(grepl(x=weatherData$date[i], pattern="02-")) 
    {
      precipEachMonth[2] = precipEachMonth[2] + weatherData$precip3[i]; 
    }
    else if(grepl(x=weatherData$date[i], pattern="03-")) 
    {
      precipEachMonth[3] = precipEachMonth[3] + weatherData$precip3[i]; 
    }
    else if(grepl(x=weatherData$date[i], pattern="04-")) 
    {
      precipEachMonth[4] = precipEachMonth[4] + weatherData$precip3[i]; 
    }
    else if(grepl(x=weatherData$date[i], pattern="05-")) 
    {
      precipEachMonth[5] = precipEachMonth[5] + weatherData$precip3[i]; 
    }
    else if(grepl(x=weatherData$date[i], pattern="06-")) 
    {
      precipEachMonth[6] = precipEachMonth[6] + weatherData$precip3[i]; 
    }
    else if(grepl(x=weatherData$date[i], pattern="07-")) 
    {
      precipEachMonth[7] = precipEachMonth[7] + weatherData$precip3[i]; 
    }
    else if(grepl(x=weatherData$date[i], pattern="08-")) 
    {
      precipEachMonth[8] = precipEachMonth[8] + weatherData$precip3[i]; 
    }
    else if(grepl(x=weatherData$date[i], pattern="09-")) 
    {
      precipEachMonth[9] = precipEachMonth[9] + weatherData$precip3[i]; 
    }
    else if(grepl(x=weatherData$date[i], pattern="10-")) 
    {
      precipEachMonth[10] = precipEachMonth[10] + weatherData$precip3[i]; 
    }
    else if(grepl(x=weatherData$date[i], pattern="11-")) 
    {
      precipEachMonth[11] = precipEachMonth[11] + weatherData$precip3[i]; 
    }
    else if(grepl(x=weatherData$date[i], pattern="12-")) 
    {
      precipEachMonth[12] = precipEachMonth[12] + weatherData$precip3[i]; 
    }
  }
  cat("\nTake 1: Month with most rain is month:", which.max(precipEachMonth),
      "\n        Amount of rain that month was:", max(precipEachMonth));
  
  ### Take 2: Replace the if-else with a for loop
  precipEachMonth2 = c(rep(0,12));
  # need to put the month patterns in a vectors
  month = c("01-", "02-", "03-", "04-", "05-", "06-",
            "07-", "08-", "09-", "10-", "11-", "12-");
  
  for(i in 1:length(weatherData$precip3))   # go through each row
  {
    for(j in 1:length(month))               # go through each month
    {
      # if its the correct month -- add the value
      if(grepl(x=weatherData$date[i], pattern=month[j])) 
      {
        precipEachMonth2[j] = precipEachMonth2[j] + weatherData$precip3[i];
        break;   # saves processing time but you can take it out
      }
    }
  }
  cat("\nTake 2: Month with most rain is month:", which.max(precipEachMonth2),
      "\n        Amount of rain that month was:", max(precipEachMonth2));
  
  
  ### Take 3: Replace the month pattern vector
  precipEachMonth3 = c(rep(0,12));

  for(i in 1:length(weatherData$precip3))
  {
    for(j in 1:12)
    {
      twoDigitMonth = formatC(j, width=2, flag="0");        # 01, 02...
      if(grepl(x=weatherData$date[i], 
               pattern=paste(twoDigitMonth, "-", sep="")))  # 01-, 02-, ...
      {
        precipEachMonth3[j] = precipEachMonth3[j] + weatherData$precip3[i];
        break;  
      }
    }
  }
  cat("\nTake 3: Month with most rain is month:", which.max(precipEachMonth3),
      "\n        Amount of rain that month was:", max(precipEachMonth3));
}  