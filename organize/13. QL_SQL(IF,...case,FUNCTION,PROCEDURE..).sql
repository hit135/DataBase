
/****************************************
 IF 문
*****************************************/

SET SERVEROUTPUT ON
SET TIMING ON

DECLARE
   vn_num1 NUMBER := 1;
   vn_num2 NUMBER := 2;
BEGIN
     IF vn_num1 >= vn_num2 THEN
        DBMS_OUTPUT.PUT_LINE(vn_num1 ||'이 큰 수(num1)');
     ELSIF vn_num1 = 0 THEN
        DBMS_OUTPUT.PUT_LINE(vn_num1 );
     ELSE
        DBMS_OUTPUT.PUT_LINE(vn_num2 ||'이 큰 수(num2)');	 
     END IF;
END;


DECLARE
-- VN_YEAR NUMBER := TO_CHAR(SYSDATE, 'YYYY');
   VN_YEAR VARCHAR2(4) := TO_CHAR(SYSDATE, 'YYYY');
   VN_CHECK_YEAR VARCHAR2(4) := :A;
BEGIN
    IF TO_NUMBER(VN_YEAR) > TO_NUMBER(VN_CHECK_YEAR) THEN
        DBMS_OUTPUT.PUT_LINE('작음');
    ELSE
        DBMS_OUTPUT.PUT_LINE('큼');
    END IF;
END;



DECLARE
   vn_salary NUMBER := 0;
   vn_department_id NUMBER := 0;
BEGIN
    vn_department_id := ROUND(DBMS_RANDOM.VALUE (10, 120), -1);
    DBMS_OUTPUT.PUT_LINE(vn_department_id);
   SELECT salary
     INTO vn_salary
     FROM employees
    WHERE department_id = vn_department_id
      AND ROWNUM = 1;
      
  DBMS_OUTPUT.PUT_LINE(vn_salary);
  IF vn_salary BETWEEN 1 AND 3000 THEN
     DBMS_OUTPUT.PUT_LINE('낮음');
  ELSIF vn_salary BETWEEN 3001 AND 6000 THEN
     DBMS_OUTPUT.PUT_LINE('중간');
  ELSIF vn_salary BETWEEN 6001 AND 10000 THEN
     DBMS_OUTPUT.PUT_LINE('높음');
  ELSE
     DBMS_OUTPUT.PUT_LINE('최상위');
  END IF;  
END;



DECLARE
   vn_salary NUMBER := 0;
   vn_department_id NUMBER := 0;
   vn_commission NUMBER := 0;
BEGIN
	vn_department_id := ROUND(DBMS_RANDOM.VALUE (10, 120), -1);
   SELECT salary, commission_pct
     INTO vn_salary, vn_commission
     FROM employees
    WHERE department_id = vn_department_id
      AND ROWNUM = 1;
  DBMS_OUTPUT.PUT_LINE(vn_salary);
  IF vn_commission > 0 THEN
     IF vn_commission > 0.15 THEN
        DBMS_OUTPUT.PUT_LINE(vn_salary * vn_commission );
     END IF;  
  ELSE
     DBMS_OUTPUT.PUT_LINE(vn_salary);
  END IF;  
END;



/****************************************
-- CASE 문
*****************************************/
DECLARE
   vn_salary NUMBER := 0;
   vn_department_id NUMBER := 0;
BEGIN
	vn_department_id := ROUND(DBMS_RANDOM.VALUE (10, 120), -1);
  
   SELECT salary
     INTO vn_salary
     FROM employees
    WHERE department_id = vn_department_id
      AND ROWNUM = 1;
  DBMS_OUTPUT.PUT_LINE(vn_salary);
  CASE WHEN vn_salary BETWEEN 1 AND 3000 THEN
            DBMS_OUTPUT.PUT_LINE('낮음');
       WHEN vn_salary BETWEEN 3001 AND 6000 THEN
            DBMS_OUTPUT.PUT_LINE('중간');
       WHEN vn_salary BETWEEN 6001 AND 10000 THEN
            DBMS_OUTPUT.PUT_LINE('높음');
       ELSE 
            DBMS_OUTPUT.PUT_LINE('최상위');
  END CASE;
END;

/****************************************
-- LOOP 문
*****************************************/
DECLARE
   vn_base_num NUMBER := 3;
   vn_cnt      NUMBER := 1;
BEGIN
   LOOP
      DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || vn_cnt || '= ' || vn_base_num * vn_cnt);
      
      vn_cnt := vn_cnt + 1; -- vn_cnt 값을 1씩 증가
      
      EXIT WHEN vn_cnt >9;  -- vn_cnt가 9보다 크면 루프 종료
   
   END LOOP;
END;



/****************************************
-- WHILE 문
*****************************************/

DECLARE
   vn_base_num NUMBER := 3;
   vn_cnt      NUMBER := 1;
BEGIN
   WHILE  vn_cnt <= 9 -- vn_cnt가 9보다 작거나 같을 경우에만 반복처리 
   LOOP
      DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || vn_cnt || '= ' || vn_base_num * vn_cnt);
      
      vn_cnt := vn_cnt + 1; -- vn_cnt 값을 1씩 증가
      
   END LOOP;
END;

DECLARE
   vn_base_num NUMBER := 3;
   vn_cnt      NUMBER := 1;
BEGIN
   
   WHILE  vn_cnt <= 9 -- vn_cnt가 9보다 작거나 같을 경우에만 반복처리 
   LOOP
      DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || vn_cnt || '= ' || vn_base_num * vn_cnt);
      EXIT WHEN vn_cnt = 5;
      vn_cnt := vn_cnt + 1; -- vn_cnt 값을 1씩 증가
   END LOOP;    
END;


/****************************************
-- FOR 문
*****************************************/
DECLARE
   vn_base_num NUMBER := 3;
BEGIN
   
   FOR i IN 1..9 
   LOOP
      DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || i || '= ' || vn_base_num * i);

   END LOOP;
    
END;


/*
 FOR 문 
 인덱스틑 초깃값에서 시작해 최종값까지 루프를 돌며 1씩 증가되는데,
 인덱스는 참조는 가능하지만 변경할 수는 없고 참조도 오직 루프안에서만 가능.
 그리고 REVERSE 를 명시하면 거꾸로 돈다(최종값에서 ->최솟값으로)
*/
DECLARE
   vn_base_num NUMBER := 3;
BEGIN
   
   FOR i IN REVERSE 1..9
  -- FOR i IN REVERSE 9..1
   LOOP
      DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || i || '= ' || vn_base_num * i);
    
   END LOOP;
    
END;






/****************************************
-- CONTINUE 문
*****************************************/

DECLARE
   vn_base_num NUMBER := 3;
BEGIN
   
   FOR i IN 1..9 
   LOOP
      CONTINUE WHEN i=5;
      DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || i || '= ' || vn_base_num * i);
   END LOOP;
    
END;





/****************************************
-- GOTO문
*****************************************/
/*
 GOTO문 
 GOTO문을 만나면 
 지정하는 라벨로 제어가 넘어간다.
 
 개발 현장에서는 GOTO문은 잘 사용하지 않는다. 
 특정 로직에 맞게 PL/SQL코드를 순차적으로 작성하는데  
 중간중간에 GOTO문을 사용해 제어를 다른 부분으로 넘기면 
 로직의 일관성을 훼손하며 가독성이 나빠지기 때문이다.
*/

DECLARE
   vn_base_num NUMBER := 3;
BEGIN

   <<third>>
   FOR i IN 1..9 
   LOOP
      DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || i || '= ' || vn_base_num * i);
      
      IF i = 3 THEN
         GOTO fourth;
      END IF;   
   END LOOP;
   
   <<fourth>>
   vn_base_num := 4;
   FOR i IN 1..9 
   LOOP
      DBMS_OUTPUT.PUT_LINE (vn_base_num || '*' || i || '= ' || vn_base_num * i);
   END LOOP;   
    
END;


/****************************************
-- NULL 문
*****************************************/
/**
 NULL 문
 NULL은 아무것도 처리하지 않는 문장. 
 IF나 CASE문에서 조건에 따라 로직을 작성하고 
 앞에서 작성한 모든 조건에 부합되지 않을 때, 
 즉 ELSE절을 수행할 때 아무것도 처리하지 않고 싶은 경우 NULL문 사용
*/
IF vn_variable = 'A' THEN
   처리로직1;
ELSIF vn_variable = 'B' THEN
   처리로직2;
...
ELSE NULL;
END IF;

CASE WHEN vn_variable = 'A' THEN
          처리로직1;
     WHEN vn_variable = 'B' THEN
          처리로직2;      
     ...
     ELSE NULL;
END CASE;    






/*******************************************************************************
-- 함수  : 프로젝트 성격에 맞게 다양한 함수를 직접 구현하여 사용.
********************************************************************************/

CREATE OR REPLACE FUNCTION my_mod ( num1 NUMBER, num2 NUMBER )
   RETURN NUMBER  -- 반환 데이터타입은 NUMBER
IS
   vn_remainder NUMBER := 0; -- 반환할 나머지
   vn_quotient  NUMBER := 0; -- 몫 
BEGIN
	 
	 vn_quotient  := FLOOR(num1 / num2); -- 피제수/제수 결과에서 정수 부분을 걸러낸다
	 vn_remainder := num1 - ( num2 * vn_quotient); --나머지 = 피제수 - ( 제수 * 몫)
	 
	 RETURN vn_remainder;  -- 나머지를 반환
END;



select my_mod(9,2) from dual;




/*
 함수삭제   
*/
DROP FUNCTION MY_MOD;




-- 국가 테이블을 읽어 국가번호를 받아 국가명을 반환하는 함수생성.
CREATE OR REPLACE FUNCTION fn_get_country_name ( p_country_id NUMBER )
   RETURN VARCHAR2  -- 국가명을 반환하므로 반환 데이터타입은 VARCHAR2
IS
   vs_country_name COUNTRIES.COUNTRY_NAME%TYPE;
BEGIN
	 
	 SELECT country_name
	   INTO vs_country_name
	   FROM countries
	  WHERE country_id = p_country_id;
	 
	 RETURN vs_country_name;  -- 국가명 반환
	
END;	



-- 없을경우는 '해당국가 없음' 반환

SELECT fn_get_country_name(52777) COUN1, fn_get_country_name(10000) COUN2
  FROM DUAL;
  
CREATE OR REPLACE FUNCTION fn_get_country_name ( p_country_id NUMBER )
   RETURN VARCHAR2  -- 국가명을 반환하므로 반환 데이터타입은 VARCHAR2
IS
   vs_country_name COUNTRIES.COUNTRY_NAME%TYPE;
   vn_count NUMBER := 0;
BEGIN

	SELECT COUNT(*)
	  INTO vn_count
	  FROM countries
	 WHERE country_id = p_country_id;
	 
  IF vn_count = 0 THEN
     vs_country_name := '해당국가 없음';
  ELSE
	
	  SELECT country_name
	    INTO vs_country_name
	    FROM countries
	   WHERE country_id = p_country_id;
	      
  END IF;
	 
 RETURN vs_country_name;  -- 국가명 반환
	
END;	  
  
  
  
SELECT fn_get_country_name (52777) COUN1, fn_get_country_name(10000) COUN2
  FROM DUAL;


-- 매개변수 없는 함수.
CREATE OR REPLACE FUNCTION fn_get_user
   RETURN VARCHAR2  -- 반환 데이터타입은 VARCHAR2
IS
   vs_user_name VARCHAR2(80);
BEGIN
	SELECT USER
    INTO vs_user_name
    FROM DUAL;
		 
  RETURN vs_user_name;  -- 사용자이름 반환
	
END;	 	

SELECT fn_get_user(),fn_get_user
  FROM DUAL;



-- 프로시저

/*******************************************************************************
-- 프로시저  : 스토어드 프로시저라고도 부름

********************************************************************************/
CREATE OR REPLACE PROCEDURE my_new_job_proc 
          ( p_job_id    IN JOBS.JOB_ID%TYPE,
            p_job_title IN JOBS.JOB_TITLE%TYPE,
            p_min_sal   IN JOBS.MIN_SALARY%TYPE,
            p_max_sal   IN JOBS.MAX_SALARY%TYPE )
IS
    vs_count NUMBER := 0;
BEGIN
	
    SELECT COUNT(*)
	  INTO vs_count
	  FROM jobs
	 WHERE job_id = p_job_id;


    IF vs_count = 0 THEN 
    
        INSERT INTO JOBS ( job_id, job_title, min_salary, max_salary, create_date, update_date)
                  VALUES ( p_job_id, p_job_title, p_min_sal, p_max_sal, SYSDATE, SYSDATE);
                  
        DBMS_OUTPUT.PUT_LINE('정보가 등록됐습니다');
                  
        COMMIT;
	ELSE
        DBMS_OUTPUT.PUT_LINE('중복된 아이디입니다');
      END IF;
	
END ; 


-- 변수명을 담아서 못하나?

CREATE OR REPLACE PROCEDURE my_new_job_proc 
          ( p_job_id    IN JOBS.JOB_ID%TYPE,
            p_job_title IN JOBS.JOB_TITLE%TYPE,
            p_min_sal   IN JOBS.MIN_SALARY%TYPE,
            p_max_sal   IN JOBS.MAX_SALARY%TYPE )
IS
    vs_count NUMBER := 0;
    vs_varchar jobs.job_id%type;
BEGIN
    
     SELECT COUNT(*)
	  INTO vs_count
	  FROM jobs
	 WHERE job_id = p_job_id;


    IF vs_count != 0 THEN 
        DBMS_OUTPUT.PUT_LINE('중복된 아이디입니다');

	ELSE
        vs_varchar := p_job_id;
        
        
        DBMS_OUTPUT.PUT_LINE(p_job_id);
        DBMS_OUTPUT.PUT_LINE(vs_varchar);
    
        INSERT INTO JOBS ( job_id, job_title, min_salary, max_salary, create_date, update_date)
                  VALUES ( p_job_id, p_job_title, p_min_sal, p_max_sal, SYSDATE, SYSDATE);
                  
        DBMS_OUTPUT.PUT_LINE(vs_varchar || '가 등록됐습니다');
                  
        COMMIT;

      END IF;
	
END ; 








-- 프로시저 실행
-- SELECT 절에 사용 불가.
EXEC my_new_job_proc ('SM_JOB1', 'Sample JOB1', 1000, 5000);

-- 무결설 제약조건으로 오류
EXEC my_new_job_proc ('SM_JOB1', 'Sample JOB1', 1000, 5000); 
EXEC my_new_job_proc ('PP_JOB2', 'Test Job2', 2000, 5000); 

SELECT *
  FROM jobs
 WHERE job_id = 'SM_JOB1';
 
 
DROP PROCEDURE my_new_job_proc;




























