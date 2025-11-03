-- subQuery

-- ----------------------
--   WHERE절에서 사용
-- ----------------------
-- 단일 행 서브쿼리
-- 서브쿼리가 단일 행 비교연산자(=, <, <=, >, >=, <>)와 함께 쓸 경우,
-- 서브 쿼리의 결과수가 반드시 1건 이하
-- 2건일 경우, 오류 발생

-- 한 쿼리안에서 여러 테이블을 부를 경우, '테이블명.컬럼'으로 혼동 방지
-- 테이블명에 별칭을 줄 수 있음. 아래의 경우, department_managers depm

-- D001 부서장의 사번과 이름을 출력
SELECT
	employees.emp_id
	, employees.`name`
FROM employees
WHERE
	employees.emp_id = (
		SELECT depm.emp_id
		FROM department_managers depm
		WHERE
			depm.dept_code = 'D001'
			AND depm.end_at IS NULL
	)
;

SELECT
	*
FROM department_managers
WHERE
	end_at IS NULL
	AND dept_code = 'D001'
;

-- 다중 행 서브쿼리
-- 서브쿼리가 2건 이상 반환 될 경우,
-- 다중 행 비교연산자(IN, ALL, ANY, SOME, EXISTS 등)사용

--  현재 부서장인 사원의 사번과 이름을 출력
SELECT
	employees.emp_id
	, employees.`name`
FROM employees
WHERE
	employees.emp_id in (
		SELECT depm.emp_id
		FROM department_managers depm
		WHERE
			end_at IS NULL
	)
;

SELECT
	*
FROM department_managers
WHERE
	end_at IS NULL
;

-- 다중 열 서브쿼리 : 성능이슈 & join을 주로 이용
-- 서브쿼리의 결과가 복수의 컬럼을 반환할 경우,
-- 메인 쿼리의 조건과 동시 비교

-- 현재 D002의 부서장이 해당 부서에 소속된 날짜 출력
SELECT
	department_emps.*
FROM department_emps
WHERE
	(department_emps.emp_id,
	department_emps.dept_code) IN (
	SELECT
		department_managers.emp_id,
		department_managers.dept_code
	from
		department_managers
	where
		department_managers.dept_code = 'D002'
		AND department_managers.end_at IS null
	)
;
SELECT *
FROM department_managers
WHERE
	end_at IS null
	AND dept_code = 'D002'
;

-- 연관 서브쿼리
-- 서브쿼리 내에서 메인쿼리의 컬럼이 사용된 서브쿼리
-- 부서장 직을 지냈던 경력이 있는 사원의 정보 출력
SELECT
	employees.*
FROM employees
WHERE
	employees.emp_id IN (
		SELECT
			department_managers.emp_id
		FROM 
			department_managers
		WHERE 
			department_managers.emp_id = employees.emp_id
	)
;