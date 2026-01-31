SELECT * 
FROM 
Parks_and_Recreation.employee_salary 
WHERE 
first_name = 'leslie'
; 


SELECT * 
FROM 
employee_salary 
WHERE 
-- first_name = 'leslie' 
salary <= 50000; 



SELECT * 
FROM 
employee_demographics 
WHERE 
birth_date > '1985-01-01';


SELECT * 
FROM 
employee_demographics 
WHERE 
birth_date > '1985-01-01' 
AND 
gender = 'male';



SELECT * 
FROM 
employee_demographics 
WHERE 
birth_date LIKE '%25' ; 


SELECT gender, 	AVG(age), MAX(age), MIN(age), COUNT(age)
FROM 
employee_demographics 
GROUP BY 
gender;

SELECT *
FROM 
employee_demographics 
ORDER BY 
gender;


SELECT gender, 	AVG(age)
FROM 
employee_demographics 
WHERE 
AVG(age) > 40
;


SELECT *
FROM 
employee_demographics emd
INNER JOIN 
employee_salary ems
ON 
emd.employee_id = ems.employee_id ;


SELECT *
FROM 
employee_demographics emd
LEFT JOIN 
employee_salary ems
ON 
emd.employee_id = ems.employee_id ;



SELECT first_name, last_name, 'old man' AS label
FROM 
employee_demographics
WHERE
age > 40 AND gender = 'male'
UNION 
SELECT first_name, last_name, 'old lady' AS label
FROM 
employee_demographics
WHERE
age > 40 AND gender = 'female'
UNION
SELECT first_name, last_name, 'Highly paid' AS label
FROM 
employee_salary
WHERE 
salary > 70000
ORDER BY 
first_name, last_name;


-- string functions 
SELECT first_name, LENGTH(first_name)
FROM 
employee_demographics
ORDER BY 2;

SELECT UPPER('diya');
SELECT LOWER('diya');

SELECT first_name, UPPER(first_name)
FROM 
employee_demographics;

SELECT first_name, REPLACE(first_name, 'Mark', 'diya')
FROM 
employee_demographics;

SELECT first_name, LOCATE('An',first_name)
FROM
employee_demographics;

SELECT first_name,last_name,
CONCAT(first_name,' ',last_name) AS full_name
FROM
employee_demographics;

-- case statements
 SELECT first_name, last_name, age,
 CASE
 WHEN age <= 30 THEN 'Young'
 WHEN age BETWEEN 31 AND 50 THEN 'old'
 WHEN age >= 50 THEN 'granny'
END AS age_bracket
FROM
employee_demographics;


 SELECT first_name, last_name, salary,
 CASE
 WHEN salary < 50000 THEN salary * 1.05
 WHEN salary > 50000 THEN salary * 1.07
END AS new_salary,
CASE
WHEN dept_id = 6 THEN salary * .10
END AS Bonus
FROM
employee_salary;


-- SUBQUERIES IN MYSQL
SELECT *
FROM
employee_demographics
WHERE employee_id IN 
			(SELECT employee_id
				FROM
					employee_salary
                     WHERE dept_id = 1)
;


-- window functions
SELECT gender, AVG(salary) OVER(PARTITION BY gender)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
;

SELECT dem.first_name, dem.last_name,gender, salary,
SUM(salary) OVER(PARTITION BY gender ORDER BY dem.employee_id) AS Rolling_Ttal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
    
    SELECT dem.employee_id, dem.first_name, dem.last_name,gender, salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num,
RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rank_num,
DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS Dense_rank_num
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
    
    -- CTEs
    
   WITH CTE_Example AS
   (
   SELECT gender, AVG(salary) avg_sal, MAX(salary) max_sal, MIN(salary) min_sal, COUNT(salary) count_sal
FROM 
employee_demographics dem
JOIN 
employee_salary sal
ON 
dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT AVG(avg_sal)
FROM CTE_Example
;


-- Temp Tables

CREATE TEMPORARY TABLE temp_table
(first_name varchar(50),
last_name varchar(50),
favorite_movie varchar(100)
);

SELECT *
FROM temp_table;

INSERT INTO temp_table
VALUES ('Mercy', 'George', 'Lord Of The Rings:  The Two Towers');

SELECT *
FROM temp_table;

SELECT *
FROM employee_salary;

CREATE TEMPORARY TABLE salary_over_50k
SELECT *
FROM employee_salary
where salary >= 50000;

SELECT *
FROM salary_over_50k;


-- Stored Proceedures

CREATE PROCEDURE large_salaries()
SELECT *
FROM employee_salary
WHERE salary >= 50000;

CALL large_salaries();


DELIMITER $$
CREATE PROCEDURE large_salaries2()
BEGIN
SELECT *
	FROM employee_salary
	WHERE salary >= 50000;
	SELECT *
	FROM employee_salary
	WHERE salary >= 10000;
END $$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE large_salaries3()
BEGIN
SELECT *
	FROM employee_salary
	WHERE salary >= 50000;
	SELECT *
	FROM employee_salary
	WHERE salary >= 10000;
END $$
DELIMITER ;

CALL large_salaries3();


DELIMITER $$
CREATE PROCEDURE large_salaries4(p_employee_id INT)
BEGIN
SELECT salary
	FROM employee_salary
    WHERE employee_id = p_employee_id
	 ;
END $$
DELIMITER ;

CALL large_salaries4(1);

-- Triggers and Events

SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;


DELIMITER $$
CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary
    FOR EACH ROW
BEGIN
	INSERT INTO employee_demographics (employee_id, first_name,last_name)
    VALUES (NEW.employee_id, NEW.first_name, NEW.last_name);
END $$
DELIMITER ;

INSERT INTO employee_salary (employee_id, first_name, last_name, occupation,
salary, dept_id)
VALUES(13, 'Jean-Ralphin', 'Saperstein', 'Entertainment 720 CEO', 1000000, NULL);