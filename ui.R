###########################################################################
##R Shiny App to visualize power and alpha for normal population testing
##with known variance.
##Justin Post - Fall 2015 (updated 2017)
###########################################################################
  
library(shiny)
library(shinydashboard)

# Define UI for application that displays an about page and the app itself

dashboardPage(skin="red",
  #add title
  dashboardHeader(title="One-Sample Normal Hypothesis Test Power App",titleWidth=750),
              
  #define sidebar items
  dashboardSidebar(sidebarMenu(
    menuItem("About", tabName = "about", icon = icon("archive")),
    menuItem("Application", tabName = "app", icon = icon("laptop"))
  )),
              
  #define the body of the app
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "about",
        fluidRow(
          #add in latex functionality if needed
          withMathJax(),
                
          #two columns for each of the two items
          column(6,
            #Description of App
            h1("What does this app do?"),
            #box to contain description
            box(background="red",width=12,
              h4("This application visualizes the relationship between the null and alternative distribution as well as the power and type I error rate when conducting a one-sample mean test from a normal parent population with known variance."),
              h4("In more detail, assume that you have a random sample of size n from a normal population with known variance but unknown mean $$Y_i\\stackrel{iid}\\sim N(\\mu,\\sigma^2),$$ \\(i=1,2,...,n\\)."),
              h4("The hypotheses of interest are $$H_0:\\mu=\\mu_0$$ vs $$H_A:\\mu>\\mu_0~~or~~\\mu<\\mu_0~~or~~\\mu\\neq\\mu_0$$"),
              h4("The type I error rate, \\(P(\\mbox{Reject }H_0|H_0\\mbox{ true})\\), is set prior to seeing the data and is denoted by \\(\\alpha\\)."),
              h4("The type II error rate, \\(P(\\mbox{Fail to Reject }H_0|H_A\\mbox{ true})\\), is denoted by \\(\\beta\\) and Power is defined as \\(Power = 1 - \\beta\\).  These two quantities can be found for a given value of the mean in the range of the alternative hypothesis, denoted as \\(\\mu_A\\).")
            )
          ),
                
          column(6,
            #How to use the app
            h1("How to use the app?"),
            #box to contain description
            box(background="red",width=12,
              h4("The controls for the app are located to the left and the visualization and information are available on the right."),
              h4("The null hypothesis mean value, \\(\\mu_0\\), and the value of interest in the range of the alternative hypothesis, \\(\\mu_A\\), can be chosen by the top left input boxes."),
              h4("Below these boxes, the user can control the assumed standard deviation of the population as well as the size of the sample to be selected."),
              h4("The above four boxes define the curves given on the graph on the right."),
              h4("On the bottom left, the user can specify the direction of the alternative hypothesis and the significance level, \\(\\alpha\\), of the test."),
              h4("The areas that correspond to \\(\\alpha\\) and \\(\\beta\\) are shaded on the graph.  Below the graph, information is provided on \\(\\alpha\\) and the calculated values of Power and \\(\\beta\\)."),
              h4("Lastly, on the bottom right, the distribution of \\(\\bar{Y}\\) is given under both the null and alternative hypotheses.")
            )
          )
        )
      ),
      
      #actual app layout      
      tabItem(tabName = "app",
        fluidRow(
          column(3,br(),
            numericInput("mu0",'Null Mean, \\(\\mu_0\\)',value=0,step=0.1),
            numericInput("muA","Alternative Mean, \\(\\mu_A\\)",value=0.5,step=0.11),
            numericInput("sigma",'True Standard Deviation, \\(\\sigma\\)',value=1,step=0.05,min=0),
            numericInput("sampleSize","Sample Size, n",value=5,min=1),
            selectizeInput("HA","Alternative Relationship",selected="Greater Than",choices=c("Greater Than","Less Than","Not Equal")),
            numericInput("alpha","Significance Level, \\(\\alpha\\)",value=0.05,min=0,max=1,step=0.001)
          ),
        
          #Show a plot of the distribution  
          column(9,
            fluidRow(
              box(width=12,plotOutput("powerPicPlot"))
            ), 
            fluidRow(
              box(title="Probabilities",uiOutput("typeII")),
              box(title="Distributions of \\(\\bar{Y}\\)",uiOutput("dists"))
            )
          )
        )
      )
    )
  )
)
