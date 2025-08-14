from plotnine import *
import pandas as pd

# Part 0: Load the data
df = pd.read_csv("data/Lansing2016NOAA.csv")

# Your plot code
plot1 = ggplot(df) + geom_line(aes(x='x', y='y'))

# Always use print()
print(plot1)
