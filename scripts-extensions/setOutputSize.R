{
  source(file="scripts/reference.R");  # this line will be in all your scripts
  weatherData = read.csv(file="data/LansingNOAA2016.csv", 
                         stringsAsFactors = FALSE);

  #### Part 5: Add labels and titles ####
  plot1 = ggplot(data=weatherData) +
          geom_point(mapping=aes(x=avgTemp, y=relHum),
                     color="darkgreen", 
        #             size=2.5, 
                     shape=17, 
                     alpha = 0.4 ) +
          theme_bw() +
          labs(title = "Humidity vs. Temperature",
               subtitle = "Lansing, Michigan: 2016",
               x = "Temperature (F)",
               y = "Humidity (%)");
  plot(plot1);

  ggsave(filename = "images/sizedPlot2.png",  
         plot = plot1,
         width = 6,
         height = 5,
         units = "cm");   # can also use "in" or "mm"

}  