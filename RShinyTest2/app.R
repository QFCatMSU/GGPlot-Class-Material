#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
# reactive outputs: https://shiny.rstudio.com/tutorial/written-tutorial/lesson4/

library(shiny)


# Define UI for application that draws a histogram
ui = fluidPage(

  # Application title
  titlePanel("A simple RShiny example"),

  flowLayout(
    mainPanel(
      HTML("<a style='color:blue;'> stuff</a>
           <br>
           <h4>More Stuff</h4>")
    ),
    sliderInput(inputId = "Age",
                label = "My age:",
                min = 1,
                max = 50,
                value = 20),         # default value,
    sliderInput(inputId = "DayNum",
                label = "Day #:",
                min = 1,
                max = 366,
                value = 70),         # default value,
    selectInput(inputId = "Animal",
                label = "My favorite animal:",
                choices = c("llama" = "llama", 
                            "guanaco" = "guanaco",
                            "alpaca" = "alpaca"),
                selected = "llama"),
    textInput(inputId = "Name",
              label = "my name:"),
    dateInput(inputId = "theDate",
              label= "dates...",
              min = "2006-02-01",
              max="2022-07-20",
              value="2016-06-28"),
    radioButtons(
      inputId = "Cheese",
      label = "My Favorite Cheese",
      choices = c("muenster" = "muenster", "swiss" = "swiss", 
                  "cheddar" = "cheddar"))
  ),

  # Show a plot of the generated distribution
  mainPanel(
     #plotOutput("distPlot")
    textOutput("text"),
    htmlOutput("htmlOut"),
    verbatimTextOutput("verb"),         
    verbatimTextOutput("verb2")
  )
)


# Define server logic required to draw a histogram
server = function(input, output) 
{
  # at server level, the working directory is where app.r is?
  ### Links in the script need to be relative to the server location (like RMarkDown)
  source("../Challenge.R", local=FALSE)  # why does local=true cause error in line 77?
  df2 = reactive(
  { 
    cat("ASDFASDFADSF\n");
    for(i in 1:5)
    {
      cat(input$Animal, "\n");
    }
  })
  
  ### Text output
  output$verb2 = renderPrint(
  {
    df2();    # calls a function...
  })  
  
  ### HTML output
  output$htmlOut = renderUI(
  {
    HTML(paste(weatherData$relHum[input$DayNum], 
               " <a style='color:blue;'>asdjhfkas</a>",
               "Hello, World, my name is<br/>", input$Name, 
               ". I am", input$Age, "years old.<br/>", sep=" ** ",
               "My favorite animal is the", input$Animal,
               "\nAnd my favorite cheese is", input$Cheese, "<br/><br/>"))
  }) 
  
  ### verbatim output -- gray box, includes line  breaks
  output$verb = renderText(
  { 
    paste("Today is", input$theDate, 
          ". I am", input$Age, "years old.\n", sep=" ** ",
          "My favorite animal is the", input$Animal,
          "\nAnd my favorite cheese is", input$Cheese, "\n\n") 
  }) 
  output$distPlot = renderPlot(
  {
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
