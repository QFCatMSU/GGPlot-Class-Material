{
  rm(list=ls());                         # clear Environment tab
  options(show.error.locations = TRUE);  # show line numbers on error
  library(package=ggplot2);              # get the GGPlot package
  library(package=ggforce);              # for geom_circle, geom_ellipse

  #### Two bugs in GGPlot that cause issues with including data and mapping:
  #    1) faceting data must come from a declared (local or global)data frame
  #    2) annotate (manually adding objects) does not work for all geoms_* 
  #       -- hline/vline/circles/ellipses...
  
  # read in CSV file and save the content to weatherData
  weatherData = read.csv(file="data/Lansing2016NOAA.csv");
  janTemps = read.csv(file="data/LansingJanTemps.csv");  # second data frame
  
  #### Part A: Include data globally from a data frame #####
  ## Note: you can make the mapping global -- I do not recommend this...
  plotA1 = ggplot(data=weatherData) +  # generally what I recommend
    theme_bw() +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    geom_smooth(mapping=aes(x=avgTemp, y=relHum),
                method = "lm",
                fill = "red");
  plot(plotA1);
  
  ## Can you switch from global to local data? Yes! ##  
  plotA2 = ggplot(data=weatherData) +  # global data frame
    theme_bw() +
    geom_point(data=janTemps,              # local data frame
               mapping=aes(x=V1, y=V2)) +  # must use local data frame (janTemps)
    geom_smooth(mapping=aes(x=avgTemp, y=relHum),  # reverts back to global (weatherData)
                method = "lm",
                fill = "blue");
  plot(plotA2);
  
  ## note: V1, V2 is what happens when you save data frame to CSV 
  #        and there are no column names in the data frame
  
  ## Facets (grid/wrap) must use a data frame -- the data frame
  #   can be global or local -- it can even be a mix
  #  note: this behavior does not make sense and is problematic!
  plotA3 = ggplot(data=weatherData) +  # global data frame
    theme_bw() +
    geom_smooth(mapping=aes(x=avgTemp, y=relHum),  # use global df (weatherData)
                method = "lm",
                fill = "red") +
    geom_point(data=janTemps,                      # use local df (janTemps)
               mapping=aes(x=V1, y=V2)) +
    facet_grid(rows=vars(V1),                      # mixes the two
               cols=vars(windSpeedLevel));
  plot(plotA3);
  
  #### Part B: A broad look at mapping and annotations ####
  ## Definitions 
  #   graphics: any component of plot that visually represents data
  #      - Grammar of Graphics book -- page 36 (free download)
  #        https://link.springer.com/book/10.1007/0-387-28695-0
  #   mapping: creates a relationship between data and the graphics
  #      - the relationship can be expressed through size, position, shape, color...
  #      - I would argue a facet is very similar to a mapping
  #   geoms: components in GGPlot that create mappings
  #      - https://ggplot2.tidyverse.org/reference/#geoms
  #      - not designed to add visuals unrelated to data (technically)
  #   annotations: add visual components to plot -- not mapped to data
  #      - https://ggplot2.tidyverse.org/reference/annotate.html
  #      - can be a visual aid (arrow) or a flourish (author name)
  #      - annotate reuses geoms (geom subcomponent) but without the mapping
  #      - faster and more practical than geoms BUT...
  #      - annotate is not consistent -- many geoms do not work 
  #      - packages are especially bad (geom_circle, geom_ellipse)

  #### Group 1: 
  #    Using plotA1, create curve that matches the picture 
  #      - Use annotate to create the brown curve
  #      - Use geom_curve to create the green curve
  #      - need angle, curvature, arrow (subcomponents of geom_curve)
  #      -      x, y, xend, yend (aesthetics)
  #    https://ggplot2.tidyverse.org/reference/geom_segment.html
  
  #### Part C: Using annotate/geoms to manually add multiple curves #####

  ### Annotate does this nicely!
  plotC0 = ggplot(data=weatherData) +
    theme_bw() +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    geom_smooth(mapping=aes(x=avgTemp, y=relHum),
                method = "lm",
                fill = "blue") + 
    annotate(geom="curve",
             x= c(1,2,3,4),
             y= c(20,40,60,80),
             xend = c(10,20,30,40),
             yend = c(5,10,15,20),
             color = c("red", "blue", "green", "orange"));     
  plot(plotC0); 
  
  ### geoms were not intended to manually add visuals to a plot
  #   annotate was intended to do that, but geom is often more reliable
  
  ### Manually add 4 curves using  geoms with no global data: ###
  plotC1 = ggplot() +
    theme_bw() +
    geom_point(data=weatherData, 
               mapping=aes(x=avgTemp, y=relHum)) +
    geom_smooth(data=weatherData,
                mapping=aes(x=avgTemp, y=relHum),
                method = "lm",
                fill = "red") + 
    geom_curve(mapping=aes(x= c(1,2,3,4),
                           y= c(20,40,60,80),
                           xend = c(10,20,30,40),
                           yend = c(5,10,15,20))); 
  plot(plotC1); 
  
  ### Manually add 4 curves using geom with global data- creates error: ###
  plotC2 = ggplot(data=weatherData) +
    theme_bw() +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    geom_smooth(mapping=aes(x=avgTemp, y=relHum),
                method = "lm",
                fill = "red") + 
    geom_curve(mapping=aes(x= c(1,2,3,4),
                           y= c(20,40,60,80),
                           xend = c(10,20,30,40),
                           yend = c(5,10,15,20)));  
# plot(plotC2);    
  # Error: Aesthetics must be either length 1 or the same as the data (366): x and y
  #    You see this error a lot in GGPlot
  
  ### A hacky way to manually add 4 curves using geoms with global data: ###
  plotC3 = ggplot(data=weatherData) +
    theme_bw() +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    geom_smooth(mapping=aes(x=avgTemp, y=relHum),
                method = "lm",
                fill = "red") + 
    geom_curve(mapping=aes(x=1, y=20, xend=10, yend=5)) +   
    geom_curve(mapping=aes(x=2, y=40, xend=20, yend=10)) +  
    geom_curve(mapping=aes(x=3, y=60, xend=30, yend=15)) +  
    geom_curve(mapping=aes(x=4, y=80, xend=40, yend=20));  
  plot(plotC3);    
  
  ### A really hacky way to manually add 4 curves using geoms with global data: ###
  #   But I feel like this hackiness is also the most robust solution...
  plotC4 = ggplot(data=weatherData) +
    theme_bw() +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    geom_smooth(mapping=aes(x=avgTemp, y=relHum),
                method = "lm",
                fill = "red") + 
    # create a local data frame and use it in the mapping
    geom_curve(data=data.frame(x0 = c(1,2,3,4), 
                               y0 = c(20,40,60,80),
                               xend0 = c(10,20,30,40), 
                               yend0 = c(5,10,15,20)),  
               mapping=aes(x=x0, y=y0, xend=xend0, yend=yend0));  
  plot(plotC4); 
  # xend = xend0: means the xend mapping is set to the 
  #                xend0 column of the local data frame

  # In case you were wondering, you can use this solution with facets... 
  plotC5 = ggplot(data=weatherData) +
    theme_bw() +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    geom_smooth(mapping=aes(x=avgTemp, y=relHum),
                method = "lm",
                fill = "red") + 
    geom_curve(data=data.frame(x0 = c(1,2,3,4), 
                               y0 = c(20,40,60,80),
                               xend0 = c(10,20,30,40), 
                               yend0 = c(5,10,15,20)),
               mapping=aes(x=x0, y=y0, xend=xend0, yend=yend0)) +
    facet_grid(rows=vars(season), cols=vars(windSpeedLevel)); 
  plot(plotC5); 

  # And if you want to put different "anotations" in each facet, then
  #    it is probably time to consider multipaneling!
  
  ### Part D: A Geom created to also be like an annotation (hline/vline) ####

  ### Some geoms specifically allow you to add visuals with or without mapping
  # https://ggplot2.tidyverse.org/reference/geom_abline.html
  plotD1 = ggplot() +   # no data frame
    theme_bw() +
    geom_hline(yintercept=10,               # without mapping (like annotate)
               color="red") +
    geom_vline(mapping=aes(xintercept=20),  # with mapping
               color="blue");
  plot(plotD1);

  # The theory of annotate is that everything that is a geom can be used in annotate.
  # But hline and vline do not work -- and they are GGPlot geoms.
  # It only gets worse when you start using packages (geom_circle...)
  plotD2 = ggplot() +   
    theme_bw() +
    annotate(geom="hline",   # if you change this to a non-geom, you will get an error
             yintercept=10,              
             color="red") +
    annotate(geom="vline",
             xintercept=20,  # remove this and you will get an error (vline requires xintercept)            
             color="blue");
  plot(plotD2);   # no error -- just an empty plot
  
  #### Group 2:
  ## Using plotA1 (same as group 1)
  ##  - Create an X that connects to all four corners using geom_abline
  ##    - being exact is not necessary!
  ##    - change the color, linetype, size, and opacity of the X
  ##  - create text using one annotate component in the top-right and top-left corner
  ##    - make 3 property changes to the text
  ##  - create text using one geom_text component in the bottom-right and bottom-left corner
  ##    - make 3 property changes to the text   
  ##    - try to do this without a legend
  
  ## Answer WAY below...
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
    plotG2 = ggplot(data=weatherData) +  # global data 
    theme_bw() +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
    geom_abline(intercept = 30, slope = 0.8) +
    geom_abline(intercept = 100, slope = -0.8) +
    annotate(geom="text",
             x = c(10,70),
             y = c(95, 95),
             label = c("llama", "alpaca"),
             color = c("red", "blue"),
             size = c(5, 7),
             angle = c(45,135)) + 
    geom_text(data = data.frame(x0 = c(10,70),
                                y0 = c(40,40)),
             mapping= aes(x=x0, y=y0),
             label = c("guanaco", "piping plover"),
             color = c("purple", "green"),
             size = c( 7, 5),
             angle = c(20, -20)) + 
    geom_smooth(mapping=aes(x=avgTemp, y=relHum),
                method = "lm",
                fill = "red");
  plot(plotG2);
}
