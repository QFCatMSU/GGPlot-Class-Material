{
  source(file="scripts/reference.R");  # this line will be in all your scripts
  weatherData = read.csv(file="data/LansingNOAA2016.csv", 
                         stringsAsFactors = FALSE);

  #### Part 1: Plot humidity vs temperature ####
  plot1 = ggplot(data=weatherData) +
          geom_point(mapping=aes(x=avgTemp, y=relHum));
  plot(plot1);
  
  #### Part 2: Change to a black and white theme ####
  plot2 = ggplot(data=weatherData) +
          geom_point(mapping=aes(x=avgTemp, y=relHum)) +
          theme_bw();    # changes the theme of the whole canvas
  plot(plot2);


  #### Part 3: Styling the points ####
  plot3 = ggplot(data=weatherData) +
          geom_point(mapping=aes(x=avgTemp, y=relHum),
                     color="darkgreen", 
                     size=2.5, 
                     shape=17 ) +
          theme_bw();
  plot(plot3);

  #### Extension: Using RGB colors and Unicode characters ####
  # RGB colors use rgb()
  # Unicode is preceded by -
  plot3b = ggplot(data=weatherData) +
           geom_point(mapping=aes(x=avgTemp, y=relHum),
                      color=rgb(red=0.8, green=0.4, blue=0), 
                      size=2.5, 
                      shape=-6235 ) +
           theme_bw();
  plot(plot3b);

  #### Part 4: Make points semi-transparent ####
  plot4 = ggplot(data=weatherData) +
         geom_point(mapping=aes(x=avgTemp, y=relHum),
                    color="darkgreen", 
                    size=2.5, 
                    shape=17, 
                    alpha = 0.4 ) +
         theme_bw();
  plot(plot4);

  #### Part 5: Add labels and titles ####
  plot5 = ggplot(data=weatherData) +
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
  plot(plot5);

  #### Part 6: Styling the labels ####
  plot6 = ggplot(data=weatherData) +
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
  plot(plot6);

  #### Trap: changing theme after changing style ####
  # In this example theme_bw() is changed after theme change were made,
  # so it overrides the other theme changes
  plot6b = ggplot(data=weatherData) +
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
  plot(plot6b);

  #### Part 7: Add regression line ####
  plot7 = ggplot(data=weatherData) +
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
  plot(plot7);

  ####Part 8: Styling the regression line ####
  plot8 = ggplot(data=weatherData) +
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
  plot(plot8);
}  