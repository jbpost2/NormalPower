###########################################################################
##R Shiny App to visualize normal approximations distributions
##Justin Post - Fall 2015
###########################################################################
  
#Load package
library(shiny)

# Define UI for application that draws the prior and posterior distributions given a value of y
shinyUI(fluidPage(
  
  # Application title
  titlePanel("One-Sample Normal Hypothesis Test Power App"),
  withMathJax(),
  # Sidebar with a slider input for the number of successes
  fluidRow(
    column(3,br(),
      numericInput("mu0",'Null Mean, \\(\\mu_0\\)',value=0,step=0.1),
      numericInput("sigma",'True Standard Deviation, \\(\\sigma\\)',value=1,step=0.05,min=0),
     numericInput("muA","Alternative Mean, \\(\\mu_A\\)",value=0.5,step=0.11),
     selectizeInput("HA","Alternative Relationship",selected="Greater Than",choices=c("Greater Than","Less Than","Not Equal")),
     numericInput("sampleSize","Sample Size, n",value=5,min=1),
     numericInput("alpha","Significance Level, \\(\\alpha\\)",value=0.05,min=0,max=1,step=0.001)
     ),
      
    #Show a plot of the distribution  
    column(9,
           fluidRow(
           plotOutput("powerPicPlot")
         ), 
         fluidRow(
           uiOutput("stats")
         )
    )
  )
))

