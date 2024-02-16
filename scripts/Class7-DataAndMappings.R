{
  rm(list=ls());                         # clear Environment tab
  options(show.error.locations = TRUE);  # show line numbers on error
  library(package=ggplot2);              # get the GGPlot package
  library(package=ggforce);              # for geom_circle, geom_ellipse

  #### Two bugs in GGPlot that cause issues with including data and mapping:
  #    1) faceting data must come from a declared data frame
  #    2) annotate (i.e., manually adding objects) does not work for all geoms (objects)
  #       -- it does not work for circles and ellipses

  # read in CSV file and save the content to weatherData
  weatherData = read.csv(file="data/Lansing2016NOAA.csv");

  #### Part A: How to include data from a data frame #####
  
  ## 1st way: data in ggplot (what I have used throughout class)
  ##  good: most intuitive (to me), works well with facets
  ##  bad: Can be problematic with manual additions or with multiple data frames
  plotA1 = ggplot(data=weatherData) +  # global data frame
    theme_bw() +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    geom_smooth(mapping=aes(x=avgTemp, y=relHum),
                method = "lm",
                fill = "red");
  plot(plotA1);
  
  ## 2nd way: data and mapping in ggplot (not preferred but often used)
  ## This is only a good idea if every plot component uses the same mapping
  plotA2 = ggplot(data=weatherData,
                  mapping=aes(x=avgTemp, y=relHum)) +
    theme_bw() +
    geom_point() +
    geom_smooth(method = "lm",
                fill = "blue");
  plot(plotA2);

  ## 3rd way: data and mapping in plot components (often used)
  ##  good: can use multiple data frames, additions are easier
  ##  bad: Problematic when you use facets
  plotA3 = ggplot() +
    theme_bw() +
    geom_point(data=weatherData, 
               mapping=aes(x=avgTemp, y=relHum)) +
    geom_smooth(data=weatherData,
                mapping=aes(x=avgTemp, y=relHum),
                method = "lm",
                fill = "green");
  plot(plotA3);
  
  ## 4th way: explicit mapping in plot components (not often used)
  ##   This is essentially treated as an annotate
  ##   bad: does not work with facets
  plotA4 = ggplot() +
    theme_bw() +
    geom_point(mapping=aes(x=weatherData$avgTemp, y=weatherData$relHum)) +
    geom_smooth(mapping=aes(x=weatherData$avgTemp, y=weatherData$relHum),
                method = "lm",
                fill = "gray50");
  plot(plotA4);
  
  # Can use method 4 to manually add data (mimics an annotate)
  plotA5 = ggplot() +
    theme_bw() +
    geom_point(mapping=aes(x=c(1:100), y=(1:100)^2)) +
    geom_smooth(mapping=aes(x=c(1:100), y=(1:100)^2),
                method = "lm",
                fill = "gray50");
  plot(plotA5);
  
  
  ######  Group 1: ##############################################
  # - Redo HW 7 #1 using the 4 different methods of including data
  # - save as Class7.R
  # - Come up with questions
  ###############################################################
  
  #### Part B: Facet using the four data inclusion methods  #####
  
  # Create a new column called month (will use in facet_wrap)
  dateFormatted = as.Date(weatherData$dateYr, "%Y-%m-%d"); # properly format date
  monthAbb = format(dateFormatted, "%b");  # extract the month from the date
  weatherData$month = monthAbb;   # save month vector to data frame
  
  ## Methods 1 works for faceting as long as a column from the data frame is used
  ## (method 2 not shown but works the same) 
  plotB1 = ggplot(data=weatherData) +
    theme_bw() +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    geom_smooth(mapping=aes(x=avgTemp, y=relHum),
                method = "lm",
                fill = "red") + 
    facet_wrap(facets = vars(month));  # this has to be a column in the data frame
  plot(plotB1);
  
  ## You must use a column from the data frame -- you cannot facet with
  ## a vector even though it is the exact same size and values
  plotB2 = ggplot(data=weatherData) +
    theme_bw() +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    geom_smooth(mapping=aes(x=avgTemp, y=relHum),
                method = "lm",
                fill = "red") + 
    facet_wrap(facets = vars(monthAbb)); # will cause error
# plot(plotB2);  # error: plot is missing monthAbb
  
  ## Methods 3 for including data works for facets
  ##   but, this is a bug as facet_wrap should not be able to see weatherData
  plotB3 = ggplot() +
    theme_bw() +
    geom_point(data=weatherData,   
               mapping=aes(x=avgTemp, y=relHum)) +
    geom_smooth(data=weatherData,
                mapping=aes(x=avgTemp, y=relHum),
                method = "lm",
                fill = "gray")  + 
    facet_wrap(facets = vars(month));
  plot(plotB3); 
  
  ## Methods 4 for including data will not work because facets require a 
  ##   global data frame (I think this is also buggy)
  plotB4 = ggplot() +
    theme_bw() +
    geom_point(mapping=aes(x=weatherData$avgTemp, y=weatherData$relHum)) +
    geom_smooth(mapping=aes(x=weatherData$avgTemp, y=weatherData$relHum),
                method = "lm",
                fill = "gray")  + 
    facet_wrap(facets = vars(weatherData$month)); 
# plot(plotB4); # Error: only 'grobs' allowed in "gList" (makes sense, right?!?)
 

  
  ######  Group 2: ##############################################
  # - Continue working in the script file Class7.R
  # - create a scatterplot of pressure vs humidity
  # - facet_wrap two other variables to create between 9 and 30 plots
  #    - hint: https://ggplot2.tidyverse.org/reference/vars.html
  #    - change either the number of rows or columns in the facet_wrap
  #    - hint: https://ggplot2.tidyverse.org/reference/facet_wrap.html
  #    - modify one other argument (aside from rows and columns) in facet_wrap 
  #    - explain what the other argument does in comments
  # - facet_grid the same two variable for the same scatterplot
  ###############################################################
  
  #### Part C: A broad look at mapping and annotations ####
  ## Definitions 
  #   visual: any component of the plot
  #   graphics: portion of plot that visually represents data (p.36 Grammar of Graphics book)
  #      - does not include titles, labels, axes, grid lines..
  #   mapping: creates a relationship between data and the graphics
  #      - the relationship can be expressed through size, position, shape, color...
  #   geoms: component in GGPlot that map data
  #      - https://ggplot2.tidyverse.org/reference/#geoms
  #   annotations: add visuals to plot -- not directly related to data
  #      - https://ggplot2.tidyverse.org/reference/annotate.html
  #      - can be a visual aid (arrow) or a flourish (author name)
  #      - annotate uses geoms but without the mapping
  #      - faster than geoms
  #      - annotate is not consistent -- many geoms do not work
  #      - packages are especially bad (geom_circle, geom_ellipse)
      
  ####### ---- End Here ----- ######
  
  #### Part D: Using geoms to manually add visuals #####
  # Note: plotA5 is an example of using geoms to manually add visuals
  
  ## Methods 1, 2 will sometimes not work -- you will get an error because x and y
  ## are not the same length as the data frame
  plotD1 = ggplot(data=weatherData) +
    theme_bw() +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    geom_smooth(mapping=aes(x=avgTemp, y=relHum),
                method = "lm",
                fill = "red") + 
    geom_point(mapping=aes(x = c(1,2,3), y = c(10,20,30)));  
# plot(plotD1); # Error: Aesthetics must be either length 1 or the same as the data (366): x and y

  ### Solution using geoms: You need to add points one at a time...
  plotD2 = ggplot(data=weatherData) +
    theme_bw() +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    geom_smooth(mapping=aes(x=avgTemp, y=relHum),
                method = "lm",
                fill = "red") + 
    geom_point(mapping=aes(x=1, y=10)) + 
    geom_point(mapping=aes(x=2, y=20)) + 
    geom_point(mapping=aes(x=3, y=30));  
  plot(plotD2); 
  
  ## Methods 3 and 4 work -- because data is not defined for the whole plot
  plotD2 = ggplot() +
    theme_bw() +
    geom_point(data=weatherData, 
               mapping=aes(x=avgTemp, y=relHum)) +
    geom_smooth(data=weatherData,
                mapping=aes(x=avgTemp, y=relHum),
                method = "lm",
                fill = "green") + 
    geom_point(mapping=aes(x = c(1,2,3),  y = c(10,20,30))); 
  plot(plotD2);
  
  ### Some geoms specifically allow you to add visuals without using mapping
  # https://ggplot2.tidyverse.org/reference/geom_abline.html
  plotD3 = ggplot() +
    theme_bw() +
    geom_hline(yintercept=10,
               color="red") +
    geom_vline(xintercept=20,
               color="blue");
  plot(plotD3);
    
  #### Part D: Alternative to manual objects -- all using first method, but
  ## these work for all second method
  

  
  ### Solution 2: Annotate...
  plotD1b = ggplot(data=weatherData) +
    theme_bw() +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    geom_smooth(mapping=aes(x=avgTemp, y=relHum),
                method = "lm",
                fill = "blue") + 
    annotate(geom="point",
             x= c(1,2,3),
             y= c(10,20,30));  
  plot(plotD1b); 
  
  #### annotate would be the perfect solution but annotate does not 
  ####   work for many geoms
  
  #### Part E: Annotating a facet ####
  plotE = ggplot(data=weatherData) +
    theme_bw() +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    geom_smooth(mapping=aes(x=avgTemp, y=relHum),
                method = "lm",
                fill = "blue") + 
    annotate(geom="point",
             x= 1:4,
             y= 2:5) +
    facet_wrap(facets = vars(month));  
  plot(plotE); 
  
  #### Part F: Can a data frame by overwritten -- yes! ####
  # Create a data frame:
  dfA = c(1,2,3);
  dfB = c(20,30,40);
  df = data.frame(dfA, dfB);
  
  plotF = ggplot(data=weatherData) +
    theme_bw() +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    geom_smooth(data=df, mapping=aes(dfA, dfB),
                method = "lm",
                fill = "blue") + 
    annotate(geom="point",
             x= 1:4,
             y= 2:5) +
    facet_wrap(facets = vars(month));  
  plot(plotF); 
    
}
