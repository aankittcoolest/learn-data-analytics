## Installation
```shell
brew install apache-spark
cd /usr/local/Cellar/apache-spark/3.2.0/libexec/conf
cp log4j.properties.template log4j.properties
```

### Testing
```shell
cd /usr/local/Cellar/apache-spark/3.2.0
pyspark
>>> rdd = sc.textFile("README.md")
>>> rdd.count()
```

spark-submit ratings-counter.py