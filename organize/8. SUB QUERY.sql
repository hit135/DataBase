-- Day 13
-- 문제
-- 1.

SELECT e.employee_id     AS 사번
     , e.emp_name        AS 사원명
     , e.salary          AS 급여
     , j.job_title       AS 업무명
     , d.department_name AS 부서명
  FROM employees e, jobs j, departments d
 WHERE e.department_id = d.department_id
   AND e.job_id = j.job_id
   AND e.salary >= 10000
 ORDER BY e.employee_id;
 
-- 이것을 inner join으로 변경해보기!
SELECT e.employee_id     AS 사번
     , e.emp_name        AS 사원명
     , e.salary          AS 급여
     , j.job_title       AS 업무명
     , d.department_name AS 부서명
  FROM employees e, jobs j, departments d
 WHERE d.department_id IN ( SELECT d.department_id
                              FROM departments d
                             WHERE e.department_id = d.department_id)
   AND j.job_id IN ( SELECT j.job_id
                       FROM jobs j
                      WHERE e.job_id = j.job_id)
   AND e.salary >= 10000
 ORDER BY e.employee_id;
 
 -- inner 조인
 SELECT e.employee_id     AS 사번
     , e.emp_name        AS 사원명
     , e.salary          AS 급여
     , j.job_title       AS 업무명
     , d.department_name AS 부서명
  FROM employees e
  INNER JOIN jobs j ON e.job_id = j.job_id
  INNER JOIN departments d ON e.department_id = d.department_id
 WHERE e.salary >= 10000
 ORDER BY e.employee_id;
 
/* 2. 사용자별 장바구니 현황
    사용자 아이디     이름  카트사용횟수, 상품품목갯수  전체상품구매갯수 (cart_qty) 총구매금액
        c001        신용환         8           23              79                  1930000
*/

-- cart, memberm, prod

SELECT m.mem_id                         AS 회원아이디
     , m.mem_name                       AS 회원이름
     , COUNT(DISTINCT c.cart_no)        AS 카트사용횟수
     , COUNT(c.cart_prod)               AS 상품품목갯수
     , SUM(c.cart_qty)                  AS 전체상품구매갯수
     , LPAD(TO_CHAR(SUM(p.prod_price * c.cart_qty), 'FML999,999,999'), 14, ' ')   AS 총구매금액
  FROM cart c, member m, prod p
 WHERE m.mem_id = c.cart_member(+)
   AND c.cart_prod = p.prod_id(+)
 GROUP BY m.mem_id, m.mem_name
 ORDER BY m.mem_id;

-- outer join을 안걸어서 사람이 빠져버렸다!
-- NVL 함수는 NUll 값을 지정한 것으로 치환시켜주는 것
-- NVL(컬럼, 0) >> 컬럼의 값을 0으로 치환
-- NVL(컬럼, '문자') >> 컬럼의 값을 문자로 치환
-- NVL(컬럼, 'SYSDATE') >> 컬럼의 값을 SYSDATE로 치환

-- 나아가기.. 카트사용횟수가 3번 이상인 사람을 구하시오..!

SELECT m.mem_id                         AS 회원아이디
     , m.mem_name                       AS 회원이름
     , COUNT(DISTINCT c.cart_no)        AS 카트사용횟수
     , COUNT(c.cart_prod)               AS 상품품목갯수
     , SUM(NVL(c.cart_qty,0))               AS 전체상품구매갯수
     , LPAD(TO_CHAR(SUM(NVL(p.prod_price * c.cart_qty,0)), 'FML999,999,999'), 14, ' ')   AS 총구매금액
  FROM cart c, member m, prod p
 WHERE m.mem_id = c.cart_member(+)
   AND c.cart_prod = p.prod_id(+)
 GROUP BY m.mem_id, m.mem_name
 HAVING COUNT(DISTINCT c.cart_no) >= 3
 ORDER BY m.mem_id;


/*
    서브쿼리
    SUB QUERY SQL 문장 안에 보조로 사용되는 또 다른 SELECT 문
    
    메인 쿼리와 연관성에 따라
    1. 연관성 없는 서브 쿼리 
    2. 연관성 있는 있는 서브쿼리
    
    형태에 따라
    1. 일반 서브쿼리 (SELECT 절) >> 데이터가 하나만 나와줘야 한다..!
    2. 인라인 뷰 (FROM 절)
    3. 중첩 쿼리 (WHERE 절)
*/

-- 중첩쿼리 ,, 메인쿼리와 연관이 없다!
SELECT COUNT(*)
  FROM employees
 WHERE salary >= (
                  SELECT AVG(salary)
                    FROM employees
                 );

SELECT COUNT(*)
  FROM employees
 WHERE department_id IN (
                         SELECT department_id
                           FROM departments
                          WHERE parent_id IS NULL
                         );
                         
SELECT employee_id, emp_name, job_id
  FROM employees
 WHERE (employee_id, job_id) IN (
                                 SELECT employee_id, job_id
                                   FROM job_history
                                 );


-- 연관이 있는 서브쿼리
SELECT a.department_id, a.department_name
  FROM departments a
 WHERE EXISTS (
               SELECT 1
                 FROM job_history b
                WHERE a.department_id = b.department_id
              );
-- EXISTS는 존재하면 출력..!
              
-- 이를 IN절로
SELECT a.department_id, a.department_name
  FROM departments a
 WHERE a.department_id IN (
                            SELECT b.department_id
                              FROM job_history b
                           );

-- 인라인 쿼리...!
-- 좀 주의해서 써야 한다..
-- 셀렉 할 때마다 쿼리가 실행돼서
-- 복잡한 것은 밑의 join절로 빼서 쓰는게 권장된다!
SELECT  a.employee_id
      ,(
        SELECT b.emp_name
          FROM employees b
         WHERE a.employee_id = b.employee_id
        ) AS emp_name
      , a.department_id
      ,(
        SELECT b.department_name
          FROM departments b
         WHERE a.department_id = b.department_id
        ) AS dep_name
  FROM job_history a;
  
-- 타고 타고 들어가는 서브쿼리
SELECT a.department_id, a.department_name
  FROM departments a
 WHERE EXISTS (
               SELECT 1
                 FROM employees b
                WHERE a.department_id = b.department_id
                  AND b.salary > (
                                  SELECT AVG(salary)
                                    FROM employees
                                  )
               );

-- 서브쿼리 연습               
SELECT department_id, AVG(salary)
  FROM employees a
 WHERE department_id IN ( SELECT department_id
                            FROM departments
                           WHERE parent_id = 90)
 GROUP BY department_id;
 
-- 상위 부서가 기획부인 모든 사원의 급여를
-- 자신의 부서별 평균값으로 업데이트
-- p196
UPDATE employees a
   SET a.salary = ( SELECT sal
                      FROM ( SELECT b. );

              
-- 인라인 뷰
-- p 198
-- 기획부 산하 부서들의 평균 임금보다 높은 사원을 추출
-- 괄호 안의 쿼리는 단독쿼리라
-- 밖에 쿼리에 영향을 안받는다..!
SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
  FROM employees a
     , departments b
     , ( SELECT AVG(c.salary) AS avg_salary
           FROM departments d,
                employees c
          WHERE d.parent_id = 90
            AND d.department_id = c.department_id) d
 WHERE a.department_id = b.department_id
   AND a.salary > d.avg_salary;


-- 이탈리아에서
-- 연 평균 매출액보다 월 평균 매출이 큰 달을 구하시오!
SELECT a.*
  FROM ( SELECT a.sales_month, ROUND(AVG(a.amount_sold)) AS month_avg
           FROM sales a
              , customers b
              , countries c
          WHERE a.sales_month BETWEEN '200001' AND '200012'
            AND a.cust_id = b.cust_id
            AND b.country_id = c.country_id
            AND c.country_name = 'Italy'
          GROUP BY a.sales_month
        ) a
     , ( SELECT ROUND(AVG(a.amount_sold)) AS year_avg
           FROM sales a
              , customers b
              , countries c
          WHERE a.sales_month BETWEEN '200001' AND '200012'
            AND a.cust_id = b.cust_id
            AND b.country_id = c.country_id
            AND c.country_name = 'Italy'
        ) b
 WHERE a.month_avg > b.year_avg;

-- 그렇다면 독일에서
-- 월 평균 매출액보다 일 평균 매출이 큰 일을 구하시오...
-- 99년 6월!

SELECT DISTINCT sales_date
  FROM sales
 WHERE sales_date LIKE '99/06/%';
 
-- 이걸 통해 30일까지 있다는것을 알 수 있다!

SELECT sales_date
     , ROUND(AVG(a.amount_sold)) AS date_avg
  FROM sales a
     , customers b
     , countries c
 WHERE sales_date LIKE '99/06/%'
   AND a.cust_id = b.cust_id
   AND b.country_id = c.country_id
   AND c.country_name = 'Germany'
 GROUP BY a.sales_date
 ORDER BY a.sales_date;
-- 이건 매일의 매출 평균액

SELECT ROUND(AVG(a.amount_sold)) AS month_avg
  FROM sales a
     , customers b
     , countries c
 WHERE sales_date LIKE '99/06/%'
   AND a.cust_id = b.cust_id
   AND b.country_id = c.country_id
   AND c.country_name = 'Germany';
-- 이건 6월의 매출 평균액


SELECT a.*
  FROM (SELECT sales_date
             , ROUND(AVG(a.amount_sold)) AS date_avg
          FROM sales a
             , customers b
             , countries c
         WHERE sales_date LIKE '99/06/%'
           AND a.cust_id = b.cust_id
           AND b.country_id = c.country_id
           AND c.country_name = 'Germany'
         GROUP BY a.sales_date
         ORDER BY a.sales_date
       ) a
     , (SELECT ROUND(AVG(a.amount_sold)) AS month_avg
          FROM sales a
             , customers b
             , countries c
         WHERE sales_date LIKE '99/06/%'
           AND a.cust_id = b.cust_id
           AND b.country_id = c.country_id
           AND c.country_name = 'Germany'
       ) b
 WHERE a.date_avg > b.month_avg
 ORDER BY a.sales_date;
 
 