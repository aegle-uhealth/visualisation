library(shiny)
library(shinydashboard)
library(ggplot2)
library(plotly)
#library(highcharter)
library(dygraphs)
library(zoo)


shinyServer(function(input, output, session) {
  
  
  
  myque <- reactive({
    mquery <- parseQueryString(session$clientData$url_search)
    myquery1 <- print(mquery[['test']])
  })
  
  
  
  require(rJava)
  require(rhdfs)
  require(plyr)
  require(data.table)
  hdfs.init()
  
  #hdfs_path <- isolate(myque())
  # 
  # 
  hdfs_path <- '/CLL/123_analytics_filterin.csv'
  
  result <- list() 
  i <- 1 
  
  handle <-hdfs.line.reader(hdfs_path) 
  content <- handle$read()
  while(length(content) != 0) {
    result[[i]]<-read.csv(textConnection(content), sep = ";", stringsAsFactors = FALSE, header=TRUE, fill=TRUE)
    content <-handle$read()
    i <- i + 1
  }
  
  local_df <- rbindlist(result)
  local_df <- as.data.frame(local_df)
  
  # f = hdfs.file(hdfs_path,"r",buffersize=5242880)
  # m = hdfs.read(f)
  # con = rawToChar(m)
  
  # if (hdfs_path == "/ICU/bennetPre.csv"){
  # local_df <<- read.table(textConnection(con), sep = ",", header=TRUE, fill=TRUE)[,c(1,64:82)]
  # }
  # else {
  # local_df <<- read.table(textConnection(con), sep = ",", header=TRUE, fill=TRUE)
  # }
  # 
  #local_df <<- read.csv("./bennetPre.csv", header = TRUE, sep=",", fill=TRUE)[,c(1,64:82)]
  
  
  output$choose_columns <- renderUI({
    cn <- colnames(local_df)
    tags$div(align = "left",width = "100px", display = "inline-block",
             checkboxGroupInput("checkGroup", "Choose columns", 
                                choices  = (cn[2:length(cn)]),
                                selected = 1
             ))
  })
  
  # output$choose_columns2 <- renderUI({
  #   tags$div(align = "left",width = "100px", display = "inline-block",
  #            checkboxGroupInput("checkGroup", "Choose columns", 
  #                               choices  = (cn[2:length(cn)]),
  #                               selected = choices
  #            ))
  # })
  
  
  # output$gotText <<- reactive(function(){
  #   ac <- cn[5]
  #   return(ac)
  # })
  
  # output$contents <- reactive({
  # 
  #   dae1 <- cn[1]
  #   assign('dae',dae1,envir=.GlobalEnv)
  #   print(summary(dae))
  # })
  # 
  #dae1 <<- cn[1]
  
  # 
  # output$plots <- renderUI({
  #   plot_output_list <- 
  #     lapply(input$checkGroup,
  #            function(i){ 
  #              plotlyOutput(paste0("plot", i))
  #              #uiOutput(paste0("slider", i))
  #            })
  #   do.call(tagList, plot_output_list)
  # })
  # 
  # # Render Line plot
  # output$Lineplots <- renderUI({
  #   plot_output_list <-
  #     lapply(input$checkGroup,
  #            function(i){
  #              dygraphOutput(paste0("Lineplot", i))
  #              #uiOutput(paste0("slider", i))
  #            })
  #   do.call(tagList, plot_output_list)
  # })
  # 
  # output$sliders <- renderUI({
  #   slider_output_list <- 
  #     lapply(input$checkGroup,
  #            function(i){ 
  #              #plotlyOutput(paste0("plot", i))
  #              uiOutput(paste0("slider", i))
  #            })
  #   do.call(tagList, slider_output_list)
  # })
  # 
  # output$Linesliders <- renderUI({
  #   slider_output_list <- 
  #     lapply(input$checkGroup,
  #            function(i){ 
  #              #plotlyOutput(paste0("plot", i))
  #              uiOutput(paste0("sliderLine", i))
  #            })
  #   do.call(tagList, slider_output_list)
  # })
  # 
  # 
  # v <- reactiveValues(doPlot = FALSE, doLinePlot = FALSE)
  # 
  # observeEvent(input$histt, {
  #   v$doPlot <- input$histt
  # })
  # 
  # observeEvent(input$linee, {
  #   v$doLinePlot <- input$linee
  # })
  # 
  # 
  # observe({
  #   if (v$doPlot == FALSE) return()
  #   isolate({
  #     for (i in input$checkGroup) {
  #       local({
  #         local_i <- i
  #         
  #         
  #         # dati2 <- select(datDF, local_i )
  #         # local_df <- collect(dati2)
  #         # colnames(local_df) <- local_i
  #         
  #         
  #         local_df2 <- cbind(local_df[, local_i])
  #         
  #         if (is.numeric(local_df2) || is.integer(local_df2) == TRUE ){
  #           mini <- min(local_df2, na.rm = TRUE)
  #           maxi <- max(local_df2, na.rm = TRUE)
  #         } else {}
  #         
  #         
  #         
  #         output[[paste0("plot", local_i)]] <- 
  #           renderPlotly({
  #             
  #             x_local <- input[[paste0("slider", local_i)]]
  #             
  #             #local_df2 <- local_df2[local_df2[[local_i]] > x_local[1] & local_df2[[local_i]] < x_local[2], ]
  #             local_df2 <- subset(local_df2, local_df2 > x_local[1] & local_df2 < x_local[2])
  #             local_df3 <- as.data.frame(local_df2)
  #             colnames(local_df3) <- local_i
  #             
  #             
  #             
  #             
  #             pu <- ggplot(data = local_df3, aes_string(local_i)) + geom_histogram(aes(stat = "count", position = "stack", fill = ..count..))
  #             ggplotly(pu)
  #             
  #           })
  #         
  #         
  #         
  #         output[[paste0("slider", local_i)]] <-
  #           
  #           renderUI({
  #             sliderInput(paste0("slider",local_i), "Select range:", min = mini, max = maxi, value = c((maxi/3),(maxi/2)) , step = 5)
  #             
  #             # switch(class(local_df2),
  #             #        
  #             #        "numeric" = sliderInput(paste0("slider",local_i), paste0("Select", local_i, "range:"), min = mini, max = maxi, value = c((maxi/3),(maxi/2)) , step = 5),
  #             #        "integer" = sliderInput(paste0("slider",local_i), paste0("Select", local_i, "range:"), min = mini, max = maxi, value = c((maxi/3),(maxi/2)) , step = 5),
  #             #        "factor"  = return()
  #             # )
  #             
  #           })
  #       })
  #     }
  #   })
  # })
  # 
  # observe({
  #   if (v$doLinePlot == FALSE) return()
  #   isolate({
  #     for (i in input$checkGroup) {
  #       local({
  #         local_i <- i
  #         
  #         #local_df2 <- cbind(local_df[, local_i])
  #         
  #         #if (is.numeric(local_df2) || is.integer(local_df2) == TRUE ){
  #         mini <- min(local_df$timestamp, na.rm = TRUE)
  #         maxi <- max(local_df$timestamp, na.rm = TRUE)
  #         #} else {}
  #         
  #         
  #         
  #         
  #         output[[paste0("Lineplot", local_i)]] <- renderDygraph({
  #           
  #           x_local <- input[[paste0("sliderLine", local_i)]]
  #           
  #           
  #           local_df2 <- local_df[, c("timestamp", local_i)]
  #           local_df3 <- local_df2[local_df2[["timestamp"]] > x_local[1] & local_df2[["timestamp"]] < x_local[2], ]
  #           
  #           local_df.zoo <- zoo(local_df3[, local_i], order.by = local_df3$timestamp)
  #           local_ts <- as.ts(local_df.zoo)
  #           
  #           # x_local <- input[[paste0("slider", local_i)]]
  #           # 
  #           # local_df2 <- subset(local_df2, local_df2 > x_local[1] & local_df2 < x_local[2])
  #           # local_df3 <- as.data.frame(local_df2)
  #           # colnames(local_df3) <- local_i
  #           
  #           dygraph(local_ts, ylab = local_i)
  #           
  #         })
  #         
  #         output[[paste0("sliderLine", local_i)]] <-
  #           
  #           renderUI({
  #             sliderInput(paste0("sliderLine",local_i), "Select range:", min = mini, max = maxi, value = c((maxi/3),(maxi/2)))
  #           })
  #         
  #       })
  #     }
  #   })
  # })
  
  output$DiaTable = renderDataTable({
    library(ggplot2)
    local_df[, input$checkGroup, drop = FALSE]
  })
  
  # observe({
  #   if (v$Table == FALSE) return()
  #   isolate({
  #     for (i in input$checkGroup) {
  #       local({
  #         local_i <- i
  #         
  #         output[[paste0("Table",local_i)]] <- renderDataTable({
  #           library(ggplot2)
  #           local_df[, input$checkGroupTab, drop = FALSE]
  #         })
  #         
  #       })
  #     }
  #   })
  # })
  
  
  
  
  
  
  
  # output$plot <- renderPlotly({
  #   if (v$doPlot == FALSE) return()
  #   
  #   isolate({
  #     x <- if(is.null(input$checkGroup[1]))
  #       return()
  #     else
  #       input$checkGroup[1]
  #     
  #     #x <- x[data$checkGroup[1] > input$BMIslider[1] & data$checkGroup[1] < input$BMIslider[2], ]
  #     labelx <- names(fooChoices[fooChoices==input$checkGroup[1]])
  #     #dataU <- data[data[[labelx]],]
  #     dataU <- data[data[[labelx]] > input$BMIslider[1] & data[[labelx]] < input$BMIslider[2], ]
  #     
  #     pu <- ggplot(data = dataU, aes_string(x = x)) + geom_histogram(aes(stat = "count", position = "stack", fill = ..count..))
  #     ggplotly(pu)
  #   })
  # })
  
  #   output$plot <- renderPlotly({
  #     x <- if(is.null(input$checkGroup[1]))
  #       return()
  #     else
  #       input$checkGroup[1]
  #     
  #     y <- if(is.null(input$checkGroup[2]))
  #       return()
  #     else
  #       input$checkGroup[2]
  #     
  #     #x <- x[data$checkGroup[1] > input$BMIslider[1] & data$checkGroup[1] < input$BMIslider[2], ]
  #     #y <- y[data$checkGroup[1] > input$BMIslider[1] & data$checkGroup[1] < input$BMIslider[2], ]
  #     labelx <- names(fooChoices[fooChoices==input$checkGroup[1]])
  #     labely <- names(fooChoices[fooChoices==input$checkGroup[2]])
  #      data3 <- data[data[[labelx]] > input$BMIslider[1] & data[[labelx]] < input$BMIslider[2], ]
  # #      x  <- data3$labelx
  # #      y <- data3$labely
  #     
  #     #x <- subset(x, x > input$BMIslider[1] && x < input$BMIslider[2])
  #     #xx <- subset(x, x > input$BMIslider[1] && x < input$BMIslider[2])
  #     
  #     
  #     p <- (ggplot(data3) + geom_point(aes_string(x, y, colour=x))
  #           + ggtitle(text()) +  labs(x= labelx,y= labely))
  #     # p <- plot_ly(data3, x = x, y = x, type = "scatter")
  #     pp <- ggplotly(p, mode = "markers")
  #     print(pp)
  #     
  #   })
  
  
  
  
}
)

#shinyApp(ui = ui, server = server)

