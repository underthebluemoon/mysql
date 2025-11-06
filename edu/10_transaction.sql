-- TRANSACTION
-- 트랜잭션 시작 -> insert 시작
-- -> rollback/commit해야 트랜잭션 종료
-- rollback의 경우, 트랜잭션 이전으로 되돌아감 = insert한 것 조회 불가
-- commit의 경우, 트랜잭션 한 것이 적용됨 = insert한 것 조회 됨

-- 트랜잭션 시작
START TRANSACTION;

-- insert
INSERT INTO employees (	`name`, birth, gender, hire_at)
VALUES ('벼리', '2000-01-01', 'F', DATE(NOW()))
;

-- select
SELECT * FROM employees WHERE `name` = '벼리';

-- rollback
ROLLBACK;

-- commit
COMMIT;

-- A 세션에서 트랜잭션 진행중 (rollback/commit 아직)
-- -> B 세션에서 A의 진행중인 트랜잭션 영향 없음. 조회 불가
-- -> A의 트랜잭션이 commit하고 완료된 경우, B 세션에 영향 있음. 조회 가능 