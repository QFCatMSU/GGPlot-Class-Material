{
  source(file="scripts/reference.R");  # this line will be in all your scripts
  weatherData = read.csv(file="data/LansingNOAA2016.csv", 
                         stringsAsFactors = FALSE);

  # This scatterplot show that...
  plotData = ggplot(data=weatherData) +
             geom_point(mapping=aes(x=abs(tempDept), y=windSpeed),
                        color=rgb(red=0, green=.6, blue=.6), 
                        size=2, 
                        shape=23,
                        alpha = 0.7 ) +
             theme_bw() +
             labs(title = "Wind Speed vs. Temperature Difference",
                  subtitle = "Lansing, Michigan: 2016",
                  x = "Temperature (F)",
                  y = "Humidity (%)") +
             theme(axis.text.y=element_text(angle=30),
                   axis.title.x=element_text(size=15, face="italic", 
                                             color=rgb(red=.8, green=.3, blue=0)),
                   plot.subtitle=element_text(face="bold.italic",
                                              color ="brown")) +
             # default confidence level is 95%
             geom_smooth(mapping=aes(x=abs(tempDept), y=windSpeed), 
                         method="lm",
                         color="purple", 
                         size=1.2, 
                         linetype=5, 
                         fill="yellow");   
  plot(plotData);
  
  ggsave(filename="images/plot.jpeg",
         plot=plotData,
         width = 5,
         height = 10,
         dpi = 360,
         units = "cm");
}  