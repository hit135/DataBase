--주석
/*
    주석영역
    테이블 스페이스 생성
*/

-- 테이블 스페이스 생성
CREATE TABLESPACE myts
datafile '/u01/app/oracle/oradata/XE/myts.dbf'
SIZE 100M autoextend on NEXT 5M;


-- 유저 생성
CREATE USER java IDENTIFIED BY oracle
default TABLESPACE myts
temporary tablespace temp;

--권한 부여
GRANT connect to java;
GRANT resource to java;

/* SQL (Structured Query Language) 구조화된 질의 언어
   데이터 정의어 (DDL, Data Definition Language)      CREATE, ALTER, DROP ...
   데이터 제어어 (DCL, Data Control Language)         REVOKE, GRANT
   데이터 조작어 (DML, Data Manipulation Language)    SELECT, INSERT, DELETE..
*/