

## Collections

- Real Time: Immediate actions
1. Kinesis Data Streams
2. Simple Queue Service
3. Internet of Things

- Near-real time: Reactive actions
1. Kinesis Data Firehose.
2. Database migration Service.

- Batch: Historical Analysis
1. Snowball
2. Data Pipeline

### Kinesis:

#### Producers

- Kinesis Producers
1. Kinesis SDK
- APIs are used PutRecord/PutRecords
- ProvisionedThroughputExceeded exception
    - Retries with backoff
    - Increase Shards
    - Ensure your partition key is good one.

2. Kinesis Producer Library (KPL)
- Easy to use. C++/Java.
- Automated and configurable retry mechanism.
- Synchronous or Asynchronous API.
- Submits metrics to CloudWatch for monitoring.
- Batching: Increase throughput/decrease cost.
- Compression must be implemented by user.
- KPL records must be decoded.
- RecordMaxBufferedTime (default 100 ms)

- KPL can incur an additional processing delay of up to  RecordMaxBufferedTime within the library (user configurabble)

3. Kinesis Agent
- Monitor log files and sends them to Kinesis Data streams.
- Java based agent, built on top of KPL
- Install on linux based server environments.

4. 3rd Party libraries (Spark,Log4j)


#### Consumers

- Consumer classic
- Consumer enhanced (Fan out)

- Kinesis SDK
- Kinesis Client Library (KCL)
- Kinesis connector library
- 3rd Party libraries (Spark,Log4j)
- Kinesis Firehose
- AWS Lambda

- GetRecords() can pull upto 10MBs data per API call.
- 5 API calls per second.