{
  rm(list=ls());  options(show.error.locations = TRUE);
  library(package = "ggplot2");
  library(package = "viridis");   # used in last plot for better colors

  ### New dataframe: January temperatures in Lansing 2016-2022
  Jan_Avg = read.csv(file = "data/Jan_TAVG.csv");
  
  ### Part 1: creating and plotting a melted dataframe

  # When you melt columns, you are essentially combining the columns
  Jan_Avg_Melt = reshape(data=Jan_Avg,             # data frame to manipulate
                         direction="long",         # how to manipulate (switch to long form) 
                         #### Columns you are combining (melting together)
                         varying=c(1:7),           # columns to combine (melt)
                         v.name="temperatures",    # name of new combined column
                         #### The new subsetting column 
                         times=colnames(Jan_Avg),  # values for the grouping column 
                         timevar = "year",         # name of the groups
                         #### The new individual column
                         ids = as.numeric(rownames(Jan_Avg)),  # values for the individuals
                         idvar = "dayNum",   # name of the individuals columns
                         ### Makes the data frame easier to read
                         new.row.names = 1:217);         

  # # Plot temperature (y) ~ dayNum (x) and subset by year (color)
  # plot1 = ggplot(data = Jan_Avg_Melt) +
  #   geom_line(mapping=aes(x=dayNum, y=temperatures, color=year));
  # plot(plot1);
  # 
  # ### Part 2: Manually plot columns (only plotting 3 of 7 columns)--
  # plot2 = ggplot() +    # data frame not initialized here
  #   geom_line(mapping=aes(x=1:31, 
  #                         y=Jan_Avg$X2016,  # data frame used in mapping instead
  #                         color="2016")) +  # needs to be in quotes
  #   geom_line(mapping=aes(x=1:31,  
  #                         y=Jan_Avg$X2017,
  #                         color="2017")) +
  #   geom_line(mapping=aes(x=1:31,
  #                         y=Jan_Avg$X2018,
  #                         color="2018")) +
  #   theme_bw() + 
  #   labs(x = "Date",
  #        y = "Temp (Celsius)",
  #        color = "Year");
  # plot(plot2);
  # 
  # # Part 3: Generalize the y-mapping  --
  # #         Move data frame to geom and index y-mapping (use in for loops)
  # 
  # ### Note: For many GGPlot situations (including this one), 
  # #         it is easier to directly map data frames
  # plot3 = ggplot() +   # remove data frame from the canvas
  #   geom_line(mapping=aes(x=1:31, 
  #                         y=Jan_Avg[,1],    # column 1, same as Jan_Avg (X2016)
  #                         color="2016")) +
  #   geom_line(mapping=aes(x=1:31,  
  #                         y=Jan_Avg[,2],    # column 2, same as Jan_Avg (X2017)
  #                         color="2017")) +
  #   geom_line(mapping=aes(x=1:31,
  #                         y=Jan_Avg[,3],    # column 3, same as Jan_Avg (X2018)
  #                         color="2018")) +
  #   theme_bw() + 
  #   labs(x = "Date",
  #        y = "Temp (Celsius)",
  #        color = "Year");
  # plot(plot3);
  # 
  # ### Part 4: Generalize the color (column names) mapping 
  # #   Note: Years became X2016, X2017, X2018 -- fix that in a bit...
  # plot4 = ggplot() +   
  #   geom_line(mapping=aes(x=1:31, 
  #                         y=Jan_Avg[,1],
  #                         color=colnames(Jan_Avg)[1])) +   
  #   geom_line(mapping=aes(x=1:31,  
  #                         y=Jan_Avg[,2],
  #                         color=colnames(Jan_Avg)[2])) +
  #   geom_line(mapping=aes(x=1:31,
  #                         y=Jan_Avg[,3],
  #                         color=colnames(Jan_Avg)[3])) +
  #   theme_bw() + 
  #   labs(x = "Date",
  #        y = "Temp (Celsius)",
  #        color = "Year");
  # plot(plot4);
  # 
  # 
  # ### Make this into an extension ###
  # ## Note that you have to generalize y and color, but not x
  # ### Part 5: Generalize the x (row names) mapping 
  # #   Note: This is not needed here -- but generalizing your code is good
  # #         programming practice
  # plot5 = ggplot() +   
  #   geom_line(mapping=aes(x=as.numeric(rownames(Jan_Avg)), # same as 1:31
  #                         y=Jan_Avg[,1],
  #                         color=colnames(Jan_Avg)[1])) +   
  #   geom_line(mapping=aes(x=as.numeric(rownames(Jan_Avg)), # 1:31,  
  #                         y=Jan_Avg[,2],
  #                         color=colnames(Jan_Avg)[2])) +
  #   geom_line(mapping=aes(x=as.numeric(rownames(Jan_Avg)), # 1:31,
  #                         y=Jan_Avg[,3],
  #                         color=colnames(Jan_Avg)[3])) +
  #   theme_bw() + 
  #   labs(x = "Date",
  #        y = "Temp (Celsius)",
  #        color = "Year");
  # plot(plot5);
  # 
  # 
  # ### Part 6: Use a for loop to plot all 7 lines
  # #   This will not work because of Lazy Evaluation 
  # #   Why this does not work is important to understand
  # plot6 = ggplot(); 
  # 
  # ### Cycle through the seven columns and make a line plot for each
  # for(i in 1:ncol(Jan_Avg))   # same as 1:7
  # {
  #   plot6 = plot6 + 
  #       geom_line(mapping=aes(x=1:31, 
  #                             y=Jan_Avg[,i],                # columns 1-7
  #                             color=colnames(Jan_Avg)[i])); # column names 1-7
  # }
  # plot(plot6);
  # 
  # 
  # #### Part 7: Stopping the Lazy Evaluation by forcing local variables
  # plot7 = ggplot(); 
  # 
  # for(i in 1:ncol(Jan_Avg))   # same as 1:7
  # { 
  #   # force local evaluation of i by replacing i with !!(i)
  #   plot7 = plot7 +
  #       geom_line(mapping=aes(x=1:31, 
  #                             y=Jan_Avg[,!!(i)],  
  #                             color=colnames(Jan_Avg)[!!(i)]));   
  # }
  # plot(plot7);
  # 
  # #### Part 8: Copy plot7 and append a theme and labels
  # #    Note: you could have started over and created the 7 lines again
  # plot8 = plot7 +
  #   theme_bw() + 
  #   labs(x = "Date",
  #        y = "Temp (Celsius)",
  #        color = "Year");
  # plot(plot8);
  # 
  ### Part 9: Make some changes to the plot
  # Convert from "X2016" to "2016" using substring to remove the first character
  yearNum = substring(colnames(Jan_Avg), first=2);

  plot9 = ggplot();   # create a new canvas

  for(i in 1:ncol(Jan_Avg))
  {
    plot9 = plot9 +    # append to plot9 the geom_line
        geom_line(mapping=aes(x=1:31,
                              y=Jan_Avg[,!!(i)],
                              color=yearNum[!!(i)]),  # change to substring
                  linewidth = 1.5);    # change the size of the line
  }
  
  otherVals = c(12,120,1200,12000);
  plot9 = plot9 +    # append these components
    theme_bw() + 
    scale_color_viridis(discrete = TRUE, # values are discrete (FALSE: continuous)
                        option = "H",    # options are A-H, default is D
                        direction = 1) + # -1 reverses colors
    scale_x_continuous(breaks = seq(0, 40, by =10),
                       labels = ~paste(., otherVals, sep = "\n"),
                       name = "Primary axis\nSecondary axis")
    labs(x = "Date",
         y = "Temp (\U00B0 C)",          # use unicode for the degree symbol
         color = "Year");
  plot(plot9);
  
  ### Viridis info:
  # https://www.rdocumentation.org/packages/viridis/versions/0.6.2/topics/scale_fill_viridis
}


