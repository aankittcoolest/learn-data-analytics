
from pyspark.sql import SparkSession
from pyspark.sql import functions as func
from pyspark.sql.types import StructType,StructField,IntegerType,FloatType

spark = SparkSession.builder.appName("CustomerSum").master("local[*]").getOrCreate()

schema= StructType([\
    StructField("ID", IntegerType(),True),\
    StructField("itemID", IntegerType(),True),\
    StructField("amount", FloatType(),True)])

df = spark.read.schema(schema).csv("data/12-data/customer-orders.csv")

df.printSchema()

result = df.groupBy("ID").agg(func.round(func.sum("amount"),2).alias("total_spent")).sort("ID")
result.show()


spark.stop()