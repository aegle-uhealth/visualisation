# library(shiny)
# require(plotly)
require(SparkR)
library(SparkR)
# 
#  #dat <- read.csv("C:/Aegle/Interface_visualization/plotly_aegle_ICU/bennetPre.csv", header = TRUE, sep=',')[,c(1,64:82)]
#  # dat <- hdfs.file("C:/Aegle/Interface_visualization/plotly_aegle/Dummy_dataset_refined_short.csv", "r")
#  # dat <- hdfs.read(dat)
#  #cn <- colnames(dat)
#  
# # # 
# # fooChoices <- list("BMI" = "End inspiratory pressure (PI END) in cmH2O (6 characters)",
# #                    "Blood Glucose levels" = "Respiratory rate (fTOT) in bpm (6 characters)",
# #                    "HbA1c levels" = "Exhaled tidal volume (VTE) in L (6 characters)",
# #                    "Age" = "DPatient exhaled minute volume (VE TOT) in L/min (6 characters)",
# #                    "Diabetes Type" = "Peak airway pressure (PPEAK) in cmH2O (6 characters)",
# #                    "BP systolic" = "Mean airway pressure (PMEAN) in cmH2O (6 characters)",
# #                    "BP Diastolic" = "Expiratory component of monitored value of I:E ratio, assuming inspiratory component of 1 (6 characters)")
# # 
# # Sys.setenv(SPARK_HOME = "C:/Apache/spark-1.6.2-bin-hadoop2.6")
# # .libPaths(c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib"),.libPaths()))
# # library(SparkR)
# # 
# # sc <- sparkR.init(master = "local")
# # sqlContext <- sparkRSQL.init(sc)
# # 
# # #dae <- reactiveValues()
# # 
# # #bb <- dae1()
# # 
# # #pathFile <- file.path(Sys.getenv("SPARK_HOME"), file = "C:/Aegle/Interface_visualization/plotly_aegle/Dummy dataset_refined_short.csv", header = TRUE, sep=',',quote="'")
# # #dat <- read.df(sqlContext, "C:/Aegle/Interface_visualization/plotly_aegle/Dummy_dataset_refined_short.csv")
# # 
# # # con = rawToChar(dat)
# # # datDF = read.csv(textConnection(con), sep = ",",header=TRUE)
# # 
# # datDF <- createDataFrame(sqlContext, dat)
# # cn <- colnames(datDF)
# # cn1 <- substring(cn, 1, 30)
# # 
# # dati2 <- select(datDF, "*" )
# # local_df <- collect(dati2)
# # #colnames(local_df) <- local_i
# 
# # --------------------------------------------------------------------------------------------------------------#
# 
# #dae <- reactiveValues()
 Sys.setenv(SPARK_HOME = "/home/manzoor_aegle/spark-1.6.2-bin-hadoop2.6")
 .libPaths(c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib"),.libPaths()))

 sc <- sparkR.init(master = "local")
 sqlContext <- sparkRSQL.init(sc)

 if (nchar(Sys.getenv("HADOOP_CMD")) < 1) {
   Sys.setenv(HADOOP_CMD = "/usr/local/hadoop/bin/hadoop")
 }

 Sys.setenv(HADOOP_STREAMING="/usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar")
 Sys.setenv(JAVA_HOME="/usr/lib/jvm/java-8-oracle/jre")