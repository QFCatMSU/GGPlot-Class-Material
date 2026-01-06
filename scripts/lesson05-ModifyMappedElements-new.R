rm(list=ls());                         # clear Environment tab
options(show.error.locations = TRUE);  # show line numbers on error
library(package=ggplot2);              # get the GGPlot package

# read in CSV file and save the content to weatherData
weatherData = read.csv(file="data/Lansing2016NOAA.csv", 
                       stringsAsFactors = FALSE);  # for people still using R v3

#### Part 1: Mapping point size and color ####
plot1 = ggplot( data=weatherData ) +
  geom_point( mapping=aes(x=avgTemp, y=relHum, color=season, size=precip2)) +
  theme_bw() +
  labs(title = "Humidity vs. Temperature",
       subtitle = "Lansing, Michigan: 2016",
       x = "Temperature (\u00B0F)",  
       y = "Humidity (\u0025)");     
plot(plot1);

#### Part 2: Factoring the values in season ####
seasonOrdered = factor(weatherData$season,
                       levels=c("Spring", "Summer", "Fall", "Winter"));

# Use the factored values in the plot
plot2 = ggplot( data=weatherData ) +
  geom_point( mapping=aes(x=avgTemp, y=relHum, color=seasonOrdered, size=precip2)) +
  theme_bw() +
  labs(title = "Humidity vs. Temperature",
       subtitle = "Lansing, Michigan: 2016",
       x = "Temperature (\u00B0F)",  
       y = "Humidity (\u0025)");     
plot(plot2);

#### Part 3: Appending scale components to a previous plot ####
plot3 = plot2 +   # get the components from plot2
  scale_x_continuous(limits=c(15,85),
                     breaks = c(30,50,70)) +
  scale_y_continuous(limits=c(40,100),
                     breaks = c(50,70,90));
plot(plot3);      # plot3 combines plot2 components with the new components

#### Part 4: Remapping the size and color values ####
plot4 = plot3 + 
  scale_size(range=c(0,5)) +
  scale_color_manual(values=c("green", "red", "yellow", "blue"));
plot(plot4);

#### Part 4b: You can be explicit about colors (plot in same as last) ####
plot4b = plot3 + 
  scale_size(range=c(0,5)) +
  scale_color_manual(values=c("Summer" = "red",
                              "Spring" = "green", 
                              "Fall" = "yellow", 
                              "Winter" = "blue"));
plot(plot4b);

#### Part 5: Reordering the legend and changing labels ####
plot5 = plot4 +
  labs(title = "Humidity vs. Temperature",
       subtitle = "Lansing, Michigan: 2016",
       x = "Temperature (\u00B0F)",  
       y = "Humidity (\u0025)",
       color = "Seasons",
       size = "Precipitation") +    
  guides(color = guide_legend(order=1),
         size = guide_legend(order=2));
plot(plot5);

#### Part 6: Our first histogram -- note there is only an x-mapping ####
plot6 = ggplot( data=weatherData ) +
  geom_histogram( mapping=aes(x=avgTemp)) +
  theme_bw() +
  labs(title = "Temperature (\u00B0F)",
       subtitle = "Lansing, Michigan: 2016",
       x = "Temperature (\u00B0F)");     
plot(plot6);

#### Part 7: Mapping fill color in a histogram ####
plot7 = ggplot( data=weatherData ) +
  geom_histogram( mapping=aes(x=avgTemp, fill=seasonOrdered)) +  
  theme_bw() +
  scale_fill_manual(values=c("lightgreen", "pink", 
                             "lightyellow", "lightblue")) +
  labs(title = "Temperature (\u00B0F)",
       subtitle = "Lansing, Michigan: 2016",
       x = "Temperature (\u00B0F)",  
       fill = "Seasons");     
plot(plot7);

#### Part 8: Add outline color subcomponent to the histogram ####
plot8 = ggplot( data=weatherData ) +
  geom_histogram( mapping=aes(x=avgTemp, fill=seasonOrdered),
                  color="black") +  # outline color -- this is not mapped
  theme_bw() +
  scale_fill_manual(values=c("lightgreen", "pink", 
                             "lightyellow", "lightblue")) +
  labs(title = "Temperature (\u00B0F)",
       subtitle = "Lansing, Michigan: 2016",
       x = "Temperature (\u00B0F)",  
       fill = "Seasons");     
plot(plot8);

#### Part 8b: Switching to a density plot ####
plot8b = ggplot( data=weatherData ) +
  geom_density( mapping=aes(x=avgTemp, fill=seasonOrdered),
                color="black", 
                alpha=0.7) +   # so you can see through the areas
  theme_bw() +
  scale_fill_manual(values=c("lightgreen", "pink", 
                             "lightyellow", "lightblue")) +
  labs(title = "Temperature (\u00B0F)",
       subtitle = "Lansing, Michigan: 2016",
       x = "Temperature (\u00B0F)",  
       fill = "Seasons");     
plot(plot8b);

#### Mapping the continuous values of precipitation to color #### 
plot9 = ggplot( data=weatherData ) +
  geom_point( mapping=aes(x=windSusSpeed, y=relHum, color=precip2)) +
  theme_bw() +
  labs(title = "Humidity vs. Wind Speed",
       subtitle = "Lansing, Michigan: 2016",
       x = "Wind Speed (miles/hour)",  
       y = "Humidity (\u0025)"); 
plot(plot9);

#### mapping precipitation to a gradient with two specified colors #### 
plotA = plot9 + 
  scale_color_gradient(low="orange", high="blue");
plot(plotA);

#### mapping precipitation to 4 specified colors #### 
plotB = plot9 + 
  scale_color_gradientn(colors=c("gray", "green", "yellow", "blue")); 
plot(plotB);

#### set the boundary on the 4 colors #### 
plotC = plot9 + 
  scale_color_gradientn(colors=c("gray", "green", "yellow", "blue"),
                        values=c(0,0.05,0.25,1)); 
plot(plotC);

#### Some shapes (21-25) have a fill -- use fill mapping instead of color #### 
plotD = ggplot( data=weatherData ) +
  geom_point( mapping=aes(x=windSusSpeed, y=relHum, fill=precip2),
              shape = 23,
              size=2.5,
              color="black") +  # outline color
  theme_bw() +
  labs(title = "Humidity vs. Wind Speed",
       subtitle = "Lansing, Michigan: 2016",
       x = "Wind Speed (miles/hour)",
       y = "Humidity (\u0025)") +
  scale_fill_gradientn(colors=c("gray", "green", "yellow", "blue"),
                       values=c(0,0.05,0.25,1));
plot(plotD);