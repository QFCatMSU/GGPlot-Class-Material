{
  source(file="scripts/reference.R");  # this line will be in all your scripts
  weatherData = read.csv(file="data/LansingNOAA2016.csv", 
                         stringsAsFactors = FALSE);

  # Need to scale wind speed value (0-25) to humidity values (35-100)
  plotData = ggplot(data=weatherData) +
             geom_point(mapping=aes(x=avgTemp, y=relHum),
                        color="darkgreen", 
                        size=2.5, 
                        shape=17,
                        alpha = 0.4 ) +
             geom_point(mapping=aes(x=avgTemp, y=(3*windSpeed + 30)),  # scale here
                        color="red",
                        size=2.5,
                        shape=16,
                        alpha = 0.4 ) +
             theme_classic() +
             labs(title = "Humidity vs. Temperature",
                  subtitle = "Lansing, Michigan: 2016",
                  x = "Temperature (F)",
                  y = "Humidity (%)") +
             scale_y_continuous(sec.axis = sec_axis(trans= ~ (.-30)/3, # reverse-scale here
                                                    name="Wind Speed (mph)")) + 
             theme(axis.title.y=element_text(size=14, color="orangered4"),
                   axis.title.y.right=element_text(size=14, color="green"));  # theme for right side axis
  plot(plotData);
}  