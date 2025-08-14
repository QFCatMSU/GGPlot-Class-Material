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
plot1.save("plot1_lineplot.png", dpi=300)

### PART 2: Melt dataframe
partialWD = weatherData[["dateYr", "minTemp", "maxTemp", "avgTemp"]]
WD_Melt = pd.melt(
    partialWD,
    id_vars="dateYr",
    value_vars=["minTemp", "maxTemp", "avgTemp"],
    var_name="tempType",
    value_name="temperatures"
)

plot2 = (
    ggplot(WD_Melt)
    + geom_line(aes(x="dateYr", y="temperatures", color="tempType"))
    + labs(color="Temperatures")
)
plot2.save("plot2_melted.png", dpi=300)

### PART 3 & 5: Generalized line plot with custom colors and labels
columnNames = ["minTemp", "maxTemp", "avgTemp"]
plot3 = ggplot()
for col in columnNames:
    plot3 += geom_line(aes(x=weatherData["dateYr"], y=weatherData[col], color=f'"{col}"'))

plot5 = (
    plot3
    + scale_color_manual(
        breaks=["minTemp", "avgTemp", "maxTemp"],
        values=["blue", "green", "red"]
    )
    + theme_bw()
    + labs(x="Date", y="Temperatures", color="Temp Types")
)
plot5.save("plot5_customized.png", dpi=300)

### PART 6: Scatterplot of humidity vs temperature
plot6 = (
    ggplot(weatherData)
    + geom_point(aes(x="avgTemp", y="relHum"), color="gray")
    + theme_bw()
    + labs(x="Temperature", y="Humidity", title="Humidity vs Temperature", subtitle="Lansing, MI -- 2016")
)
plot6.save("plot6_scatter.png", dpi=300)

### PART 7: Add labels to all points (not recommended for dense plots)
plot7 = (
    plot6
    + geom_text(aes(x="avgTemp", y="relHum", label="date"), color="red", size=6)
)
plot7.save("plot7_all_labels.png", dpi=300)

### PART 8: Add labels every 15 days
every15 = list(range(0, len(weatherData), 15))
subset15 = weatherData.iloc[every15]

plot8 = (
    plot6
    + geom_text(data=subset15, mapping=aes(x="avgTemp", y="relHum", label="date"), color="red", size=6)
)
plot8.save("plot8_every15.png", dpi=300)

### PART 9: Conditionally label extreme points
extremePoints = weatherData[
    (weatherData["relHum"] > 90)
    | (weatherData["relHum"] < 40)
    | (weatherData["avgTemp"] > 80)
    | (weatherData["avgTemp"] < 10)
]

plot9 = (
    plot6
    + geom_text(data=extremePoints, mapping=aes(x="avgTemp", y="relHum", label="date"), color="red", size=6)
)
plot9.save("plot9_extremes.png", dpi=300)

print("✅ All plots saved to PNG files.")
