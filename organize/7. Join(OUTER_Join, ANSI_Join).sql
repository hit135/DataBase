
-- 문제
/* 1. 급여가 10000 이상인 사원의
      사번, 사원명, 급여, 업무명, 부서명 조회
   2. 기획부(90)의 평균 급여보다 많이 받는 직원과 그의 부서를 출력하시오.
   3. lprod(상품대분류) P301의 상품코드 상품명 목록 및 바이어 정보를 출력하시오
   4. lprod(상품대분류)별 상품수, 바이어수 조회
*/

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
 
-- 2.  일단 넘어가기
-- 서브쿼리에서 값이 하마녀
-- 비교가 가능하다!
SELECT e.employee_id        AS 사번
     , e.emp_name           AS 사원명
     , d.department_name    AS 부서명
  FROM employees e, departments d
 WHERE (SELECT AVG(salary)
        FROM employees
        WHERE department_id = 90) < e.salary
   AND e.department_id = d.department_id;
   
-- 3.
SELECT p.prod_id
     , l.lprod_nm
     , p.prod_name
     , p.prod_buyer
     , b.buyer_name
  FROM lprod l, prod p, buyer b
 WHERE l.LPROD_GU = p.PROD_LGU
   AND p.prod_buyer = b.buyer_id
   AND l.LPROD_GU = 'P301'
 ORDER BY p.prod_id;
 
-- 4
SELECT l.lprod_nm                                                   AS 대분류
     , COUNT(DISTINCT p.prod_name)                                  AS 상품수
     , COUNT(DISTINCT p.prod_buyer)                                 AS 바이어수
     , LPAD(TO_CHAR(SUM(p.prod_cost), 'FML999,999,999'), 14, ' ' )  AS 상품금액합
  FROM lprod l, prod p
 WHERE l.LPROD_GU = p.PROD_LGU
 GROUP BY ROLLUP (l.lprod_nm)
 ORDER BY l.lprod_nm;
-- 여기서 바이어 총 수가 바이어수가 아니다 >> 12명이 운 좋게 맞긴 했지만
-- 만약에 대분류별 중복이 생긴다면
-- 값이 틀려질 것이다.

-- 오른쪽 정렬 LPAD('sql',5,'*')->**sql >> 오른족 정렬 후 왼쪽에 지정한 문자 삽입
-- 컴퓨터제품에서 prod 상품을 받은 바이어는 2명이지만
-- 실제 컴퓨터제품 buyer의 바이어는 3명이다
-- 함정에 빠지지 말자
SELECT DISTINCT prod_buyer
  FROM prod;


SELECT a.lprod_gu, a.lprod_nm, a.b_cnt, b.p_cnt
  FROM 
      (SELECT l.lprod_gu, l.lprod_nm       , COUNT(b.buyer_id) b_cnt
         FROM lprod l, buyer b
        WHERE l.lprod_gu = b.buyer_lgu
        GROUP BY l.lprod_gu, l.lprod_nm) a
    , (SELECT l.lprod_gu, l.lprod_nm       , Count(p.prod_id) p_cnt
         FROM lprod l, prod p
        WHERE l.lprod_gu = p.prod_lgu
        GROUP BY l.lprod_gu, l.lprod_nm) b
  WHERE a.lprod_gu = b.lprod_gu;

-- 한번에 하는 것보다는 여러개를 합치는게 가시적으로 좋다
-- 그리고 상품 테이블에는 계속해서 데이터가 늘어날텐데
-- 그룹바이를 항상 상품테이블도 해주기 때문에..? 위에가 낫다?
SELECT l.lprod_nm                                                   AS 대분류
     , COUNT(DISTINCT p.prod_name)                                  AS 상품수
     , COUNT(DISTINCT b.buyer_id)                                   AS 바이어수
     , LPAD(TO_CHAR(SUM(p.prod_cost), 'FML999,999,999'), 14, ' ' )  AS 상품금액합
  FROM lprod l, prod p, buyer b
 WHERE l.LPROD_GU = p.PROD_LGU
   AND l.LPROD_GU = b.buyer_lgu
 GROUP BY ROLLUP (l.lprod_nm)
 ORDER BY l.lprod_nm;
 
 -- 이론
 
 -- 외부조인(OUTER JOIN)
 
-- 이퀄
SELECT a.department_id
     , a.department_name
     , b.job_id
     , b.department_id
  FROM departments a, job_history b
 WHERE a.department_id = b.department_id;

SELECT *
  FROM job_history;
SELECT *
  FROM departments;
-- 이퀄되지 않는 department_id 데이터의 손실이 있다.
-- 이럴때 OUTER JOIN을 쓴다

-- 조인 조건에서 데이터가 없는 테이블의 컬럼에 (+)
SELECT a.department_id
     , a.department_name
     , b.job_id
     , b.department_id
  FROM departments a, job_history b
 WHERE a.department_id = b.department_id (+);
-- 더 큰 테이블의 데이터를 다 보고 싶다
-- 사용 예시 >> 부서 분류가 있다하면
-- 사원이 있으면 다 보이지만
-- 사원이 없다고 그 부서가 출력이 되지 않는다면 안된다..
-- 그러니 부서를 모두 출력할 때 OUTER JOIN같은게 필요하다

-- 위 문제를 빗댄 예신

SELECT DISTINCT b.buyer_id    BID
     , p.prod_buyer           PID
  FROM buyer b, prod p
 WHERE b.buyer_id = p.prod_buyer;

SELECT DISTINCT b.buyer_id    BID
     , p.prod_buyer           PID
  FROM buyer b, prod p
 WHERE b.buyer_id = p.prod_buyer (+)
 ORDER BY p.prod_buyer;


-- employees와 departments 테이블에서 부서 다 출력하기
SELECT DISTINCT e.department_id      E_DID
              , d.department_id      D_DID
              , d.department_name    D_DNAME
  FROM employees e, departments d
 WHERE e.department_id (+) = d.department_id
 ORDER BY e.department_id;

SELECT DISTINCT department_id  E_DID_COUNT
  FROM employees;
SELECT DISTINCT department_id  D_DID_COUNT
  FROM departments;

-- 사원이 없는 부서만 출력하기
SELECT DISTINCT e.department_id      E_DID
              , d.department_id      D_DID
              , d.department_name    D_DNAME
  FROM employees e, departments d
 WHERE e.department_id (+) = d.department_id
   AND e.department_id is null
 ORDER BY e.department_id;
 -- AND e.department_id is null 조건이 안먹으면
 -- 서브쿼리로 만들고 조건을 걸어주면 된다
 
-- 모든 사원을 보고 싶다
SELECT a.employee_id
     , a.emp_name
     , b.employee_id
     , b.job_id
     , b.department_id
  FROM employees a, job_history b
 WHERE a.employee_id = b.employee_id (+)
   AND a.department_id = b.department_id;
-- 모든 값이 안나온다..
-- 조건이 추가 돼서 이퀄조인이 이루어져버렸기 때문에!

SELECT a.employee_id
     , a.emp_name
     , b.employee_id
     , b.job_id
     , b.department_id
  FROM employees a, job_history b
 WHERE a.employee_id = b.employee_id (+)
   AND a.department_id = b.department_id (+);
   
-- 카타시안 조인 (현업에서는 크로스 조인이라고도 부른다)
-- 내가 생각하기에 곱조인이라고 생각하자
-- A데이터는 3개 B데이터는 2개 일때
-- SELECT *
--   FROM A , B
-- where절을 안둔다 >> 이게 카타시안 조인 >> 6개


-- ANSI 조인

SELECT a.employee_id            -- 이 문법을 ANSI 조인으로 
     , a.emp_name
     , a.salary
     , b.job_id
     , b.job_title
  FROM employees a
     , jobs b
 WHERE a.job_id = b.job_id
   AND a.salary >= 10000;

-- ANSI 조인 표준
SELECT a.employee_id
     , a.emp_name
     , a.salary
     , a.job_id
     , b.job_title
  FROM employees a
 INNER JOIN jobs b ON (a.job_id = b.job_id) -- 조인조건
 WHERE a.salary >= 10000;                   -- 조건
 
 -- 문법상 INNER OUTER은 생략이 가능하다!


-- ANSI 외부조인

SELECT a.employee_id        -- 이 JOIN을 ANSI외부조인으로
     , a.emp_name
     , b.employee_id
     , b.job_id
     , b.department_id
  FROM employees a, job_history b
 WHERE a.employee_id = b.employee_id (+)
   AND a.department_id = b.department_id (+);
   
-- 왼쪽의 모든 데이터를 추출
SELECT a.employee_id
     , a.emp_name
     , b.job_id
     , b.department_id
  FROM employees a
  LEFT OUTER JOIN job_history b
  ON ( a.employee_id = b.employee_id
       AND a.department_id = b.department_id);
       
-- 오른쪽의 모든 데이터를 추출
SELECT a.employee_id
     , a.emp_name
     , b.job_id
     , b.department_id
  FROM job_history b
  RIGHT OUTER JOIN employees a
  ON ( a.employee_id = b.employee_id
       AND a.department_id = b.department_id);
  
-- 문법상 INNER OUTER은 생략이 가능하다!


-- ANSI조인의 CROSS조인 >> 카타시안 조인
SELECT a.employee_id
     , a.emp_name
     , b.department_id
     , b.department_name
  FROM employees a
     , departments b;

SELECT a.employee_id
     , a.emp_name
     , b.department_id
     , b.department_name
  FROM employees a
 CROSS JOIN departments b;

-- FULL OUTER 조인!
CREATE TABLE hong_a (emp_id number);
DROP TABLE hong_a;
CREATE TABLE hong_b (emp_id number);

INSERT INTO hong_a VALUES (10);
INSERT INTO hong_a VALUES (20);
INSERT INTO hong_a VALUES (40);

INSERT INTO hong_b VALUES (10);
INSERT INTO hong_b VALUES (20);
INSERT INTO hong_b VALUES (30);

commit;
  
SELECT a.emp_id     A_id
     , b.emp_id     B_id
  FROM hong_a a
     , hong_b b
 WHERE a.emp_id (+) = b.emp_id (+);    -- 양쪽 다 보고 싶다고 (+)를 양쪽에 주면
                                       -- 오류가 난다
                                       -- 이는 FULL OUTER JOIN을 써줘야 한다!

-- FULL OUTER JOIN                                       
SELECT a.emp_id
     , b.emp_id
  FROM hong_a a
  FULL OUTER JOIN hong_b b
  ON ( a.emp_id = b.emp_id);
  
-- LEFT OUTER JOIN
-- 겹쳐지는 원의 왼쪽 >> FROM으로 먼저 꺼내오니 a 데이터를 모두 끄집어내겠찌..
SELECT a.emp_id     A_emp
     , b.emp_id     B_emp
  FROM hong_a a
  LEFT JOIN hong_b b
  ON( a.emp_id = b.emp_id);
  
-- RIGHT OUTER JOIN
-- 겹쳐지는 원의 오른쪽
SELECT a.emp_id     A_emp
     , b.emp_id     B_emp
  FROM hong_a a
  RIGHT JOIN hong_b b
  ON( a.emp_id = b.emp_id);

-- INNER JOIN
-- 양쪽다 겹쳐지는 교집합!
SELECT a.emp_id     A_emp
     , b.emp_id     B_emp
  FROM hong_a a
  JOIN hong_b b
  ON( a.emp_id = b.emp_id);

-- 카타시안 조인
SELECT a.emp_id
     , b.emp_id
  FROM hong_a a, hong_b b;
-- 크로스 조인
SELECT a.emp_id     A_emp
     , b.emp_id     B_emp
  FROM hong_a a
  CROSS JOIN hong_b b;










