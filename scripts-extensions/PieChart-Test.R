{
  source(file="scripts/reference.R");  # this line will be in all your scripts
  weatherData = read.csv(file="data/LansingNOAA2016-3.csv", 
                         stringsAsFactors = FALSE);

  library(ggplot2)

  # Change values to 10 degree ranges for average temperature
  avgTempRange = floor(weatherData$avgTemp / 10) *10;
  
  # put the values and their count into a table:
  tableTempRange = table(avgTempRange);
  
  # colors -- be nice to make it a gradient (purple -> yellow -> red)
  tempColors = c("purple", "blue", "lightblue", "green", "yellow", 
                 "orange", "orangered", "red", "brown");
  
  # figure out the label positions
  labPos = c();
  for(i in 1:length(tableTempRange))
  {
     labPos[i] = sum(tableTempRange) - sum(tableTempRange[1:i]) + 0.5*tableTempRange[i];
  }
  
  temperatures = paste(names(tableTempRange), "s", sep="");
  # Essentially, you are making 1 vertical stack bar and then changing it
  # to polar coordinates
  plot1 = ggplot() +
    geom_bar(mapping=aes(x="", y = as.numeric(tableTempRange), # as.numeric -- otherwise it treats the numbers as characters
                         fill = temperatures),
             width = 1, 
             stat = "identity", 
             color = "white") +
    coord_polar("y", start = 0) +
    geom_text(mapping = aes(x=1.3, y = labPos, label = as.numeric(tableTempRange)), 
              color = "black")+
    scale_fill_manual(values = tempColors) +
    labs(title="Days with temperatures in the...") +
    theme_void();
  plot(plot1);
}