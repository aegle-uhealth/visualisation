library(shiny)
library(shinydashboard)
library(ggplot2)
library(plotly)
require(SparkR)


shinyServer(function(input, output, session) {
  

  
  

 
  
 
   # output$myquery <- renderText({
   #   query <- parseQueryString(session$clientData$url_search)
   #   query1 <- deparse(query[['test']])
   #   #dae[['b']] <- query1
   #   #assign(dae[['b']],query1, envir = .GlobalEnv)
   #   #print(summary(dae))
   #   #isolate(query1)
   # })
   # 
   myque <- reactive({
    mquery <- parseQueryString(session$clientData$url_search)
    #mquery1 <- deparse(mquery[['test']])
    myquery1 <- print(mquery[['test']])
  })
  
   require(rJava)
   require(rhdfs)
   require(plyr)
   require(data.table)
   
   hdfs.init()
   
   hdfs_path <- isolate(myque())
   
   #hdfs_path = "/visualization/Dummy_dataset_refined_short.csv"
   
   result <- list() 
   i <- 1 
   
   handle <-hdfs.line.reader(hdfs_path) 
   content <- handle$read()
   while(length(content) != 0) {
     result[[i]]<-read.csv(textConnection(content), sep = ",", stringsAsFactors = FALSE)
     content <-handle$read()
     i <- i + 1
   }
   
   local_df <- rbindlist(result)
   local_df <- as.data.frame(local_df)
   #local_df <<- do.call("rbind",result)    
   #local_df <<- result
   
   
   
   # if (hdfs_path == "/visualization/Dummy_dataset_refined_short.csv"){
   #   local_df <<- read.table(textConnection(con), sep = ",", header=TRUE, fill=TRUE)[,c(1,64:82)]
   # }
   # else {
   #   local_df <<- read.table(textConnection(con), sep = ",", header=TRUE, fill=TRUE)
   # }
   
    #hdfs_path <- isolate(myque())
    # f = hdfs.file(hdfs_path,"r",buffersize=5242880)
    # m = hdfs.read(f)
    # con = rawToChar(m)
    # local_df <<- read.table(textConnection(con), sep = ",", header=TRUE, fill=TRUE)
    
  

 
#local_df <- isolate(dframe())
  
  
  
  output$choose_columns <- renderUI({
    cn <- colnames(local_df)
       checkboxGroupInput("checkGroup", "Choose columns", 
                choices  = cn,
                selected = 1
                )
  })
  
 
  
  output$plots <- renderUI({
    plot_output_list <- 
      lapply(input$checkGroup,
             function(i){ 
               plotlyOutput(paste0("plot", i))
               #uiOutput(paste0("slider", i))
             })
    do.call(tagList, plot_output_list)
  })
  
  output$sliders <- renderUI({
    slider_output_list <- 
      lapply(input$checkGroup,
             function(i){ 
               #plotlyOutput(paste0("plot", i))
               uiOutput(paste0("slider", i))
             })
    do.call(tagList, slider_output_list)
  })
  
  
  v <- reactiveValues(doPlot = FALSE)
  
  observeEvent(input$histt, {
    v$doPlot <- input$histt
  })
  
  
  observe({
    if (v$doPlot == FALSE) return()
    isolate({
    for (i in input$checkGroup) {
      local({
        local_i <- i
      
        
            # dati2 <- select(datDF, local_i )
            # local_df <- collect(dati2)
            # colnames(local_df) <- local_i
            # 
            # 
             local_df2 <- local_df[, local_i]
            
            local_df2 <- cbind(local_df[, local_i])
            
            
            if (is.numeric(local_df2) || is.integer(local_df2) == TRUE ){
              mini <- min(local_df2, na.rm = TRUE)
              maxi <- max(local_df2, na.rm = TRUE)
            } else {}
            
# 
#             local_df$mini <- mini
#             local_df$maxi <- maxi
#             
#            
#             colnames(local_df) <- c(local_i, "mini", "maxi")
            
          
        
        output[[paste0("plot", local_i)]] <- 
          renderPlotly({
            
            x_local <- input[[paste0("slider", local_i)]]
         
            # local_df <- local_df[local_df[[local_i]] > x_local[1] & local_df[[local_i]] < x_local[2], ]
            # local_df3 <- as.data.frame(local_df)
            # colnames(local_df3) <- local_i
            
            local_df2 <- subset(local_df2, local_df2 > x_local[1] & local_df2 < x_local[2])
            local_df3 <- as.data.frame(local_df2)
            colnames(local_df3) <- local_i
         
            
            
            
            pu <- ggplot(data = local_df3, aes_string(local_i)) + geom_histogram(aes(stat = "count", position = "stack", fill = ..count..))
            ggplotly(pu)
            
          })
        
        
       
         output[[paste0("slider", local_i)]] <-
           
           renderUI({
             sliderInput(paste0("slider",local_i), "Select range:", min = mini, max = maxi, value = c((maxi/3),(maxi/2)) , step = 5)

           })
      })
    }
   })
  })
  
  
  
  
  
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

