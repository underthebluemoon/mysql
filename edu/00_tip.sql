-- '2025-10-31'의 값을 찾는다는 것은 '00:00:00'가 생략된 것으로 인식
-- WHERE	created_at = '2025-10-31'로 '2025-10-31 15:37:47'를 찾을 수 없음
-- DATE()를 이용: between '2025-10-31 00:00:01' and '2025-10-31 23:59:59' 와 같음
SELECT *
FROM employees
WHERE
	date(created_at) = '2025-10-31'
;

-- 해당 섹션의 오토 커밋 막음
-- 커밋 롤백 후 transaction 종료
START TRANSACTION;

-- 빠르게 필터링 하기 위해
-- WHERE절 : 인덱스 -> 많이 걸러낼 수 있는 조건부터

-- 범위 조건 : AND/OR 보다 BTWEEN/IN 우선 적용 

-- join : 왼쪽(main)에 있는 테이블일수록 적은 양
-- -> 보통 left join 사용. right join 사용 안 함