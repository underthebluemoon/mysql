-- 테이블 전체 컬럼 조회
SELECT * 
from employees;

-- 테이블 특정 컬럼만 지정하여  조회
SELECT
	name
	, birth
-- 	, hire_at v002 del (주석처리를 위해 쉼표+검색내용 형식)
FROM employees;

-- where절 : 특정 컬럼의 값과 일치한 데이터만 조회 : 필터
SELECT *
FROM employees
WHERE
	emp_id = 5
;
	
-- 이름이 강영화 인 사원 조회
SELECT *
FROM employees
WHERE
	NAME = '강영화'
;

-- 이름이 강영화 이고, 성별이 M인 사원 조회 : and / or
SELECT *
FROM employees
WHERE
	NAME = '강영화'
	AND gender = 'm'
;

-- 이름이 강영화 이거나, 김영화인 사원 조회
SELECT *
FROM employees
WHERE
	NAME = '강영화'
	OR NAME = '김영화'
;

-- 날짜를 필터링 할 경우 : mysql은 date를 '문자열'로 사용가능
SELECT *
FROM employees
WHERE
	hire_at >= '2023-01-01'
;

-- 재직중인 사원 조회 (null 조회) : is null / is not null
SELECT *
FROM employees
WHERE
	fire_at IS null
;

-- WHERE 절에서 AND / OR 복합 사용 시 주의
-- 입사일이 20250101 이후거나 20000101이전이고,  이미 퇴사한 직원
SELECT *
FROM employees
WHERE
	(
		hire_at >= '2025-01-01'
		or hire_at <= '2000-01-01'
	)
	and fire_at IS NOT NULL
;
SELECT *
FROM employees
WHERE
	(
		NAME = '원성현'
		or NAME = '반승현'
	)
	AND birth >= '1990-01-01'
;

-- between 연산자 : 지정한 범위 내에 데이터를 조회
SELECT *
FROM employees
WHERE
	emp_id >= 10000
	AND emp_id <= 10010
;
SELECT *
FROM employees
WHERE
	emp_id BETWEEN 10000 AND 10010
;

-- in 연산자 : 지정한 값과 일치한 데이터를 조회
-- 사번이 5, 7, 9, 12인 사원 조회
SELECT *
FROM employees
WHERE
	emp_id = 5
	OR emp_id = 7
	OR emp_id = 9
	OR emp_id = 12
;

SELECT *
FROM employees
WHERE
	emp_id IN(5, 7, 9, 12)
;

-- like 연산자 : 문자열 내용을 조회할 때 사용. 퍼포먼스 이슈 조심
-- % : 글자수와 상관없이 조회
-- 이름이 '태호'인 사원 조회
SELECT *
FROM employees
WHERE
	NAME LIKE '%태호'
;
-- 이름이 '호'로 끝나는 사원 조회
SELECT *
FROM employees
WHERE
	NAME LIKE '%호'
;
-- 이름에 '호'가 포함되는 사원 조회
SELECT *
FROM employees
WHERE
	NAME LIKE '%호%'
;
-- _ : 언더 바의 개수만큼 글자의 개수
SELECT *
FROM employees
WHERE
	name LIKE '남궁_'
;

-- ORDER BY 절 : 데이터 정렬. 기본-데이터입력 순서
-- ASC : 오름차순
-- DESC : 내림 차순
SELECT *
FROM employees
ORDER BY NAME ASC 
;
SELECT *
FROM employees
ORDER BY birth deSC 
;
-- 동명이인의 생년월일 순으로 
SELECT *
FROM employees
ORDER BY
	NAME ASC
	, birth asc
;
-- 입사일이 2000년 이후인 사원을 이름, 생일, 오름차순으로 정렬 조회
-- 절의 실행 순서 주의
SELECT *
FROM employees
WHERE
	hire_at >= '2000-01-01'
ORDER BY
	NAME ASC
	, birth asc
;
-- 여자 사원을 이름, 생일 오름차순으로 정렬
SELECT *
FROM employees
WHERE
	gender = 'F'
ORDER BY
	NAME asc
	, birth ASC
;

-- DISTINCT 키워드 : 검색 결과에서 중복되는 레코드를 제거. 쓸 일 거의 없음
SELECT distinct NAME
FROM employees
ORDER BY NAME ASC
;

-- 집계 함수 
-- GROUP BY 절 : 그룹으로 묶어서 조회
-- HAVING 절 : GROUP BY 절의 조건 절
-- 집계 함수
-- 	MAX(최대값)
-- 	MIN(최소값)
--		COUNT(개수)
-- 	AVG(평균)
-- 	SUM(합계)

-- 사원 별 최고 연봉
-- as : 별칭 붙이기. 생략가능
SELECT
	emp_id
	, MAX(salary) max_salary
FROM salaries
GROUP BY emp_id
;

-- 사원 별 최고 연봉이 5000만원 이상인 사원 조회
SELECT
	emp_id
	, MAX(salary) max_salary
FROM salaries
GROUP BY emp_id
	HAVING MAX(salary) >= 50000000
;

-- 성별 사원의 수를 조회해 주세요
SELECT
	gender
	, COUNT(gender) AS COUNT_gender
FROM employees
GROUP BY gender
;
-- 재직 중인 성별 사원 수를 조회해주세요
SELECT
	gender
	, COUNT(gender) AS count_gender
FROM employees
WHERE fire_at IS NULL
GROUP BY
	gender
;

-- LIMIT, OFFSET : 출력하는 데이터의 개수를 제한. 정렬 필수
-- LIMIT : 가져올 데이터 개수 한정. 10 : 상위 10개만 가져옴
-- OFFSET : skip할 데이터 개수. 10 : 11번째 데이터부터 가져옴
-- 사원 번호로 오름차순 정렬해서 10개만 조회
SELECT *
FROM employees
ORDER BY
	emp_id ASC
LIMIT 10 OFFSET 0
;

-- 현재 받고 있는 급여 중 사원의 연봉 상위 5명 조회해주세요
SELECT *
FROM salaries
WHERE end_at IS NULL
ORDER BY salary DESC
LIMIT 5
;

-- SELECT문 기본 구조
-- SELECT [DISTINCT] 컬럼명
-- FROM [테이블명]
-- WHERE [쿼리 조건]
-- GROUP BY [컬럼명] HAVING [집계함수 조건]
-- ORDER BY [컬럼명 ASC || 컬럼명 DESC]
-- LIMIT [n] OFFSET [n]
-- ;