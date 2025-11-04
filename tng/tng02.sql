-- 1. 사원의 사원번호, 이름, 직급코드를 출력해 주세요.
SELECT
	emp.emp_id
	, emp.`name`
	, t_emp.title_code
FROM employees emp
	JOIN title_emps t_emp
		ON emp.emp_id = t_emp.emp_id
		AND t_emp.end_at IS null
;	

-- 2. 사원의 사원번호, 성별, 현재 연봉을 출력해 주세요.
SELECT
	emp.emp_id
	, emp.gender
	, sal.salary
FROM employees emp
	JOIN salaries sal
		ON emp.emp_id = sal.emp_id
		AND sal.end_at IS null
;

-- 3. 10010 사원의 이름과 과거부터 현재까지 연봉 이력을 출력해 주세요.
SELECT
	emp.emp_id
	, emp.`name`
	, sal.salary
FROM employees emp
	JOIN salaries sal
		ON emp.emp_id = sal.emp_id
WHERE
	emp.emp_id = 10010
;

-- 4. 사원의 사원번호, 이름, 소속부서명을 출력해 주세요.
SELECT
	emp.emp_id
	, emp.`name`
	, d_emp.dept_code
FROM employees emp
	JOIN department_emps d_emp
		ON emp.emp_id = d_emp.emp_id
		AND d_emp.end_at IS null
;

-- 5. 현재 연봉의 상위 10위까지 사원의 사번, 이름, 연봉을 출력해 주세요.
SELECT
	emp.emp_id
	, emp.`name`
	, sal.salary
FROM employees emp
	JOIN salaries sal
		ON emp.emp_id = sal.emp_id
		AND sal.end_at IS null
ORDER BY sal.salary DESC 
LIMIT 10
;

-- 6. 현재 각 부서의 부서장의 부서명, 이름, 입사일을 출력해 주세요.
SELECT
	dep.dept_name
	, emp.`name`
	, emp.hire_at
FROM employees emp
	JOIN department_managers d_mana
		ON emp.emp_id = d_mana.emp_id
		AND d_mana.end_at IS NULL
	JOIN departments dep
		ON d_mana.dept_code = dep.dept_code
;	

-- 7. 현재 직급이 "부장"인 사원들의 연봉 평균을 출력해 주세요.
-- 현재 각 부장별 이름, 연봉평균
SELECT
	emp.`name`
	, AVG(sal.salary)
FROM employees emp
	JOIN title_emps t_emp
		ON emp.emp_id = t_emp.emp_id
		AND t_emp.title_code = 'T005'
		AND t_emp.end_at IS null
	JOIN salaries sal
		ON emp.emp_id = sal.emp_id
GROUP BY emp.emp_id
	HAVING AVG(sal.salary)
;

-- 8. 부서장직을 역임했던 모든 사원의 이름과 입사일, 사번, 부서번호를 출력해 주세요.
SELECT
	emp.emp_id
	, emp.`name`
	, emp.hire_at
	, d_mana.dept_code
FROM employees emp
	JOIN department_managers d_mana
		ON emp.emp_id = d_mana.emp_id
;

-- 9. 현재 각 직급별 평균연봉 중 60,000,000이상인 직급의 직급명, 평균연봉(정수)를을
--		평균연봉 내림차순으로 출력해 주세요.
SELECT
	t_emp.title_code
	, floor(AVG(sal.salary)) avg_sal
FROM title_emps t_emp
	JOIN salaries sal
		ON t_emp.emp_id = sal.emp_id
		AND sal.end_at IS null
GROUP BY t_emp.title_code
	having avg_sal >= 60000000
ORDER BY avg_sal DESC 
;


-- 10. 성별이 여자인 사원들의 직급별 사원수를 출력해 주세요.
SELECT
	emp.gender
	, t_emp.title_code
	, COUNT(t_emp.title_code) count_title
FROM employees emp
	JOIN title_emps t_emp
		ON emp.emp_id = t_emp.emp_id
WHERE
	emp.gender = 'F'
GROUP BY
	t_emp.title_code
;