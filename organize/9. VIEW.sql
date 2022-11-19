-- Day 14
/* 1번. 2000년도(검색조건) 판매(금액)왕을 출력하시오 (sales)
    (1) sales 테이블을 활용하여 직원별 판매금액(amount_sold), 수량을 집계
    (2) 판매금액 기준으로 정렬하여 1건 출력 (인라인 뷰 사용)
    (3) 사번으로 employees 테이블 이용하여 이름 가져오기 (스칼라서브쿼리사용)
*/

-- 사원별 / 2000년 총 판매금액 집계
SELECT employee_id
     , SUM(amount_sold) AS 판매총액
     , TO_CHAR(sales_date, 'yyyy') AS 판매년도
  FROM sales
 WHERE TO_CHAR(sales_date, 'yyyy') = 2000
 GROUP BY employee_id, TO_CHAR(sales_date, 'yyyy')
 ORDER BY 판매총액 DESC;

SELECT 
      sales_date
     , MAX(amount_sold)
  FROM sales
 GROUP BY sales_date
 ORDER BY sales_date;


SELECT 
       employee_id
     , MAX(amount_sold)
  FROM sales
 GROUP BY employee_id
 ORDER BY employee_id;

SELECT employee_id 
     , sales_date 
     , MAX(amount_sold)
  FROM sales
 GROUP BY employee_id,  sales_date
 ORDER BY employee_id,  sales_date;
    

-- 1등 출력
SELECT a.employee_id
     , a.판매총액
     , a.판매년도
     , ROWNUM
  FROM (SELECT employee_id
             , SUM(amount_sold) AS 판매총액
             , TO_CHAR(sales_date, 'yyyy') AS 판매년도
          FROM sales
         WHERE TO_CHAR(sales_date, 'yyyy') = 2000
         GROUP BY employee_id, TO_CHAR(sales_date, 'yyyy')
         ORDER BY 판매총액 DESC) a
 WHERE ROWNUM <= 1;
 
-- 사번으로 이름 가져오기
SELECT a.employee_id
     , b.emp_name
     , a.판매총액
     , a.판매년도
     , ROWNUM 등수
  FROM (SELECT employee_id
             , SUM(amount_sold) AS 판매총액
             , TO_CHAR(sales_date, 'yyyy') AS 판매년도
          FROM sales
         WHERE TO_CHAR(sales_date, 'yyyy') = 2000
         GROUP BY employee_id, TO_CHAR(sales_date, 'yyyy')
         ORDER BY 판매총액 DESC) a
      , employees b
 WHERE ROWNUM <= 1
   AND a.employee_id = b.employee_id;

/*    
  2번. 2000년도 최대판매상품(수량으로) 1~3등까지 출력하시오
   (1) 필요한 컬럼 출력
   (2) 집계 및 정렬 후 3건 출력
   (3) 상품 아이디로 상품명 출력
*/   
-- 상품이름별로 품목 출력
-- 나는 실수로 상품판매 금액으로 1~3등을 구함
-- 문제는 수량으로 1~3등임...!
SELECT prod_id
     , SUM(amount_sold) AS 판매총액
     , TO_CHAR(sales_date, 'yyyy') AS 판매년도
  FROM sales
 WHERE TO_CHAR(sales_date, 'yyyy') = 2000
 GROUP BY prod_id, TO_CHAR(sales_date, 'yyyy')
 ORDER BY 판매총액 DESC;

-- 수량
SELECT prod_id
     , COUNT(prod_id) AS 판매수량
     , TO_CHAR(sales_date, 'yyyy') AS 판매년도
  FROM sales
 WHERE TO_CHAR(sales_date, 'yyyy') = 2000
 GROUP BY prod_id, TO_CHAR(sales_date, 'yyyy')
 ORDER BY 판매수량 DESC;
  
-- 금액 1~3등
SELECT b.id
     , p.prod_name
     , b.sold
     , b.year
     , b.grade
  FROM (SELECT a.prod_id id
             , a.sold sold
             , a.year year
             , ROWNUM grade
          FROM (SELECT prod_id
                     , SUM(amount_sold) AS sold
                     , TO_CHAR(sales_date, 'yyyy') AS year
                  FROM sales
                 WHERE TO_CHAR(sales_date, 'yyyy') = 2000
                 GROUP BY prod_id, TO_CHAR(sales_date, 'yyyy')
                 ORDER BY sold DESC) a
         WHERE a.year = 2000
         ORDER BY a.sold DESC) b
      , products p
 WHERE b.id = p.prod_id
   AND b.grade < 4;
  
  
-- 수량 1~3등
SELECT b.id
     , p.prod_name
     , b.sold
     , b.year
     , b.grade
  FROM (SELECT a.prod_id id
             , a.sold sold
             , a.year year
             , ROWNUM grade
          FROM (SELECT prod_id
                     , COUNT(prod_id) AS sold
                     , TO_CHAR(sales_date, 'yyyy') AS year
                  FROM sales
                 WHERE TO_CHAR(sales_date, 'yyyy') = 2000
                 GROUP BY prod_id, TO_CHAR(sales_date, 'yyyy')
                 ORDER BY sold DESC) a
         WHERE a.year = 2000
         ORDER BY a.sold DESC) b
      , products p
 WHERE b.id = p.prod_id
   AND b.grade < 4;
  
  
  
/*   
  3번. kor_loan_status 테이블에서 '연도별' '최종월' 기준 가장 대출이 많은 도시와 잔액을 구하시오
----------------------------------------------------------------------------------------------
   (1) 연도별 최종 : 2011 년의 최종월은 12월 이지만 2013년도의 최종월은 11월 이므로 연도별 최종월을 알아야 한다.
        -tip 그룹쿼리로 연도별 가장 큰 월을 구한다 : max
   (2) 연도별 최종월을 대상으로 대출잔액이 가장 큰 금액을 추출한다  >> 가장 큰 도시를 구해야지..
        -tip 1번과 조인을 해서 연도별로 가장 큰 잔액을 구한다 : max
   (3) 월별, 지역별 대출잔액과 2의 결과를 비교해 금액이 같은 건을 추출한다.
        -tip 2의 조인을 해서 두 금액이 같은 건을 구한다.      
*/

-- 일단 연도만 뽑아낸다..
SELECT SUBSTR(a.period, 1, 4)
  FROM kor_loan_status a;
  
-- 가장 큰 월을 구한다..
SELECT a.year
     , MAX(a.month)
  FROM (SELECT SUBSTR(a.period, 1, 4) year
             , a.period month
          FROM kor_loan_status a) a
 GROUP BY a.year;
 
-- 가장 큰월의 대출잔액을 뽑아낸다..
SELECT b.period period
     , MAX(b.loan_jan_amt) amount
  FROM (SELECT a.year year
             , MAX(a.month) month
          FROM (SELECT SUBSTR(a.period, 1, 4) year
                     , a.period month
                  FROM kor_loan_status a) a
         GROUP BY a.year
       ) a
     , kor_loan_status b
 WHERE b.period = a.month
 GROUP BY b.period;
-- 여기서 또 MAX값을 추출해야 한다.. 

-- MAX값!
SELECT MAX(c.amount)
  FROM (SELECT b.period period
             , b.loan_jan_amt amount
          FROM (SELECT a.year year
                     , MAX(a.month) month
                  FROM (SELECT SUBSTR(a.period, 1, 4) year
                             , a.period month
                          FROM kor_loan_status a) a
                 GROUP BY a.year
               ) a
             , kor_loan_status b
         WHERE b.period = a.month
       ) c;
  
-- 월별, 지역별 대출잔액!
SELECT a.period
     , a.region
     , MAX(a.loan_jan_amt) amount
  FROM kor_loan_status a
-- WHERE SUM(a.loan_jan_amt) = 205644.3
 GROUP BY a.period, a.region;
 
-- 두개를 비교!

SELECT a.period
     , a.region
     , a.amount
  FROM (SELECT a.period period
             , a.region region
             , MAX(a.loan_jan_amt) amount
          FROM kor_loan_status a
         GROUP BY a.period, a.region) a
     , (SELECT MAX(c.amount) amount
          FROM (SELECT b.period period
                     , b.loan_jan_amt amount
                  FROM (SELECT a.year year
                             , MAX(a.month) month
                          FROM (SELECT SUBSTR(a.period, 1, 4) year
                                     , a.period month
                                  FROM kor_loan_status a) a
                         GROUP BY a.year
                       ) a
                     , kor_loan_status b
                 WHERE b.period = a.month
               ) c) b
 WHERE a.amount = b.amount;



-- 뷰(가상 테이블) 실습
-- 실제 물리적으로 존재 x

-- 일단 권한을 주고!
-- sqlplus system/oracle
-- grant create view to java;

-- 뷰 생성
CREATE OR REPLACE VIEW emp_dept_v1 AS
SELECT e.employee_id, e.emp_name, e.department_id
     , d.department_name
  FROM employees e
     , departments d
 WHERE e.department_id = d.department_id;

SELECT * FROM emp_dept_v1;

-- 뷰를 만들어서 다른 사람한테
-- 필요한 정보만 뷰로 만들어서
-- 준다

-- TO 계정에게 뷰를 셀렉할 권한을 준다
--GRANT SELECT ON emp_dept_v1 TO study;

-- 그렇다면 STUDY 계정에서 불러올라면
-- SELECT * FROM java.emp_dept_vi;

- 특징
    1. 단순 뷰
       = 하나의 테이블로 생성
       = 그룹 함수의 사용이 불가능
       = distinct(중복방지) 사용이 불가능
       = insert/update/delete 등 사용 가능
    2. 복합 뷰
       = 여러 개의 테이블로 생성
       = 그룹 함수의 사용이 가능
       = distinct(중복방지) 사용이 가능
       = insert/update/delete 등 사용 가능

-- 뷰를 만들때
-- CREATE OR REPLACE VIEW
-- 만들거나 있으면 대체한다..!

CREATE OR REPLACE VIEW emp_dept_v1 AS
SELECT e.employee_id       AS 사번
     , e.emp_name          AS 사원명
     , e.department_id     AS 부서번호
     , d.department_name   AS 부서명
  FROM employees e
     , departments d
 WHERE e.department_id = d.department_id;

SELECT * FROM emp_dept_v1;

-- 뷰에 AS를 주면 별명으로 나온다
-- 보안!
-- 즉, 뷰는 편리함 + 보안상의 이유로 계정상 많이 쓴다.

DROP VIEW emp_dept_v1;




