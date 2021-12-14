#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Lansing Weather Test"),

    # Sidebar with a slider input for number of bins 
     flowLayout(
       # sidebarPanel(
            sliderInput(inputId = "size",
                        label = "Size of points:",
                        min = 0.5,
                        max = 5,
                        value = 2.5),   # default value,
            selectInput(inputId = "tempCol",
              label = "Temperature Column",
              choices = c("Average" = "avgTemp", 
                          "High" = "maxTemp",
                          "Low" = "minTemp"),
              selected = "Average"
            ),
            radioButtons(
              inputId = "subset",
              label = "Reduce points",
              choices = c("1" = 1, "1/2" = 2, "1/3" = 3))
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
     weatherData = read.csv(file="../data/LansingNOAA2016-3.csv",
                           stringsAsFactors = FALSE);
      springIndex = grep(weatherData$date, pattern="3-21");
      summerIndex = grep(weatherData$date, pattern="6-21");
      fallIndex = grep(weatherData$date, pattern="9-21");
      winterIndex = grep(weatherData$date, pattern="12-21");
      
      subsetData = subset(weatherData, X %% as.numeric(input$subset) == 0);
      thePlot = ggplot(data=subsetData) +
        geom_text(mapping=aes_string(x=input$tempCol, y="relHum",
                              color="1:nrow(subsetData)", 
                              label="date"),
                  size=input$size) +
        scale_color_gradientn(colors=c("blue","green","red","brown","blue"),
                              values=c(0, 0.2, 0.55, 0.85, 1),
                              breaks=c(winterIndex, springIndex,
                                       summerIndex, fallIndex),
                              labels=c("winter","spring","summer","fall")) +
        scale_x_continuous(limits = c(0, 90)) +
        theme_bw() +
        theme(panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              legend.key.height = unit(15, units="pt"),
              legend.key.width = unit(40, units="pt"),
              legend.direction = "horizontal",
              legend.position = c(0.25, 0.08)) +
        labs(title = paste("Humidity vs." ,input$tempCol),
             subtitle = "Lansing, Michigan: 2016",
             x = "Degrees (Fahrenheit)",
             y = "Relative Humidity",
             color = "");
      plot(thePlot);
    }, width=800, height=800)
}

# Run the application 
shinyApp(ui = ui, server = server)
