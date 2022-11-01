/* 데이터 베이스 기본 객체
    1) 테이블
    
    2) 뷰        
        >> 이친구도 많이 씀..
        >> 하나 이상 테이블을 연결해 가상의 테이블을 만듬
        >> 중요 정보에 접근하지 않고(필요없는 정보)
        >> 필요한 관계형 (가상)테이블을 노출
    
    3) 인덱스
        >> 중요한 컬럼에 인덱스를 준다
        >> 그럼 DB가 알아서 정리한다.
        >> 잘못 걸면 거꾸로 걸려서 검색속도가 느려짐
        >> 신입은 안검
    
    4) 시노님
        >> 별명
        >> 뷰, 테이블에 별명을 준다.
        >> 대부분 보안과 편리성 때문에 쓴다.
        
    5) 시퀀스
        >> 일렬번호 채번(key 값)
        >> nextVal
        
    6) 함수
    6) 프로시저
    7) 패키지
    
    
  1. 테이블(Table)
    >> CRUD
    >> 로우(행)과 컬럼(열)(필드)로 구성된다.
    >> 테이블 이름은 고유하다.
    >> 컬럼 이름은 고유하고 두번 나타낼 수 없다.
    >> 테이블 생성
        - CREATE TABLE (테이블 이름)(염문, 숫자, 언더바)
*/

-- 테이블 생성

-- 테이블 1 >> char, varchar2
CREATE TABLE ex2_1 (
    -- 테이블을 생성할 때.. 열 이름을 설정해준다.. >> 즉 구조를 설정해준다!
    -- 이는 데이터가 아니라 찾기 위해서 이름을 정해주는것
    col1 CHAR(10) ,     -- CHAR은 고정길이 (적게 쓰이지만 중요함) 
                        -- 공백까지 끼워넣어서 10칸을 만든다..
                        -- 정해진 길이를 주기 때문에 찾을 때 더 빠르다.
    
    col2 VARCHAR2(10)   -- VARCHAR은 가변길이 (많이 쓰임)        
                        -- 공백을 짜른다. 그리고 추가하면 이어 붙인다.
);

-- INSERT INTO 테이블명 (col명1 , col명2)
-- VALUES ( col명1 값, col명2 값)
INSERT INTO ex2_1 (col1, col2)
VALUES ('abcD', 'abcDEF');

-- SELECT 선택할 것, LENGTH(칼럼) AS 출력할곳 이름
SELECT 
    col1
  , LENGTH(col1) AS len1
  , col2
  , LENGTH(col2) AS len2
FROM ex2_1;

-- SELECT * FROM 은 모두 꺼내기
-- AS는 별명주기!
SELECT * FROM ex2_1;
SELECT col1, col2 FROM ex2_1;
SELECT col2, col1 FROM ex2_1;
SELECT col1 AS C1, col2 AS C2 FROM ex2_1;

SELECT '[' || col1 || ']'
      ,'[' || col2 || ']'
FROM ex2_1;

-- 지우기
DELETE FROM ex2_1;

-- COMMIT/ROLLBACK
COMMIT;

ROLLBACK;


---------------------------------------------------------------------------------------------------
-- table2 >> varchar2의 단위
CREATE TABLE ex2_2(
    -- varchar2, char, date 단위가 많이 쓰인다.
     col1 varchar2(3)   -- 디폴트 값인 byte 적용
    ,col2 varchar2(3 byte)
    ,col3 varchar2(3 char)
    -- char 단위를 거의 안쓰기 떄문에 쓰지마라..
);

INSERT INTO ex2_2 (col1, col2, col3)
VALUES('abc','abc','abc');

INSERT INTO ex2_2 (col1, col2, col3)
VALUES('이','이','이이이');

SELECT * FROM ex2_2;

SELECT col1
     , LENGTHB(col1) AS lenB1
     , col2
     , LENGTHB(col2) AS lenB2
     , col3
     , LENGTHB(col3) AS lenB3
FROM ex2_2;

-- 테이블은 데이터 조작어가 아니라서
-- 구조이기 때문에 커밋, 롤백과 관련이 없다?


-- table3 단위 number
CREATE TABLE ex2_3(
    col1 NUMBER(3)
   ,col2 NUMBER(3,2)
   -- 3자리수 들어가나 소수가 2자리 들어감
   ,col3 NUMBER(5,-2)
   -- -자리수를 하면 남들이 이해하기 어려울 수 있으니
   -- 메이저한 문법이 아니라면 주석을 남겨놓는게 좋다..
   
   -- 소수자리에 -숫자를 넣으면 정수에서 앞으로 간다.
   -- 즉 5,-2는 5자리를 출력하는데
   -- 소수자리와는 다르게 앞에서부터 세는 것이 아니라
   -- -숫자가 끝난 뒷자리부터 5자리이다.
);

INSERT INTO ex2_3 (col1) VALUES (0.7098);
INSERT INTO ex2_3 (col1) VALUES (0.4898);
INSERT INTO ex2_3 (col1) VALUES (999.5);            -- 오류
INSERT INTO ex2_3 (col1) VALUES (1004);             -- 오류
INSERT INTO ex2_3 (col2) VALUES (0.7098);
INSERT INTO ex2_3 (col2) VALUES (1.2345);
INSERT INTO ex2_3 (col2) VALUES (32);               -- 오류
INSERT INTO ex2_3 (col2) VALUES (9.99);
INSERT INTO ex2_3 (col2) VALUES (9.995);            -- 오류
INSERT INTO ex2_3 (col3) VALUES (12345.2345);
INSERT INTO ex2_3 (col3) VALUES (12367.2346);
INSERT INTO ex2_3 (col3) VALUES (2123057.2346);
INSERT INTO ex2_3 (col3) VALUES (22123057.2346);    -- 오류

SELECT * FROM ex2_3;


-- FROM dual
-- dual은 형식적인것!
-- 함수같은 것들, 계산식들 확인할 때, sysdate 확인할때 dual에 날려서 확인함
SELECT 10*30 FROM dual;
SELECT LENGTH('adfasdf') FROM dual;
-- sysdate >> 시스템 날짜
-- systimestamp >> 시간이 나옴....//
SELECT sysdate FROM dual;
SELECT systimestamp FROM dual;


-- 테이블 4 time
CREATE TABLE ex2_4(
     date_1 DATE
    ,date_2 TIMESTAMP
);

INSERT INTO ex2_4(date_1, date_2)
VALUES (sysdate, systimestamp);

SELECT * FROM ex2_4;

-- TO_CHAR로 형식을 줘서 리드한다.
SELECT TO_CHAR(date_1, 'yyyy-mm-dd HH24:mi:ss')
      ,date_2
FROM ex2_4;

SELECT
    sysdate
   ,TO_CHAR(sysdate, 'yyyymmdd')
   ,TO_CHAR(sysdate, 'yyyy-mm-dd')
   ,TO_CHAR(sysdate, 'yyyy/mm/dd')
FROM dual;


-- 테이블 5 null
CREATE TABLE ex2_5(
     col1 VARCHAR2(20)
    ,col2 VARCHAR2(20) NOT NULL
);

INSERT INTO ex2_5 (col1, col2) VALUES ('abc','abc');
INSERT INTO ex2_5 (col1) VALUES ('abc'); -- 오류! col2는 not null 이므로!
INSERT INTO ex2_5 (col2) VALUES ('abc');
INSERT INTO ex2_5 VALUES ('',''); -- 오류 >> why? Oracle에서는 ''을 null 취급한다..
                                  -- 다른 DB에서 ''을 null이 아니라고 취급하기도 한다.. 잘 구분!
INSERT INTO ex2_5 VALUES (' ',' ');
INSERT INTO ex2_5 VALUES ('  ','  ');
-- []대괄호를 넣고 싶을 때는 작은 따옴표
-- 그리고 열의 이름 앞뒤로 ||
SELECT '[' || col1 || ']', '[' || col2 || ']' FROM ex2_5;


-- 테이블 6 unique
-- unique는 데이터가 중복이 안되는 컬럼.. >> 중요!
-- Oracle에서 대소문자는 구분안하지만
-- 안의 데이터는 대소문자를 구분한다.
CREATE TABLE ex2_6(
     col1 VARCHAR2(28)
    ,col2 VARCHAR2(28) NOT NULL
    ,col3 VARCHAR2(28) UNIQUE
    -- unique 혹은 primary key 혹은 constraints 지정할 이름 unique(col2)
);

CREATE TABLE ex2_6_1(
     col1 VARCHAR2(28)
    ,col2 VARCHAR2(28)
    ,CONSTRAINTS uq_ex2_6_col2 UNIQUE(col2)
    -- 즉 CONSTRAINTS를 주면 제약 조건에 CONSTRAINT_NAME을 지정해준다.
);

INSERT INTO ex2_6 (col1,col2,col3)
VALUES ('abc','abc','abc');
INSERT INTO ex2_6 (col1,col2,col3)
VALUES ('abc','abc','abc');
INSERT INTO ex2_6 (col1,col2,col3)
VALUES ('ABC','ABC','ABC');
INSERT INTO ex2_6 (col1,col2,col3)
VALUES ('abc','abc','');
SELECT * FROM ex2_6;
-- null 값은 중복이 아니기 때문에 유니크가 먹는다..

COMMIT;












