-- Day5


----------------------------- 연산자 -----------------------------
-- 문자 연산자 : ||
SELECT '[' || employee_id || '-' || emp_name || ']' AS emp_into
  FROM employees
 WHERE ROWNUM < 5;
 
 -- 수식 연산자 : +, -, *, /
 SELECT employee_id             AS 직원아이디
      , emp_name                AS 직원이름
      , TO_CHAR(salary / 30, '999.99')             AS 일당
      , salary                  AS 월급
      , salary - salary * 0.1   AS 실수령액
      , salary * 12             AS 연봉
  FROM employees
 WHERE department_id = 30;
 
 SELECT *
   FROM employees
  WHERE department_id = 30;

-- 논리연산자 : >, <, >=, <=, =, <>, !=, ^=(같지않다)
SELECT * FROM employees WHERE salary  = 2600;        -- 같다
SELECT * FROM employees WHERE salary <> 2600;        -- 같지않다
SELECT * FROM employees WHERE salary != 2600;        -- 같지않다
SELECT * FROM employees WHERE salary  < 2600;        -- 미만
SELECT * FROM employees WHERE salary  > 2600;        -- 초과
SELECT * FROM employees WHERE salary <= 2600;        -- 이하
SELECT * FROM employees WHERE salary >= 2600;        -- 이상


/*
  1. 논리 연산자를 사용하여 products 테이블에서
    '상품 최저 금액(PROD_MIN_PRICE)' 이
    30원 '이상' 40원 '미만'의 상품명을 조회하세요
  2. products 테이블에서 하위카테고리가 'CD-ROM'이고
    '상품 최저 금액'이 35 보다 크고
    '상품 최저 금액'이 40보다 작은 '상품명(prod_name)'을 조회하시오
*/

-- 1
SELECT prod_name    AS 상품명
  FROM products
 WHERE prod_min_price >= 30
   AND prod_min_price  < 40;
-- 2
SELECT prod_name    AS 상품명
  FROM products
 WHERE prod_subcategory = 'CD-ROM'
   AND prod_min_price > 35
   AND prod_min_price < 40;
   
SELECT *
  FROM products
 WHERE prod_min_price >= 30
   AND prod_min_price  < 40;

----------------------------------------------------------------
/*
  문제
  1. MEMBER 테이블을 이용하여 아래의 필드를 갖는 MEM_EX 테이블 만들고,
  (MEM_ID, MEM_NAME, MEM_ADD1, MEM_COMTEL, MEM_MAIL, MEM_JOB, MEM_LIKE, MEM_MEMORIALDAY, MEM_MILEAGE)
  MEMBER 테이블에서 직업이 '자영업' 인 정보만
  생성한 MEM_EX 테이블에 insert 하시오.
  (해당 조건으로 검색 후 insert - select 문으로 삽입)
*/

DESC member;

CREATE TABLE mem_ex
AS
SELECT  mem_id
       ,mem_name
       ,mem_add1
       ,mem_comtel
       ,mem_mail
       ,mem_job
       ,mem_like
       ,mem_memorialday
       ,mem_mileage
FROM    member
WHERE   mem_job = '자영업';

-- 구조만 가져오고 싶으면
-- where에 말도안되는 조건을 주면 된다
-- 1 <> 1;

SELECT *
FROM member
WHERE mem_job = '자영업';

SELECT *
FROM mem_ex;

--2. MEN_EX의 '김은대'의 마일리지를 0으로 초기화 하시오

INSERT INTO mem_ex
SELECT  mem_id
       ,mem_name
       ,mem_add1
       ,mem_comtel
       ,mem_mail
       ,mem_job
       ,mem_like
       ,mem_memorialday
       ,mem_mileage
 FROM   member
WHERE   mem_name = '김은대';


UPDATE mem_ex
   SET mem_mileage = 0, mem_like = '축구'
 WHERE mem_name = '김은대';



--3. BUYER 테이블에서
--   농협, 국민은행을 사용하는
--  '거래처의 이름' 과 '은행', '계좌번호', '전화번호'를 조회하시오

SELECT *
FROM buyer;

SELECT buyer_name       AS 거래처의이름
      ,buyer_bank       AS 은행
      ,buyer_bankno     AS 계좌번호
      ,buyer_comtel     AS 전화번호
  FROM buyer
 WHERE buyer_bank = '농협'
    OR buyer_bank = '국민은행';


----------------------------------------- MERGE문 -----------------------------------------

CREATE TABLE ex3_3(
       employee_id NUMBER,
       bonus_emt   NUMBER DEFAULT 0);
    
DROP TABLE ex3_3;
INSERT INTO ex3_3 (employee_id)
SELECT e.employee_id
  FROM employees e,
       sales s
 WHERE e.employee_id = s.employee_id
   AND s.SALES_MONTH BETWEEN '200010' AND '200012'
GROUP BY e.employee_id;

SELECT *
FROM ex3_3
ORDER BY employee_id;
 ---------------------------------------------------------------------------------------------------------------------
 -- merge문에서 d와 b는 별명을 지어준것이다.
 -- 테이블은 as 필요없이 간편하게 지역변수로 별명지어줌
 MERGE INTO ex3_3 d
      USING (SELECT employee_id, salary, manager_id
               FROM employees
              WHERE manager_id = 146) b
         ON (d.employee_id = b.employee_id)
 WHEN MATCHED THEN
    UPDATE SET d.bonus_emt = d.bonus_emt + b.salary * 0.01
 WHEN NOT MATCHED THEN
    INSERT (d.employee_id, d.bonus_emt)
    VALUES (b.employee_id, b.salary * 0.001)
     WHERE (b.salary < 8000);

-- if 첫번째는 id값이 같은가?
-- 같으면 업데이트
-- 다르면 인설트
-- 그런데, 인설트 할 때 b.salary < 8000보다 작아야 한다.

SELECT *
  FROM employees
 WHERE manager_id = 146;

------------------------------------ 표현식 ------------------------------------

-- case : if ~ else if ~ else

SELECT employee_id
     , salary
     , CASE WHEN salary <= 5000 THEN 'C등급'
            WHEN salary  > 5000 AND salary <= 15000 THEN 'B등급'
            ELSE 'A등급'
       END AS salary_grade
  FROM employees
  ORDER BY salary;


/* 문제 
    표현식을 이용해
    member 테이블에서 직업이 '주부'이거나 '공무원'인 회원을 출력
    mem_mileage가 1000 이하 FAMILY
                  1000 초과 2000 이하 GOLD
                  2000 초과 4000 이하 VIP
                  나머지              VVIP              
*/

-- 전체를 집고 싶으면 별명을 주자!
-- all을 자꾸쓰면 코드 참고하는 사람이 db까지 열어봐야해서
-- 선호되지 않음
SELECT  a.*
  , CASE WHEN MEM_MILEAGE <= 1000 THEN 'FAMILY'
         WHEN MEM_MILEAGE  > 1000 AND MEM_MILEAGE <= 2000 THEN 'GOLD'
         WHEN MEM_MILEAGE  > 2000 AND MEM_MILEAGE <= 4000 THEN 'VIP'
         ELSE 'VVIP'
     END AS 등급
    FROM member a
   WHERE mem_job = '주부' 
      OR mem_job = '공무원'
ORDER BY MEM_MILEAGE;

SELECT *
FROM member;

-----------------------------------------------------------------------------
SELECT *
FROM countries;

  SELECT country_region
    FROM countries
ORDER BY country_region ASC; 

-- 중복 데이터 제거
  SELECT DISTINCT country_region
    FROM countries
ORDER BY country_region ASC; 

-- 두개의 값 이상이 같고 중복이면 제거
-- ,로 연결된 값을 하나로 연결해서 중복이면 제거라고 생각하면 편하다.
SELECT DISTINCT country_region
               ,country_iso_code
    FROM countries
ORDER BY country_region ASC; 

SELECT DISTINCT country_region
               ,country_iso_code
               ,country_subregion
    FROM countries
ORDER BY country_region ASC;

SELECT DISTINCT prod_id
  FROM sales;


















