suppressMessages(library(shiny))
suppressMessages(library(shinythemes))
suppressMessages(library(dplyr))
suppressMessages(library(markdown))
suppressMessages(library(ggplot2))
suppressMessages(library(tidyverse))


data <- read.csv("https://raw.githubusercontent.com/nedeinlein/CaseStudy2DDS/main/BaseData.csv")

ui <-navbarPage("EDA Tool", theme = shinytheme("slate"),
                tabPanel("Scatterplot",
                         sidebarLayout(
                           sidebarPanel(
                             #Select X Variable
                             selectInput("var1", label = h3("X Variable"), 
                                         choices = c("Age","BusinessTravel","DailyRate","Department","DistanceFromHome","Education","EducationField","EmployeeCount","EmployeeNumber","EnvironmentSatisfaction","Gender","HourlyRate","JobInvolvement","JobLevel","JobRole","JobSatisfaction","MaritalStatus","MonthlyIncome","MonthlyRate","NumCompaniesWorked","Over18","OverTime","PercentSalaryHike","PerformanceRating","RelationshipSatisfaction","StandardHours","StockOptionLevel","TotalWorkingYears","TrainingTimesLastYear","WorkLifeBalance","YearsAtCompany","YearsInCurrentRole","YearsSinceLastPromotion","YearsWithCurrManager"
), 
                                         selected = 1),


                             hr(),
                             fluidRow(column(3, verbatimTextOutput("value")))
                           ),
                           
                           # Main panel for displaying outputs ----
                           mainPanel(
                             
                             # Output: Histogram ----
                             plotOutput(outputId = "distPlot1")
                           )
                         )
                ),
tabPanel("Histogram",
         sidebarLayout(
           sidebarPanel(
             #Select X Variable
             selectInput("var2", label = h3("X Variable"), 
                         choices = c("Age","BusinessTravel","DailyRate","Department","DistanceFromHome","Education","EducationField","EmployeeCount","EmployeeNumber","EnvironmentSatisfaction","Gender","HourlyRate","JobInvolvement","JobLevel","JobRole","JobSatisfaction","MaritalStatus","MonthlyIncome","MonthlyRate","NumCompaniesWorked","Over18","OverTime","PercentSalaryHike","PerformanceRating","RelationshipSatisfaction","StandardHours","StockOptionLevel","TotalWorkingYears","TrainingTimesLastYear","WorkLifeBalance","YearsAtCompany","YearsInCurrentRole","YearsSinceLastPromotion","YearsWithCurrManager"
                         ), 
                         selected = 1),
             
             
             hr(),
             fluidRow(column(3, verbatimTextOutput("histogram")))
           ),
           
           # Main panel for displaying outputs ----
           mainPanel(
             
             # Output: Histogram ----
             plotOutput(outputId = "distPlot2")
           )
         )
),
                tabPanel("Summary",
                         verbatimTextOutput("summary")
                ),
                navbarMenu("More",
                           tabPanel("Table",
                                    DT::dataTableOutput("table")
                           ),
                           tabPanel("About",
                                    fluidRow(
                                      column(6,
                                             includeMarkdown("https://raw.githubusercontent.com/nedeinlein/Apps/main/Revenuetracker.About.rmd")
                                      ),
                                    )
                           )
                )
)



server <- function(input, output, session) {
  
  
  #reactive filters



  #Output Scatterplot
  output$distPlot1 <- renderPlot({
    df <- reactive({df1 <- as.data.frame(data %>% select(input$var1,MonthlyIncome)) %>% rename("X_Variable" = input$var1)})
    df3 <- df()
    df3 %>% ggplot(aes(x = X_Variable,y = MonthlyIncome, xlab = input$var1)) + geom_point(col = "blue")
  })
  
  output$distPlot2 <- renderPlot({
    df <- reactive({df1 <- as.data.frame(data %>% select(input$var2,Attrition)) %>% rename("X_Variable" = input$var2)})
    df3 <- df()
    df3 %>% ggplot(aes(x = X_Variable, fill = Attrition)) + geom_bar(position = 'Dodge')
  })
  #summary Output
  output$summary <- renderPrint({
    summary(data)
  })
  
  #table Output
  output$table <- DT::renderDataTable({
    DT::datatable(data)
  })
}

shinyApp(ui, server)
