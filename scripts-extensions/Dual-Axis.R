{
 # source(file="scripts/reference.R");  # this line will be in all your scripts
  weatherData = read.csv(file="data/LansingNOAA2016.csv", 
                         stringsAsFactors = FALSE);

  # There is no way in GGPlot to create a secondary axis (right-side)
  #    independent of the primary axis (left-side)
  #
  # Instead, 
  #   1) scale and shift the values going on secondary axis (in this case, wind speed) 
  #      to approximate the primary axis (humidity)
  #   2) create a secondary axis using sec.axis in scale_y_continuous
  #   3) reverse scale and shift the secondary axis to match the values
  #      of the 
  plotData = ggplot(data=weatherData) +
             geom_point(mapping=aes(x=avgTemp, y=relHum),
                        color="darkgreen", 
                        size=2.5, 
                        shape=17,
                        alpha = 0.4 ) +
             # 2) scale and shift the windspeed values (0-25) to approximate humidity values (35-100)
             #    Multiply by 3 and add 30 to windspeed to approximate humidity
             #    Note: you can scale and shift by whatever values you want 
             #          as long as you reverse it correctly below
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
             # 1) create a secondary axis with name="Wind Speed (mph)"
             # 2) reverse scale and shift using trans 
             #    subtract 30 and divide by 3 
             #    (.-30)/3 means take this value (.), subtract 30, then divide by 3 (it's weird!)
             scale_y_continuous(sec.axis = sec_axis(trans= ~ (.-30)/3,
                                                    name="Wind Speed (mph)")) + 
             theme(axis.title.y=element_text(size=14, color="orangered4"),
                   axis.title.y.right=element_text(size=14, color="green"));  # theme for right side axis
  plot(plotData);
}  