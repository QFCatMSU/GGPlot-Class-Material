{
  source(file="scripts/reference.R");  # this line will be in all your scripts
  weatherData = read.csv(file="data/LansingNOAA2016.csv", 
                         stringsAsFactors = FALSE);

  #### Part 1: Plot humidity vs temperature ####
  plotData = ggplot(data=weatherData) +
             geom_point(mapping=aes(x=avgTemp, y=relHum));
  plot(plotData);
  
  #### Part 2: Change to a black and white theme ####
  plotData = ggplot(data=weatherData) +
             geom_point(mapping=aes(x=avgTemp, y=relHum)) +
             theme_bw();    # changes the theme of the whole canvas
  plot(plotData);


  #### Part 3: Styling the points ####
  plotData = ggplot(data=weatherData) +
             geom_point(mapping=aes(x=avgTemp, y=relHum),
                        color="darkgreen", 
                        size=2.5, 
                        shape=17 ) +
             theme_bw();
  plot(plotData);

  #### Extension: Using RGB colors and Unicode characters ####
  # RGB colors use rgb()
  # Unicode is preceded by -
  plotData = ggplot(data=weatherData) +
             geom_point(mapping=aes(x=avgTemp, y=relHum),
                        color=rgb(red=0.8, green=0.4, blue=0), 
                        size=2.5, 
                        shape=-6235 ) +
             theme_bw();
  plot(plotData);

  #### Part 4: Make points semi-transparent ####
  plotData = ggplot(data=weatherData) +
             geom_point(mapping=aes(x=avgTemp, y=relHum),
                        color="darkgreen", 
                        size=2.5, 
                        shape=17, 
                        alpha = 0.4 ) +
             theme_bw();
  plot(plotData);

  #### Part 5: Add labels and titles ####
  plotData = ggplot(data=weatherData) +
             geom_point(mapping=aes(x=avgTemp, y=relHum),
                        color="darkgreen", 
                        size=2.5, 
                        shape=17, 
                        alpha = 0.4 ) +
             theme_bw() +
             labs(title = "Humidity vs. Temperature",
                  subtitle = "Lansing, Michigan: 2016",
                  x = "Temperature (F)",
                  y = "Humidity (%)");
  plot(plotData);

  #### Part 6: Styling the labels ####
  plotData = ggplot(data=weatherData) +
             geom_point(mapping=aes(x=avgTemp, y=relHum),
                        color="darkgreen", 
                        size=2.5, 
                        shape=17, 
                        alpha = 0.4 ) +
             theme_bw() +
             labs(title = "Humidity vs. Temperature",
                  subtitle = "Lansing, Michigan: 2016",
                  x = "Temperature (F)",
                  y = "Humidity (%)") +
             theme(axis.title.x=element_text(size=14, color="orangered2"),
                   axis.title.y=element_text(size=14, color="orangered4"),
                   plot.title=element_text(size=18, face="bold",
                                           color ="darkblue"),
                   plot.subtitle=element_text(size=10, face="bold.italic",
                                              color ="brown", family="serif"));
  plot(plotData);

  #### Trap: changing theme after changing style ####
  # In this example theme_bw() is changed after theme change were made,
  # so it overrides the other theme changes
  plotData = ggplot(data=weatherData) +
             geom_point(mapping=aes(x=avgTemp, y=relHum),
                        color="darkgreen", 
                        size=2.5, 
                        shape=17, 
                        alpha = 0.4 ) +
             labs(title = "Humidity vs. Temperature -- Trap in theme",
                  subtitle = "Lansing, Michigan: 2016",
                  x = "Temperature (F)",
                  y = "Humidity (%)") +
             theme(axis.title.x=element_text(size=14, color="orangered2"),
                   axis.title.y=element_text(size=14, color="orangered4"),
                   plot.title=element_text(size=18, face="bold",
                                           color ="darkblue"),
                   plot.subtitle=element_text(size=10, face="bold.italic",
                                              color ="brown", family="serif")) +
             theme_bw();
  plot(plotData);

  #### Part 7: Add regression line ####
  plotData = ggplot(data=weatherData) +
             geom_point(mapping=aes(x=avgTemp, y=relHum),
                        color="darkgreen", 
                        size=2.5, 
                        shape=17,
                        alpha = 0.4) +
             theme_bw() +
             labs(title = "Humidity vs. Temperature",
                  subtitle = "Lansing, Michigan: 2016",
                  x = "Temperature (F)",
                  y = "Humidity (%)") +
             theme(axis.title.x=element_text(size=14, color="orangered2"),
                   axis.title.y=element_text(size=14, color="orangered4"),
                   plot.title=element_text(size=18, face="bold",
                                           color ="darkblue"),
                   plot.subtitle=element_text(size=10, face="bold.italic",
                                              color ="brown", family="serif")) +
             geom_smooth(mapping=aes(x=avgTemp, y=relHum), 
                         method="lm");
  plot(plotData);

  ####Part 8: Styling the regression line ####
  plotData = ggplot(data=weatherData) +
             geom_point(mapping=aes(x=avgTemp, y=relHum),
                        color="darkgreen", 
                        size=2.5, 
                        shape=17,
                        alpha = 0.4 ) +
             theme_bw() +
             labs(title = "Humidity vs. Temperature",
                  subtitle = "Lansing, Michigan: 2016",
                  x = "Temperature (F)",
                  y = "Humidity (%)") +
             theme(axis.title.x=element_text(size=14, color="orangered2"),
                   axis.title.y=element_text(size=14, color="orangered4"),
                   plot.title=element_text(size=18, face="bold",
                                           color ="darkblue"),
                   plot.subtitle=element_text(size=10, face="bold.italic",
                                              color ="brown", family="serif")) +
             geom_smooth(mapping=aes(x=avgTemp, y=relHum), 
                         method="lm",
                         color="red", 
                         size=0.8, 
                         linetype=4, 
                         fill="lightblue");
  plot(plotData);
}  