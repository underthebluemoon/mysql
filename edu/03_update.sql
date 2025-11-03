-- UPDATE 문 : 기존 데이터베이터를 수정

UPDATE employees
SET
	fire_at = NOW()
	, deleted_at = NOW()
WHERE
	emp_id = 100005
;

SELECT *
FROM employees
WHERE
	emp_id = 100005
;

UPDATE salaries
SET salary = 30000000
WHERE
	sal_id = 1022177
;

SELECT *
FROM salaries
WHERE
	emp_id = 100005
;

SELECT *
FROM salaries
WHERE
	emp_id = 100000
	AND end_at IS NULL
;