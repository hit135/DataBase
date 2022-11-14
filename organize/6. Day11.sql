-- Day 6
-- 코로나로 1주일 빠짐


1. 사원테이블에서 입사년도별 사원수를 구하는 쿼리를 작성해보자.

SELECT EMPLOYEE_ID
     , EMP_NAME
     , HIRE_DATE
  FROM employees;
  
SELECT TO_CHAR(hire_date, 'yyyy')       AS 입사년도
     , COUNT(employee_id)               AS 사원수
  FROM employees
 GROUP BY TO_CHAR(hire_date, 'yyyy')
 ORDER BY TO_CHAR(hire_date, 'yyyy');
--------------------------------------------------------------------------------------------------------------------------------
2. kor_loan_status 테이블에서 2012년도 월별, 지역별 대출 총 잔액을 구하는 쿼리를 작성하라.

SELECT period                       AS 날짜
     , region                       AS 지역
     , SUM(loan_jan_amt)            AS 대출잔액
  FROM kor_loan_status
 WHERE period LIKE '2012%'
 GROUP BY period, region
 ORDER BY period, region;
--------------------------------------------------------------------------------------------------------------------------------
3. 아래의 쿼리는 분할 ROLLUP을 적용한 쿼리이다.
SELECT period, gubun, SUM(loan_jan_amt) totl_jan
  FROM kor_loan_status
 WHERE period LIKE '2013%'
 GROUP BY period, ROLLUP(gubun);
이 쿼리를 ROLLUP을 사용하지 않고, 집합연산자를 사용해서 동일한 결과가 나오도록 쿼리를 작성해보자.

-- 여기서부터 못 풀음 >> 시간부족

-- 데이터 타입과 개수만 똑같으면 union을 쓸 수 있다.

SELECT period, gubun, SUM(loan_jan_amt) totl_jan
  FROM kor_loan_status
 WHERE period LIKE '2013%'
 GROUP BY period, gubun
UNION
SELECT period, '', SUM(loan_jan_amt) totl_jan
  FROM kor_loan_status
 WHERE period LIKE '2013%'
 GROUP BY period
 ORDER BY period;
-- 여기서 두번째 집합은 구분에 null값이 들어가기 때문에
-- ''을 넣어준다. >> 형식만 맞춰주면 된다.
-- 그리고 group by를 기간만 걸어준다
--------------------------------------------------------------------------------------------------------------------------------
4. 다음 쿼리를 실행해서 결과를 확인한 후, 집합 연산자를 사용해 동일한 결과를 추출하도록 쿼리를 작성해 보자.
SELECT period,
       CASE WHEN gubun = '주택담보대출' THEN SUM(loan_jan_amt) ELSE 0 END 주택담보대출액,
       CASE WHEN gubun = '기타대출'     THEN SUM(loan_jan_amt) ELSE 0 END 기타대출액
  FROM kor_loan_status
 WHERE period = '201311'
 GROUP BY period, gubun;
 
 
SELECT period, SUM(loan_jan_amt) 주택담보대출액, 0 기타대출액
  FROM kor_loan_status
 WHERE period = '201311'
   AND gubun = '주택담보대출'
 GROUP BY period, gubun
 UNION ALL
SELECT period, 0 주택담보대출액, SUM(loan_jan_amt) 기타대출액
  FROM kor_loan_status
 WHERE period = '201311'
   AND gubun = '기타대출'
 GROUP BY period, gubun;
 
-- 여기서 주의할 점은 GROUP BY에 gubun을 줘야한다..
 
 
 
 
 
 
 
5. 다음과 같은 형태, 즉 지역과 각 월별 대출총잔액을 구하는 쿼리를 작성해보자.
--------------------------------------------------------------------------------------------------------------------------------
지역  201111  201112  201210  201211  201212  201310  201311
--------------------------------------------------------------------------------------------------------------------------------
서울
부산
...
...
--------------------------------------------------------------------------------------------------------------------------------

-- 열을 행으로 피벗하는 것
-- 인라인뷰? 서브쿼리?

-- 5번 문제같은 작업을 많이 한다..
-- 하지만 이것은 한계가 있기때문에
-- 이를 주기적으로 집계테이블에 쌓는다..

SELECT region
     , SUM(AMT1) AS "201111"
     , SUM(AMT2) AS "201112"
     , SUM(AMT3) AS "201210"
     , SUM(AMT4) AS "201211"
     , SUM(AMT5) AS "201212"
     , SUM(AMT6) AS "201310"
     , SUM(AMT7) AS "201311"
  FROM (
        SELECT region,
               CASE WHEN period = '201111' THEN loan_jan_amt ELSE 0 END AMT1
             , CASE WHEN period = '201112' THEN loan_jan_amt ELSE 0 END AMT2
             , CASE WHEN period = '201210' THEN loan_jan_amt ELSE 0 END AMT3
             , CASE WHEN period = '201211' THEN loan_jan_amt ELSE 0 END AMT4
             , CASE WHEN period = '201212' THEN loan_jan_amt ELSE 0 END AMT5
             , CASE WHEN period = '201310' THEN loan_jan_amt ELSE 0 END AMT6
             , CASE WHEN period = '201311' THEN loan_jan_amt ELSE 0 END AMT7
          FROM kor_loan_status
        )
 GROUP BY region
 ORDER BY region;



-- JOIN문

-- 기본족인 inner조인, equal조인
SELECT employees.employee_id
     , employees.emp_name
     , employees.salary
     , employees.department_id
     , departments.department_name
  FROM employees
     , departments
 WHERE employees.department_id = departments.department_id;
 
 SELECT e.employee_id
     , e.emp_name
     , e.salary
     , e.department_id
     , d.department_name
  FROM employees e
     , departments d
 WHERE e.department_id = d.department_id;

SELECT *
  FROM employees;
-- outer조인을 쓰면 department_id가 없는 직원도 나타낼 수 있다.

문제 1
employees, jobs 테이블 이용
사번, 사원명, 급여, 직업 아이디, 직업명
급여가 15000 이상인

SELECT e.employee_id
     , e.emp_name
     , e.salary
     , e.job_id
     , j.job_title
  FROM employees e
     , jobs j
 WHERE e.job_id = j.job_id
   AND e.salary >= 15000
 ORDER BY e.employee_id;
   
SELECT *
  FROM employees
 ORDER BY salary DESC;

-- 3개 이상 참조
SELECT e.employee_id
     , e.emp_name
     , e.salary
     , e.department_id
     , d.department_name
     , e.job_id
     , j.job_title
  FROM employees e
     , departments d
     , jobs j
 WHERE e.job_id = j.job_id
   AND e.department_id = d.department_id
 ORDER BY e.employee_id;


-- 예제 문제
cart 테이블에서 c001, 이름, 구매한 물품, 물품의 타이틀
prod, member, cart테이블 참조

SELECT c.cart_member
     , m.mem_name
     , c.cart_prod
     , p.prod_name
  FROM cart c
     , prod p
     , member m
 WHERE c.cart_member = m.mem_id
   AND c.cart_prod = p.prod_id
   AND c.cart_member = 'c001'
 ORDER BY c.cart_prod;
 
 
-- 물품들의 가격을 더해보고 싶은데..?
 SELECT c.cart_member
     , m.mem_name
     , c.cart_prod
     , p.prod_name
     , p.prod_cost
  FROM cart c
     , prod p
     , member m
 WHERE c.cart_member = m.mem_id
   AND c.cart_prod = p.prod_id
   AND c.cart_member = 'c001'
UNION
  SELECT 'c001'
     , '신용환'
     , ''
     , ''
     , SUM(p.prod_cost)
  FROM cart c
     , prod p
     , member m
WHERE c.cart_member = m.mem_id
   AND c.cart_prod = p.prod_id
   AND c.cart_member = 'c001';


--------------------------------------------------------------------------------------------------------------------------------
-- 세미조인 EXISTS

SELECT department_id
     , department_name
  FROM departments a
 WHERE EXISTS(SELECT *
                FROM employees b
               WHERE a.department_id = b.department_id
                 AND b.salary > 3000)
 ORDER BY a.department_name;
 
-- 현업에서는 EXISTS는 확 들어오지 않아서 잘 안쓴다..
-- EXISTS는 true, false 개념이 들어간다..

--------------------------------------------------------------------------------------------------------------------------------
-- 세미조인 IN

SELECT DISTINCT b.department_id
  FROM employees b
     , departments a
 WHERE b.salary > 3000;
 
SELECT department_id, department_name
  FROM departments a
 WHERE a.department_id IN ( SELECT b.department_id
                              FROM employees b
                             WHERE b.salary > 3000)
 ORDER BY department_name;
 
 
--------------------------------------------------------------------------------------------------------------------------------
-- 안티 조인 NOT IN
-- not in () 뒤의 조건이 아닌애들을 꺼낸다..

SELECT a.employee_id, a.emp_name, a.department_id, b.department_name
  FROM employees a
     , departments b
 WHERE a.department_id = b.department_id
   AND a.department_id NOT IN( SELECT department_id
                                 FROM departments
                                WHERE manager_id IS NULL);

-- NOT EXISTS
-- exists 는 true면 꺼내고
-- not exists 는 false면 꺼낸다..
-- null을 포함해버린다..

SELECT a.employee_id, a.emp_name, a.department_id
  FROM employees a
 WHERE NOT EXISTS ( SELECT *
                      FROM departments d
                     WHERE a.department_id = d.department_id
                       AND d.manager_id IS NULL);
--------------------------------------------------------------------------------------------------------------------------------
-- self 조인
-- 같은 테이블을 두번 쓴다..!

SELECT a.employee_id
     , a.emp_name
     , a.manager_id
     , b.emp_name manager_name
  FROM employees a
     , employees b
 WHERE a.department_id = 30
   AND a.manager_id = b.employee_id;




















