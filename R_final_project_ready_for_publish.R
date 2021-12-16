#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(dplyr)
library(ggplot2)
library(shinyWidgets)
library(dslabs)
library(plotly)
library(tidyverse)
library(shiny)
library(tidyverse)
library(readr)
library(broom)
library(rlang)
library(readxl)

tobacco_data <- read_excel("C:/Users/caleb/OneDrive/Desktop/School/PHP2560 Statistical Programming with R/final_project/Tobacco_Use_Data_for_1995-2010.xls")
tobacco_data$year_2 <- tobacco_data$year^2
#head(tobacco_data)


lmp <- function (modelobject) {
    if (class(modelobject) != "lm") stop("Not an object of class 'lm' ")
    p <- summary(modelobject)$coefficients[ ,4][3]
    return(p)
}


get_model <- function(State, Year1, Var) {
    
    tobacco_data <- tobacco_data %>%
        filter(state==!!(State) & year <= Year1)
    
    formula <- paste(Var, "~year")
    linear_model <- lm(formula = formula, data = tobacco_data)
    
    formula2 <- paste(Var, "~year", "+ year_2")
    quad_model <- lm(formula = formula2, data = tobacco_data)
    quad_p <- lmp(quad_model)
    
    if(quad_p < 0.05){
        best_model = quad_model
    }else{
        best_model = linear_model
    }
    return(best_model)
}

predict_model <- function(State, Year1, Year2, Var) {
    dist <- Year2 - Year1
    
    tobacco_data1 <- tobacco_data %>%
        #filter(state==!!(State)) %>% 
        filter(state == State,
               year >= Year1,
               year <= Year2) 
    
    formula <- paste(Var, "~year")
    linear_model <- lm(formula=formula, data = tobacco_data1)
    
    formula2 <- paste(Var, "~year + year_2")
    quad_model <- lm(formula=formula2, data = tobacco_data1)
    quad_p <- lmp(quad_model)
    
    simulated_years <- matrix(ncol=3, nrow=dist)
    
    simulated_years[,1] <- seq(Year1+1,Year2,1)
    simulated_years[,2] <- seq(Year1+1,Year2,1)
    simulated_years[,2] <- (simulated_years[,2])^2
    
    simulated_years <- as.data.frame(simulated_years)
    colnames(simulated_years) <- c(c('year','year_2','outcome'))
    
    tobacco_data2 <- tobacco_data %>%
        filter(state==!!(State) & year <= Year2)
    
    if(quad_p > 0.05){
        best_model = linear_model
        simulated_years$outcome <- predict(linear_model, newdata=simulated_years)
        
        ggplot() +
            geom_line(data=simulated_years, aes(x=year, y=outcome),size=1, alpha=0.5, color="red") +
            geom_point(data=simulated_years, aes(x=year, y=outcome),size=1, alpha=0.9, color="red") +
            geom_line(data=tobacco_data2, aes(x=year, y=!!sym(Var)),size=1, alpha=0.5, color="black") + #line graph over time to show changing rates
            geom_point(data=tobacco_data2, aes(x=year, y=!!sym(Var)),size=1, alpha=0.9, color="black") +
            labs(title = "Percentage of Selected Measure Over Time", x="Year", y="Percentage",
                 caption = "Data Source: CDC BRFSS Prevalence and Trends Data") +
            theme(
                plot.title = element_text(color = "blue", size = 20, face = "bold", hjust = 0.5),
                plot.caption = element_text(color = "blue", face = "italic"))
        
    }else{
        best_model = quad_model
        simulated_years$outcome <- predict(quad_model, newdata=simulated_years)
        
        ggplot() +
            geom_line(data=simulated_years, aes(x=year, y=outcome),size=1, alpha=0.5, color="red") +
            geom_point(data=simulated_years, aes(x=year, y=outcome),size=1, alpha=0.9, color="red") +
            geom_line(data=tobacco_data2, aes(x=year, y=!!sym(Var)),size=1, alpha=0.5, color="black") + #line graph over time to show changing rates
            geom_point(data=tobacco_data2, aes(x=year, y=!!sym(Var)),size=1, alpha=0.5, color="black") +
            labs(title = "Percentage of Selected Measure Over Time", x="Year", y="Percentage",
                 caption = "Data Source: CDC BRFSS Prevalence and Trends Data") +
            theme(
                plot.title = element_text(color = "blue", size = 20, face = "bold", hjust = 0.5),
                plot.caption = element_text(color = "blue", face = "italic"))
    }
}


# Define UI for application that draws a histogram
ui <- fluidPage(
    
    # Application title
    titlePanel("Tobacco Use in the U.S. 1990 - 2030"),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            
            selectizeInput("measureInput", "Measure",
                           choices = c("Smoke Everyday" = "smoke_everyday",
                                       "Smoke Somedays" = "smoke_some_days",
                                       "Former Smoker" = "former_smoker",
                                       "Never Smoked" = "never_smoked"),  
                           selected=c("tobacco_data$smoke_everyday")),
            
            selectizeInput("stateInput", "State",
                           choices = unique(tobacco_data$state),  
                           selected="Virginia", multiple =FALSE),
            
            sliderInput("yearInput", "Year", min=1995, max=2030, 
                        value=c(1995, 2010), sep="")
            
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("plot")
        )
    )
)


# Define server logic required to draw a line graph
server <- function(input, output) {
    
    d <- reactive({
        #filtered <-
        #    tobacco_data %>%
        #    filter(state == input$stateInput,
        #           year >= input$yearInput[1],
        #           year <= input$yearInput[2]) 
        predict_model(input$stateInput, input$yearInput[1], input$yearInput[2],
                      input$measureInput)
    })
    
    output$plot <- renderPlot({
        
        # draw the line graph 
        d()
        
    })
} 

# Run the application 
shinyApp(ui = ui, server = server)
