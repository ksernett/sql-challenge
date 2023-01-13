-- create employee table and add data
CREATE TABLE employees (
	emp_no INT PRIMARY KEY NOT NULL,
	emp_title_id VARCHAR(50) NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	sex VARCHAR(1) NOT NULL,
	hire_date VARCHAR(50) NOT NULL
);

COPY employees(emp_no, emp_title_id, birth_date, first_name, last_name, sex, hire_date)
--NOTE: you will need to update the file path based on the location
FROM '/private/tmp/employees.csv'
DELIMITER ','
CSV HEADER;


-- create salaries table and add data
CREATE TABLE salaries (
	emp_no INT PRIMARY KEY NOT NULL,
	salary INT NOT NULL
);

COPY salaries(emp_no, salary)
--NOTE: you will need to update the file path based on the location
FROM '/private/tmp/salaries.csv'
DELIMITER ','
CSV HEADER;


-- create titles table and add data
CREATE TABLE titles (
	title_id VARCHAR(50) PRIMARY KEY NOT NULL,
	title VARCHAR(50) NOT NULL
);

COPY titles(title_id, title)
--NOTE: you will need to update the file path based on the location
FROM '/private/tmp/titles.csv'
DELIMITER ','
CSV HEADER;


-- create departments table and add data
CREATE TABLE departments (
	dept_no VARCHAR(50) PRIMARY KEY NOT NULL,
	dept_name VARCHAR(50) NOT NULL
);

COPY departments(dept_no, dept_name)
--NOTE: you will need to update the file path based on the location
FROM '/private/tmp/departments.csv'
DELIMITER ','
CSV HEADER;


-- create dept_emp table and add data
CREATE TABLE dept_emp(
	emp_no INT NOT NULL,
	dept_no VARCHAR(50) NOT NULL,
	PRIMARY KEY(emp_no, dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

COPY dept_emp(emp_no, dept_no)
--NOTE: you will need to update the file path based on the location
FROM '/private/tmp/dept_emp.csv'
DELIMITER ','
CSV HEADER;


-- create dept_manager table and add data
CREATE TABLE dept_manager(
	dept_no VARCHAR(50) NOT NULL,
	emp_no INT NOT NULL,
	PRIMARY KEY (dept_no, emp_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

COPY dept_manager(dept_no, emp_no)
--NOTE: you will need to update the file path based on the location
FROM '/private/tmp/dept_manager.csv'
DELIMITER ','
CSV HEADER;


--list the employee number, last name, first name, sex, and salary of each employee
SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
FROM employees
INNER JOIN salaries ON employees.emp_no=salaries.emp_no;


-- list the first name, last name, and hire date for the employees who were hired in 1986
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date LIKE '%1986';


--list the manager of each department along with their department number, department name, employee number, last name, and first name
SELECT departments.dept_no, departments.dept_name, dept_manager.emp_no, employees.last_name, employees.first_name
FROM dept_manager
INNER JOIN departments ON departments.dept_no=dept_manager.dept_no
INNER JOIN employees ON dept_manager.emp_no=employees.emp_no;


--list the department number for each employee along with that employee’s employee number, last name, first name, and department name
SELECT dept_emp.dept_no, dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM dept_emp
INNER JOIN employees ON dept_emp.emp_no=employees.emp_no
INNER JOIN departments ON departments.dept_no=dept_emp.dept_no;


--List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B
SELECT first_name, last_name, sex
FROM employees
WHERE first_name ='Hercules'
AND last_name LIKE 'B%';

--List each employee in the Sales department, including their employee number, last name, and first name dept_no d007
SELECT dept_emp.emp_no, employees.last_name, employees.first_name
FROM employees
INNER JOIN dept_emp ON employees.emp_no=dept_emp.emp_no
WHERE dept_emp.dept_no='d007';

--List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name
SELECT dept_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM employees
INNER JOIN dept_emp ON employees.emp_no=dept_emp.emp_no
INNER JOIN departments ON dept_emp.dept_no=departments.dept_no
WHERE departments.dept_name = 'Sales'
OR departments.dept_name = 'Development';

--List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name)
SELECT last_name, COUNT (last_name)
FROM employees
GROUP BY last_name
ORDER BY last_name DESC;


