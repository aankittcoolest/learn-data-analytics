from pyspark.sql import SparkSession
from pyspark.sql import functions as func
from pyspark.sql.types import StructType, StructField, IntegerType, StringType

spark = SparkSession.builder.appName("MostPopularSuperHero").getOrCreate()



schema = StructType([\
    StructField("id", IntegerType(), True),\
    StructField("name", StringType(), True)])

names = spark.read.schema(schema).option("sep"," ").csv("data/15-data/Marvel-names.txt")

lines = spark.read.text("data/15-data/marvel-graph.txt")

connnections = lines.withColumn("id", func.split(func.col("value"), " ")[0]) \
    .withColumn("connections", func.size(func.split(func.col("value"), " "))-1) \
        .groupBy("id").agg(func.sum("connections").alias("connections"))

sortedConnections = connnections.sort(func.col("connections"))

filteredConnections = sortedConnections.filter(func.col("connections") == 1)

result = filteredConnections.join(names,"id")
result.show()


spark.stop()