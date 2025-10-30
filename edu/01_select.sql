-- 테이블 전체 컬럼 조회
SELECT * 
from employees;

-- 테이블 특정 컬럼만 지정하여  조회
SELECT
	name
	, birth
-- 	, hire_at v002 del (주석처리를 위해 쉼표+검색내용 형식)
FROM employees;

-- where절 : 특정 컬럼의 값과 일치한 데이터만 조회 = 필터
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

-- 이름이 강영화 이고, 성별이 M인 사원 조회
SELECT *
FROM employees
WHERE
	NAME = '강영화'
	AND gender = 'm'
;