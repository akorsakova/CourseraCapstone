library(shiny)
library(shinythemes)

# ui.R

shinyUI(fluidPage(theme = shinytheme("journal"),
  titlePanel("SwiftKey Capstone Project"),
  br(),  
  
  sidebarLayout(
    sidebarPanel(
      helpText("This application will try to predict the next word in your sentence."),
      textInput("userInput", "Enter your partial sentence here:", "Today is the"),
      submitButton("Give me the predictions!")
    ),
    
    mainPanel(
      h3("You entered:"),
      textOutput("text1"),
      br(),
      h3("The application predicted:"),
      dataTableOutput("prediction")
    )
  )
))
