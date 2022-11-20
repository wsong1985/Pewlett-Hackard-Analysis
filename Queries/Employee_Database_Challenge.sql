----------------------
-- Deliverable #1	--
----------------------

-- 1. Create a Retirement Titles table
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

----------------------------------------------------------

-- 2. Use Dictinct ON with Order By to remove duplicate rows
SELECT DISTINCT ON (r.emp_no) r.emp_no,
r.first_name,
r.last_name,
r.title
INTO unique_titles
FROM retirement_titles as r
WHERE r.to_date = '9999-01-01'
ORDER BY r.emp_no, r.to_date DESC;

-- SELECT * FROM unique_titles LIMIT 10;

----------------------------------------------------------

-- 3. Create a Retiring Titles table
SELECT COUNT(u.title), 
u.title
INTO retiring_titles
FROM unique_titles AS u
GROUP BY u.title
ORDER BY COUNT(u.title) DESC;

-- SELECT * FROM retiring_titles;

----------------------------------------------------------

----------------------
-- Deliverable #2	--
----------------------

-- 4. Create a Mentorship Eligibility table
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

----------------------------------------------------------

----------------------
-- Deliverable #3	--
----------------------

-- 5. How many roles will need to be filled as the "silver tsunami" begins to make impact?
SELECT SUM (r.count) AS "Total of Retiring Employees"
FROM retiring_titles as r;

-- 6. Are there enough qualified, retirement-ready employees in the departments to mentor the next generation of Pewlet-Hackard employees?
SELECT d.dept_name AS "Department Name",
m.title AS "Job Title",
m.mentor AS " Number of Retirement-Ready Employees",
m.student AS " Number of Employees Eligible for Mentorship Program"
From(
	SELECT e.dept_no,
	e.title,
	e.count AS "mentor",
	s.count AS "student"
	FROM(
		SELECT j.dept_no,
		j.title,
		COUNT(j.emp_no)
		FROM(
			SELECT u.emp_no,
			u.first_name,
			u.last_name,
			u.title,
			d.dept_no
			FROM unique_titles AS u
			INNER JOIN dept_emp AS d
			ON u.emp_no = d.emp_no
		) AS j
		GROUP BY j.dept_no, j.title
	) AS e
	FULL JOIN (
		SELECT j.dept_no,
		j.title,
		COUNT(j.emp_no)
		FROM(
			SELECT m.emp_no,
			m.first_name,
			m.last_name,
			m.title,
			d.dept_no
			FROM mentorship_eligibility AS m
			INNER JOIN dept_emp as d
			on m.emp_no = d.emp_no
		) AS j
		GROUP BY j.dept_no, j.title
	) AS s
	ON e.dept_no=s.dept_no AND e.title = s.title
) AS m
INNER JOIN departments as d
ON m.dept_no = d.dept_no;

-- SELECT r.title AS "Job Title",
-- r.count AS "Number of Retirement-ready Employees",
-- m.count AS "Number of Students in Mentorship Program"
-- FROM retiring_titles as r
-- INNER JOIN (
-- 	SELECT m.title, COUNT(m.emp_no)
-- 	FROM mentorship_eligibility AS m
-- 	GROUP BY m.title
-- ) as m
-- ON r.title = m.title
-- ORDER BY r.title;

