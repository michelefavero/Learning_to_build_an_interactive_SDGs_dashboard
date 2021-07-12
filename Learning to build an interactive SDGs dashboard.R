install.packages("readr") # Uploading data
install.packages("dplyr") # Data management
install.packages("assertive") # Data Cleaning, coverting data types 
install.packages("stringr") # Data Adjustments 
install.packages("ggplot2") # Data visualization
install.packages("plotly") # Interactive charts 
install.packages("DT") # Data tables interface 

library(readr)
library(dplyr)
library(assertive)
library(stringr)
library(ggplot2)
library(plotly)
library(shiny) # Building shiny apps
library(DT) # It provides an interface to the JavaScript library


#Datasets that can be uploaded:

library(readxl)
Papua_New_Guinea_SDG_Data <- read_excel("Desktop/Papua New Guinea SDG Data.xlsx")
View(Papua_New_Guinea_SDG_Data)

library(readxl)
PNG_biodiversity <- read_excel("Desktop/PNG_biodiversity.xlsx")
View(PNG_biodiversity)

library(readxl)
png_earthquake_health_facility_status <- read_excel("Desktop/png-earthquake-health-facility-status.xlsx")
View(png_earthquake_health_facility_status)


Papua_New_Guinea_SDG_Data
top_10_indicators_1 <- Papua_New_Guinea_SDG_Data %>%
  filter(Year == Year) %>%
  filter(Year == Year) %>%
  top_n(10, "Total population")

top_10_indicators_1

  
# UI = User interface
  
  ui <- fluidPage(
    titlePanel("Papua New Guinea SDGs, Draft 1"),
    theme = shinythemes::shinytheme("paper"),
    sidebarLayout(
      sidebarPanel(
        selectInput("Year", "Choose Year", top_10_indicators_1$Year),
        #sliderInput("Year", "Choose Year", min = 1960, max = 2020, value = 1960),
        selectInput("PNG_category", "Biodiversity Category", PNG_biodiversity$PNG_category),
        selectInput("District_Name", "District Name", png_earthquake_health_facility_status$District_Name),
      ),
      mainPanel(
        tabsetPanel(
          tabPanel("Population Chart", plotly::plotlyOutput("plot_top_10_indicators")),
          tabPanel("Indicators Table", DT::DTOutput("table_top_10_indicators")),
          tabPanel("Biodiversity Table", DT::DTOutput("table_PNG_biodiversity")),
          tabPanel("Districts and Health Facilities Table", DT::DTOutput("table_png_earthquake_health_facility_status"))
        )
      )
    )  
    
    
  )




# Server function
server <- function(input,
                   output, 
                   session) {
  plot_SDG_indicators <- function(){
    Papua_New_Guinea_SDG_Data %>%
      filter(Year == input$Year) %>%
      filter(Year == input$Year) %>%
      top_n(10, "Total population") %>%
      ggplot(aes(x = Year, y = "Total population")) +
      geom_jitter(fill = "#263e63")
    
  }
  
  output$plot_top_10_indicators <- plotly::renderPlotly({
    plot_SDG_indicators()
  })
  
  
  output$table_top_10_indicators <- renderDT({
    Papua_New_Guinea_SDG_Data %>%
      filter(Year == input$Year)
    
  })
  
  output$table_PNG_biodiversity <- renderDT({
    PNG_biodiversity %>%
      filter(PNG_category == input$PNG_category)
    
  })
  
  output$table_png_earthquake_health_facility_status <- renderDT({
    png_earthquake_health_facility_status %>%
      filter(District_Name == input$District_Name)
    
  })
  
  
  
}




# Running the app

shinyApp(ui = ui, server = server)


