rm(list=ls());
library(package = "ggplot2");

# read in CSV file and save the content to weatherData
weatherData = read.csv(file="data/Lansing2016NOAA.csv", 
                       stringsAsFactors = FALSE); 

# Part 1: Line plot of the three temperature columns in weatherData
plot1 = ggplot(data=weatherData) +
  geom_line(mapping=aes(x=as.Date(dateYr), 
                        y=minTemp,
                        color = "Min")) +
  geom_line(mapping=aes(x=as.Date(dateYr), 
                        y=maxTemp,
                        color = "Max")) +
  geom_line(mapping=aes(x=as.Date(dateYr), 
                        y=avgTemp,
                        color="Avg")) +
  labs(color = "Temperatures");  # name of color mapping in the legend
plot(plot1);

### Part 2: creating and plotting a melted dataframe
partialWD = weatherData[, c("dateYr", "minTemp","maxTemp", "avgTemp")];

# When you melt columns, you are essentially combining the columns
WD_Melt = reshape(partialWD ,         # could also use weatherData[, c(1:4)]
            direction="long",         # how to manipulate (switch to long form) 
            varying=c("minTemp", "maxTemp", "avgTemp"), # columns to "melt" 
            v.name="temperatures",    # name of new combined melted column
            times=c("minTemp", "maxTemp", "avgTemp"),   # names for column
            timevar = "tempType",     # name of the groups
            ids = "dateYr",           # values for the individuals
            idvar = "dateYr"); # name of the individuals columns

# rename the rows to make the data frame easier to read:
rownames(WD_Melt) = 1:1098;

#   Essentially: plot temperature (y) ~ dayNum (x) and subset by year (color)
plot2 = ggplot(data = WD_Melt) +
  geom_line(mapping=aes(x=as.Date(dateYr), 
                        y=temperatures, 
                        color=tempType)) +
  labs(color = "Temperatures");
plot(plot2);

# Part 3: Generalize the mappings -- 
columnNames = c("minTemp", "maxTemp", "avgTemp"); # columns to cycle through

plot3 = ggplot();

# cycle through the column names
for (i in 1:3)   # the three names/ columns
{
  plot3 = plot3 + 
    geom_line(mapping=aes(x=as.Date(weatherData$dateYr), 
                           y=weatherData[,columnNames[!!(i)]],
                           color=columnNames[!!(i)]));
}
plot(plot3);

### Change order of legend and colors, and labels and theme
plot5 = plot3 +    # make copy of last plot and add...
  scale_color_manual(breaks=c("minTemp", "avgTemp", "maxTemp"),
                     values=c("blue",    "green",   "red")) +
  theme_bw() +
  labs(x = "Date",
       y = "Temperatures",
       color="Temp Types"); 
plot(plot5);

# Part 6: Create a scatterplot of humidity vs temperature
plot6 = ggplot() +
  geom_point(mapping=aes(x=weatherData$avgTemp, 
                         y=weatherData$relHum),
             color="gray") +    # color is not a mapping here -- only a style
  theme_bw() +
  labs(x = "Temperature",
       y = "Humidity",
       title = "Humidity vs Temperature",
       subtitle="Lansing, MI -- 2016");
plot(plot6);

# Part 7: Add labels to to the points in a scatterplot
# Keep (plot6), and create a copy (plot7), of the scatterplot 
plot7 = plot6 +
  geom_text(mapping=aes(x=weatherData$avgTemp,   # at x = ...
                        y=weatherData$relHum,    # and y = ...
                        label=weatherData$date), # add the label ...
            color="red");                        # in the color red
plot(plot7);


# Part 8: Selectively add labels using seq()
every15 = seq(from=1, to=366, by=15);

plot8 = plot6 +  # copy plot6 and append
  geom_text(mapping=aes(x=weatherData$avgTemp[every15],   # at x = ...
                        y=weatherData$relHum[every15],    # and y = ...
                        label=weatherData$date[every15]), # add the label ...
            color="red");                                 # in the color red
plot(plot8);

# Part 9: Conditionally add labels using which()
extremePoints = which(weatherData$relHum > 90  | weatherData$relHum < 40 |
                      weatherData$avgTemp > 80 | weatherData$avgTemp < 10);  

plot9 = plot6 +  # copy plot6 and append
  geom_text(mapping=aes(x=weatherData$avgTemp[extremePoints],
                        y=weatherData$relHum[extremePoints],
                        label=weatherData$date[extremePoints]),
            color = "red") +
  theme_bw();
plot(plot9);