{
  library(ggplot2);
  
  df = data.frame(year=c(2015,2016,2017,2018), 
                  rateMI=c(.2, .3, .4, .5),
                  rateOH=c(.1, .2, .3, .4),
                  rateIL=c(.3, .4, .5, .6));

  thePlot = ggplot(data=df) +
    geom_col(mapping=aes(x=year, y=rateMI), 
             width=0.2,
             fill="red",
             position=position_nudge(x=0.2)) +
    geom_col(mapping=aes(x=year, y=rateOH), 
             width=0.2,
             fill="green",
             position=position_nudge(x=-0.2)) +
    geom_col(mapping=aes(x=year, y=rateIL), 
             fill="blue",
             width=0.2,
             position=position_nudge(x=-0)) +
    theme_bw();
  plot(thePlot);
  
  # This is just the above data frame "melted"
  df2 = data.frame(year=rep(c(2015,2016,2017,2018), times=3), 
                   state=(c(rep("MI", times=4), 
                            rep("OH", times=4), 
                            rep("IL", times=4))),
                   rate=c(.2, .3, .4, .5, 
                          .1, .2, .3, .4,
                          .3, .4, .5, .6));
  
  thePlot = ggplot(data=df2) +
    geom_bar(mapping=aes(x=year, y=rate, fill=state), 
             stat="identity",
             width=0.3,
             position=position_dodge()) +
    theme_bw();

  plot(thePlot);
}

