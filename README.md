# 📊 Job Market & Skills Analysis

## 📌 Project Overview

This project analyzes job posting data using PostgreSQL and SQL to identify trends in the job market, with a particular focus on Data Analyst roles.

The analysis explores job demand, salary trends, locations, companies, and the skills most frequently associated with Data Analyst positions.

---

## 🎯 Project Objectives

The main objectives of this project are to:

- Analyze overall job market demand
- Identify Data Analyst job opportunities
- Explore salary trends
- Analyze job locations and remote opportunities
- Identify companies hiring Data Analysts
- Determine the most demanded skills
- Analyze skills associated with higher observed salaries
- Apply advanced SQL techniques to derive insights

---

## 🗂️ Dataset

The dataset contains **787,686 job postings** across multiple job roles.

The analysis focuses particularly on **196,593 Data Analyst job postings**.

The database contains information about:

- Job postings
- Companies
- Skills
- Job-skill relationships
- Salaries
- Locations

---

## 🛠️ Tools & Technologies

- PostgreSQL
- SQL
- pgAdmin 4
- Visual Studio Code
- GitHub

---

## 🧠 SQL Concepts Used

This project demonstrates:

- SELECT
- WHERE
- GROUP BY
- ORDER BY
- HAVING
- Aggregate Functions
- INNER JOIN
- Subqueries
- Common Table Expressions (CTEs)
- Window Functions
- RANK()
- Data filtering and aggregation

---

## 🔍 Business Questions

The analysis answers questions such as:

1. Which job roles are most frequently posted?
2. How many Data Analyst jobs are available in the dataset?
3. Where are Data Analyst jobs concentrated?
4. How do remote opportunities compare with other postings?
5. What are the salary patterns for Data Analyst roles?
6. Which companies have the most Data Analyst postings?
7. Which skills are most frequently requested?
8. What percentage of Data Analyst postings mention specific skills?
9. Which skills are associated with higher observed salaries?
10. How do skill demand and salary compare?

---

## 📈 Analysis Structure

The SQL analysis is organized into the following areas:

### 1. Job Market Analysis
Analysis of job postings and job title demand.

### 2. Data Analyst Market
Analysis of Data Analyst postings, locations, and remote opportunities.

### 3. Salary Analysis
Exploration of salary ranges and average salaries.

### 4. Company Analysis
Identification of companies with Data Analyst job postings.

### 5. Skills Analysis
Analysis of skill demand across Data Analyst postings.

### 6. Skill & Salary Analysis
Comparison of skill demand with observed salary levels.

### 7. Advanced SQL Analysis
Application of:

- CTEs
- Subqueries
- Window Functions
- RANK()

---

## 📁 Project Files

```text
job-market-skills-analysis/
│
├── 01_data_exploration.sql
└── README.md

---

## 💡 Key Insights

### Job Market
- The dataset contains **787,686 job postings** across multiple roles.
- **196,593 postings** are categorized as Data Analyst roles.

### Job Demand
The analysis identifies the most frequently posted job categories and highlights the position of Data Analyst roles within the overall dataset.

### Geographic Trends
Data Analyst postings were analyzed by location to identify areas with higher concentrations of opportunities.

### Remote Work
The analysis compares remote and non-remote Data Analyst opportunities based on the available job-posting data.

### Salary Trends
Salary statistics were calculated for Data Analyst positions where annual salary information was available.

### Skill Demand
The analysis identifies frequently requested technical skills across Data Analyst job postings.

### Skill & Salary Analysis
Skills were analyzed using both demand frequency and observed average salary, allowing the results to be compared across two dimensions:

**Skill Demand ↔ Observed Salary**
