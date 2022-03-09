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
    titlePanel("A simple RShiny example"),

    # Sidebar with a slider input for number of bins 
    flowLayout(
      # sidebarPanel(
      sliderInput(inputId = "Age",
                  label = "My age:",
                  min = 1,
                  max = 50,
                  value = 20),   # default value,
      selectInput(inputId = "Animal",
                  label = "My favorite animal:",
                  choices = c("llama" = "llama", 
                              "guanaco" = "guanaco",
                              "alpaca" = "alpaca"),
                  selected = "llama"
      ),
      textInput(inputId = "Name",
                label = "my name:"),
      radioButtons(
        inputId = "Cheese",
        label = "My Favorite Cheese",
        choices = c("muenster" = "muenster", "swiss" = "swiss", 
                    "cheddar" = "cheddar"))
    ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )


# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
      cat("Hello, World, my name is", input$Name, 
          ". I am", input$Age, "years old.",
          "My favorite animal is the", input$Animal,
          "And my favorite cheese is", input$Cheese, "\n\n");
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
