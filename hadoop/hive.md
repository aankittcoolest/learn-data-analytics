
## Basic commands

```sql
create database d1;
create database if not exists d1;

describe database d1;
create database if not exists d2 comment 'this is a database';
describe database extended d2;

create database if not exists d3 with dbproperties('creator'='ankit','date'='2021-12-02');
describe database extended d3;

show databases;
use d2;


# By default internal table is created.
create table if not exists table1(col1 string,col2 array<string>,col3 string,col4 int) row format delimited fields terminated by ',' collection items terminated by ':' lines terminated by '\n' stored as textfile;


create table if not exists table2(col1 string,col2 array<string>,col3 string,col4 int);


# To create external table
create external table


#create table with location clause
set hive.metastore.warehouse.dir;

create table if not exists table3(col1 string,col2 array<string>,col3 string,col4 int) row format delimited fields terminated by ',' collection items terminated by ':' lines terminated by '\n' stored as textfile location '/user/ankit/table3';

load data local inpath'/home/ankit/data.txt' into table table1;

select * from table1;


# load data from another table
set hive.cli.print.header=true
select * from emp_tab;

create table tab (col1 int, col2 string, col3 string) stored as textfile;

insert into table tab select col1,col2,col3 from emp_tab;
select * from tab;


insert overwrite table tab select col1,col2,col3 from emp_tab where col3='Developer';


# multi insert
create table developer_tab (id int,name string,desg string) stored as textfile;

create table manager_tab (id int,name string,desg string) stored as textfile;

from emp_tab insert into table developer_tab select col1,col2,col3 where col3='Developer' insert into table manager_tab select col1,col2,col3 where col3='manager';

# alter commands
alter table tab add columns(col4 string, col5 int);
alter table tab change col1 col1 int after col3;
alter table tab change column col2 new_col2 string;
alter table tab rename to tab1;
alter table tab1 replace columns (id int, name string);

describe formatted tab1;
alter table set tblproperties('auto.purge'='true');
describe formatted tab1;
alter table set fileformat avro;

```


## Functions


```sql
select unix_timestamp('2017-04-26 00:00:00');
1493145000

selct from unixtime(1234145)
1970-01-15 12:19:05

select ceil(9.5)
10

select floor(10.9)
10

select round(123.456,2)
123.46

select rand();
0.8769

select(23);
23


# string functions
select concat(col1,'.'),col3) from table1;
select length(col3) from table1;
select lower(col3) from table1;
select lpad(col3,10,'v') from table1;
vvvEngland

select rpad(col3,10,'v') from table1;
Englandvvv

select ltrim('  ankit');
ankit

select rtrim('ankit  ');
ankit

select repeat(col3,2) from table1;
select reverse(col3) from table1;

select split('hive:hadoop',':');
["hive","hadoop"]

select substr('hive is a query tool',4);
e is a querying tool

select substr('hive is a query tool',4,3);
e i

select instr('hive is a quering tool','e');
4

# conditional statements
select * from table1;
select if(col='England',col1,col4) from table1;

select isnull(col1) from table1;
select isnotnull(col1) from table1;

select explode(col2) as mycol from table1;
select author_name, dummy_booksname from table2 lateral view explode(books_name) dummy as dummy_booksname;

select key,value from table2 lateral view explode(col1) dummy as key,value;


select 'hadoop' rlike 'ha';
select 'hadoop' rlike 'ha*';
select 'hadoop         ' rlike 'hadoop';
# returns null
select null rlike 'ha';
# returns null
select 'hadoop' rlike null;

# rank, dense rank, row_number
select col1,col3,rank() over(order by col2 desc) from table1;
select col1,col3,dense_rank() over(order by col2 desc) from table1;
select col1,col2, row_number() over(order by col2 desc) from table1;
select col1,col2, row_number() over(partition by col1 order by col2 desc) from table1;

```

## Paritition tables

```sql
# static partition
create table if not exists part_dept (deptno int, empname string, sal int) partitioned by (deptname string) row format delimited fields terminated by ',' lines terminated by '\n' stored as textfile;

insert into table part_dept partition (deptname='HR') select col1,col3,col4 from deptwhere col2='HR';

load data local inpath '/home/ankit/act' into table part_dept partition (deptname='XZ');

#dynamic partition
set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;

create table if not exists part_dept1 (deptno int, empname string, sal int) partitioned by (deptname string) row format delimited fields terminated by ',' lines terminated by '\n' stored as textfile;

insert into table part_dept1 partition(deptname) select col1,col3,col4,col2 from dept;

# alter partition table
show partitions part_dept1;
alter table part_dept1 drop parttion (deptname='HR');
alter table part_dept1 add partition (deptname='Dev');
load data local inpath '/home/ankit/dev' into table part_dept1 partition (deptname='Dev');


# access table
bin/hadoop fs -ls /user/hive/warehouse/part_dept1
bin/hadoop fs -mkdir /user/hive/warehouse/part_dept1/deptname=Finance
# Hive will not recognise Finance partition
show partitions part_dept1;
# Method 1: Add partition manually
alter table part_dept1 add partition (deptname='Finance');

bin/hadoop fs -mkdir /user/hive/warehouse/part_dept1/deptname=Production
show partitions part_dept1;
# Method 2: Fix metadata
msck repair table part_dept1;
show partitions part_dept1;
```

## Bucketing

```sql
select * from dept_with_loc;
set hive.enforce.bucketing = true
set hive.exec.dynamic.partition = nonstrict

create table if not exists dept_buck (deptno int, empname string, sal int, location string) partitioned by (deptname string) clustered by (location) into 4 buckets row format delimited fields terminated by ',' lines terminated by '\n' stored as textfile;

insert into table dept_buck partition (deptname) select col1,col3,col4,col5,col2 from dept_with_loc;

show partitions dept_buck;

# table sampling
select * from dept_buck limit 15;
select deptno,empname,sal,location from dept_buck tablesample (bucket 1 out of 2 on location);
select deptno,empname,sal,location from dept_buck tablesample (2 percent);
select deptno,empname,sal,location from dept_buck tablesample (1M);
select deptno,empname,sal,location from dept_buck tablesample (20 rows);

# no_drops (safety feature)
alter table emp_tab enable no_drop;
drop table emp_tab
alter table emp_tab disable no_drop;

# no drops on partition
alter table part_dept partition (deptname='HR') enable no drop;
alter table drop partition (deptname = 'HR')
alter table part_dept partition (deptname='HR') disable no drop;

# offline
alter table dept_tab enable offline;
select * from dept_tab;
alter table dept_tab disable offline;
select * from dept_tab;

alter table part_dept1 partition (deptname = 'Accounts') enable offline;
select * from part_dept1 where deptname = 'Accounts';
alter table part_dept1 partition (deptname = 'Accounts') disable offline;
select * from part_dept1 where deptname = 'Accounts';

```

## Joins
```sql
# inner join
select * from emp_tab;
select * from dept_tab;

select emp_tab.col1,emp_tab.col2,emp_tab.col3, dept_tab.col1,dept_tab.col2,dept_tab.col3 from emp_tab join dept_tab on (emp_tab.col6 = dept_tab.col1);

# join three tables
select * from emp_tab;
select * from dept_tab;
select * from third_tab;
select emp_tab.col1,emp_tab.col2,dept_tab.col3,third_tab.col2 from emp_tab join dept_tab on (emp_tab.col6 = dept_tab.col1) join third_tab on (dept_tab.col1 = third_tab.col1);

# explicitly define stream table
select /*+ STREAMTABLE (emp_tab) */ emp_tab.col1,emp_tab.col2,dept_tab.col3,third_tab.col2 from emp_tab join dept_tab on (emp_tab.col6 = dept_tab.col1) join third_tab on (dept_tab.col1 = third_tab.col1);

# join mappers (when data is small)
select /*+ MAPJOIN (emp_tab) */ emp_tab.col1,emp_tab.col2,emp_tab.col3, dept_tab.col1,dept_tab.col2,dept_tab.col3 from emp_tab join dept_tab on (emp_tab.col6 = dept_tab.col1);

# allow hive to do map joins
set hive.auto.convert.join=true;
set hive.mapjoin.smalltable.filesize=25000000;

#bucketed map joins
set hive.input.format=org.apache.hadoop.hive.ql.io.BucketizedHiveInputFormat;
set hive.optimize.bucketmapjoin=true;
set hive.auto.convert.sortmerge.join=true;
set hive.optimize.bucketmapjoin.sortedmerge=true;
```

## Views

```sql
select * from emp_tab;
create view emp_view1 as select * from emp_tab;
create view emp_view2 as select col1,col2,col3 from emp_tab;
select * from emp_view2;
select col1,col2 from emp_view2;
create view if not exists emp_view3 as select col1 as id,col2 as name from emp_tab;

create view emp_view5 as select emp_tab.col1,emp_tab.col2,dept_tab.col3,third_tab.col2 from emp_tab join dept_tab on (emp_tab.col6 = dept_tab.col1) join third_tab on (dept_tab.col1 = third_tab.col1);

alter view emp_view1 as select col1 from emp_tab;
alter view emp_view1 rename to emp_view_new;
drop view emp_vuiew2;
show tables;

```