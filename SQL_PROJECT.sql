create database employee;
use employee;

CREATE TABLE JobDepartment (
    Job_ID INT PRIMARY KEY,
    jobdept VARCHAR(50),
    name VARCHAR(100),
    description TEXT,
    salaryrange VARCHAR(50)
);

CREATE TABLE SalaryBonus (
    salary_ID INT PRIMARY KEY,
    Job_ID INT,
    amount DECIMAL(10,2),
    annual DECIMAL(10,2),
    bonus DECIMAL(10,2),
    
    CONSTRAINT fk_salary_job 
        FOREIGN KEY (Job_ID) 
        REFERENCES JobDepartment(Job_ID)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE Employee (
    emp_ID INT PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    gender VARCHAR(10),
    age INT,
    contact_add VARCHAR(100),
    emp_email VARCHAR(100) UNIQUE,
    emp_pass VARCHAR(50),
    Job_ID INT,
    
    CONSTRAINT fk_employee_job 
        FOREIGN KEY (Job_ID) 
        REFERENCES JobDepartment(Job_ID)
        ON DELETE SET NULL 
        ON UPDATE CASCADE
);

CREATE TABLE Qualification (
    QualID INT PRIMARY KEY,
    Emp_ID INT,
    Position VARCHAR(50),
    Requirements VARCHAR(255),
    Date_In DATE,

    CONSTRAINT fk_qualification_emp 
        FOREIGN KEY (Emp_ID) 
        REFERENCES Employee(emp_ID)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE Leaves (
    leave_ID INT PRIMARY KEY,
    emp_ID INT,
    date DATE,
    reason TEXT,

    CONSTRAINT fk_leave_emp 
        FOREIGN KEY (emp_ID) 
        REFERENCES Employee(emp_ID)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

CREATE TABLE Payroll (
    payroll_ID INT PRIMARY KEY,
    emp_ID INT,
    job_ID INT,
    salary_ID INT,
    leave_ID INT,
    date DATE,
    report TEXT,
    total_amount DECIMAL(10,2),

    CONSTRAINT fk_payroll_emp 
        FOREIGN KEY (emp_ID) 
        REFERENCES Employee(emp_ID)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,

    CONSTRAINT fk_payroll_job 
        FOREIGN KEY (job_ID) 
        REFERENCES JobDepartment(job_ID)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,

    CONSTRAINT fk_payroll_salary 
        FOREIGN KEY (salary_ID) 
        REFERENCES SalaryBonus(salary_ID)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,

    CONSTRAINT fk_payroll_leave 
        FOREIGN KEY (leave_ID) 
        REFERENCES Leaves(leave_ID)
        ON DELETE SET NULL 
        ON UPDATE CASCADE
);

-- EMPLOYEE INSIGHTS

-- How many unique employees are currently in the system?
SELECT COUNT(DISTINCT EMP_ID) AS UNIQUE_EMPLOYEES
FROM EMPLOYEE;

-- Which departments have the highest number of employees?
SELECT JOBDEPT AS DEPARTMENTS,
COUNT(EMP_ID) AS COUNT_EMPLOYEES
FROM JOBDEPARTMENT AS JD
JOIN EMPLOYEE AS E
ON JD.JOB_ID = E.JOB_ID
GROUP BY JOBDEPT
ORDER BY COUNT_EMPLOYEES DESC
LIMIT 1;

-- What is the average salary per department?
SELECT (AVG(ANNUAL) + AVG(AMOUNT) + AVG(BONUS)) AS AVERAGE_SALARY , JOBDEPT
FROM SALARYBONUS AS SB
JOIN JOBDEPARTMENT JD
ON SB.JOB_ID = JD.JOB_ID
GROUP BY JOBDEPT;

-- Who are the top 5 highest-paid employees?
SELECT E.EMP_ID,FIRSTNAME,LASTNAME,TOTAL_AMOUNT
FROM EMPLOYEE E
JOIN PAYROLL PR
ON E.EMP_ID = PR.EMP_ID
ORDER BY TOTAL_AMOUNT DESC
LIMIT 5;

-- What is the total salary expenditure across the company?
SELECT SUM(TOTAL_AMOUNT) AS TOTAL_SALARY_EXPENDITURE 
FROM PAYROLL;


-- JOB ROLE AND DEPARTMENT ANALYSIS

-- How many different job roles exist in each department?
SELECT COUNT(DISTINCT NAME) AS JOB_ROLES ,JOBDEPT AS DEPARTMENT
FROM JOBDEPARTMENT AS JD
GROUP BY DEPARTMENT
ORDER BY JOB_ROLES DESC;

-- What is the average salary range per department?
SELECT 
    Jobdept as Department,
    avg(
    cast(replace(substring_index(salaryrange,'-',-1) ,'$','') as unsigned)-cast(replace(substring_index(salaryrange,'-',1) ,'$','') as unsigned)
    ) as average_salary_range
    from jobdepartment
    group by department;

-- Which job roles offer the highest salary?
select name as job_roles ,
cast(replace(substring_index(salaryrange,'-',-1),'$','') as unsigned) as highest_salary
from jobdepartment
order by highest_salary desc;

-- Which departments have the highest total salary allocation?
select jobdept as Departments ,
sum(total_amount) as total_salary_allocation
from jobdepartment as jd
join payroll as pr
on jd.job_id = pr.job_id
group by departments
order by total_salary_allocation desc;

-- QUALIFICATION AND SKILLS ANALYSIS


--  How many employees have at least one qualification listed?
select count(distinct emp_id) as employee_qualification
from qualification;

-- Which positions require the most qualifications?
select  position , count(requirements) as most_qualification
from qualification
group by position
order by most_qualification desc;

-- Which employees have the highest number of qualifications?
select emp_id , count(requirements) as highest_no_of_qualifications
from qualification
group by emp_id
order by highest_no_of_qualifications;

-- LEAVE AND ABSENCE PATTERNS

-- Which year had the most employees taking leaves?
select year(date) as year , count(date) as total_leaves
from leaves 
group by year
order by total_leaves desc;

-- What is the average number of leave days taken by its employees per department?
select count(l.emp_id)/count(distinct e.emp_id) as average_leaves,jobdept as department
from employee as e
join leaves as l
on e.emp_id = l.emp_id
join jobdepartment as jd
on e.job_id = jd.job_id
group by department;

-- Which employees have taken the most leaves?
select concat(firstname, '',lastname) as employees , count(date) as emp_leaves
from leaves as l
join employee as e
on l.emp_id = e.emp_id
group by employees
order by  emp_leaves desc;

-- What is the total number of leave days taken company-wide?
select count(*) as total_leaves_companywide
from leaves;

-- How do leave days correlate with payroll amounts?
SELECT e.Emp_ID,
CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
COUNT(L.Leave_ID) AS LeaveDays,
P.Total_Amount AS PayrollAmount
FROM Employee e
LEFT JOIN Leaves L ON e.Emp_ID = L.Emp_ID
JOIN Payroll P ON e.Emp_ID = P.Emp_ID
GROUP BY e.Emp_ID, P.Total_Amount
ORDER BY LeaveDays DESC;

-- PAYROLL AND COMPENSATION ANALYSIS
-- What is the total monthly payroll processed?
select date_format(date,'%M') as month , sum(total_amount) as total_monthly 
from payroll
group by month;

-- What is the average bonus given per department?
select avg(bonus) as avg_bonus , jobdept as departments
from salarybonus as sb
join jobdepartment as jd
on sb.job_id = jd.job_id
group by departments;

-- Which department receives the highest total bonuses?
select jobdept as department , avg(bonus) as avg_bonus
from jobdepartment as jd
join salarybonus sb
on jd.job_id = sb.job_id
group by department
order by avg_bonus desc
limit 1;

-- What is the average value of total_amount after considering leave deductions?
select avg(total_amount) as avg_total_amount_leave_deductions
from leaves as l
join payroll as pr
on l.leave_id = pr.leave_id;

select * from jobdepartment;
select *  from salarybonus;
select * from employee;
select * from qualification;
select * from leaves;
select * from payroll;



