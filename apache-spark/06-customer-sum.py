
from pyspark import SparkConf, SparkContext
import re

conf = SparkConf().setMaster("local").setAppName("WordCount")
sc = SparkContext(conf = conf)

def filterData(line):
    items = line.split(',')
    key = int(items[0])
    value = float(items[2])
    return (key,value)

input = sc.textFile("data/06-data/customer-orders.csv")
words = input.map(filterData)
data = words.reduceByKey(lambda x,y : x + y).sortByKey()
results = data.collect()

for result in results:
    print(result[0],result[1])