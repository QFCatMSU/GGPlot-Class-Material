rm(list=ls());                         # clear Environment tab
library(package=ggplot2);              # get the GGPlot package

### Use application from boxplots2 ####

### Computed variables -- do with geom_text (2 lessons?) ###

# read in CSV file and save the content to weatherData
weatherData = read.csv(file="data/Lansing2016NOAA.csv", 
                       stringsAsFactors = FALSE);  # for people still using R v3

#### Part 1: Factoring the values in season ####
seasonOrdered = factor(weatherData$season,
                       levels=c("Spring", "Summer", "Fall", "Winter"));

# Note that, in a mapping, the plot component will first check the columns 
# of the data frame (avgTemp).  Then it will check the Environment (seasonOrdered)

#### Histogram with factored seasons ####
plot1 = ggplot( data=weatherData ) +
  geom_histogram( mapping=aes(x=avgTemp, fill=seasonOrdered),
                  color="black") +  # outline color -- not mapped
  theme_bw() +
  scale_fill_manual(values=c("lightgreen", "pink", 
                             "lightyellow", "lightblue")) +
  labs(title = "Temperature (\u00B0F)",
       subtitle = "Lansing, Michigan: 2016",
       x = "Temperature (\u00B0F)",  
       fill = "Seasons");     
plot(plot1);

#### Part 2: Faceting the histogram ####
plot2 = ggplot( data=weatherData ) +
  geom_histogram( mapping=aes(x=avgTemp),
                  color="black") +  
  theme_bw() +
  facet_grid( rows=vars(season) ) + # vars() checks the data frame
  labs(title = "Temperature (\u00B0F)",
       subtitle = "Lansing, Michigan: 2016",
       x = "Temperature (\u00B0F)");     
plot(plot2);

#### Part 3: Reordering the seasons ####
# Need to put seasonOrdered in the data frame to use with facet_grid()
weatherData$seasonOrdered = seasonOrdered;

# Use seasonOrdered (from the data frame) instead of season
plot3 = ggplot( data=weatherData ) +
  geom_histogram( mapping=aes(x=avgTemp),
                  color="black") +  
  theme_bw() +
  facet_grid( rows=seasonOrdered ) + 
  labs(title = "Temperature (\u00B0F)",
       subtitle = "Lansing, Michigan: 2016",
       x = "Temperature (\u00B0F)");     
plot(plot3);

#### Part 4: Reversing the facet equation ####
plot4 = plot3 +                             # take all components from plot3
  facet_grid( cols = vars(seasonOrdered) ); # and rewrite the facet component
plot(plot4);

#### Part 5: Adding color and switching to a density plot ####
plot5 = ggplot( data=weatherData ) +
  geom_density( mapping=aes(x=avgTemp, fill=season),
                color="black") +  
  theme_bw() +
  facet_grid( cols=vars(seasonOrdered)) +  # season has to be in the data frame
  labs(title = "Temperature (\u00B0F)",
       subtitle = "Lansing, Michigan: 2016",
       x = "Temperature (\u00B0F)");     
plot(plot5);

#### Part 6: Faceting a scatterplot ####  
plot6 = ggplot( data=weatherData ) +
  geom_point( mapping=aes(x=avgTemp, y=relHum)) +  
  theme_bw() +
  facet_grid( rows = vars(seasonOrdered) ) +  
  labs(title = "Temperature (\u00B0F)",
       subtitle = "Lansing, Michigan: 2016",
       x = "Temperature (\u00B0F)");     
plot(plot6);

#### Part 6b: Faceting a barplot ####  
plot6b = ggplot( data=weatherData ) +
  geom_bar( mapping=aes(x=avgTemp)) +  
  theme_bw() +
  facet_grid( rows = vars(seasonOrdered) ) +  
  labs(title = "Temperature (\u00B0F)",
       subtitle = "Lansing, Michigan: 2016",
       x = "Temperature (\u00B0F)");     
plot(plot6b);

#### Part 6c: Free scaling -- each facet uses a different scale ####  
plot6c = ggplot( data=weatherData ) +
  geom_bar( mapping=aes(x=avgTemp)) +  
  theme_bw() +
  facet_grid( rows = vars(seasonOrdered), 
              scales="free") +  
  labs(title = "Temperature (\u00B0F)",
       subtitle = "Lansing, Michigan: 2016",
       x = "Temperature (\u00B0F)");     
plot(plot6c);

#### Part 7: Two-dimensional facets ####
plot7 = ggplot( data=weatherData ) +
  geom_point( mapping=aes(x=avgTemp, y=relHum)) +  
  theme_bw() +
  facet_grid( rows = vars(seasonOrdered),
              cols = vars(windSpeedLevel)) +
  labs(title = "Temperature (\u00B0F)",
       subtitle = "Lansing, Michigan: 2016",
       x = "Temperature (\u00B0F)");     
plot(plot7);

#### Part 8: Modify the box labels ####
plot8 = ggplot( data=weatherData ) +
  geom_point( mapping=aes(x=avgTemp, y=relHum)) +  
  theme_bw() +
  theme(strip.text = element_text(color="purple",
                                  size=15),
        strip.background.x = element_rect(color="red",
                                          fill="yellow"),
        strip.background.y = element_rect(color="blue",
                                          fill="lightgreen")) +
  facet_grid( rows = vars(seasonOrdered),
              cols = vars(windSpeedLevel),
              switch = "both") +  # could use "x" or "y" to switch only one axis
  labs(title = "Temperature (\u00B0F)",
       subtitle = "Lansing, Michigan: 2016",
       x = "Temperature (\u00B0F)");     
plot(plot8);

#### Part 9: Facet_wrap with one variable ####
plot9 = ggplot( data=weatherData ) +
  geom_point( mapping=aes(x=avgTemp, y=relHum)) +  
  theme_bw() +
  facet_wrap( facets = vars(windSusDir),
              nrow = 4) +
  labs(title = "Temperature (\u00B0F)",
       subtitle = "Lansing, Michigan: 2016",
       x = "Temperature (\u00B0F)");     
plot(plot9);

#### Part 10: Facet_wrap with multiple variable ####
plot10 = ggplot( data=weatherData ) +
  geom_point( mapping=aes(x=avgTemp, y=relHum)) +  
  theme_bw() +
  facet_wrap( facets = vars(seasonOrdered, windSpeedLevel),
              ncol = 4,
              dir = "v") +  # order facets vertically (default is "h" or horizontally)
  labs(title = "Temperature (\u00B0F)",
       subtitle = "Lansing, Michigan: 2016",
       x = "Temperature (\u00B0F)");     
plot(plot10);

# Save the dateYr column in Date format
dateYr2 = as.Date(weatherData$dateYr, format="%Y-%m-%d");
# Extract the month from the dateYr2 vector -- create a new column
weatherData$monthsCol = format(dateYr2, format="%b");