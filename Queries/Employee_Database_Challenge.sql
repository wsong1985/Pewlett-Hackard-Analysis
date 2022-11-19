----------------------
-- Deliverable #1	--
----------------------

-- Create a Retirement Titles table
SELECT e.emp_no, 
e.first_name, 
e.last_name,
t.title, 
t.from_date, 
t.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as t
ON e.emp_no = t.emp_no
WHERE e.birth_date BETWEEN '1952-01-01' and '1955-12-31'
ORDER BY e.emp_no;

-- SELECT * FROM retirement_titles LIMIT 10;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
INTO unique_titles
FROM retirement_titles
WHERE to_date = '9999-01-01'
ORDER BY emp_no, to_date DESC;

-- SELECT * FROM unique_titles LIMIT 10;

-- Create a Retiring Titles table
SELECT COUNT(u.title), 
u.title
INTO retiring_titles
FROM unique_titles AS u
GROUP BY u.title
ORDER BY COUNT(u.title) DESC;

-- SELECT * FROM retiring_titles;

----------------------
-- Deliverable #2	--
----------------------

-- Create a Mentorship Eligibility table
SELECT ei.emp_no,
ei.first_name,
ei.last_name,
ei.birth_date,
ei.from_date,
ei.to_date,
et.title
INTO mentorship_eligibility
FROM(
	SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	d.from_date,
	d.to_date
	FROM employees as e
	RIGHT JOIN dept_emp as d
	ON e.emp_no = d.emp_no
	WHERE d.to_date = '9999-01-01'
)	AS ei
INNER JOIN (
	SELECT DISTINCT ON (t.emp_no) t.emp_no, 
	t.title
	FROM titles as t
	ORDER BY t.emp_no
) as et
ON ei.emp_no = et.emp_no
WHERE ei.birth_date Between '1965-01-01' AND '1965-12-31'
ORDER BY ei.emp_no;

-- SELECT * FROM mentorship_eligibility LIMIT 10;

----------------------
-- Deliverable #3	--
----------------------

