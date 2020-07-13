{
  library(package="extrafont"); # not yet...

  
  source(file="scripts/reference.R");  # this line will be in all your scripts
  weatherData = read.csv(file="data/LansingNOAA2016.csv", 
                         stringsAsFactors = FALSE);

  # This scatterplot show that...
  plotData = ggplot(weatherData) +
             geom_point(mapping = aes(x=abs(tempDept), y=windSpeed),
                        color=rgb(red=0, green=.6, blue=.6), 
                        size=2, 
                        shape=23,
                        alpha = 0.7 ) +
             theme_bw() +
             labs(title = "Wind Speed vs. Temperature Difference",
                  subtitle = "Lansing, Michigan: 2016",
                  x = "Temperature (F)",
                  y = "Humidity\n\n (%)") +
             theme(aspect.ratio = 3/5,
                   axis.text.x=element_text(angle=-30),
                   axis.text.y=element_text(angle=30),
                   axis.title.y=element_text(angle=0, vjust=0.3),
                   axis.title.x=element_text(size=15, face="italic", 
                                             color=rgb(red=.8, green=.3, blue=0),
                                             hjust=0.2),
                   plot.subtitle=element_text(face="bold.italic",
                                              color ="brown", hjust=0.7),
                   plot.title=element_text(hjust=0.8),
                   plot.background = element_rect(fill = "bisque"),
                   panel.background = element_rect(fill="grey85"),
                   panel.grid.minor = element_line(linetype=0),
                   panel.grid.major = element_line(color="grey70", linetype=4)) +
             scale_x_continuous(expand= c(0,1),
                                breaks = seq(from=-1, to=40, by=3),
                                minor_breaks = NULL) +
             scale_y_continuous(expand= c(0,0),
                               breaks= c(5,10,15,20),
                               limits = c(0,20)) +
             geom_smooth(mapping=aes(x=abs(tempDept), y=windSpeed), 
                         method="lm",
                         color="purple", 
                         size=1.2, 
                         linetype=5, 
                         fill="yellow",
                         level=0.99); # confidence level changed to 99% (default is 95%)
  plot(plotData);
}  