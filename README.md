# Employee Management System

## 📌 Project Overview

The **Employee Management System** is a relational database project designed to manage employee information, job departments, payroll details, qualifications, salaries, bonuses, and leave records within an organization.

This system helps organizations efficiently store, organize, and retrieve employee-related data using **structured SQL tables and relationships**.

The project demonstrates the use of **database normalization, relational schema design, foreign keys, and data integrity constraints**.

---

## 🎯 Objectives

* Manage employee records efficiently
* Maintain department and job role information
* Track employee qualifications and career details
* Handle employee leave records
* Manage payroll and salary information
* Ensure data integrity using relational database constraints

---

## 🛠 Technologies Used

* **Database:** MySQL
* **Language:** SQL
* **Tools:** MySQL Workbench* 

---

## 🗂 Database Structure

The system contains the following tables:

### 1️⃣ JobDepartment

Stores job roles and department details.

| Column      | Description              |
| ----------- | ------------------------ |
| Job_ID      | Unique job identifier    |
| jobdept     | Department name          |
| name        | Job role name            |
| description | Job description          |
| salaryrange | Salary range for the job |

---

### 2️⃣ Employee

Stores employee personal and job-related information.

| Column      | Description             |
| ----------- | ----------------------- |
| emp_ID      | Unique employee ID      |
| firstname   | Employee first name     |
| lastname    | Employee last name      |
| gender      | Employee gender         |
| age         | Employee age            |
| contact_add | Contact address         |
| emp_email   | Employee email (unique) |
| emp_pass    | Employee login password |
| Job_ID      | Associated job role     |

---

### 3️⃣ Qualification

Stores employee qualification details.

| Column       | Description                |
| ------------ | -------------------------- |
| QualID       | Qualification ID           |
| Emp_ID       | Employee ID                |
| Position     | Job position               |
| Requirements | Qualification requirements |
| Date_In      | Date of joining            |

---

### 4️⃣ SalaryBonus

Stores salary and bonus details for jobs.

| Column    | Description      |
| --------- | ---------------- |
| salary_ID | Salary record ID |
| Job_ID    | Job role ID      |
| amount    | Base salary      |
| annual    | Annual salary    |
| bonus     | Bonus amount     |

---

### 5️⃣ Leaves

Stores employee leave records.

| Column   | Description      |
| -------- | ---------------- |
| leave_ID | Leave ID         |
| emp_ID   | Employee ID      |
| date     | Leave date       |
| reason   | Reason for leave |

---

### 6️⃣ Payroll

Stores payroll information for employees.

| Column       | Description         |
| ------------ | ------------------- |
| payroll_ID   | Payroll ID          |
| emp_ID       | Employee ID         |
| job_ID       | Job ID              |
| salary_ID    | Salary ID           |
| leave_ID     | Leave ID            |
| date         | Payroll date        |
| report       | Payroll report      |
| total_amount | Total salary amount |

---

## 🔗 Database Relationships

The database uses **foreign keys** to maintain relationships between tables:

* `Employee.Job_ID → JobDepartment.Job_ID`
* `SalaryBonus.Job_ID → JobDepartment.Job_ID`
* `Qualification.Emp_ID → Employee.emp_ID`
* `Leaves.emp_ID → Employee.emp_ID`
* `Payroll.emp_ID → Employee.emp_ID`
* `Payroll.job_ID → JobDepartment.Job_ID`
* `Payroll.salary_ID → SalaryBonus.salary_ID`
* `Payroll.leave_ID → Leaves.leave_ID`

These relationships ensure **referential integrity** across the system.

---


## 📊 Features

* Employee record management
* Department and job tracking
* Payroll and salary management
* Employee leave tracking
* Qualification management
* Relational database design with constraints

