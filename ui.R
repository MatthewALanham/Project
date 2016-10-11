library(shiny)
library(ggvis)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Movies- A 100 Year Story"),
  
  sidebarLayout(
    #Graph Slider Inputs
    sidebarPanel(
      sliderInput(inputId = "Month",
                  label = "Month the Movie was released",
                  value = c(1,12), min = 1, max = 12),
      
      sliderInput(inputId = "Year",
                  label = "Year the Movie was released",
                  value = c(1915,2016), min = 1915, max = 2015),
      
      sliderInput(inputId = "Budget",
                  label = "The budget of the movie (millions)",
                  value = c(0,450), min = 0, max = 450),
      
      sliderInput(inputId = "Domestic_Grossing",
                  label = "The Domestic Grossing of the movie (millions)",
                  value = c(0,770), min = 0, max = 770),
      
      sliderInput(inputId = "Worldwide_Grossing",
                  label = "The Worldwide Grossing of the movie (millions)",
                  value = c(0,2800), min = 0, max = 2800)
    ),
    
    #Main Panel Outputs (Graphs)
    mainPanel(
      wellPanel(
        plotOutput(outputId="distplot")
      ),
      wellPanel(
        plotOutput(outputId="budgPlot")
      ),
      textOutput(outputId="n_movies")
    )
  ),
  
  #Title for predictors
  wellPanel(
    h4("WORLDWIDE GROSSINGS PREDICTOR")
  ),
  #Get inputs for predictors
  wellPanel(
    textInput(inputId="predMonth",
              label="Release Month (1 for Jan, 2 for Feb...)"),
    textInput(inputId="prodBudget", label="Production Budget ($M)"),
    textInput(inputId="dmarketingBudget", label = "Domestic Marketing Budget ($M)"),
    textInput(inputId="dGrossings", label = "Domestic Grossings ($M)"),
    textInput(inputId="wwMarketing", label = "Worldwide Marketing Budget ($M)"),
    actionButton(inputId = "predictWW", label = "Predict Worldwide Grossings")
  ),
  
  #Location for Regression Outputs
  wellPanel(
    h5("Expected Worldwide Earnings"),
    textOutput(outputId="expWW"),
    h5("Release Decision"),
    textOutput(outputId="decision")
  )
))