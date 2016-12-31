library(shiny)
require(plotly)
require(SparkR)


# #dat <- read.csv("./Dummy_dataset_refined_short.csv", header = TRUE, sep=',',quote="'")
# # dat <- hdfs.file("C:/Aegle/Interface_visualization/plotly_aegle/Dummy_dataset_refined_short.csv", "r")
# # dat <- hdfs.read(dat)
# #cn <- colnames(dat)

Sys.setenv(SPARK_HOME = "/home/manzoor_aegle/spark-1.6.2-bin-hadoop2.6")
.libPaths(c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib"),.libPaths()))

sc <- sparkR.init(master = "local")
sqlContext <- sparkRSQL.init(sc)

if (nchar(Sys.getenv("HADOOP_CMD")) < 1) {
  Sys.setenv(HADOOP_CMD = "/usr/local/hadoop/bin/hadoop")
}

Sys.setenv("HADOOP_STREAMING"="/usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar")
Sys.setenv(JAVA_HOME="/usr/lib/jvm/java-8-oracle/jre")



#

#
# #pathFile <- file.path(Sys.getenv("SPARK_HOME"), file = "C:/Aegle/Interface_visualization/plotly_aegle/Dummy dataset_refined_short.csv", header = TRUE, sep=',',quote="'")
# #dat <- read.df(sqlContext, "C:/Aegle/Interface_visualization/plotly_aegle/Dummy_dataset_refined_short.csv")
#
# # con = rawToChar(dat)
# # datDF = read.csv(textConnection(con), sep = ",",header=TRUE)
#
#
#dae <- reactiveValues()
#dae <- isolate(myquery())
# require(rJava)
# require(rhdfs)
# hdfs.init()
# 
#   hdfs_path = "/visualization/Dummy_dataset_refined_short.csv"
#   f = hdfs.file(hdfs_path,"r",buffersize=5242880)
#   m = hdfs.read(f)
#   con = rawToChar(m)
#   local_df = read.table(textConnection(con), sep = ",", header=TRUE, fill=TRUE)
# 
# #   #datDF <- createDataFrame(sqlContext, dat)
#   cn <- colnames(local_df)
#   # dati2 <- select(datDF, "*" )
#   # local_df <- collect(dati2)

