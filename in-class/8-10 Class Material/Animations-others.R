{
  source(file="scripts/reference.R");  # this line will be in all your scripts
  weatherData = read.csv(file="data/LansingNOAA2016-3.csv", 
                         stringsAsFactors = FALSE);

  library(gganimate);
  
  precipNum = weatherData$precip
  precipNum[which(precipNum == "T")] = 0.005;
  precipNum = as.numeric(precipNum);
  
  # boxplot - discrete (does cont make any sense?)
  plot1 = ggplot(data=weatherData) +
    geom_boxplot(mapping=aes(x=avgTemp, y=windDir)) +
    labs(title = 'Temperature vs. Wind Direction in {closest_state}',
         subtitle = 'Lansing, MI - 2016',
         x = 'Average Temp', 
         y = 'Humidity') +
    theme_bw() +
    transition_states(states=season,
                      transition_length = 1,
                      state_length = 2,
                      wrap = TRUE);
  
  # histogram - discrete
  plot1 = ggplot(data=weatherData) +
    geom_histogram(mapping=aes(x=avgTemp)) +
    labs(title = 'Temperature vs. Wind Direction in {closest_state}',
         subtitle = 'Lansing, MI - 2016',
         x = 'Average Temp', 
         y = 'Humidity') +
    theme_bw() +
    transition_states(states=season,
                      transition_length = 1,
                      state_length = 2,
                      wrap = TRUE);
#  print(plot1);   # needs to be print() not plot() -- goes to Viewer
  

  # barplot - discrete
  plot5 = ggplot(data=weatherData) +
    geom_col(mapping=aes(x=windSpeedLevel, y=precipNum)) +
    labs(title = 'Temperature vs. Wind Direction in {closest_state}',
         subtitle = 'Lansing, MI - 2016',
         x = 'Average Temp', 
         y = 'Humidity') +
    theme_bw() +
    transition_states(states=season,
                      transition_length = 1,
                      state_length = 2,
                      wrap = TRUE);
# print(plot3);   # needs to be print() not plot() -- goes to Viewer

}