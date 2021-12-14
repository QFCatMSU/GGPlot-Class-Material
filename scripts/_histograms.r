rm(list=ls());                         # clear Console Window
options(show.error.locations = TRUE);  # show line numbers on error
library(package=ggplot2);   

# get 2016 Lansing weatherData from the NOAA
weatherData = read.csv(file="data/LansingNOAA2016-3.csv", 
                     stringsAsFactors = FALSE);

# plot basic histogram using RBase
hist(x=weatherData$maxTemp);

# plot basic histogram using GGPlot
thePlot = ggplot(data=weatherData) +
          geom_histogram(mapping=aes(x=maxTemp));
plot(thePlot);
