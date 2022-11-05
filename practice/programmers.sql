-- 프로그래머스에서 나온 것들 공부

-- 최댓값 구하기 (MAX)

SELECT MAX(salary)
  FROM employees;
  
-- 최솟값 구하기 (MIN)
SELECT MIN(salary)
  FROM employees;
  
-- 조건으로 최솟값 최댓값 주기
SELECT employee_id
     , emp_name
     , salary
  FROM employees e
 WHERE e.salary = (SELECT MAX(salary)
                   FROM employees)
    OR e.salary = (SELECT MIN(salary)
                   FROM employees);
                   

-----------------------------------------------------------------------------
-- 데이터 안에 포함된 값 조건으로 주기 (LIKE)
-- employees안에 폰번호가 앞자리가 650으로 시작되는 사람들 표시

SELECT employee_id
     , emp_name
     , phone_number
  FROM employees 
 WHERE phone_number 
  LIKE '650%'
ORDER BY employee_id;

-- 123이 포함되는 폰번
SELECT employee_id
     , emp_name
     , phone_number
  FROM employees 
 WHERE phone_number 
  LIKE '%123%'
ORDER BY employee_id;

-----------------------------------------------------------------------------

-- 숫자 구하기 (COUNT)
-- 직업이 IT_PROG인 사람수 구하기
SELECT COUNT(job_id)
  FROM employees
 WHERE job_id = 'IT_PROG';

SELECT job_id
  FROM employees
 WHERE job_id = 'IT_PROG';

-----------------------------------------------------------------------------

-- 조건으로 날짜 주기
-- employees에서 2002년에 입사한 사람들의 숫자를 출력
SELECT COUNT(hire_date)
  FROM employees
 WHERE TO_CHAR(hire_date, 'yyyy') = '2002';

SELECT hire_date
  FROM employees
 WHERE TO_CHAR(hire_date, 'yyyy') = '2002';

