{
  source(file="scripts/reference.R");  # this line will be in all your scripts
  weatherData = read.csv(file="data/LansingNOAA2016-3.csv", 
                         stringsAsFactors = FALSE);

  library(package=gganimate);
  library(package=av);        # to create mp4 videos

  # create a numeric precipitation column
  precipNum = weatherData$precip;
  precipNum[which(precipNum == "T")] = 0.005;
  weatherData$precipNum = as.numeric(precipNum);
  
  # animation mapping -- using precipNum, a continuous variable
  # frame_time is a "Label variable" (look on cheat sheet)
  plot1 = ggplot(data=weatherData) +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    labs(title = paste('Humidity (y) vs. Temperature (x) by Precipitation (animation)'),
         subtitle = 'Precipitation: {frame_time} inches',
         x = 'Average Temp', 
         y = 'Humidity') +
    theme_bw() +
    shadow_mark(color="gray80") +            # keeps old values
    enter_fly(x_loc=20, y_loc=40) +          # ????
    ease_aes(default = "elastic-in-out") +
    transition_time(time = precipNum,
                    range = c(0.04, 1.5));   # range can be changed to limit the "time"
  print(plot1); 
  

}