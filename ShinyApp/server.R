library(shiny)
source("model.R")

# server.R


shinyServer(
  function(input, output) {
    
    output$text1 <- renderText({
      input$userInput
    })
    
    wordOutput <- reactive({
      predict_word(input$userInput)
    })
    
    output$prediction <- renderDataTable({
      wordOutput()
    },
    options = list(dom = 't',searching = FALSE, autoWidth = TRUE))
    
  }
)
