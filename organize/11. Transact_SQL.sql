
-- 분석함수
-- RANK()
-- 파티션으로 그룹지어서 오더바이로 정렬된 랭크순을 반환
SELECT department_id, emp_name, salary,
       RANK() OVER (PARTITION BY department_id
                    ORDER BY salary) dep_rank
  FROM employees;

-- dense_rank는 중복값이 있어도 다음 번호
-- DENSE_RANK >> 1 1 2 2 2 3
-- RANK >> 1 1 3 3 3 6
SELECT department_id, emp_name, salary,
       DENSE_RANK() OVER (PARTITION BY department_id
                    ORDER BY salary) dep_rank
  FROM employees;

-- ROWNUMBER랑 RANK는 다르다!
-- ROWNUMBER은 중복값이 다른 번호를 부여
-- RANK는 중복값이 같은 번호를 부여

SELECT department_id, emp_name, salary,
       ROW_NUMBER() OVER (PARTITION BY department_id
                    ORDER BY salary) dep_rank
  FROM employees;

SELECT department_id, emp_name, salary,
       DENSE_RANK() OVER (PARTITION BY department_id
                    ORDER BY salary) dep_dense_rank,
       RANK() OVER (PARTITION BY department_id
                    ORDER BY salary) dep_rank,
       ROW_NUMBER() OVER (PARTITION BY department_id
                    ORDER BY salary) dep_row_number
  FROM employees;

-- 분석함수의 SUM, AVG
-- GROUP BY 랑 다른게 다 뽑아줌
SELECT employee_id
     , emp_name
     , salary
     , department_id
     , SUM(salary) OVER (PARTITION BY department_id)
     , ROUND(AVG(salary) OVER (PARTITION BY department_id),2)
  FROM employees;

-- 부서별 salary순으로 정렬하고
-- 5등인 사람들만 출력하라

SELECT department_id
     , emp_name
     , salary
     , sal_rank
  FROM (SELECT department_id
             , emp_name
             , salary
             , DENSE_RANK() OVER (PARTITION BY department_id
                                  ORDER BY salary DESC) sal_rank
          FROM employees
       ) a
 WHERE sal_rank = 5;

-- 'job_id' 별 'salary'가 10000이상이고 salary가 1등인사람

SELECT *
  FROM employees;

SELECT job_id
     , emp_name
     , salary
     , RANK() OVER (PARTITION BY job_id
                    ORDER BY salary DESC) job_rank
  FROM employees
 WHERE salary >= 10000;
 
SELECT job_id
     , emp_name
     , salary
     , job_rank
  FROM (SELECT job_id
             , emp_name
             , salary
             , RANK() OVER (PARTITION BY job_id
                            ORDER BY salary DESC) job_rank
          FROM employees
         WHERE salary >= 10000)
 WHERE job_rank = 1;

-- 누적분포도 값
-- CUME_DIST() >> 1/2 2/2 , 1/3 2/3 3/3
-- 내가 0~1사이 중 어느정도 위치에 있는가
-- 0< x <= 1
SELECT department_id, emp_name, salary,
       CUME_DIST() OVER (PARTITION BY department_id
                    ORDER BY salary) CUME_DIST
  FROM employees;

-- 백분위 순위 반환
-- PERCENT_RANK()
-- 나보다 작은 값이 몇명인가에 따라 값 변화
-- 0 <= x <= 1
SELECT department_id, emp_name, salary,
       PERCENT_RANK() OVER (PARTITION BY department_id
                    ORDER BY salary) CUME_DIST
  FROM employees;

SELECT department_id, emp_name, salary,
       DENSE_RANK() OVER (PARTITION BY department_id
                    ORDER BY salary) DENSE_RANK,
       PERCENT_RANK() OVER (PARTITION BY department_id
                    ORDER BY salary) PERCENT_RANK,
       CUME_DIST() OVER (PARTITION BY department_id
                    ORDER BY salary) CUME_DIST
  FROM employees
 WHERE department_id = 60;


-- NTILE(num)
-- 등분한 다음 순서가 등분한 곳의 어디에 들어가는지
-- 6등인걸 4등분하면 신기하게 11 22 3 4 요렇게 들어감
-- 원리는 모르겠음
-- 6명을 4등분 하면 6명이 4명 들어가고
-- 남은 2명이 이제 1번 2번

-- 이와같은 원리로 45명을 20등분하면
-- 20번까지 2명씩 들어가고
-- 1~5에 5명 더들어간다
SELECT department_id, emp_name, salary,
       NTILE(4) OVER (PARTITION BY department_id
                    ORDER BY salary) NTILE
  FROM employees;


-- 문제
-- 부서별 급여를 20분위로 나누었을 때 1분위에 속하는 직원만 조회
SELECT department_id, emp_name, salary,
       NTILE(20) OVER (PARTITION BY department_id
                    ORDER BY salary DESC) NTILE
  FROM employees;
  
SELECT department_id, emp_name, salary,
       NTILE
  FROM (SELECT department_id, emp_name, salary,
               NTILE(20) OVER (PARTITION BY department_id
                            ORDER BY salary DESC) NTILE
          FROM employees)
 WHERE NTILE = 1
   AND department_id IS NOT NULL;

SELECT COUNT(*)
  FROM employees
 WHERE department_id = 50;


-- LAG 선행 로우 값을 가져와서 반환 / LEAD 후행 로우 값을 가져와서 반환
SELECT employee_id , emp_name, salary, department_id, hire_date
     , LAG(emp_name, 1, '최상위') OVER (PARTITION BY department_id
                                       ORDER BY salary DESC) LAG_emp_name
     , LEAD(emp_name, 1, '최하위') OVER (PARTITION BY department_id
                                        ORDER BY salary DESC) LEAD_emp_name2
  FROM employees
 WHERE department_id IN (30,60);

SELECT employee_id , emp_name, salary, department_id, hire_date
     , LAG(emp_name, 2, '최차상위') OVER (PARTITION BY department_id
                                         ORDER BY salary DESC) LAG_emp_name
     , LEAD(emp_name, 2, '최차하위') OVER (PARTITION BY department_id
                                          ORDER BY salary DESC) LEAD_emp_name2
  FROM employees
 WHERE department_id IN (30,60);


-- window 절 
-- 파티션으로 분할되는걸 또 조건을 준다
-- GROUP BY 의 HAVING같은 느낌이다.
-- 이건 쉬운데?

SELECT department_id, emp_name, hire_date, salary,
       SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                         ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                         ) AS all_salary,
       SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                         ) AS first_current_salary,
       SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                         ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
                         ) AS current_end_salary
  FROM employees
 WHERE department_id IN (30, 90);

-- UNBOUNDED PRECEDING << 처음 로우
-- CURRENT ROW << 현재 로우
-- UNBOUNDED FOLLOWING << 마지막 로우


-- range는 범위를 정해준다
SELECT department_id, emp_name, hire_date, salary,
       SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                         RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                         ) AS all_salary,
       SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                         RANGE 365 PRECEDING
                         ) AS range_salary,
       SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date
                         RANGE BETWEEN 365 PRECEDING AND CURRENT ROW
                         ) AS current_range_salary
  FROM employees
 WHERE department_id IN (30, 90);

-- FIRST_VALUE(expr)  주어진 그룹 상에서 가장 첫 번째 값.
-- PARTITION으로 나눠진거에서 ROWS나 RANGE로 조건을 걸어준 후 거기 안에서 값을 뽑아냄
SELECT department_id, emp_name, hire_date, salary,

       FIRST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY hire_Date
                                 RANGE 1095 PRECEDING
                                ) AS first_range_760_sal,
       FIRST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY hire_Date
                                 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                                ) AS all_salary,
       FIRST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY hire_Date
                                 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                                ) AS fr_st_to_current_sal,
       FIRST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY hire_Date
                                 ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
                                ) AS fr_current_to_end_sal
  FROM employees  WHERE department_id IN (30, 90); 
  
-- LAST_VALUE(expr)  주어진 그룹 상에서 가장 마지막 값.
-- PARTITION으로 나눠진거에서 ROWS나 RANGE로 조건을 걸어준 후 거기 안에서 값을 뽑아냄    
 SELECT department_id, emp_name, hire_date, salary,
       LAST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY hire_Date
                                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                                ) AS all_salary,
       LAST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY hire_Date
                                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                                ) AS fr_st_to_current_sal,
       LAST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY hire_Date
                                ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
                                ) AS fr_current_to_end_sal
  FROM employees
 WHERE department_id IN (30, 90); 
 
-- NTH_VALUE(measure_expr, n) 함수는 주어진 그룹에서 n번째 로우에 해당하는 measure_expr 값을 반환.
-- PARTITION으로 나눠진거에서 ROWS나 RANGE로 조건을 걸어준 후 거기 안에서 값을 뽑아냄
SELECT department_id, emp_name, hire_date, salary,
       NTH_VALUE(salary, 2) OVER (PARTITION BY department_id ORDER BY hire_Date
                                  ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                                 ) AS all_salary,
       NTH_VALUE(salary, 2) OVER (PARTITION BY department_id ORDER BY hire_Date
                                  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                                 ) AS fr_st_to_current_sal,
       NTH_VALUE(salary,2 ) OVER (PARTITION BY department_id ORDER BY hire_Date
                                  ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
                                 ) AS fr_current_to_end_sal
  FROM employees
 WHERE department_id IN (30, 90) ; 


-- 기타 분석 함수
-- WIDTH_BUCKET ( 컬럼명, 최솟값, 최댓값, 나눌수)
-- 컬럼명에 따라 최솟값과 최댓값 사이를 나눌수만큼 나눈다
-- 그래서 거기에 포함된 숫자를 출력
-- 영역을 잡아서 넣는것
SELECT department_id
     , emp_name
     , salary
     , NTILE(4) OVER (PARTITION BY department_id ORDER BY salary) NTILES
     , WIDTH_BUCKET (salary, 1000, 10000, 4) WIDTHBUCKET
     , WIDTH_BUCKET (salary, 5000, 10000, 4) WIDTHBUCKET
  FROM employees
 WHERE department_id = 60;
 
-- RATIO_TO_REPORT
-- 전체 더한것에서 현재 값의 비율을 구함
-- 즉, 내 값 / 전체 값
-- 내가 전체에서 얼마나 차지하나!
SELECT department_id, emp_name, hire_date, salary
     , ROUND(RATIO_TO_REPORT(salary) OVER (PARTITION BY department_id),2) AS salary_percent
  FROM employees
 WHERE department_id IN (30, 90);
 
SELECT department_id, emp_name, hire_date, salary
     , ROUND(RATIO_TO_REPORT(salary) OVER (PARTITION BY department_id),2) AS salary_percent
     , ROUND(salary / SUM(salary) OVER (PARTITION BY department_id), 2) AS salary_sum
  FROM employees
 WHERE department_id IN (30, 90);
 
 
-- first와 last
WITH basis AS ( SELECT period, region, SUM(loan_jan_amt) jan_amt
                  FROM kor_loan_status
                 GROUP BY period, region
              ), 
    basis2 as ( SELECT period, MIN(jan_amt) min_amt, MAX(jan_amt) max_amt
                  FROM basis
                 GROUP BY period
              )
 SELECT a.period, 
        b.region "최소지역", b.jan_amt "최소금액",
        c.region "최대지역", c.jan_amt "최대금액"
   FROM basis2 a, basis b, basis c
  WHERE a.period  = b.period
    AND a.min_amt = b.jan_amt 
    AND a.period  = c.period
    AND a.max_amt = c.jan_amt
  ORDER BY 1, 2;
 
 
-- DENSE_RANK, RANK, 
-- FIRST, LAST 
WITH basis AS (
               SELECT period, region, SUM(loan_jan_amt) jan_amt
                 FROM kor_loan_status
                GROUP BY period, region
              )
SELECT a.period, 
       MIN(a.region) KEEP ( DENSE_RANK FIRST ORDER BY jan_amt) "최소지역", 
       MIN(jan_amt) "최소금액", 
       MAX(a.region) KEEP ( DENSE_RANK LAST ORDER BY jan_amt) "최대지역",
       MAX(jan_amt) "최대금액"
FROM basis a
GROUP BY a.period
ORDER BY 1, 2;
 
 
SELECT period, region, SUM(loan_jan_amt) jan_amt
  FROM kor_loan_status
 GROUP BY period, region;
                 
SELECT period, MIN(jan_amt) min_amt, MAX(jan_amt) max_amt
  FROM (SELECT period, region, SUM(loan_jan_amt) jan_amt
          FROM kor_loan_status
         GROUP BY period, region)
 GROUP BY period;
 
 
-- 그 달의 최댓값, 최솟값
-- 그리고 그에 따른 지역

SELECT *
  FROM kor_loan_status;
  
-- 일단 기간과 지역으로 묶는다
SELECT period, region, SUM(loan_jan_amt) jan_amt
  FROM kor_loan_status
 GROUP BY period, region;
 
-- 위의 쿼리에서 최댓값 최소값을 뽑는다
SELECT period, MIN(jan_amt) min_amt, MAX(jan_amt) max_amt
  FROM (SELECT period, region, SUM(loan_jan_amt) jan_amt
          FROM kor_loan_status
         GROUP BY period, region)
 GROUP BY period;
 
SELECT a.period
     , a.region
     , b.min_amt
     , c.region
     , b.max_amt
  FROM (SELECT period, region, SUM(loan_jan_amt) jan_amt
          FROM kor_loan_status
         GROUP BY period, region) a ,
       (SELECT period, MIN(jan_amt) min_amt, MAX(jan_amt) max_amt
          FROM (SELECT period, region, SUM(loan_jan_amt) jan_amt
                  FROM kor_loan_status
                 GROUP BY period, region)
         GROUP BY period) b ,
       (SELECT period, region, SUM(loan_jan_amt) jan_amt
          FROM kor_loan_status
         GROUP BY period, region) c
 WHERE a.period = b.period
   AND a.jan_amt = b.min_amt
   AND c.period = b.period
   AND c.jan_amt = b.max_amt
 ORDER BY 1,2;
 
 
 
 
 
 
 
 
 