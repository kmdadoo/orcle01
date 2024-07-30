/*****************
파일명 : Or12SubQuery.sql
서브쿼리
설명 : 쿼리문 안에 또 다른 쿼리문이 들어가는 형태의 select문
    where구에 select문을 사용하면 서브쿼리라고 한다.
*******************/
-- HR 계정으로 하기

/*
단일행 서브쿼리
    단 하나의 행만 반환하는 서브쿼리로 비교연산자(=, <, <=, >, >=, <>)를 
    사용한다.
    형식] 
        select * from 테이블명 where 컬럼=(
            select 컬럼 from 테이블명 where 조건
        );
    * 괄호안의 서브쿼리는 반드시 하나의 결과를 인출해야 한다.
*/
/*
시나리오] 사원테이블에서 전체사원의 평균급여보다 낮은 급여를 받는 사원들을
    추출하여 출력하시오.
    출력항목 : 사원번호, 이름, 이메일, 연락처, 급여
*/
-- 1.평균 급여 구하기 : 6462
SELECT avg(salary) FROM employees;
-- 2.해당 쿼리문은 문맥상 맞는 듯하지만 그룹함수를 단일행에 적용한 
-- 잘못된 쿼리문이다. 오류가 발생한다.
SELECT * FROM employees WHERE salary < avg(salary);
-- 3.앞에서 구한 평균 급여를 조건으로 select문을 작성하시오.
SELECT * FROM employees WHERE salary < 6462;
-- 4.2개의 쿼리문을 하나의 서브쿼리문으로 합쳐서 결과를 확인한다.
SELECT employee_id, first_name, email, phone_number, salary
 FROM employees
 WHERE salary < (SELECT avg(salary) FROM employees)
 ORDER BY salary;
 
 /*
퀴즈] 전체 사원중 급여가 가장작은 사원의 이름과 급여를 출력하는 
    서브쿼리문을 작성하시오.
    출력항목 : 이름1, 이름2, 이메일, 급여
*/
-- 1단계 : 최소급여를 확인한다.
SELECT min(salary) FROM employees;
-- 2단계 : 2100을 받는 직원의 정보를 인출하시오.
SELECT * FROM employees WHERE salary=2100;
-- 3단계 : 2개의 쿼리를 합쳐서 서브쿼리를 만든다.
SELECT first_name, last_name, email, salary
 FROM employees
 WHERE salary=(SELECT min(salary) FROM employees);
 
/*
시나리오] 평균급여가 많은 급여를 받는 사원들의 명단을 조회할 수 있는
    서브쿼리문을 작성하시오.
    출력내용 : 이름1, 이름2, 담당업무명, 급여
    * 담당업무명은 jobs 테이블에 있으므로 join 해야 한다. using 사용
*/
-- 1단계 : 평균급여 환산하기
SELECT round(avg(salary)) FROM employees;
-- 2단계 : 테이블 조인
SELECT 
    first_name, last_name, job_title, salary
 FROM employees INNER JOIN jobs USING(job_id)
 WHERE salary > 6462;
-- 3단계 : 서브쿼리문으로 병합
SELECT 
    first_name, last_name, job_title, salary
 FROM employees INNER JOIN jobs USING(job_id)
 WHERE salary > (SELECT round(avg(salary)) FROM employees)
 ORDER BY salary DESC;
 
/*
복수형 서브쿼리 : 다중행 서브쿼리라고도 하고 여러개의 행을 반환
    하는 것으로 in, any, all, exists를 사용해야 한다.
    형식] select * from 테이블명 where 컬럼 in (
                select 컬럼 from 테이블명 where 조건
            );
    * 괄호안의 서브쿼리는 2개 이상의 결과를 인출해야 한다.
*/
/*
시나리오] 담당업무별로 가장 높은 급여를 받는 사원의 명단을 조회하시오.
    출력목록 : 사원아이디, 이름, 담당 업무 아이디, 급여
*/
-- 1단계 : 담당업무별 가장 높은 급여를 확인한다.
SELECT job_id, max(salary) FROM employees GROUP BY job_id;
-- 2단계 : 위의 결과를 단순한 or 조건으로 묶어본다.
SELECT * FROM employees
 WHERE
    (job_id='AD_VP' AND salary=17000) or
    (job_id='PU_CLERK' AND salary=3100) or
    (job_id='ST_MAN' AND salary=8200) or
    (job_id='MK_REP' AND salary=6000);
-- 3단계 : 복수형 연산자를 통해 서브쿼리로 병합한다.
SELECT employee_id, first_name, job_id, salary
 FROM employees 
 WHERE (job_id, salary) 
    IN (SELECT job_id, max(salary) FROM employees GROUP BY job_id)
 ORDER BY salary DESC;

/*
복수행 연산자 : any(어떤것이라도_의 개념은 or와 비슷하다.
    메인쿼리의 비교조건이 서브쿼리의 검색결과와 하나이상
    일치하면 참이되는 연산자. 즉 둘 중 하나만 만족하면 해당 레코드를
    인출한다.
*/
/*
시나리오] 전체 사원중에서 부서번호가 20인 사원들의 급여보다 높은 급여를 
    받는 직원들을 인출하는 서브쿼리문을 작성하시오. 단 둘 중 하나만 
    만족하더라도 인출하시오.
*/
-- 1단계 : 20부서 부터 급여를 확인한다.
SELECT first_name, salary FROM employees WHERE department_id = 20;
-- 2단계 : 1번의 결과를 단순한 or절로 작성해본다.
SELECT first_name, salary FROM employees
 WHERE salary>13000 OR salary>6000;
-- 3단계 : 둘중 하나만 만족하면 되므로 복수행연산자 any를 이용해서 서브쿼리를
-- 만들면 된다. 즉 6000보다 크고 또는 13000보다 큰 조건으로 생성된다.
SELECT first_name, salary FROM employees
 WHERE salary>any(
    SELECT salary FROM employees WHERE department_id = 20)
 ORDER BY salary DESC;
/*
    결과적으로 6000보다 크면 조건에 만족한다. 결과 : 55명
*/

/*
복수행 연산자3 : all은 and의 개념과 유사하다.
    메인쿼리는 비교조건이 서브쿼리의 검색결과와 모두 일치해야
    레코드를 인출한다.
*/
/*
시나리오] 전체 사원중에서 부서번호가 20인 사원들의 급여보다 높은 급여를 
    받는 직원들을 인출하는 서브쿼리문을 작성하시오. 단 둘다 만족하는 
    레코드만 인출하시오.
*/
SELECT first_name, salary FROM employees
 WHERE salary>all(
    SELECT salary FROM employees WHERE department_id = 20)
 ORDER BY salary DESC;
/*
    6000이상이고 동시에 13000보다 커야하므로 결과적으로 13000이상인
    레코드만 인출하게 된다. 결과 : 5명
*/

/*
rownum : 테이블에서 레코드를 조회한 순서대로 순번이 부여되는 가상의
    컬럼을 말한다. 해당 컬럼은 모든 테이블에 논리적으로 존재한다.
*/
-- 모든 계정에 논리적으로 존재하는 테이블
SELECT * FROM dual;
-- 레코드의 정렬없이 모든 레코드를 가져와서 rownum으로 부여한다.
-- 이경우 rownum은 순서대로 출력된다.
SELECT employee_id, first_name, ROWNUM FROM employees;
-- 이름의 오름차순으로 정렬하면 rownum이 섞여서 이상하게 나온다.
SELECT employee_id, first_name, ROWNUM FROM employees
    ORDER BY first_name;

/*
rownum을 우리가 정렬한 순서대로 재부여하기 위해 서브쿼리를 사용한다.
from절에는 테이블이 들어와야 하는데, 아래의 서브쿼리에서는 사원테이블의
전체 레코드를 대상으로 하되 이름의 오름차순으로 정렬된 상태로 레코드를
가져와서 테이블처럼 사용한다.
*/
SELECT first_name, rownum 
 FROM (SELECT * FROM employees ORDER BY first_name asc);

--------------------------------------------------------
--------------- Sub Query 연 습 문 제 ------------------ 
--------------------------------------------------------
-- scott계정에서 진행합니다. 

/*
01.사원번호가 7782인 사원과 담당 업무가 같은 사원을 표시하시오.
출력 : 사원이름, 담당 업무
*/
-- 1단계 7782사원의 담당업무 확인
SELECT * FROM emp WHERE empno=7782;
-- 2단계 MANAGER 업무인 사람 확인
SELECT ename, job FROM emp WHERE job='MANAGER';
-- 3단계 병합
SELECT ename, job FROM emp WHERE job=(SELECT job FROM emp WHERE empno=7782);

/*
02.사원번호가 7499인 사원보다 급여가 많은 사원을 표시하시오.
출력 : 사원이름, 급여, 담당업무
*/
-- 1단계 7499의 급여 확인
SELECT sal FROM emp WHERE empno=7499;
-- 2단계
SELECT ename, sal, job FROM emp WHERE sal > 1600;
-- 3단계
SELECT ename, sal, job FROM emp 
 WHERE sal > (SELECT sal FROM emp WHERE empno=7499)
 ORDER BY sal DESC;

/*
03.최소 급여를 받는 사원번호, 이름, 담당 업무 및 급여를 표시하시오.
(그룹함수 사용), 그룹하는 것 아님.
*/
SELECT min(sal) FROM emp;
SELECT empno, ename, job, sal FROM emp WHERE sal=800;
SELECT empno, ename, job, sal FROM emp WHERE sal=(SELECT min(sal) FROM emp);

/*
04.평균 급여가 가장 적은 직급(job)과 평균 급여를 표시하시오.
*/
--직급별 평균급여 인출(job을 그룹으로 사용하므로 select절에 기술할수있다)
SELECT job, avg(sal) FROM emp GROUP BY job;
--에러발생. 그룹함수를 2개 겹쳤기 때문에 job컬럼을 제외해야한다.
--(평균급여 중 최소값을 찾아 인출하므로 job컬럼은 단일컬럼이 되므로 
--select절에서 제외해야 한다.)
SELECT job, min(avg(sal)) FROM emp GROUP BY job; -- 에러
--정상실행. 직급중 평균급여가 최소인 레코드 인출
SELECT min(avg(sal)) FROM emp GROUP BY job;
/*
평균급여는 물리적으로 존재하는 컬럼이 아니므로 where절에는 사용할수없고
having절에 사용해야 한다. 즉, 평균급여가 1017인 직급을 출력하는 방식으로
서브쿼리를 작성해야 한다. 
*/
SELECT job, round(avg(sal)) FROM emp 
 GROUP BY job
 HAVING avg(sal)=(SELECT min(avg(sal)) FROM emp GROUP BY job);

/*
05.각 부서의 최소 급여를 받는 사원의 이름, 급여, 부서번호를 표시하시오.
*/
--단순 정렬을 통해 부서별 급여 확인
SELECT deptno, sal FROM emp ORDER BY deptno, sal;
--그룹함수를 통해 부서별 최소급여 확인
SELECT deptno, min(sal) FROM emp GROUP BY deptno;
--단순 or절을 통한 인출
SELECT ename, sal, deptno FROM emp
 WHERE (deptno=20 and sal=800) OR
    (deptno=30 and sal=950) OR
    (deptno=10 and sal=1300);
--서브쿼리의 복수행 연산자를 통해 쿼리 작성   
SELECT ename, sal, deptno FROM emp
 WHERE (deptno, sal) 
    IN (SELECT deptno, min(sal) FROM emp GROUP BY deptno)
 ORDER BY sal DESC;

/*
06.담당 업무가 분석가(ANALYST)인 사원보다 급여가 적으면서 
업무가 분석가(ANALYST)가 아닌 사원들을 표시(사원번호, 이름, 담당업무, 급여)
하시오.
*/
SELECT sal FROM emp WHERE job='ANALYST'; --급여가 3000인것을 확인.
SELECT empno, ename, job, sal 
 FROM emp
 WHERE sal <3000 AND job <> 'ANALYST';
/*
ANALYST 업무를 통한 결과가 1개이므로 아래와 같이 단일행 연산자로 서브쿼리를
만들수 있지만, 만약 결과가 2개이상이라면 복수행 연산자 all 혹은 any를 
추가해야한다. 
*/
SELECT empno, ename, job, sal 
 FROM emp
 WHERE sal < (SELECT sal FROM emp WHERE job='ANALYST')AND job <> 'ANALYST'
 ORDER BY sal DESC;

/*
Ex) 만약 담당업무가 CLERK로 주어졌다면 쿼리는 아래와 같이 해야한다. 
*/
SELECT sal FROM emp WHERE job='CLERK'; --3개의 결과가 인출된다.
SELECT empno, ename, job, sal 
 FROM emp
 WHERE job <> 'ANALYST' 
    AND (sal <800 or sal < 950 or sal < 1300) ;
--복수행이 되므로 any혹은 all을 사용해야 한다. 
SELECT empno, ename, job, sal 
 FROM emp
 WHERE job <> 'ANALYST' 
    AND sal < any(SELECT sal FROM emp WHERE job='CLERK');





