library(shiny)
library(shinydashboard)
library(plotly)


shinyUI(dashboardPage(
  dashboardHeader(title = tags$li(class = "dropdown",  style="list-style-type: none;", tags$img(src="Logo1.png", height = "65px", width = "150px", type = "image"))),
  # dashboardSidebar(checkboxGroupInput("checkGroup", label = h3("Variables"),
  #                                     choices = fooChoices,
  #                                     selected = 1)),
  
  dashboardSidebar(
    uiOutput("choose_columns")
  ),
  
  dashboardBody(
    tags$head(tags$style(HTML('
        
        .skin-blue .main-header .logo {
                              background-color: #fff;
                              }')
    )),
    
    

    # Boxes need to be put in a row (or column)
    fluidRow(
      # column(width = 3,
      #        box(width = NULL, uiOutput("sliders"))),
      
      box(width = 4, uiOutput("sliders")),
      
      # mainPanel(
      #   h3("clientData values"),
      #   #textInput("text", "Text", "")),
      #   verbatimTextOutput("myquery")),

      absolutePanel( top = 400, width = 165,  draggable = TRUE,
                     wellPanel(HTML("<strong> Visualizations </strong>"), 
                               actionButton("barr",label = "", icon = tags$img(src="bar-chart.png", height = "100%", width = "100%")),
                               tags$style(type='text/css', "#barr { vertical-align: middle; height: 50px; width: 60px; font-size: 15px; background-color: #eee;}"),
                               actionButton("piee", label = "", icon =  tags$img(src="PieChart.png", height = "100%", width = "100%")),
                               tags$style(type='text/css', "#piee { vertical-align: middle; height: 50px; width: 60px; font-size: 15px; background-color: #eee;}"),
                               actionButton("linee",label = "", icon =  tags$img(src="Line-chart.png", height = "100%", width = "100%")),
                               tags$style(type='text/css', "#linee { vertical-align: middle; height: 50px; width: 60px; font-size: 15px; background-color: #eee;}"),
                               actionButton("boxp", label = "", icon =  tags$img(src="boxplot.png", height = "100%", width = "100%")),
                               tags$style(type='text/css', "#boxp { vertical-align: middle; height: 50px; width: 60px; font-size: 15px; background-color: #eee;}"),
                               actionButton("histt",label = "", icon =  tags$img(src="hist-chart.png", height = "100%", width = "100%")),
                               tags$style(type='text/css', "#histt { vertical-align: middle; height: 50px; width: 60px; font-size: 15px; background-color: #eee;}"),
                               actionButton("scat",label = "", icon =  tags$img(src="scatter.png", height = "100%", width = "100%")),
                               tags$style(type='text/css', "#scat { vertical-align: middle; height: 50px; width: 60px; font-size: 15px; background-color: #eee;}")                   
                               )
          ),
      #),
      
      # column(width = 8,
      #        box(width = NULL, uiOutput("plots"))
      # )
      box(width = 8, uiOutput("plots"))
    )
  )
)
)


#shinyApp(ui = ui, server = server)

