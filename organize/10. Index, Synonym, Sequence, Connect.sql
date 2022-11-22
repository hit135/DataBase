
-- 조회

-- ALL OBJECTS : 오브젝트 조회
-- ALL_SYNONYMS : 시노님 조회
-- ALL_IND_COLUMNS : 테이블 인덱스 정보 조회
-- ALL_TAB_COLUMNS : 테이블별 컬럼 정보 조회


/*
    인덱스
    테이블에 있는 데이터를 빨리 찾기 위한 용도의 데이터베이스 객체
    EX) 책의 목차와도 같다.
    
    가장 일반적이고 표준인 B-tree 인덱스
    인덱은 테이블에 있는 한 개 이상의 컬럼으로 만들 수 있다.
    인덱스
*/

CREATE TABLE ex2_20
(
    col1 VARCHAR2(20),
    col2 NUMBER(10),
    col3 VARCHAR2(100)
);

DROP TABLE ex2_20;

-- UNIQUE 인덱스는 컬럼 값에 중복값을 허용하지 않는다
CREATE UNIQUE INDEX ex2_20_idx01
ON ex2_20 (col1);
-- 기본키 제약조건을 생성해도 디폴트로 UNIQUE 인덱스를 생성해 준다.
-- 즉 PK를 설정하면 디폴트값으로 유니크 인덱스를 생성

SELECT * FROM user_indexes
WHERE table_name = 'EX2_20';    -- 인덱스 확인

SELECT index_name, index_type, table_name uniqueness
  FROM user_indexes
 WHERE table_name = 'EX2_20';
 
SELECT constraint_name, constraint_type, table_name, index_name
  FROM user_constraints
 WHERE table_name = 'JOB_HISTORY';
 
SELECT index_name, index_type, table_name, uniqueness
  FROM user_indexes
 WHERE table_name = 'JOB_HISTORY';


/*
    1개 이상의 컬럼으로 인덱스를 만들 수 있음.
    인덱스 자체에 키와 매핑 주소 값을 별도로 저장한다.
    따라서 테이블 입력, 삭제, 수정할 때 인덱스에 저장된 벙보도 수정된다.
    그러므로 너무 인덱스를 많이 만들면
    SELECT 이외의 INSERT, DELETE, UPDATE 시 서능에 부하가 뒤따른다.
*/

CREATE INDEX ex2_20_idx02
ON ex2_20 (col1, col2);

SELECT index_name, index_type, table_name, uniqueness
  FROM user_indexes
 WHERE table_name = 'EX2_20';
 
-- 인덱스 삭제
DROP INDEX ex2_20_idx02;

인덱스 생성시 고려사항
 (1) 일반적으로 테이블 전체 로우 수의 15% 이하의 데이터를 조회할 때 인덱스를 생성한다.
 (2) 테이블 건수가 적다면 굳이 인덱스를 만들 필요없다.
     데이터 추출을 위해 테이블이나 인덱스를 탐색하는 것을 스캔이라고 하는데
     테이블 건수가 적으면 인덱스를 경유하기보다 테이블 전체를 스캔하는 것이 빠르다
 (3) 데이터의 유일성 정도가 좋거나 범위가 넓은 값을 가진 컬럼을 인덱스로 만드는 것이 좋다.
 (4) NULL이 많이 포함된 컬럼은 인덱스 컬럼으로 만들기 적당하지 않다.
 (5) 결합 인덱스를 만들 때는, 컬럼의 순서가 중요하다.
 (6) 테이블에 만들 수 있는 인덱스 수의 제한은 없으나, 너무 많으면 오히려 성능 부하가 발생한다.


/*
 시노님
 Synonym은 '동의어'란 뜻으로 객체 각자의 고유한 이름에 대한 동의어를 만드는 것,
 PUBLIC 모든 사용자 접근 가능
 PRIVATE 시노님은 특정 사용자만 참조된느 시노님
 
 시노님 생성시 PUBLIC을 생략하면 PRIVATE 시노님이 만들어 진다.
 PUBLIC 시노님은 DBA권한이 있는 사용자만 생성 및 삭제 가능.
*/;

CREATE OR REPLACE SYNONYM syn_channel
FOR channels;

SELECT COUNT(*)
FROM syn_channel;

SELECT *
FROM syn_channel;

CREATE OR REPLACE SYNONYM syn_channel2 FOR channels;

-- java 계정에서 다른 계정으로 권한주기
GRANT SELECT ON syn_channel TO HR;
GRANT SELECT ON syn_channel2 TO system;

-- 디폴트 값이 private이므로..!
-- public으로 만들면 어디서든 붙을 수 있다

CREATE OR REPLACE PUBLIC SYNONYM syn_channel2 FOR channels;

DROP SYNONYM syn_channel;

시노님 사용 이유
 
 1. 데이터베이스의 투명성을 제공하기 위해, 다른 사용자의 객체를 참조할 때 사용
 2. 시노님을 생성해 놓으면 나중에 시노님이
    참조하고 있는 객체의 이름이 바뀌어도 이전에 작성해 놨던 SQL 문을 수정할 필요가 없다.
 3. 시노님은 별칭이므로 원 객체를 숨길 수 있다.
    (보안) private는 소유자명.시노님 명이지만 public은 소유자 명도 숨길 수 있다.


-- 시퀀스 : Sequence 는 자동 순번을 반환하는 데이터베이스 객체
CREATE SEQUENCE my_seq1
INCREMENT BY 1  -- 증강숫자
START WITH 1    -- 시작숫자
MINVALUE 1      -- 최솟값 (시작숫자보다 작거나 같아야 함)
MAXVALUE 1000   -- 최댓값 (시작숫자 보다 커야함)
NOCYCLE         -- 디폴트 값으로 최대나 최솟값에 도달하면 생성 중지
NOCACHE         -- 디폴트로 메모리에 시퀀스 값을 미리 할당해 놓지 않으며 디폴트 값은 20
;

CREATE SEQUENCE my_seq1
INCREMENT BY 1 
START WITH 1  
MINVALUE 1     
MAXVALUE 1000  
NOCYCLE      
NOCACHE         
;


SELECT my_seq1.CURRVAL  -- 현재 시퀀스값
FROM dual;
SELECT my_seq1.NEXTVAL  -- 시퀀스에서 다음 순번 값을 가져온다.
FROM dual;


SELECT my_seq1.CURRVAL
FROM dual;
SELECT my_seq1.NEXTVAL 
FROM dual;

CREATE TABLE ex11_1 (
    col1 NUMBER
);

SELECT * FROM ex11_1;

-- 테이블에 시퀀스 넣기
INSERT INTO ex11_1 (col1) VALUES (my_seq1.NEXTVAL);

-- 시퀀스를 못 쓴다면
SELECT MAX(col1) + 1 FROM ex11_1;

INSERT INTO ex11_1 (col1) VALUES ((SELECT MAX(col1) + 1 FROM ex11_1));

-- 지금은 섞어 썼지만 실제로는 섞어쓰면 안된다..
-- 시퀀스의 현재 값이 달라지므로

-- MAX로 쓰기...!
CREATE TABLE ex11_2 (
    col1 NUMBER
);

SELECT NVL(MAX(col1),0) + 1 FROM ex11_2;

/* 최솟값 1, 최댓값 999999999, 1000부터 시작해서 2씩 증가하는
   ORDERS_SEQ 라는 시퀀스를 만들어보자(NOCYCLE) */
   
CREATE SEQUENCE ORDERS_SEQ
INCREMENT BY 2 
START WITH 1000  
MINVALUE 1     
MAXVALUE 999999999  
NOCYCLE      
NOCACHE         
;

SELECT ORDERS_SEQ.CURRVAL
FROM dual;
SELECT ORDERS_SEQ.NEXTVAL 
FROM dual;


-- 책 209p 계층형 쿼리
SELECT * FROM departments;

-- 이런 느낌으로 꺼내기
10	총무기획부
    20	마케팅	10
    30	구매/생산부	10
        170	생산팀	30
        180	건설팀	30
        200	운영팀	30
        210	IT 지원	30
        220	NOC	30
    40	인사부	10
    50	배송부	10
;

-- sort는 정렬을 하기 위해서 만든다
-- 최상위 계층
SELECT department_id
     , department_name
     , 0                            AS parent_id
     , 1                            AS levels
     , parent_id || department_id   AS sort
  FROM departments
 WHERE parent_id IS NULL
UNION ALL
-- 하위 계층
SELECT t2.department_id
     , LPAD(' ', 3 * (2-1)) || t2.department_name   AS department_name
     , t2.parent_id
     , 2                                            AS levles
     , t2.parent_id || t2.department_id             AS sort
  FROM departments t1
     , departments t2
 WHERE t1.parent_id IS NULL
   AND t2.parent_id = t1.department_id
UNION ALL
-- 그 다음 하위 계층
SELECT t3.department_id
     , LPAD(' ' , 3 * (3-1)) || t3.department_name      AS department_name
     , t3.parent_id
     , 3                                                AS levels
     , t2.parent_id || t3.parent_id || t3.department_id AS sort
  FROM departments t1
     , departments t2
     , departments t3
 WHERE t1.parent_id IS NULL
   AND t2.parent_id = t1.department_id
   AND t3.parent_id = t2.department_id
UNION ALL
-- 마지막 하위 계층
SELECT t4.department_id
     , LPAD(' ' , 3 * (4-1)) || t4.department_name                      AS department_name
     , t4.parent_id
     , 4                                                                AS levels
     , t2.parent_id || t3.parent_id || t4.parent_id || t4.department_id AS sort
  FROM departments t1
     , departments t2
     , departments t3
     , departments t4
 WHERE t1.parent_id IS NULL
   AND t2.parent_id = t1.department_id
   AND t3.parent_id = t2.department_id
   AND t4.parent_id = t3.department_id
 ORDER BY sort;

-- CONNECT BY를 안쓰고
-- 이걸로 구현하는 구조를 알고는 있어야 한다..
-- 부서 시스템, 댓글.. 대댓글 이런느낌
-- 글의 답글.. 답글의 답글..

/*
    위와 같은 쿼리의 문제점은
    1. 현 부서의 계층 구조는 4레벨이지만, 레벨이 더 많아지면 쿼리를 수정해서 작성해야한다.
    2. 레벨 수 자체를 직접 코딩함(하드코딩)
    3. 쿼리가 복잡해 파악하는데 오래 걸림.
*/

-- 댓글의 댓글의 댓글 구조, 구문 인터넷에 찾아보기

-- 위의 복잡한 쿼리를
-- CONNECT BY를 쓰면 간단하다
-- but, ORACLE에서만 사용가능 하다..

SELECT department_id
     , LPAD(' ' , 3 * (LEVEL - 1)) || department_name AS department_name
     , LEVEL
  FROM departments
 START WITH parent_id IS NULL                   -- 최상위 조건
 CONNECT BY PRIOR department_id = parent_id;    -- 계층형 구조의 조건

-- PRIOR aa = bbbb >>> 이전 aa가 bbbb와 같다
-- LEVEL도 CONNECT BY와 함께 자주 쓴다.

SELECT a.employee_id
     , LPAD(' ' , 3 * (LEVEL - 1)) || a.emp_name
     , LEVEL
     , b.department_name
  FROM employees a
     , departments b
 WHERE a.department_id = b.department_id
 START WITH a.manager_id IS NULL
 CONNECT BY PRIOR a.employee_id = a.manager_id;

-- 조건을 어디에 주느냐에 따라
-- 결과가 달라짐
SELECT a.employee_id
     , LPAD(' ' , 3 * (LEVEL - 1)) || a.emp_name
     , LEVEL
     , b.department_name
     , a.department_id
  FROM employees a
     , departments b
 WHERE a.department_id = b.department_id
   AND a.department_id = 30
 START WITH a.manager_id IS NULL
 CONNECT BY PRIOR a.employee_id = a.manager_id;
-- WHERE 조건에 AND로 붙이면 정확한 값

SELECT a.employee_id
     , LPAD(' ' , 3 * (LEVEL - 1)) || a.emp_name
     , LEVEL
     , b.department_name
     , a.department_id
  FROM employees a
     , departments b
 WHERE a.department_id = b.department_id
 START WITH a.manager_id IS NULL
 CONNECT BY PRIOR a.employee_id = a.manager_id
   AND a.department_id = 30;
-- CONNECT BY가 끝나고 AND로 조건을 붙이면.. 트리 구조를 꺼내준다

-- 위의 employees 테이블을 계층형 쿼리로 만들기

SELECT e.employee_id                        AS 사번
     , e.emp_name                           AS 사원명
     , d.department_name                    AS 부서명
     , 1                                    AS 레벨
     , e.manager_id || e.employee_id        AS sort
  FROM employees e
     , departments d
 WHERE e.manager_id IS NULL
   AND e.department_id = d.department_id
UNION ALL
SELECT e2.employee_id
     , LPAD(' ', 3 * (2 - 1)) || e2.emp_name
     , d.department_name
     , 2                                      AS levels
     , e2.manager_id || e2.employee_id        AS sort
  FROM employees e1
     , employees e2
     , departments d
 WHERE e1.manager_id IS NULL
   AND e2.manager_id = e1.employee_id
   AND e2.department_id = d.department_id
UNION ALL
SELECT e3.employee_id
     , LPAD(' ', 3 * (3 - 1)) || e3.emp_name
     , d.department_name
     , 3                                                      AS levels
     , e2.manager_id || e3.manager_id || e3.employee_id       AS sort
  FROM employees e1
     , employees e2
     , employees e3
     , departments d
 WHERE e1.manager_id IS NULL
   AND e2.manager_id = e1.employee_id
   AND e3.manager_id = e2.employee_id
   AND e3.department_id = d.department_id
UNION ALL
SELECT e4.employee_id
     , LPAD(' ', 3 * (4 - 1)) || e4.emp_name
     , d.department_name
     , 4                                                                        AS levels
     , e2.manager_id || e3.manager_id || e4.manager_id || e4.employee_id        AS sort
  FROM employees e1
     , employees e2
     , employees e3
     , employees e4
     , departments d
 WHERE e1.manager_id IS NULL
   AND e2.manager_id = e1.employee_id
   AND e3.manager_id = e2.employee_id
   AND e4.manager_id = e3.employee_id
   AND e4.department_id = d.department_id
 ORDER BY sort;




