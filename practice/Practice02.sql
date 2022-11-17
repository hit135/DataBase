-- 1. 고개명 고객번호, 담당직원명, 담당업무 출력
-- 조건에서 담당직원이 있는 고객만 출력

-- 이퀄조인
SELECT c.cname
     , c.telnum
     , e.ename
     , e.job
  FROM emp e
     , cust c
 WHERE e.empno = c.empno
 ORDER BY c.telnum;
 
-- INNER 조인으로..!
 SELECT c.cname
     , c.telnum
     , e.ename
     , e.job
  FROM emp e
 INNER JOIN cust c
    ON e.empno = c.empno
 ORDER BY c.telnum;
 
-- 2. 최고 연봉을 받는 직원 구하기

SELECT ename
     , sal
  FROM emp
 WHERE sal = (SELECT MAX(sal)
                FROM emp);
 
-- 3 부서별 사원수를 구하시오
-- 사원이 없는 부서 포함
-- 사원이 적은 부서부터 많은 부서 순으로 출력

SELECT d.dname
     , COUNT(e.deptno) emp_count
  FROM emp e
     , dept d
 WHERE e.deptno(+) = d.deptno
 GROUP BY d.dname
 ORDER BY emp_count;
 
-- 4 직원별 담당 고객수를 구하시오.(고객 수 내림차순)

SELECT e.ename
     , COUNT(c.empno) cust_count
  FROM emp e
     , cust c
 WHERE e.empno = c.empno(+)
 GROUP BY e.ename
 ORDER BY cust_count DESC
        , e.ename DESC;
        
-- 5. 평균 이상의 연봉을 받는 사람과 연봉을 구하시오

SELECT ename
     , sal
  FROM emp
 WHERE sal >= (SELECT AVG(sal)
                 FROM emp)
 ORDER BY sal;
 
-- 6. 부서별 총 연봉 합계를 구하세요 (직원이 없는 부서는 0원)

SELECT d.dname
     , NVL(SUM(e.sal),0) sum_sal
  FROM dept d
     , emp e
 WHERE d.deptno = e.deptno(+)
 GROUP BY d.dname
 ORDER BY sum_sal;
 
-- 7. 직급별 최고 연봉자와 평균 연봉을 구하시오
-- 컬럼 붙이기..

-- 첫번째 방법...!
-- 평균값을 어케 붙이지..
SELECT ename
     , job
     , MAX(sal) max_sal
  FROM emp a
 WHERE sal IN (SELECT MAX(sal)
                     FROM emp
                    GROUP BY job)
 GROUP BY job, ename
 ORDER BY max_sal;
 
-- 평균값을 셀렉트에 서브쿼리로 붙여보기!
SELECT ename
     , job
     , MAX(sal) max_sal
     , ROUND((SELECT AVG(b.sal)
                FROM emp b
               WHERE b.job = a.job
               GROUP BY b.job),0) AS avg_sal
  FROM emp a
 WHERE sal IN (SELECT MAX(sal)
                 FROM emp
                GROUP BY job)
 GROUP BY job, ename
 ORDER BY max_sal;

-- 두번째 방법...!
-- 이름을 어케 붙이징..
SELECT job
     , MAX(sal) max_sal
     , ROUND(AVG(sal)) avx_sal
  FROM emp
 GROUP BY job
 ORDER BY max_sal;

-- 이름을 따로 파자..!
-- 정답
SELECT a.ename
     , b.job
     , b.max_sal
     , b.avg_sal
  FROM emp a
     , (SELECT job
             , MAX(sal) max_sal
             , ROUND(AVG(sal)) avg_sal
          FROM emp
         GROUP BY job) b
 WHERE a.sal = b.max_sal
 ORDER BY b.max_sal;
 
-- 직업이 다른데 맥스 sal이 같을 수도 있으므로
-- 조건을 하나 더 준다
SELECT a.ename
     , b.job
     , b.max_sal
     , b.avg_sal
  FROM emp a
     , (SELECT job
             , MAX(sal) max_sal
             , ROUND(AVG(sal)) avg_sal
          FROM emp
         GROUP BY job) b
 WHERE a.sal = b.max_sal
   AND a.job = b.job
 ORDER BY b.max_sal;
 
 
-- 8. 연봉 상위 5명의 직원을 검색하시오
SELECT ename
     , sal
     , ROWNUM sal_no
  FROM (SELECT *
          FROM emp
         ORDER BY sal DESC)
 WHERE ROWNUM < 6;
-- 여기서 5명을 짜르면 된다..!

-- 9. 연봉 상위 3~5위 직원의 직원번호, 직원명, 연봉을 구하시오

SELECT a.empno
     , a.ename
     , a.sal
     , a.sal_no
  FROM (SELECT empno
             , ename
             , sal
             , ROWNUM sal_no
          FROM (SELECT *
                  FROM emp
                 ORDER BY sal DESC)
         ORDER BY sal DESC) a
 WHERE a.sal_no > 2
   AND a.sal_no < 6
 ORDER BY a.sal_no;

-- 흠..
-- 차이를 모르겠네
-- ROWNUM이 의사쿼리라 잡지 못한다면
-- 서브쿼리를 파서 뷰 형식으로 파서
-- 사용할 수 있다.

SELECT ename
     , sal
     , ROWNUM sal_no
  FROM (SELECT *
          FROM emp
         ORDER BY sal DESC)
 WHERE ROWNUM > 2
   AND ROWNUM < 6;
   

-- 10 부서별 사원수 및 고객수를 구하시오

SELECT d.dname
     , COUNT(DISTINCT e.empno) emp_count
     , COUNT(c.empno) cust_count
  FROM emp e
     , dept d
     , cust c
 WHERE e.deptno(+) = d.deptno
   AND e.empno = c.empno(+)
 GROUP BY d.dname
 ORDER BY emp_count DESC;









