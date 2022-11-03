/* 우리끼리 연습문제 만들어서..
   Q1. 배송부 테이블을 만들것이다.
   테이블들의 이름은 사번, 사원명, 부서명, 상사ID, 입사일자, 급여, 고용상태
   고용상태 빼고는 departments ,employees표를 참고해서 만들고
   안의 데이터는 배송부만 들어간다.

   조건 1. 테이블명은 자유 그러나 코멘트에 "배송부"라는 코멘트를 달아준다

   조건 2. 사번에는 pk키를 걸어준다 이 때 제약조건의 이름은 PK_Delivery

   조건 3. 입사일자는 20XX.XX.XX로 저장

   조건 4. 급여는 ₩32,300만원 깥이 출렦

   조건 5. 고용상태라는 컬럼은 디폴트 값이 'Y'이다.
*/

CREATE TABLE delivery_table
          AS
      SELECT employee_id        AS 사번
           , emp_name           AS 사원명
           , manager_id         AS 상사ID
           , TO_CHAR(hire_date, 'yyyy.mm.dd')           AS 입사일자
           , TO_CHAR(salary, 'FML999,999') || '만원'    AS 급여
        FROM employees
       WHERE department_id = 50
    ORDER BY employee_id;

SELECT *
  FROM delivery_table;
  
-- 테이블에 코멘트 붙이기
COMMENT ON TABLE delivery_table IS '배송부';
-- 컬럼 추가
ALTER TABLE delivery_table ADD 부서명 VARCHAR(10) DEFAULT '배송부';
ALTER TABLE delivery_table ADD 고용상태 CHAR(1) DEFAULT 'Y';

-- 사번에 프라이머리키 주기
ALTER TABLE delivery_table ADD CONSTRAINT PK_Delivery PRIMARY KEY (사번);

DESC delivery_table;

/* Q2. KOR_LOAN_STATUS에서 실수로 FK키를 누락시켰다.
   배송부 테이블의 사원키를 fk로 주는 테이블을 만드시오
   이 때, 사원 번호가 작은 순으로
   KOR_LOAN_STATUS의 로우 순서대로 2개의 로우를 갖는다.
*/
DESC kor_loan_status;

CREATE TABLE del_loan(
     사번    NUMBER(6,0)
    ,period VARCHAR2(6)
    ,region VARCHAR2(10)
    ,gubun  VARCHAR2(30)
    ,loan_jan_amt NUMBER
);

SELECT *
  FROM del_loan;
  
INSERT INTO del_loan
     SELECT delivery_table."사번"
          , kor_loan_status.period
          , kor_loan_status.region
          , kor_loan_status.gubun
          , kor_loan_status.loan_jan_amt
       FROM delivery_table, kor_loan_status
      WHERE delivery_table."사번" = 121
        AND kor_loan_status.loan_jan_amt = 29389.4;
       
DROP TABLE del_loan;

-- 현재 배운거로는 수동밖에 없다..

