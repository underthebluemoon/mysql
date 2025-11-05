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

-- 풀이
SELECT
	emp.emp_id
	, emp.`name`
	, tite.title_code
FROM employees emp
	JOIN title_emps tite
		ON emp.emp_id = tite.emp_id
		AND tite.end_at IS NULL
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

-- 풀이
SELECT
	emp.`name`
	, sal.start_at
	, sal.end_at
	, sal.salary
FROM employees emp
	JOIN salaries sal
		ON emp.emp_id = sal.emp_id
		AND emp.emp_id = 10010
ORDER BY sal.start_at
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

-- 풀이
SELECT
	emp.emp_id
	, emp.`name`
	, dept.dept_name
FROM employees emp
	JOIN department_emps depe
		ON emp.emp_id = depe.emp_id
		AND depe.end_at IS null
	JOIN departments dept
		ON dept.dept_code = depe.dept_code
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

-- 풀이
-- 데이터상의 누락으로 인해 퇴사자 검증 필요
-- 1.2초 소요 -> 개선 필요
SELECT
	emp.emp_id
	, emp.`name`
	, sal.salary
FROM employees emp
	JOIN salaries sal
		ON emp.emp_id = sal.emp_id
		AND sal.end_at IS null
		AND emp.fire_at IS NULL
ORDER BY sal.salary DESC
LIMIT 10
;

-- 개선 방향 : 서브 쿼리 사용
-- salaries에서 상위 10을 먼저 계산한 뒤 조인 하는 방법

-- 조인할 상위 10의 salaries
SELECT
	sal.emp_id
	, sal.salary
FROM salaries sal
WHERE 
	sal.end_at IS null
ORDER BY sal.salary DESC
LIMIT 10
;

SELECT
	emp.emp_id
	, emp.`name`
	, tmp_sal.salary
FROM employees emp
	JOIN (
		SELECT
			sal.emp_id
			, sal.salary
		FROM salaries sal
		WHERE 
			sal.end_at IS null
		ORDER BY sal.salary DESC
		LIMIT 10
	) tmp_sal
		ON emp.emp_id = tmp_sal.emp_id
WHERE emp.fire_at IS NULL
ORDER BY tmp_sal.salary DESC
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

-- 풀이
-- 퇴사자 처리 추가
-- 데이터 양이 적은 department_managers 를 메인으로
-- 정렬 추가
SELECT
	dept.dept_name
	, emp.`name`
	, emp.hire_at
FROM department_managers depm
	JOIN departments dept
		ON depm.dept_code = dept.dept_code
		AND depm.end_at IS NULL
	JOIN employees emp
		ON depm.emp_id = emp.emp_id
		AND emp.fire_at IS null
ORDER BY dept.dept_code ASC 
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

-- 풀이
-- 7-1. 현재 부장인 사람들의 연봉 평균
SELECT
	AVG(sal.salary) avg_sal
FROM titles tit
	JOIN title_emps tite
		ON tit.title_code = tite.title_code
		AND tit.title = '부장'
		AND tite.end_at IS NULL
	JOIN salaries sal
		ON tite.emp_id = sal.emp_id
		AND sal.end_at IS NULL 
;
-- 7-2. 현재 각 부장별 이름, 연봉 평균
-- group by 사용한 경우, 그룹으로만든 컬럼만 select에서 사용 가능
-- 임시 해결 방안 : select에서 사용한 `name`을 그룹 조건에 추가
-- 다른 해결 방안 : 서브쿼리 사용
SELECT
	emp.`name`
	, AVG(sal.salary)
FROM titles tit
	JOIN title_emps tite
		ON tit.title_code = tite.title_code
		AND tit.title = '부장'
		AND tite.end_at IS null
	JOIN employees emp
		ON emp.emp_id = tite.emp_id
		AND emp.fire_at IS null
	JOIN salaries sal
		ON emp.emp_id = sal.emp_id
GROUP BY sal.emp_id, emp.`name`
;

-- group으로 묶는 임시테이블을 만들어, 서브쿼리로 사용
-- 메인과 임시 테이블을 조인하여 group을 직접적으로 사용하지 않음
SELECT
	emp.`name`
	, sub_salaries.avg_sal
FROM employees emp
	JOIN (
		SELECT 
			sal.emp_id
			, AVG(sal.salary) avg_sal
		FROM title_emps tite
			JOIN titles tit
				ON tite.title_code = tit.title_code
				AND tit.title = '부장'
				AND tite.end_at IS null
			JOIN salaries sal
				ON sal.emp_id = tite.emp_id
		GROUP BY sal.emp_id	
	) sub_salaries
		ON emp.emp_id = sub_salaries.emp_id
		AND emp.fire_at IS NULL
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

-- 풀이
-- 다른 부서의 장을 한 사람이 맡은 적 이 있다면,
-- 중복 데이터가 있을 수 있음
SELECT
	emp.`name`
	, emp.hire_at
	, emp.emp_id
	, depm.dept_code
FROM department_managers depm
	JOIN employees emp
		ON depm.emp_id = emp.emp_id	
;


-- 9. 현재 각 직급별 평균연봉 중 60,000,000이상인 직급의 직급명, 평균연봉(정수)를을
--		평균연봉 내림차순으로 출력해 주세요.
SELECT
	t_emp.title_code
	, tit.title
	, floor(AVG(sal.salary)) avg_sal
FROM title_emps t_emp
	JOIN salaries sal
		ON t_emp.emp_id = sal.emp_id
		AND sal.end_at IS null
		AND t_emp.end_at IS null
	JOIN titles tit
		ON t_emp.title_code = tit.title_code
GROUP BY t_emp.title_code
	having avg_sal >= 60000000
ORDER BY avg_sal DESC 
;

-- 풀이
-- 돈, 포인트 관련은 보통 올림 사용
-- group by 관련 7번 문항 확인
SELECT
	tit.title
	, CEILING(AVG(sal.salary)) avg_sal
FROM salaries sal
	JOIN title_emps tite
		ON sal.emp_id = tite.emp_id
		AND sal.end_at IS null
		AND tite.end_at IS null
	JOIN titles tit
		ON tit.title_code = tite.title_code
GROUP BY tit.title
	HAVING avg_sal >= 60000000
ORDER BY avg_sal desc
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
	AND t_emp.end_at IS null
	AND emp.fire_at IS null
GROUP BY
	t_emp.title_code
;

-- 풀이
SELECT
	tite.title_code
	, COUNT(*) cnt_f_emp
FROM employees emp
	JOIN title_emps tite
		ON emp.emp_id = tite.emp_id
		AND emp.fire_at IS NULL 
		AND tite.end_at IS NULL 
		AND emp.gender = 'F'
GROUP BY tite.title_code
;

-- 각 직급별 성별 인원
SELECT
	tite.title_code
	, emp.gender
	, COUNT(*) cnt_f_emp
FROM employees emp
	JOIN title_emps tite
		ON emp.emp_id = tite.emp_id
		AND emp.fire_at IS NULL 
		AND tite.end_at IS NULL
GROUP BY tite.title_code, emp.gender
ORDER BY tite.title_code, emp.gender
;

-- 응용 : 위의 데이터에서 직급명 출력
SELECT
	tit.title
	, cnt_t_gen.gender
	, cnt_t_gen.cnt_gen
FROM titles tit
	JOIN (
		SELECT
			tite.title_code
			, emp.gender
			, COUNT(*) cnt_gen
		FROM employees emp
			JOIN title_emps tite
				ON emp.emp_id = tite.emp_id
				AND emp.fire_at IS NULL 
				AND tite.end_at IS NULL
		GROUP BY tite.title_code, emp.gender
	) cnt_t_gen
		ON tit.title_code = cnt_t_gen.title_code
ORDER BY cnt_t_gen.title_code, cnt_t_gen.gender