from pyspark import SparkConf, SparkContext
import re

conf = SparkConf().setMaster("local").setAppName("WordCount")
sc = SparkContext(conf = conf)

def normalizeWords(text):
    return re.compile(r'\W+', re.UNICODE) .split(text.lower())

input = sc.textFile("data/05-data/book.txt")
words = input.flatMap(normalizeWords)
# wordCounts = words.countByValue()

# for word, count in wordCounts.items():
#     cleanWord = word.encode("ascii", 'ignore')
#     if (cleanWord):
#         print(cleanWord, count)

wordCounts = words.map(lambda x: (x,1)).reduceByKey(lambda x,y : x + y)
wordCountsSorted = wordCounts.map(lambda x: (x[1],x[0])).sortByKey()
results = wordCountsSorted.collect()
print(results)


for result in results:
    count = str(result[0])
    word = result[1].encode("ascii", 'ignore')
    if (word):
        print(word,":",count)