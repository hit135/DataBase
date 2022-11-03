-- Day 3

-- 무결성!!
-- PK, FK
-- 5교시

-- 테이블 연습 1 PK 무결성
CREATE TABLE ex2_7 (
     col1 VARCHAR2(10) PRIMARY KEY
    ,col2 NUMBER
);

INSERT INTO ex2_7 (col1, col2) VALUES('abc', 1);
INSERT INTO ex2_7 (col1, col2) VALUES('abc', 2);    -- unique 오류
INSERT INTO ex2_7 (col1, col2) VALUES(null, 2);     -- null 오류
INSERT INTO ex2_7 (col1, col2) VALUES('def', 112312312323234345546123);

SELECT * FROM ex2_7;


-- 테이블 연습 2 두개의 PK
CREATE TABLE ex2_8(
     col1 VARCHAR2(10)
    ,col2 NUMBER
    ,CONSTRAINTS pk_ex2_8 PRIMARY KEY(col1, col2)
);

INSERT INTO ex2_8 (col1, col2) VALUES ('abc', 0);
INSERT INTO ex2_8 (col1, col2) VALUES ('abc', 1);
INSERT INTO ex2_8 (col1, col2) VALUES ('abc', 1); -- 중복 오류
INSERT INTO ex2_8 (col1, col2) VALUES ('abc', null) -- null 오류
INSERT INTO ex2_8 (col1, col2) VALUES (null, 3); -- null 오류


-- 테이블 연습 3 PK와 FK
CREATE TABLE dep(
     deptno NUMBER(3) CONSTRAINTS dep_pk_deptno PRIMARY KEY
    ,deptname VARCHAR2(20)
    ,floor NUMBER(5)
);

CREATE TABLE emp(
    empno NUMBER(5) CONSTRAINTS emp_pk_employee PRIMARY KEY
   ,empname VARCHAR2(20)
   ,title VARCHAR2(20)
   ,dno NUMBER(3) CONSTRAINTS emp_fk_dno REFERENCES dep(deptno)
   ,salary NUMBER(10)
);

------------------------------------------------------------------------------------------------------
INSERT INTO dep (deptno, deptname, floor) VALUES (1, '영업', 8);
INSERT INTO dep (deptno, deptname, floor) VALUES (2, '기획', 10);
INSERT INTO dep (deptno, deptname, floor) VALUES (3, '개발', 9);
------------------------------------------------------------------------------------------------------
INSERT INTO emp (empno, empname, title, dno, salary) VALUES (2306, '김창섭', '대리', 2, 2000000);
INSERT INTO emp (empno, empname, title, dno, salary) VALUES (3415, '박영권', '대리', 3, 3000000);
INSERT INTO emp (empno, empname, title, dno, salary) VALUES (4556, '이수민', '과장', 1, 4000000);
INSERT INTO emp (empno, empname, title, dno, salary) VALUES (2323, '조민희', '부장', 1, 5000000);
INSERT INTO emp (empno, empname, title, dno, salary) VALUES (4546, '최종철', '사원', 3, 1000000);

INSERT INTO emp (empno, empname, title, salary) VALUES (4146, '홍길동', '사원', 1500000);        -- fk가 null은 들어간다.
INSERT INTO emp (empno, empname, title, dno, salary) VALUES (4546, '임꺽정', '사원', 4, 1000000);-- 4는 참조하는 값에 없기 때문에 오류

------------------------------------------------------------------------------------------------------
SELECT * FROM dep;
SELECT * FROM emp;



-- 테이블 연습 4 CHECK
CREATE TABLE ex2_9(
     name VARCHAR2(30) NOT NULL
    ,age NUMBER(3)
    ,gender CHAR(1)
    ,CONSTRAINTS ck_ex_2_9_age CHECK (age BETWEEN 1 AND 150)
    ,CONSTRAINTS ck_ex_2_9_gender CHECK (gender IN ('F', 'M'))
);

INSERT INTO ex2_9 (name, age, gender) VALUES('melja', 200, 'G'); --ck_ex2_9_gender
INSERT INTO ex2_9 (name, age, gender) VALUES('melja', 200, 'F'); --ck_ex2_9_age
INSERT INTO ex2_9 (name, age, gender) VALUES('melja', 25, 'F');




-- 6교시

-- 테이블 연습 5 DEFAULT
CREATE TABLE ex2_10(
     name VARCHAR2(30) NOT NULL
    ,point NUMBER(5) DEFAULT 0
    ,gender CHAR(1) DEFAULT 'F'
    ,reg_date DATE DEFAULT sysdate
    ,CONSTRAINTS ck_ex2_10_gender CHECK (gender in ('F','M'))
);

INSERT INTO ex2_10 (name) VALUES ('sunja');
SELECT * FROM ex2_10;
INSERT INTO ex2_10 (name, point) VALUES ('nolja', 250);


-- 연습문제

-- 1.
CREATE TABLE orders(
     order_id       NUMBER(2,0)
     PRIMARY KEY
    ,order_date     DATE
    ,order_mode     VARCHAR2(8 BYTE)
    ,customer_id    NUMBER(6,0)
    ,order_status   NUMBER(2,0)
    ,order_total    NUMBER(8,2)
     DEFAULT 0
    ,sales_rep_id   NUMBER(6,0)
    ,promotion_id   NUMBER(6,0)
    ,CHECK (order_mode IN ('direct', 'online'))
);

SELECT * FROM orders;


-- 2.
CREATE TABLE order_items(
     order_id       NUMBER(12,0)
    ,line_item_id   NUMBER(3,0)
    ,product_id     NUMBER(3,0)
    ,unit_price     NUMBER(8,2)
     DEFAULT 0
    ,quantity       NUMBER(8,0)
     DEFAULT 0
    ,CONSTRAINTS base_primary_key PRIMARY KEY (order_id, line_item_id)
    ,CONSTRAINTS id_foreign_key FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
-- DEFAULT 값을 추가 못했을 때
-- ALTER TABLE board MODIFY bHit DEAFULT 1

-- 3.
CREATE TABLE promotions(
     promo_id   NUMBER(6,0)
    ,promo_name VARCHAR2(20)
    ,CONSTRAINTS promo_primary_key PRIMARY KEY (promo_id)
);

DROP TABLE order_items;


-- 7교시
--------------------------- 테이블 삭제 ------------------------------------------------

DROP TABLE dep;     -- 참조 되어있는 테이블이 있어서 삭제 되지 않는다.
DROP TABLE emp;

-- CASCADE CONSTRAINT 참조되어 있던 제약조건도 제거 
-- >> 즉 다른것들이 참조하고 있어도 지워버림
DROP TABLE dep CASCADE CONSTRAINT;

------------------ ALTER 테이블 수정 (컬럼, 타입, 제약사항) ------------------------------
-- 컬럼명 수정
ALTER TABLE ex2_7 RENAME COLUMN col1 TO col11;
-- 테이블 이름, 널유무, 유형 확인
DESC ex2_7; 
-- 확인하는 sql문


SELECT * FROM EX2_7;

-- 컬럼 타입 수정
ALTER TABLE ex2_7 MODIFY col11 VARCHAR2(30);

-- 컬럼 추가
ALTER TABLE ex2_7 ADD col3 NUMBER;
DESC ex2_7;

-- 컬럼 삭제
ALTER TABLE ex2_7 DROP COLUMN col3;

CREATE TABLE ex2_15(
     col1 VARCHAR(10)
    ,col2 VARCHAR(20)
);

-- 제약 조건 추가
ALTER TABLE ex2_15 ADD CONSTRAINTS pk_ex2_15 PRIMARY KEY (col1);

-- 이거 왜 안먹냐
SELECT  constraint_name
       ,constraint_type
       ,table_name
       ,search_condition
FROM user_constraints
WHERE table_name = 'ex2_15';

-- 테이블 제약 조건 삭제
ALTER TABLE ex2_15 DROP CONSTRAINTS pk_ex2_15;


-- 테이블 복사
-- 종종 실무에서 쓴다.
CREATE TABLE ex2_9_1
as
SELECT * FROM ex2_9;

SELECT * FROM ex2_9_1;

-- 테이블 이름만 복사
CREATE TABLE ex2_9_2
AS
SELECT
    NAME
FROM ex2_9;

SELECT * FROM ex2_9_2;


-- 8교시
-- 테이블에 코멘트 달기
-- DESCRIPTION 설명 넣기
-- COMMENT ON TABLE 테이블명 IS '멋진 테이블';
-- COMMENT ON COLUMN 테이블명.칼럼명 IS '더 멋진 컬럼';

COMMENT ON TABLE dep IS '부서 정보';

COMMENT ON COLUMN dep.deptno IS '부서번호';
COMMENT ON COLUMN dep.deptname IS '부서명';
COMMENT ON COLUMN dep.floor IS '부서층';

-- 내일은 SELECT에서 조건을 주는것을 배울것이다
SELECT * FROM emp
WHERE emp.empno = 2306;
SELECT * FROM dep
WHERE dep.deptno = 2;

SELECT * FROM emp, dep;
-- 곱하기로 나옴

SELECT * FROM emp, dep
WHERE emp.empno = 2306
  AND emp.dno = dep.deptno
;

-- join?
SELECT 
     dep.deptname       AS 부서
    ,dep.floor || '층'   AS 위치
    ,emp.empname        AS 이름
    ,emp.title          AS 직위
    ,emp.salary || '원'  AS 월급
--    ,salary * 12 || '원' AS 연봉
    ,TO_CHAR(emp.salary * 12, '999,999,999,999,999') AS 연봉
FROM dep, emp
WHERE dep.deptno = emp.dno
ORDER BY salary DESC;
-- ORDER BY 칼럼명 DESC >> 칼럼명을 참고해서 내림차순 정리
-- ORDER BY 칼럼명 ASC  >> 칼럼명을 참고해서 오름차순 정리

-- 위의 셀렉트 emp, dep를 하면 두 테이블의 곱으로 나온다..
-- 내 생각에는 FK(외래키)를 당연히 참조해서
-- 중복되지 않게 나와야 된다고 생각했다..
-- 하지만 프로그램에서 셀렉하는건 인식하지 못함!!

-- 그래서 WHERE로 내가 연결된 FK가 같을때를 설정해줘야 한다.
SELECT * FROM dep;
SELECT * FROM emp;

SELECT * FROM dep, emp
WHERE dep.deptno = emp.dno;

-- 혼자 공부 .. 수정 >> 업데이트
UPDATE dep SET
    floor = 8
WHERE deptno = 1;



























