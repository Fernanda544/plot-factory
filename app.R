#install.packages("shiny")
library(shiny)
#install.packages("ggplot2")
library(ggplot2)
#install.packages("tidyverse")
library(tidyverse)

bcl <-  read.csv("bcl-data.csv",stringsAsFactors=FALSE)

#runExample("01_hello") #para testar

ui <- fluidPage(
  titlePanel("BC Liquor Store prices"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("priceInput", "Price", min=0, max=100, value = c(25,40), pre="$"),
      radioButtons("typeInput", "Product type", choices = c("BEER", "REFRESHMENT", "SPIRITS", "WINE"),selected = "WINE"),
      selectInput("countryInput", "Country", choices = c("CANADA", "FRANCE", "ITALY"))
    ),
    mainPanel(
      plotOutput("coolplot"),
      br(), br(),
      tableOutput("results")
    )
  )
) #usuário

server <- function (input, output, session) {
  filtered <- reactive({
    req(input$priceInput, input$typeInput, input$countryInput)
    
    bcl %>% 
      filter(
        Price >= input$priceInput [1],
        Price >= input$priceInput [2],
        Type == input$typeInput,
        Country == input$countryInput
      )
  })
  output$coolplot <- renderPlot({
    req(filtered)
    ggplot(filtered(), aes(Alcohol_Content)) + geom_histogram()
  })
  
  output$results <- renderTable({
    req(filtered)
    filtered()
  })
} #progamação

shinyApp(ui, server)

