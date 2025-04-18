SELECT * 
FROM parks_and_recreation.employee_demographics;

SELECT first_name, 
last_name, 
birth_date,
age,
age + 10
FROM parks_and_recreation.employee_demographics;

SELECT distinct first_name, gender
FROM parks_and_recreation.employee_demographics;

select *
from employee_salary
where first_name = 'Leslie'
;

select *
from employee_salary
where salary <= 50000
;

select *
from employee_demographics
where (first_name = 'Leslie' and age = 44) or age > 55
;

-- LIKE statement
-- % (anything) and _ (specific)
select *
from employee_demographics
where birth_date like '198%'
;

-- Group By
select gender, avg(age), max(age), min(age), count(age)
from employee_demographics
group by gender
;

-- Order By, asc is ascending -- desc is descending (the order in the order by is important!)
select *
from employee_demographics
order by gender, age
;

-- Having vs where
select gender, avg(age)
from employee_demographics
group by gender
having avg(age) > 40
;

select occupation, avg(salary)
from employee_salary
where occupation like '%manager%'
group by occupation
having avg(salary) > 75000
;

-- Limit & Aliasing
-- Limit
select *
from employee_demographics
order by age desc
limit 2, 1
;

-- Aliasing 
select gender, avg(age) as avg_age
from employee_demographics
group by gender
having avg_age > 40
;

-- Joins
select *
from employee_demographics
;

select *
from employee_salary
;

-- Inner join
select dem.employee_id, age, occupation
from employee_demographics as dem
inner join employee_salary as sal
	on dem.employee_id = sal.employee_id
;

-- Outer join
select *
from employee_demographics as dem
right join employee_salary as sal
	on dem.employee_id = sal.employee_id
;

-- Self join
select emp1.employee_id as emp_santa,
emp1.first_name as first_name_santa,
emp1.last_name as last_name_santa,
emp2.employee_id as emp_name,
emp2.first_name as first_name_emp,
emp2.last_name as last_name_emp
from employee_salary as emp1
join employee_salary as emp2
	on emp1.employee_id + 1 = emp2.employee_id
;

-- Joining multiple tables together
select *
from employee_demographics as dem
inner join employee_salary as sal
	on dem.employee_id = sal.employee_id
inner join parks_departments as pd
	on sal.dept_id = pd.department_id
;

select *
from parks_departments
;

-- Unions
select first_name, last_name
from employee_demographics
union all
select first_name, last_name
from employee_salary 
;

select first_name, last_name, 'Old man' as Label
from employee_demographics
where age > 40 and gender = 'Male'
union
select first_name, last_name, 'Old lady' as Label
from employee_demographics
where age > 40 and gender = 'Female'
union
select first_name, last_name, 'Highly paid' as Label
from employee_salary
where salary > 70000
order by first_name, last_name
;

-- String Functions
select length('skyfall');

select first_name, length(first_name) as length
from employee_demographics
order by length
;

select upper('sky');
select lower('SKY');

select first_name, upper(first_name) as Caps
from employee_demographics
order by Caps
;

select first_name, left(first_name, 4), right(first_name, 4), substring(first_name, 3, 2), birth_date, substring(birth_date, 6, 2)
from employee_demographics
;

select locate('x', 'Alexander');

select first_name, locate('An', first_name)
from employee_demographics
;

select first_name, last_name,
concat(first_name, ' ', last_name) as full_name
from employee_demographics
;

-- Case statements
select first_name, last_name, age,
case
	when age <= 30 then 'Young'
    when age between 31 and 50 then 'Unc'
    when age >= 50 then 'just die atp bru'
end as age_bracket
from employee_demographics
;

-- Pay increase and bonus
-- < 50000 = 5%
-- > 50000 = 7%
-- Finance = 10% bonus
select first_name, last_name, salary, 
case
	when salary < 50000 then salary + (salary * 0.05)
    when salary > 50000 then salary + (salary * 0.07)
end as new_salary,
case
	when dept_id = 6 then salary * 0.10
end as bonus
from employee_salary
;

-- Subqueries, a query inside a query basically
select *
from employee_demographics
where employee_id in 
	(
	select employee_id
	from employee_salary
	where dept_id = 1
	)
;

select first_name, salary, 
(select avg(salary)
from employee_salary)
from employee_salary
;

select gender, avg(age), max(age), min(age), count(age)
from employee_demographics
group by gender
;

select avg(min_age)
from
	(
	select gender, 
	avg(age) as avg_max, 
	max(age) as max_age, 
	min(age) as min_age, 
	count(age) as count_age
	from employee_demographics
	group by gender
    ) as agg_table
;

-- Window Functions
select dem.first_name, dem.last_name, gender, avg(salary) as avg_salary
from employee_demographics as dem
join employee_salary as sal
	on dem.employee_id = sal.employee_id
group by dem.first_name, dem.last_name, gender
;

select dem.first_name, dem.last_name, gender, avg(salary) over(partition by gender)
from employee_demographics as dem
join employee_salary as sal
	on dem.employee_id = sal.employee_id
;

select dem.first_name, dem.last_name, gender, salary,
sum(salary) over(partition by gender order by dem.employee_id) as rolling_total
from employee_demographics as dem
join employee_salary as sal
	on dem.employee_id = sal.employee_id
;

select dem.employee_id, dem.first_name, dem.last_name, gender, salary,
row_number() over(partition by gender order by salary desc) as row_num,
rank() over(partition by gender order by salary desc) as rank_num,
dense_rank() over(partition by gender order by salary desc) as dense_rank_num
from employee_demographics as dem
join employee_salary as sal
	on dem.employee_id = sal.employee_id
;

-- CTEs, command table expression
with cte_example as
(
select employee_id, gender, birth_date
from employee_demographics 
where birth_date > '1985-01-01'
),
cte_example2 as
(
select employee_id, salary
from employee_salary
where salary > 50000
)
select *
from cte_example
join cte_example2
	on cte_example.employee_id = cte_example2.employee_id
;

-- Temporary Tables
create temporary table temp_table
(
first_name varchar(50),
last_name varchar(50),
favorite_movie varchar(100)
)
;

select *
from temp_table;

insert into temp_table
values('Aikal','Frieberg','Shirobako');

select *
from temp_table;

select *
from employee_salary;

create temporary table salary_over_50k
select *
from employee_salary
where salary >= 50000
;

select *
from salary_over_50k
;

-- Stored Procedures
select *
from employee_salary
where salary >= 50000
;

delimiter $$
create procedure large_salaries4()
begin
	select *
	from employee_salary
	where salary >= 50000
	;
	select *
	from employee_salary
	where salary >= 10000
	;
end $$
delimiter ;

call large_salaries4();

select salary
from employee_salary;

delimiter $$
create procedure large_salaries5(huggymuffin int)
begin
	select salary
    from employee_salary
    where employee_id = huggymuffin
    ;
end $$
delimiter ;

call large_salaries5(3);

-- Trigger and Events
-- Triggers
select *
from employee_demographics
;

select *
from employee_salary
;

delimiter $$
create trigger employee_insert
	after insert on employee_salary
    for each row 
begin
	insert into employee_demographics (employee_id, first_name, last_name)
    values (new.employee_id, new.first_name, new.last_name)
    ;
end $$
delimiter ;

insert into employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
values(13, 'Jean-Ralphio', 'Saperstein', 'Entertainment 720 CEO', 1000000, NULL);

-- Events
select *
from employee_demographics;

delimiter $$
create event delete_retirees
on schedule every 30 second
do
begin
	delete
    from employee_demographics
    where age >= 60
    ;
end $$
delimiter ;

show variables like 'event%';






