import pandas as pd
from plotnine import *
import matplotlib.pyplot as plt

# Load the weather data
weatherData = pd.read_csv("data/Lansing2016NOAA.csv")
weatherData["dateYr"] = pd.to_datetime(weatherData["dateYr"])

### PART 1: Line plot of three temperature columns
plot1 = (
    ggplot(weatherData)
    + geom_line(aes(x='dateYr', y='minTemp', color='"Min"'))
    + geom_line(aes(x='dateYr', y='maxTemp', color='"Max"'))
    + geom_line(aes(x='dateYr', y='avgTemp', color='"Avg"'))
    + labs(color="Temperatures")
)
print(plot1)
plt.show()
#plot1.save("plot1_lineplot.png", dpi=300)

