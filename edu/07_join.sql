-- JOIN문
-- 두개 이상의 테이블을 묶어서 하나의 결과 집합으로 출력

-- INNERJOIN
-- 여러 테이블이 공통적으로 만족하는 레코드를 출력 : 교집합
-- INNER JOIN = JOIN

-- 전 사원의 사번, 이름, 현재 급여를 출력해주세요
SELECT
	emp.emp_id
	, emp.`name`
	, sal.salary
FROM employees emp
	JOIN salaries sal
		ON emp.emp_id = sal.emp_id
WHERE sal.end_at IS NULL	
ORDER BY emp.emp_id ASC
;

-- 현재 재직중인 사원의 사번, 이름, 생일, 부서명
SELECT
	depe.emp_id
	, emp.`name`
	, emp.birth
	, dept.dept_code
	, dept.dept_name
FROM department_emps depe
	JOIN departments dept
		ON depe.dept_code = dept.dept_code
	JOIN employees emp
		ON depe.emp_id = emp.emp_id
			AND emp.fire_at IS null
WHERE
 depe.end_at IS NULL 
; 
 
--  LEFT JOIN
SELECT
	emp.*
	, sal.*
FROM employees emp
	left JOIN salaries sal
		ON emp.emp_id = sal.emp_id
			AND sal.end_at IS NULL 
;

-- UNION
-- 두개 이상의 쿼리의 결과를 합쳐서 출력
-- UNION (중복 레코드 제거)
-- UNION ALL (중복 레코드 제거 안 함)
SELECT * FROM employees WHERE emp_id IN(1,3)
UNION
SELECT * FROM employees WHERE emp_id IN(3,6)
;

-- SELFJOIN
-- 같은 테이블 끼리 JOIN

SELECT
	emp.emp_id AS junior_id
	, emp.`name` AS junior_name
	, supemp.emp_id AS supervisor_id
	, supemp.`name` AS supervisor_name
FROM employees emp
	JOIN employees supemp
		on emp.sup_id = supemp.emp_id
		AND emp.sup_id IS NOT NULL 
;

	