select * from t_employees ;


select year(d.from_date), e.gender, count(e.emp_no)
from t_employees e 
join t_dept_emp d on e.emp_no = d.emp_no 
where from_date >= '1990-01-01' 
group by year(d.from_date), e.gender
order by d.from_date,e.emp_no ;



# problem 1 : solution in SQL 

select year(d.from_date) as calender_year, e.gender, count(e.emp_no) as num_of_employees
from t_employees e 
join t_dept_emp d on e.emp_no = d.emp_no  
group by calender_year, e.gender
having calender_year >= 1990 
order by calender_year ;




# problem 2 : solution in SQL 


/*
select count(emp_no) from t_dept_manager ;


select d.dept_name ,year(dm.from_date) as calender_year , e.gender , count(dm.emp_no) as num_of_employees
from t_employees e 
join t_dept_manager dm on e.emp_no = dm.emp_no
join t_departments d on dm.dept_no = d.dept_no
group by calender_year , e.gender 
having calender_year >= 1990
order by dept_name ,calender_year,e.gender ;

*/

select d.dept_name, ee.gender, dm.emp_no, dm.from_date, dm.to_date, e.calender_year,
case 
 when year(dm.to_date) >= e.calender_year and year(dm.from_date) <= e.calender_year THEN 1
 else 0
 END as active
 from 
 (select year(hire_date) as calender_year 
 from t_employees 
 group by calender_year ) e
 cross join t_dept_manager dm
 join 
 t_departments d on dm.dept_no = d.dept_no 
 join 
 t_employees ee on dm.emp_no = ee.emp_no 
 order by dm.emp_no , calender_year ;
 
 
 
 # problem 3 : solution in SQL 
 
 
 /*
 
 
 select d.dept_name, e.gender, avg(s.salary) , year(s.from_date) as calender_year
 from t_employees e 
 join t_salaries s on e.emp_no = s.emp_no
 cross join t_departments d 
 group by d.dept_name , e.gender 
 having calender_year <=2002 
 order by e.gender , dept_name ;
 
 
 */
 
 
 /*
  
 select d.dept_name, e.gender, avg(s.salary) , year(dm.from_date) as calender_year
 from t_employees e 
 join t_salaries s on e.emp_no = s.emp_no
 join t_dept_manager dm on s.emp_no = dm.emp_no 
 join t_departments d on dm.dept_no = d.dept_no
 group by d.dept_name , e.gender 
 having calender_year <=2002 
 order by  calender_year , d.dept_name ;
 
 
 */
 
 
 
  
 select  e.gender, d.dept_name , round(avg(s.salary),2) as salary  , year(s.from_date) as calender_year
 from t_salaries s 
 join t_employees e on s.emp_no = e.emp_no
 join t_dept_emp de on de.emp_no = e.emp_no
 join t_departments d on d.dept_no = de.dept_no
 group by d.dept_no , e.gender, calender_year 
 having calender_year <=2002 
 order by d.dept_no ;
 
 
 
 
  # problem 4 : solution in SQL 
  
/*  
  
  delimiter $$
create procedure emp_avg_salary_out(in p_emp_no integer, out p_avg_salary decimal(10,2))
begin
select avg(s.salary)
into p_avg_salary from
employees e
join salaries s on e.emp_no = s.emp_no
where 
e.emp_no = p_emp_no ;
end$$



# nice approach -> 

delimiter $$
create procedure filter_kar_salary(in p_min_salary float, in p_max_salary float)
begin
 select e.gender, d.dept_name , avg(s.salary) as avg_salary
 from t_employees e 
 join t_salaries s on e.emp_no = s.emp_no
 join t_dept_manager dm on s.emp_no = dm.emp_no
join departments d on d.dept_no = dm.dept_no 
WHERE s.salary BETWEEN p_min_salary AND p_max_salary
group by e.gender, d.dept_name 
order by dept_name ;

*/




DROP PROCEDURE IF EXISTS filter_salary;

DELIMITER $$
CREATE PROCEDURE filter_salary (IN p_min_salary FLOAT, IN p_max_salary FLOAT)
BEGIN
SELECT 
    e.gender, d.dept_name, AVG(s.salary) as avg_salary
FROM
    t_salaries s
        JOIN
    t_employees e ON s.emp_no = e.emp_no
        JOIN
    t_dept_emp de ON de.emp_no = e.emp_no
        JOIN
    t_departments d ON d.dept_no = de.dept_no
    WHERE s.salary BETWEEN p_min_salary AND p_max_salary
GROUP BY d.dept_no, e.gender;
END$$

DELIMITER ;

CALL filter_salary(50000, 90000);