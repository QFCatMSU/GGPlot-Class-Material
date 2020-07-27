{
  source(file="scripts/reference.R");  
  weatherData = read.csv(file="data/LansingNOAA2016-3.csv");

  ###
  # Differences:
  # - facet_wrap() will not print plots without data
  # - When x and y facets are used, facet_grid() creates a grid the plots by the facets
  #   whereas fact_wrap() does not (easier to see than show...)
  
  # facet_grid creates a 2D grid of plots whose x and y coordinates are the factors 
  #   of the facets (i.e., 4 seasons by 3 wind speeds)
  thePlot = ggplot(data=weatherData) +
      geom_point(mapping=aes(x=relHum, y=avgTemp),
                 na.rm=TRUE) +
      theme_bw() +
    
      # strip.text and strip.background changes the style of the facet boxes
      theme(strip.text = element_text(size=9, color="darkgreen"),
            strip.background = element_rect(colour="gray", fill="transparent")) + 
    
      facet_grid(facets=season~factor(windSpeedLevel,
                                 levels=c("Low", "Medium", "High"))) +
    
      labs(title = "Humidity vs Temperature by Season and Wind Speed",
           subtitle = "Lansing, Michigan: 2016",
           x = "Humidity / Wind Speed",
           y = "Temperature (F) / Season");  
  
   plot(thePlot);

  # facet_wrap creates plots with the factors of the 2 facets labeled on each plot.
  #   The plots are arranged 2D, but this arrangement is based on efficient spacing.
  #   The advantage to facet_wrap is that it will remove plots that have no data.
  #   This example does not have any plots with no data.
  thePlot = ggplot(data=weatherData) +
    geom_point(mapping=aes(x=relHum, y=avgTemp),
               na.rm=TRUE) +
    theme_bw() +
    
    # strip.text and strip.background changes the style of the facet boxes
    theme(strip.text = element_text(size=9, color="darkgreen"),
          strip.background = element_rect(colour="gray", fill="transparent")) + 
    
    facet_wrap(facets=season~factor(windSpeedLevel,
                                    levels=c("Low", "Medium", "High"))) +
    
    labs(title = "Humidity vs Temperature by Season and Wind Speed",
         subtitle = "Lansing, Michigan: 2016",
         x = "Humidity / Wind Speed",
         y = "Temperature (F) / Season");  
  
  plot(thePlot);
}  