# create data base 
create database tigif; # this statement will create database 
use tigif; # to use the database 

# Table 1 Query: 

Create Table EmployeeDemographics 
(EmployeeID int, 
FirstName varchar(50), 
LastName varchar(50), 
Age int, 
Gender varchar(50)
);

# Table 2 Query:  

Create Table EmployeeSalary 
(EmployeeID int, 
JobTitle varchar(50), 
Salary int
);

# insert data into the table 

# Table 1 Insert


Insert into EmployeeDemographics VALUES
(1001, 'Jim', 'Halpert', 30, 'Male'),
(1002, 'Pam', 'Beasley', 30, 'Female'),
(1003, 'Dwight', 'Schrute', 29, 'Male'),
(1004, 'Angela', 'Martin', 31, 'Female'),
(1005, 'Toby', 'Flenderson', 32, 'Male'),
(1006, 'Michael', 'Scott', 35, 'Male'),
(1007, 'Meredith', 'Palmer', 32, 'Female'),
(1008, 'Stanley', 'Hudson', 38, 'Male'),
(1009, 'Kevin', 'Malone', 31, 'Male');

# Table 2 Insert:
Insert Into EmployeeSalary VALUES
(1001, 'Salesman', 45000),
(1002, 'Receptionist', 36000),
(1003, 'Salesman', 63000),
(1004, 'Accountant', 47000),
(1005, 'HR', 50000),
(1006, 'Regional Manager', 65000),
(1007, 'Supplier Relations', 41000),
(1008, 'Salesman', 48000),
(1009, 'Accountant', 42000);

# delete entry from the table 

delete from employeedemographics;

# delete table 

drop table employeesalary;
# select statement in sql
select * from EmployeeDemographics;

select * from EmployeeSalary;

# select specific column of the table 
select jobtitle,salary from tigif.EmployeeSalary;

# DISTINCT Function 

select distinct gender,firstname from EmployeeDemographics ;
# here distinct need to be at first place afterthat we can specify other column names 

select firstname,age+10 from employeeDemographics; # we can perform mathematical operations here 

select firstname,(age+10)*12 from employeeDemographics; # we can perform mathematical operations here 

# PEMDAS = > this is the operation precedence will be given by the exectue engine in sql

# where statement - it is used to filter the data 

-- comparision operator 
select * from employeedemographics
where firstname = 'JIM';

select * from employeedemographics
where firstname != 'JIM';

select * from employeedemographics
where age > 10;

-- Logival opertors -- AND , OR , NOT 

select * from employeedemographics
where firstname = 'JIM' and age >=30;

select * from employeedemographics
where firstname = 'JIM' or age >89;

select * from employeedemographics
where NOT firstname = 'JIM';

-- Like -- % ,_

select * from employeedemographics
where firstname like 'jim';

select * from employeedemographics
where firstname like 'a%';

select * from employeedemographics
where firstname like 'a___%'; 

insert into employeedemographics value (1,'sham','bjp',null,'male');

# goup by - this will roll up rows into single row based on the specified column and then on it we could apply aggeregate functions on that 


select gender,max(age),min(age),count(age) from employeedemographics
group by gender ;   
#here the col specified in group by need to match the col in select and we can use when we are using agg function on the col which is not specified in group by 
# and aggregat fun wont consider null 
 
-- order by  - this will sort the data into asc and desc based on the specified columns 

select * from employeedemographics
order by age desc; # by default ascending order 

select gender,max(age) from employeedemographics
group by gender
order by gender; # first group by and then order by 

select gender,age from employeedemographics
group by gender,age
order by gender,age desc; 

# having clause  - used with aggregate function

# having vs where 

select gender,max(age) from employeedemographics
where max(age) > 20
group by gender;

-- this is will give us erroe as aggregate function depends on group by clause 

select gender,max(age) from employeedemographics
group by gender
having max(age)>35;

select gender,min(age) from employeedemographics
where age > 30
group by gender;

-- Limit

select * from employeedemographics
limit 2;

select * from employeedemographics
limit 2,3; # 3 indicates number of rows we need from 2 

-- aliasing 

select gender,avg(age) as avg_age 
from employeedemographics
group by gender;


-- joins in sql - joining the tables with the common column (here column name need not be same but data within that need to be sam )

-- inner join
select * from employeedemographics edemo
inner join  employeesalary esal
  on edemo.EmployeeID = esal.EmployeeID;

-- outer join

insert into employeedemographics value (2,'abhi','ram',20,'male');

select * from employeedemographics edemo
left  join  employeesalary esal
  on edemo.EmployeeID = esal.EmployeeID;
  
select * from employeedemographics edemo
right join employeesalary esal
   on edemo.EmployeeID = esal.EmployeeID;
   
-- self join 

select * from employeedemographics edemo1
join employeedemographics edemo2
   on edemo1.EmployeeID = edemo2.EmployeeID;
   
-- lets consider we are gone make a supervisor among employee each other 
select * from employeedemographics edemo1
join employeedemographics edemo2
   on edemo1.EmployeeID+1 = edemo2.EmployeeID;
-- and we can join multiple tables alter
-- how ? => we can join the result of one join with another table 

-- Unions - are used combine row togther not like joins where we combine cols together and here we need to hv same number of cols in both the table 
-- UNION  - similar to UNION DISTINCT - here duplicates are ignored 

select EmployeeID from employeedemographics 
union #= union distinct
select EmployeeID from employeesalary;

-- union all - duplicates are considered 
select EmployeeID,'men' as label from employeedemographics 
where  age >30 
union all #= union distinct
select EmployeeID,'high paid' as label  from employeesalary
where salary > 10000 ;
-- in above code we used label as column with label value based on result of where clause 


-- string functions - string functions are used to manipulate the string
-- -- update some data to practice string functions
update employeedemographics
set firstname = "  tobby   "
where employeeid = 1005;

-- trim -> it is used to remove both left and right space 

select TRIM("    ram    ");

-- LTRIM - it is used to remove left space 
select ltrim("    ram    ");

-- RTRIM - it is used to remove right space 
select rtrim("    ram    ");

-- UPPER AND LOWER - convert string into upper and lower letter
select upper("ram");

select lower("rAM");

-- REPLACE - this is used to replace some sequence charcter from the string 
select replace("sham",'sh','r');

-- LENGTH - this will give us the lengthe of the string 
select length("sham");

-- LEFT and RIGHT - this will give use subtring from left with LEFT() and right from RIGHT funstion()
select LEFT("sham",3),RIGHT('ram',2);

-- SUBSTRING() - this will give use the substring depending on the parameter we pass
select substring("sham",1,3); # here index starts from 1


-- Locate() - this function will just give us the integer of the charcater in the string 

select locate('A',"anny");

-- concate() - this function is sude to add the string 


select concat("ram",' ',"sham");


select concat(firstname,' ',lastname) from employeedemographics;

-- cae statement - its is used to add logic reolated  to  decision making 
-- here indentetion doesnt matter but for convention we use ;
select firstname,LastName,
case
  when age < 30 then 'young'
  when age between 30 and 50 then 'men'
  else 'old'
end as label  
from employeedemographics;  
  
-- sub-query => query inside a query 

-- sub-query in select statement 
-- here the subquery in select statement is gone run for each row of  table mentioned outside selected statement
select firstname,lastname,(select avg(age) from employeedemoGraphics) as average_age from employeedemographics;

-- sub query in where 
select * from employeedemographics
where EmployeeID in (select EmployeeID from employeesalary);

-- sub query in form 
-- here we have use "`" back mark to make its as column or we can use alias name mentioned within subquery select statement
select avg(`max(age)`) from (select gender,max(age),min(age),avg(age)  from employeedemographics group by gender) as etable;


-- window functions - its will not roll up into one it maintain the row without rolling the rows 

select firstname,avg(age) over(partition by gender) from employeedemographics;

-- rolling total
select firstname,sum(age) over(partition by gender order by EmployeeID) from employeedemographics;

select firstname,row_number() over(partition by gender order by EmployeeID)  from employeedemographics;
-- it is gone give us row number in increasing order if we specify order by  that partition if we specify order by 
select * from employeedemographics;
select firstname,row_number() over(partition by gender )  from employeedemographics;
-- it is gone give us row number in increasing order and it will give row number on how it is inserted into table

select firstname,rank() over(partition by gender order by EmployeeID)  from employeedemographics;
-- its gone give us rank positionally and if it sees duplicates then it will assign same rank 

insert into employeedemographics values (2,'jim','halpert',30,'377384');

select firstname,dense_rank() over(partition by gender order by EmployeeID)  from employeedemographics;
-- its gone give us rank numerically and if it sees duplicates then it will assign samerank

-- cte (common table expression) - it conatins the result set(its a kind of temp table without creating actual table)

with cte_example (fn,ln,sal) as 
(
select firstname,lastname,salary from employeedemographics
join employeesalary
on employeedemographics.EmployeeID = employeesalary.EmployeeID 
),
cte_example1 as (
select gender,avg(salary)
from employeedemographics 
join employeesalary 
on employeesalary.employeeid = employeedemographics.employeeid
group by gender
)

select * from cte_example1;

-- Temproray temple - it a table that will stay still the duration of session for transation ends

create temporary table salary_over_30000(
employeeid int,
jobtitle varchar(50),
salary float
);

insert into salary_over_30000 value (1,'ml eng',40000);
select * from salary_over_30000 ;
-- one more way of inserting the data into temp table     
insert into salary_over_30000 select * from employeesalary;

select * from salary_over_30000;

-- one morw way of creating temp table

-- it creates the permanenet table 
create table salar_over_20000 
select * from employeesalary where salary > 20000;

create temporary table salary_over_20000
select * from employeesalary where salary > 20000;


select * from salary_over_20000;

-- store procdure -- this are used to store the result set permanenetly and we can query it over and over 

create procedure p1()
select  * from employeedemographics;
select * from employeesalary;
-- here it considered only one select statement as  statement of store_procdure and another one as normal query 
-- the reason is ; act as end of the statement so we need to change the delimiter here 

call p1();


-- changeing the delimitere 

delimiter  @
create procedure p4()
Begin
select  * from employeedemographics;
select * from employeesalary;
end @

delimiter ;
call p3();

-- parameters - these are the variables passed as input to the store procedures 


delimiter  @
create procedure p7(employeeid int)
Begin
select  * from employeedemographics
where employeedemographics.employeeid = employeeid;
end @

delimiter ;
call p7(1);


-- trigger and event 

-- trigger - trigger is the block of code that will be executed when event happens on table 
delimiter $$
create trigger new_t1
     After insert on employeesalary  # here before means after deleting the data 
     for each row 
begin
     insert into employeedemographics values (NEW.employeeid,'shree','ram',20,'male');
end $$  
   
delimiter ;

insert into employeesalary values (4,'ml engineer',20002) ,(5,'ml engineer',20002);

select * from employeedemographics;
  
select * from employeesalary ;



-- event - event is the action happens on schedule 

delimiter $$
create event delete_retires
on schedule every 30 second
do
begin
 delete  from employeedemographics
 where age >=38;
end $$
delimiter ;

select * from employeedemographics;

-- for practice purpose 
select * from employeedemographics;

insert employeedemographics 
value (1,'dffhg','djkjfkd',23,377384);

-- here i want to delete dulicate from the table ,this is how we can delete duplicate from the table 

delete from employeedemographics
where EmployeeID LIKE 1
limit 1;

select *,row_number() over() from employeedemographics;
--  here over() is considering the entire data set as one partition without consideration of even duplicates 

-- use of having clause 
select gender,sum(age) from employeedemographics
group by gender
having sum(age) > 100;


# Rename table

rename table employeesalary to employeesSal; 

rename table  employeesSal to employeesalary; 








