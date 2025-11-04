-- INSERT문
-- 신규 데이터를 저장하기 위해 사용하는 문
INSERT INTO employees(
	`name`
	,birth
	,gender
	,hire_at
	,fire_at
	,sup_id
	,created_at
	,updated_at
	,deleted_at
)
VALUES(
	'벼리'
	,'2011-06-23'
	,'F'
	,'2025-10-31'
	,NULL 
	,NULL 
	,NOW()
	,NOW()
	,NULL 
);

SELECT *
FROM employees
WHERE
	`name` = '벼리'
	AND birth = '2011-06-23'
	AND hire_at = '2025-10-31'
;

-- 연봉 데이터를 넣어주세요
INSERT INTO salaries (
	emp_id
	,salary
	,start_at
)
VALUE (
	100005
	,'1'
	,NOW()
);

SELECT *
FROM salaries
WHERE
	emp_id = 100005
;

-- SELECT INSERT
INSERT INTO salaries (
	emp_id
	, salary
	,start_at
)
SELECT
	emp_id
	, 3
	,created_at
FROM employees
WHERE
	`name` = '벼리'
	AND birth = '2011-06-23'
	AND hire_at = '2025-10-31'
;