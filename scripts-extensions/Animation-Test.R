{
  source(file="scripts/reference.R");  # this line will be in all your scripts
  weatherData = read.csv(file="data/LansingNOAA2016-3.csv", 
                         stringsAsFactors = FALSE);

  library(ggplot2)
 # library(gapminder)
  library(gganimate)
 # library(gifski)
  
  # transition by category
  plot1 = ggplot(data=weatherData) +
    geom_point(mapping=aes(x=avgTemp, y=relHum)) +
     labs(title = 'Temperature vs. Humidity in {closest_state}',
          subtitle = 'Lansing, MI - 2016',
          x = 'Average Temp', 
          y = 'Humidity') +
    transition_states(states=season, transition_length = 1,
                      state_length = 1, wrap = TRUE);
  print(plot1);
  
  ## standard ggplot2
  # myPlot = ggplot(data=gapminder) + 
  #   geom_point(mapping=aes(x=gdpPercap, y=lifeExp, size = pop, 
  #                          colour = country),
  #              alpha = 0.7, 
  #              show.legend = FALSE) +
  #   scale_colour_manual(values = country_colors) +
  #   scale_size(range = c(2, 12)) +
  #   scale_x_log10() +
  #   # Here comes the gganimate specific bits
  #   labs(title = 'Year: {frame_time}', 
  #        x = 'GDP per capita', 
  #        y = 'life expectancy') +
  #   transition_time(time=year) +
  #   ease_aes(default='linear');
  
  # animate(myPlot, 
  #         duration = 5, 
  #         fps = 20, 
  #         width = 200, 
  #         height = 200, 
  #         renderer = gifski_renderer());
#  anim_save("images/output.gif");
  
 # print(myPlot)
  
  # p <- ggplot(
  #   gapminder, 
  #   aes(x = gdpPercap, y=lifeExp, size = pop, colour = country)
  # ) +
  #   geom_point(show.legend = FALSE, alpha = 0.7) +
  #   scale_color_viridis_d() +
  #   scale_size(range = c(2, 12)) +
  #   scale_x_log10() +
  #   labs(x = "GDP per capita", y = "Life expectancy")
  # plot(p);
  # 
  # q = p + transition_time(year) +
  #   labs(title = "Year: {frame_time}")
  # 
  # animate(q, duration = 5, fps = 20, width = 200, height = 200,
  #         renderer = gifski_renderer())
  # anim_save(filename="this.gif", animation=q);

  # We'll start with a static plot
  # p <- ggplot(iris, aes(x = Petal.Width, y = Petal.Length)) +
  #   geom_point()
  # 
  # plot(p)
  # 
  # anim <- p +
  #   transition_states(Species,
  #                     transition_length = 2,
  #                     state_length = 1)
  # 
  # gganimate(anim, "output.gif")
  
  
  # a = ggplot(mtcars, aes(factor(cyl), mpg)) + 
  #   geom_boxplot() + 
  #   # Here comes the gganimate code
  #   transition_states(
  #     gear,
  #     transition_length = 2,
  #     state_length = 1
  #   ) +
  #   enter_fade() + 
  #   exit_shrink() +
  #   ease_aes('sine-in-out');
  # 
  # animate(a, fps = 10, width = 750, height = 450)
  # anim_save("a.gif")
}