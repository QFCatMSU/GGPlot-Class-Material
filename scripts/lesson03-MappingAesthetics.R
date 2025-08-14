rm(list=ls());                         # clear Environment tab
library(package=ggplot2);              # get the GGPlot package

# read in CSV file and save the content to weatherData
weatherData = read.csv(file="data/Lansing2016NOAA.csv", 
                       stringsAsFactors = FALSE);  # for people still using R v3

#### Part 1: Last lesson's plot ####
plot1 = ggplot( data=weatherData ) +
  geom_point( mapping=aes(x=avgTemp, y=relHum) ) +
  labs( title="Humidity vs Temperature",
        subtitle="Lansing, MI -- 2016",
        x = "Average Temperatures (Fahrenheit)",
        y = "Relative Humidity") +
  scale_x_continuous( breaks = seq(from=10, to=80, by=10) ) +
  theme_bw() +
  theme( axis.text.x=element_text(angle=90, vjust=0.5) );
plot(plot1);

#### Part 2: Same plot with awful code spacing. Please don't do this.  ####
plot2 = ggplot( data=weatherData ) + geom_point( mapping=aes(x=avgTemp, 
y=relHum) ) + labs( title="Humidity vs Temperature", subtitle="Lansing, MI -- 2016",
x = "Average Temperatures (Fahrenheit)", y = "Relative Humidity") +
  scale_x_continuous( breaks = seq(from=10, to=80, by=10) ) + theme_bw() +
theme( axis.text.x=element_text(angle=90, vjust=0.5) );  plot(plot2);

#### Part 3: adding color to represent season ####
plot3 = ggplot( data=weatherData ) +
  geom_point( mapping=aes(x=avgTemp, y=relHum, color=season) ) +
  labs( title="Humidity vs Temperature",
        subtitle="Lansing, MI -- 2016",
        x = "Average Temperatures (Fahrenheit)",
        y = "Relative Humidity") +
  scale_x_continuous( breaks = seq(from=10, to=80, by=10) ) +
  theme_bw() +
  theme( axis.text.x=element_text(angle=90, vjust=0.5) );
plot(plot3);

#### Part 3b: adding color to represent precip2 ####
plot3b = ggplot( data=weatherData ) +
  geom_point( mapping=aes(x=avgTemp, y=relHum, color=precip2) ) +
  labs( title="Humidity vs Temperature",
        subtitle="Lansing, MI -- 2016",
        x = "Average Temperatures (Fahrenheit)",
        y = "Relative Humidity") +
  scale_x_continuous( breaks = seq(from=10, to=80, by=10) ) +
  theme_bw() +
  theme( axis.text.x=element_text(angle=90, vjust=0.5) );
plot(plot3b);

#### Part 3c: adding color to represent the string precip column ####
plot3c = ggplot( data=weatherData ) +
  geom_point( mapping=aes(x=avgTemp, y=relHum, color=precip) ) +
  labs( title="Humidity vs Temperature",
        subtitle="Lansing, MI -- 2016",
        x = "Average Temperatures (Fahrenheit)",
        y = "Relative Humidity") +
  scale_x_continuous( breaks = seq(from=10, to=80, by=10) ) +
  theme_bw() +
  theme( axis.text.x=element_text(angle=90, vjust=0.5) );
plot(plot3c);

#### Part 4: adding size to represent precipitation ####
plot4 = ggplot( data=weatherData ) +
  geom_point( mapping=aes(x=avgTemp, y=relHum, size=precip2) ) +
  labs( title="Humidity vs Temperature",
        subtitle="Lansing, MI -- 2016",
        x = "Average Temperatures (Fahrenheit)",
        y = "Relative Humidity") +
  scale_x_continuous( breaks = seq(from=10, to=80, by=10) ) +
  theme_bw() +
  theme( axis.text.x=element_text(angle=90, vjust=0.5) );
plot(plot4);

#### Part 4b: map size to a string value ####
plot4b = ggplot( data=weatherData ) +
  geom_point( mapping=aes(x=avgTemp, y=relHum, size=season) ) +
  labs( title="Humidity vs Temperature",
        subtitle="Lansing, MI -- 2016",
        x = "Average Temperatures (Fahrenheit)",
        y = "Relative Humidity") +
  scale_x_continuous( breaks = seq(from=10, to=80, by=10) ) +
  theme_bw() +
  theme( axis.text.x=element_text(angle=90, vjust=0.5) );
plot(plot4b);

#### Part 4c: map alpha to a numeric value ####
plot4c = ggplot( data=weatherData ) +
  geom_point( mapping=aes(x=avgTemp, y=relHum, alpha=precip2) ) +
  labs( title="Humidity vs Temperature",
        subtitle="Lansing, MI -- 2016",
        x = "Average Temperatures (Fahrenheit)",
        y = "Relative Humidity") +
  scale_x_continuous( breaks = seq(from=10, to=80, by=10) ) +
  theme_bw() +
  theme( axis.text.x=element_text(angle=90, vjust=0.5) );
plot(plot4c);

#### Part 5: Change legend position and title ####
plot5 = ggplot( data=weatherData ) +
  geom_point( mapping=aes(x=avgTemp, y=relHum, alpha=precip2) ) +
  labs( title="Humidity vs Temperature",
        subtitle="Lansing, MI -- 2016",
        x = "Average Temperatures (Fahrenheit)",
        y = "Relative Humidity",
        alpha = "Precipitation") +
  scale_x_continuous( breaks = seq(from=10, to=80, by=10) ) +
  theme_bw() +
  theme( axis.text.x=element_text(angle=90, vjust=0.5),
         legend.position = "inside",
         legend.position.inside = c(0.15, 0.2));
plot(plot5);

#### Part 6: combining size and color ####
plot6 = ggplot( data=weatherData ) +
  geom_point( mapping=aes(x=avgTemp, y=relHum, size=precip2, color=season) ) +
  labs( title="Humidity vs Temperature",
        subtitle="Lansing, MI -- 2016",
        x = "Average Temperatures (Fahrenheit)",
        y = "Relative Humidity",
        size = "Precipitation",
        color = "Seasons") +    # changes order
  scale_x_continuous( breaks = seq(from=10, to=80, by=10) ) +
  theme_bw() +
  theme( axis.text.x=element_text(angle=90, vjust=0.5) ,
         legend.position = "left");
plot(plot6);

#### Part 7: adding a linear model ####
plot7 = ggplot( data=weatherData ) +
  geom_point( mapping=aes(x=avgTemp, y=relHum, size=precip2, color=season) ) +
  geom_smooth( mapping=aes(x=avgTemp, y=relHum), 
               method="lm" ) +
  labs( title="Humidity vs Temperature",
        subtitle="Lansing, MI -- 2016",
        x = "Average Temperatures (Fahrenheit)",
        y = "Relative Humidity",
        size = "Precipitation",
        color = "Seasons") +    # changes order
  scale_x_continuous( breaks = seq(from=10, to=80, by=10) ) +
  theme_bw() +
  theme( axis.text.x=element_text(angle=90, vjust=0.5) ,
         legend.position = "none");
plot(plot7);

#### Part 8: overlapping plots ####
plot8 = ggplot( data=weatherData ) +
  geom_smooth( mapping=aes(x=avgTemp, y=relHum), 
               method="lm" ) +
  geom_point( mapping=aes(x=avgTemp, y=relHum, size=precip2, color=season) ) +
  labs( title="Humidity vs Temperature",
        subtitle="Lansing, MI -- 2016",
        x = "Average Temperatures (Fahrenheit)",
        y = "Relative Humidity",
        size = "Precipitation",
        color = "Seasons") +    # changes order
  scale_x_continuous( breaks = seq(from=10, to=80, by=10) ) +
  theme_bw() +
  theme( axis.text.x=element_text(angle=90, vjust=0.5) ,
         legend.position = "none");
plot(plot8);