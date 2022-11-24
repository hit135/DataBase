Day 19
/* 문제 1, 월별로 판매금액이 가장 하위에 속하는 대륙 목록을 뽑아보자.
          (대륙목록은 countries 테이블의 country_region에 있으며,
           country_id 컬럼으로 customers 테이블과 조인을 해서 구한다.)
  [WITH 문과 분석함수 이용]
*/

SELECT *
  FROM countries;
SElECT *
  FROM customers;


SELECT a.country_id
     , a.country_name
     , b.cust_name
     , c.amount_sold
     , SUBSTR(c.sales_date, 4, 2) month
  FROM countries a
     , customers b
     , sales c
 WHERE a.country_id = b.country_id
   AND b.cust_id = c.cust_id
 ORDER BY month;
 
 -- 월별로 랭킹을 해줘야 한다.
 -- 일단 일자별로!
SELECT a.country_name
     , c.sales_date
     , SUM(c.amount_sold) 
  FROM countries a
     , customers b
     , sales c
 WHERE a.country_id = b.country_id
   AND b.cust_id = c.cust_id
 GROUP BY a.country_name, c.sales_date;
 
 -- 위 쿼리문을 월별로 나라마다 세일 총합을 구했음!
SELECT a.country_name
     , SUBSTR(c.sales_date, 4, 2)
     , SUM(c.amount_sold) 
  FROM countries a
     , customers b
     , sales c
 WHERE a.country_id = b.country_id
   AND b.cust_id = c.cust_id
 GROUP BY a.country_name, SUBSTR(c.sales_date, 4, 2)
 ORDER BY SUBSTR(c.sales_date, 4, 2);
 
 
-- 월별 랭킹
SELECT a.country_name AS country_name
     , SUBSTR(c.sales_date, 4, 2) AS month
     , SUM(c.amount_sold) AS sum
     , DENSE_RANK() OVER (PARTITION BY SUBSTR(c.sales_date, 4, 2)
                        ORDER BY SUM(c.amount_sold)) AS rank
  FROM countries a
     , customers b
     , sales c
 WHERE a.country_id = b.country_id
   AND b.cust_id = c.cust_id
 GROUP BY a.country_name, SUBSTR(c.sales_date, 4, 2)
 ORDER BY month, rank;
 
-- 1번 답
WITH month_sale AS (SELECT a.country_name AS country_name
                         , SUBSTR(c.sales_date, 4, 2) AS month
                         , SUM(c.amount_sold) AS sum
                         , DENSE_RANK() OVER (PARTITION BY SUBSTR(c.sales_date, 4, 2)
                                            ORDER BY SUM(c.amount_sold)) AS rank
                      FROM countries a
                         , customers b
                         , sales c
                     WHERE a.country_id = b.country_id
                       AND b.cust_id = c.cust_id
                     GROUP BY a.country_name, SUBSTR(c.sales_date, 4, 2)
                     ORDER BY month, rank
                    )
SELECT a.country_name
     , a.month
     , a.sum
     , a.rank
  FROM month_sale a
 WHERE a.rank = 1;
 


-- 년월로 안구하고 나는 모든 년도 더하고 월도 더하고 했다
-- 근데 뭔가 섬값이 이상하다..
-- 다시해보기


-- 문제2 부서별 급여 기준 상위 2등이 2명인 부서를 출력하시오 (WITH문 사용)

-- 부서별 급여의 상위 랭킹을 구한다 
SELECT e.emp_name
     , e.department_id
     , e.salary
     , d.department_name
     , DENSE_RANK() OVER(PARTITION BY d.department_id
                         ORDER BY e.salary DESC) AS rank
  FROM EMPLOYEES e
     , DEPARTMENTS d
 WHERE e.department_id = d.department_id
 ORDER BY d.department_id, rank;
 
-- 여기서 상위 2등이 2명인 부서를 구하면 된다.

WITH salary_rank AS (SELECT e.emp_name          AS emp_name
                          , e.department_id     AS department_id
                          , e.salary            AS salary
                          , d.department_name   AS department_name
                          , DENSE_RANK() OVER(PARTITION BY d.department_id
                                              ORDER BY e.salary DESC) AS rank
                       FROM EMPLOYEES e
                          , DEPARTMENTS d
                      WHERE e.department_id = d.department_id
                      ORDER BY d.department_id, rank
                    )
   , count_rank AS (SELECT a.department_name AS department_name
                         , COUNT(rank) AS COUNT
                      FROM salary_rank a
                     WHERE rank = 2
                     GROUP BY a.department_name
                    )
SELECT b.department_name
     , b.COUNT
  FROM count_rank b
 WHERE b.COUNT = 2;




/*
    관계형 데이터베이스 용어 및 정의를 기술
    릴레이션, 엔티티, 튜플, 어트리뷰트, 기타 등등
*/

-- 데이터베이스 모델링, (erd, erwin, 트랜잭션, 트리거)

-- ERD란? >> 엔티티 릴레이션십 다이어그램 >> 관계 표현을 알긴 해야지..! >> 즉, 읽을수는 있어야지
-- ERwin 프로그램


-- 함수, 프로시저, 패키지, 트리거...!
함수(function)        : 특정연산을 하고 값을 반화하는 객체로
                        프로시저와 동일하게 절차형 SQL을 활용 >> SELECT, SUM등 그게 함수
프로시저(procedure)   : SELECT절에서 사용할 수 없다!
패키지(pakage)        :
----------------------------------------------------------------------------------------------
트리거(triger)        : 특정 테이블에 삽입, 수정, 삭제제 등의 데이터 변경 이벤트가 발생하면
                        DBMS에서 자동적으로 실행되도록 구현된 프로그램을 트리거라고 한다.
                        - 전체 행/ 개별 행으로 구분하여 작업 할 수 있다 >> 이대로 쓰면 틀렸다고 하실거임
----------------------------------------------------------------------------------------------
예외 

트랜잭션



-- DB를 했음 이런 용어는 알아야지!
-- 릴레이션, 엔티티, 튜플, 어트리뷰트, 기타 등등
-- 데이터베이스 모델링 (erd, erwin, 트랜잭션, 트리거)


-- PL/SQL

-- 선언
DECLARE
    vi_num NUMBER;
-- 실행
BEGIN
    vi_num := 100;
    DBMS_OUTPUT.PUT_LINE(vi_num);
END;

-- 값을 볼라면 output을 on으로 바꿔줘야 한다.
SET SERVEROUTPUT ON
SET SERVEROUTPUT OFF

-- 경과 시간을 볼라면 timing을 on으로 해야한다.
SET TIMING ON
SET TIMING OFF

-- 선언
DECLARE
    vi_num NUMBER := 2;
-- 실행
BEGIN
    -- 2의 10승
    vi_num := vi_num ** 10;
    DBMS_OUTPUT.PUT_LINE(vi_num);
END;

DECLARE
    vi_num CONSTANT NUMBER := 2;
BEGIN
    -- 상수를 바꾸려고 하니 오류 떨어진다
    vi_num := vi_num ** 10;
    DBMS_OUTPUT.PUT_LINE(vi_num);
END;

DECLARE
    vi_num NUMBER := 2*2;
BEGIN
    -- 글자 붙이기
    DBMS_OUTPUT.PUT_LINE(vi_num);
    DBMS_OUTPUT.PUT_LINE('vi_num = ' || vi_num);
END;

-- 주의할점!! 실행부 안에서 SELECT해도 안나옴..
-- 프로그램이기 때문에 어딘가에 담아줘야한다.
-- 인썰트 업데이트는 실행이기 떄문에 가능하다..!


-- 그럼 실행부에서 셀렉할라면 어케해야 하냐?
-- 변수에 INTO로 담아준다!
-- 267P, 268P
DECLARE
    vs_emp_name     VARCHAR2(80);    -- 사원명 변수
    vs_dep_name     VARCHAR2(80);    -- 부서명 변수
    vs_num          NUMBER := 100;
BEGIN
    SELECT a.emp_name, b.department_name
      INTO vs_emp_name, vs_dep_name
      FROM employees a
         , departments b
     WHERE a.department_id = b.department_id
       AND a.employee_id = vs_num;
    DBMS_OUTPUT.PUT_LINE(vs_emp_name || '-' || vs_dep_name);
END;



















