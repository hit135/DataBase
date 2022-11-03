-- Day 4


--------------------- SELECT문 ---------------------
SELECT *
FROM employees;
-- WHERE 조건
-- 보통 WHERE 컬럼명 , 비교연산자, 값

-- 셀렉1
SELECT 
      employee_id
    , emp_name
    , employee_id AS 아이디
    , emp_name AS 이름
    , employee_id "아이디"
    , emp_name "이름"
    , salary
FROM employees
WHERE salary > 5000 AND salary <= 10000 -- 검색조건
ORDER BY salary DESC;

SELECT *
FROM employees
ORDER BY salary, employee_id;

-- AND(그리고)[A, B 조건 모두 포함할때]
SELECT employee_id
    , emp_name
    , salary
    , job_id
FROM employees
WHERE salary > 5000
  AND job_id = 'IT_PROG'
ORDER BY employee_id;

-- ORER BY를 할 때 셀렉한것들의 숫자를 적어주면 정렬되기는 하나
-- 남들이 보기 어렵고 내가 확인하기 어렵기 때문에
-- 선호되지 않는다.

-- 조금 헷갈릴수도 있다.
-- 내가 쓴 쿼리가 맞는 데이터가 나오는지 꼭 확인해봐야 한다.

-- OR(또는)[A 또는 B 조건에 해당하면]
SELECT employee_id
     , emp_name
     , job_id
     , salary
FROM employees
WHERE salary > 5000
   OR job_id = 'IT_PROG'
ORDER BY employee_id;

-- 이런식으로 다시 확인해봐야 한다.
-- 데이터가 잘 뽑혔는지!!!
-- 중요하다!
SELECT employee_id
     , emp_name
     , job_id
     , salary
FROM employees
WHERE job_id = 'IT_PROG'
ORDER BY employee_id;

-- 혼자 연습
SELECT employee_id
     , hire_date
     , emp_name
     , phone_number
     , salary
 FROM employees
WHERE employee_id > 200
  AND salary > 6000
ORDER BY hire_date, emp_name;
-- 연습 확인 >> ep_di 200 보다 큰 사람이 6이고 salary 6000 초과가 5명이므로
-- 위에 5명이 나와야 한다.
SELECT employee_id
     , hire_date
     , emp_name
     , phone_number
     , salary
 FROM employees
WHERE employee_id > 200
ORDER BY hire_date, emp_name;


--------------------- 문제 1 ---------------------
/* customers 테이블에서 다음과 같이 출력하시오
   ex) cust_city, cust_gender 검색 조건,, 
   도시가 'ALine', 성별은 'M'
   정렬 조건 추가
   1. customers 테이블 데이터 보기
   2. 기본 SELECT문 작성(보고자 하는 칼럼)
   3. 검색조건과 정렬조건 추가
*/

SELECT cust_name
     , cust_city
     , cust_gender
     , cust_year_of_birth
FROM  customers
WHERE cust_city = 'Aline'
AND   cust_gender = 'M'
ORDER BY cust_year_of_birth DESC;

-- 짠 쿼리문 확인
SELECT cust_name
     , cust_city
     , cust_gender
     , cust_year_of_birth
FROM  customers
WHERE cust_gender = 'M'
ORDER BY cust_city;


--------------------- INSERT문 ---------------------
CREATE TABLE ex3_1 (
     col1 VARCHAR2(10)
    ,col2 NUMBER
    ,col3 DATE
);
-- INSERT 기본형태
INSERT INTO ex3_1 (col1, col2, col3)
VALUES ('ABC', 10, SYSDATE);
SELECT * FROM ex3_1;

INSERT INTO ex3_1 (col1, col2, col3)
VALUES ('ABC', 10, 30);             -- 오류 DATE에 숫자가 들어가서

INSERT INTO ex3_1 (col1, col2, col3)
VALUES (10, '10', '2014-01-01');    -- col2의 '10'을 자동형변환, col3의 문자를 자동형변환

SELECT *
FROM ex3_1;

-- 많이쓰는
-- INSERT 기술명 생략
-- 모든 컬럼에 집어넣을 때는..!
INSERT INTO ex3_1
VALUES ('GHI', 10, SYSDATE);

-- INSERT 몇 개 컬럼만 삽일항 경우는 컬럼명 써야함
INSERT INTO ex3_1 (col1, col2)
VALUES ('GHI', 20);
-- 모든 컬럼에 집어넣지 않을 때
-- 컬럼명을 쓰지 않으면 어디에 넣어야 할 지 몰라서 오류가 난다.
INSERT INTO ex3_1
VALUES ('GHI', 30);

DROP TABLE ex3_1;

CREATE TABLE ex3_1 (
     emp_id     NUMBER
    ,emp_name   VARCHAR2(100)
);
-- INSERT SELECT 형태
INSERT INTO ex3_1(emp_id, emp_name)
SELECT employee_id, emp_name
FROM employees
WHERE salary > 5000;

SELECT *
FROM ex3_1
ORDER BY emp_id;
-- UPDATE와 DELETE를 쓸 때는 주의해야 한다.!


--------------------- UPDATE문 ---------------------
-- UPDATE 테이블명 SET 컬럼명 = 변경할 값
SELECT * FROM ex3_1;
UPDATE ex3_1 
SET emp_name = '홍길동';
-- WHERE로 조건을 잘 줘야한다.
UPDATE ex3_1
SET emp_name = '장길산'
WHERE emp_id = 201;

-- 혼자연습
SELECT departments.department_name AS 부서
     , departments.department_id   AS 부서번호
     , employees.employee_id       AS 직원번호
     , employees.emp_name          AS 직원이름
     , TO_CHAR(employees.salary, 'FML999,999,999') ||'만원' AS 급여
FROM departments, employees
WHERE departments.department_id = employees.department_id
ORDER BY departments.department_id DESC;

/* 문제
   사원테이블(employees)에서 관리자사번이 124번이고
   급여가 2000에서 3000사이에 있는 사원의 사번, 사원명, 급여, 관리자사번
   데이터를 가진 EX3_5 테이블을 만드시오
*/
SELECT employee_id
     , emp_name
     , salary
     , manager_id
FROM employees
WHERE salary >= 2000
AND   salary <= 3000
ORDER BY manager_id;
-- 방법 1 복사하기!
CREATE TABLE ex3_5 
AS
SELECT
     employee_id    AS 사번
    ,emp_name       AS 사원명
    ,salary         AS 급여
    ,manager_id     AS 관리자사번
FROM employees
WHERE salary >= 2000
AND   salary <= 3000
AND   manager_id = 124
ORDER BY employee_id;

DROP TABLE ex3_5;
SELECT * FROM ex3_5;

-- 방법 2 그냥 만들기
-- 일단 정보를 얻어야함
DESC employees;
-- 유형과 널 형식을 얻음
CREATE TABLE ex3_5 (
    employee_id   NUMBER(6) NOT NULL,
    emp_name      VARCHAR2(80) NOT NULL,
    salary        NUMBER(8, 2),
    manager_id    NUMBER(6)
);
-- 그리고 인설트 셀렉트하기
INSERT INTO ex3_5
SELECT
     employee_id    AS 사번
    ,emp_name       AS 사원명
    ,salary         AS 급여
    ,manager_id     AS 관리자사번
FROM employees
WHERE salary >= 2000
AND   salary <= 3000
AND   manager_id = 124
ORDER BY employee_id;

-- 구조만 따오기 >> pk같은 곳에
-- is null을 주면
-- 데이터가 없고 구조만 들어간는 테이블 복사
CREATE TABLE ex3_5 
AS
SELECT
     employee_id    AS 사번
    ,emp_name       AS 사원명
    ,salary         AS 급여
    ,manager_id     AS 관리자사번
FROM employees
WHERE employee_id Is Null;

DESC ex3_5;


/* 문제2
   사원테이블(employees)에서 커미션(commission_pct) 값이 없는
   사원의 사번과 사원명을 추출하는 쿼리를 작성
*/

CREATE TABLE ex3_6
AS
SELECT employee_id      AS 사번
     , emp_name         AS 사원명
FROM  employees
WHERE commission_pct IS NULL
ORDER BY employee_id;
SELECT *
FROM ex3_6;

SELECT *
FROM employees
WHERE commission_pct IS NULL;

commit;


--------------------- DELETE문 ---------------------

CREATE TABLE ex_emp -- (emp_id, emp)name, salary, dept_id)
          AS
      SELECT employee_id AS emp_id
           , emp_name
           , salary
           , department_id AS dept_id
        FROM employees
       WHERE department_id = 50;

SELECT * 
  FROM ex_emp;
  
UPDATE ex_emp SET emp_name = '홍길동' , salary = 999;
-- 모든 정보가 변경
ROLLBACK;

SELECT * FROM ex_emp WHERE emp_id = 198;

DELETE FROM ex_emp WHERE emp_id = 198;
DELETE FROM ex_emp;

-- 굉장히 빠르게 삭제가능, 하지만 실제로 사용안함
-- TRUNCATE TABLER 굉장히 조심히 써야한다.
SELECT * FROM ex_emp;
COMMIT;
TRUNCATE TABLE ex_emp;
SELECT * FROM ex_emp;
ROLLBACK;
-- 복구 안됨!!!!!!!

-- ROWNUM 
-- 테이블의 컬럼처럼 동작 하지만
-- 실제로 테이블에 저장되지 않는 컬럼
-- 데이터를 각 로우들에 대한 순서값을 주고
-- 출력해주는 의사컬럼이다..
-- 의사컬럼은 테이터를 INSERT, UPDATE, DELETE
SELECT employee_id
  FROM employees;

SELECT ROWNUM, 
       employee_id
  FROM employees;  

-- ROWID는 톄이블의 각 로우가 저장된 주소값을 가르키는 의사컬럼
-- 유일하다
-- 하지만 잘 안쓴다.
SELECT ROWNUM
     , employee_id
     , ROWID
  FROM employees;
  
  
SELECT *
  FROM departments;
  
  
  
  
  
  
  

