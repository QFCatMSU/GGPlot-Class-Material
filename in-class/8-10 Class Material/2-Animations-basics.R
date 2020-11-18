{
  source(file="scripts/reference.R");  # this line will be in all your scripts
  weatherData = read.csv(file="data/LansingNOAA2016-3.csv", 
                         stringsAsFactors = FALSE);

  library(package=gganimate);  # package used to create the animation mappings

  # animation mapping -- using season, a discrete variable
  # closest_state is a "Label variable" (look on cheat sheet)
  plot1 = ggplot(data=weatherData) +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    labs(title = 'Humidity (y) vs. Temperature (x) by {closest_state} (animation)',  
         subtitle = 'Lansing, MI - 2016',
         x = 'Average Temp', 
         y = 'Humidity') +
    theme_bw() +
    transition_states(states=season); # maps season to animation 
  
  # You need to use print() instead of plot() -- 
  # The animation is sent to the Viewer tab
  #print(plot1);  
  
  # Note: animations take a lot of time to process -- you probably want
  #       to do the print() commands in Console or comment out most of them
  
  # Same plot as above with some tweaks to transition_states()
  plot2 = ggplot(data=weatherData) +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    labs(title = 'Humidity (y) vs. Temperature (x) by {closest_state} (animation)',
         subtitle = 'Lansing, MI - 2016',
         x = 'Average Temp', 
         y = 'Humidity') +
    theme_bw() +
    transition_states(states = season,       # season is a column in weatherData
                      transition_length = 1, # relative animation time (default: 1)  
                      state_length = 2,      # relative pause time (default: 1)
                      wrap = TRUE);          # gif always wraps so this is useless
   print(plot2);
}