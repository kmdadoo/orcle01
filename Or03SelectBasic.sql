/*****************
파일명 : Or03SelectBasic.sql
처음으로 실행에 보는 질의어(SQL문 혹은 Query문)
개발자들 사이에서는 '시퀄'이라고 표현하기도 합니다.
설명 : select, where 등 가장 기본적인 DML문 사용해보기
*******************/
-- HR 계정으로 하기
/*
SQL Developer 에서 주석 사용하기
    블럭 단위 주석 : 자바와 동일함
    라인 단위 주석 : -- 실행문장. 하이픈 2개를 연속으로 사용한다.
*/

-- select문 : 테이블에 저장된 레코드를 조회하는 SQL문으로 DQL문에 해당한다.
/*
형식] 
    select 컬럼1, 컬럼2, ... 또는*
        from 테이블명
        where 조건1 and 조건2 or 조건3
        order by 정렬할 컬럼 asc(오름차순), desc(내림차순);
*/
-- 사원테이블에 저장된 모든 레코드를 대상으로 모든 컬럼을 조회하기
-- (쿼리문은 대소문자를 구분하지 않는다.)
select * from employees;
SELECT * FROM EMPLOYEES;

/*
컬럼명을 지정해서 조회하고 싶은 컬럼만 조회하기
=> 사원번호, 이름, 이메일, 부서번호만 조회하시오.
*/
SELECT employee_id, first_name, last_name, email, department_id
    FROM employees;   -- 하나의 쿼리문이 끝날때 ;을 반드시 기술해야 한다.
    
-- 테이블의 구조와 컬럼별 자료형 및 크기를 출력한다.
-- 즉 테이블의 스키마를 알수 있다.
DESC employees;

-- as 는 생략할 수 있다.
SELECT employee_id  "사원아이디", first_name AS "이름", last_name "성"
    FROM employees WHERE first_name = 'William';

/*
오라클은 기본적으로 대소문자를 구분하지 않는다. 예약어의 경우 대소문자
구분없이 사용할 수 있다.
*/
SELect employee_id "사원아이디", first_name as "이름", last_name "성"
    FROM Employees WHERE first_name = 'William';

-- 단, 레코드인 경우 대소문자를 구분한다. 따라서 아래 SQL문을 실행하면
-- 아무런 결과도 나오지 않는다. 중요함.
SELECT employee_id "사원아이디", first_name as "이름", last_name "성"
    FROM Employees WHERE first_name = 'WILLIAM';

/*
where절을 이용해서 조건에 맞는 레코드 추출하기
-> last_name이 Smith인 레코드를 추출하시오.
*/
SELECT * FROM employees WHERE last_name = 'Smith';

/*
where절에 2개 이상의 조건이 필요할 때 and 혹은 or를 사용할 수 있다.
-> last_name이 Smith이면서 급여가 8000인 사원을 추출하시오.
*/
-- 컬럼이 문자형인 경우 싱글쿼테이션으로 감싼다. 숫자인 경우 생략한다.
SELECT * FROM employees WHERE last_name = 'Smith' and salary=8000;
-- 에러발생. 컬럼이 문자형인 경우 싱글쿼테이션이 없으면 에러가 발생한다.
SELECT * FROM employees WHERE last_name = Smith and salary=8000;
-- 컬럼이 숫자형일때는 생략이 기본이지만, 쓰더라도 에러가 발생하지 않는다.
SELECT * FROM employees WHERE last_name = 'Smith' and salary='8000';

/*
비교연산자를 통한 쿼리문 작성
    : 이상, 이하와 같은 조건에 >, <=와 같은 비교연산자를 사용할 수 있다.
    날짜인 경우 이전, 이후와 같은 조건도 가능 하다.
*/
-- 급여가 5000미만인 사원의 정보를 추출하시오.
SELECT * FROM employees WHERE salary < 5000;
-- 입사일이 04년 01월 01일 이후인 사원정보를 추출하시오.
SELECT * FROM employees WHERE hire_date >= '04/01/01';

/*
in 연산자
    : or 연산자와 같이 하나의 컬럼에 여러개의 값으로 조건을 걸고 싶을 때
    사용한다.
    => 급여가 4200, 6400, 8000인 사원의 정보를 추출하시오.
*/
-- 방법1 : or를 사용한다. 이때 컬럼명을 반복적으로 기술해야 하므로 불편하다.
SELECT * FROM employees WHERE salary=4200 or salary=6400 or salary=8000;
-- 방법2 : in을 사용하면 컬럼명은 한번만 기술하면 되므로 편리하다.
SELECT * FROM employees WHERE salary in(4200, 6400, 8000);

/*
not 연산자
    : 해당 조건이 아닌 레코드를 추출한다.
    -> 부서번호가 50이 아닌 사원정보를 조회하는 SQL문을 작성하시오.
*/
SELECT * FROM employees WHERE not (department_id = 50);
SELECT * FROM employees WHERE department_id <> 50;

/*
between and 연산자
    : 컬럼의 구간을 정해 검색할 때 사용한다.
    => 급여가 4000~8000사이의 사원을 인출하시오.
*/
-- 방법1
SELECT * FROM employees WHERE salary>=4000 and salary<=8000;
-- 방법2
SELECT * FROM employees WHERE salary BETWEEN 4000 AND 8000;

/*
distinct
    : 컬럼에서 중복되는 레코드를 제거할 때 사용한다.
    특정 조건으로 select했을 때 하나의 컬럼에서 중복되는 값이 있는 경우
    중복값을 제거한 후 결과를 출력할 수 있다.
    -- 담당업무 아이디를 중복을 제거한 후 출력하시오.
*/
-- 전체 사원에 대한 담당업무명이 인출됨.
SELECT job_id from employees;
SELECT DISTINCT job_id from employees;

/*
like 연산자
    : 특정 키워드를 통한 문자열을 검색할 때 사용한다.
    형식] 컬럼명 like '%검색어'
    와일드카드 사용법
        % : 모든 문자 혹은 문자열을 대체한다.
        Ex) D로 시작되는 단어 : D% => Da, Dea, Deawoo
            Z로 끝난 단어 : %Z => aZ, adxZ
            C가 포함된 단어 : %C% => aCd, abCde, Vitamin-C
        _ : 언더바는 하나의 문자를 대체한다.
        Ex) D로 시작하는 3글자 단어 : D__ -> Dad, Ddd, Dxy
            A가 중간에 들어가는 3글자의 단어 : _A_ -> aAa, xAy
*/
-- first_name이 'D'로 시작하는 직원을 검새하시오.
SELECT * FROM employees WHERE first_name like 'D%';
-- first_name 이 세번째문자가 a인 직원을 추출하시오.
SELECT * FROM employees WHERE first_name like '__a%';
-- last_name 에서 y로 끝나는 직원을 추출하시오.
SELECT * FROM employees WHERE last_name like '%y';
-- 전화번화에 1344가 포함된 직원 전체를 인출하시오.
SELECT * FROM employees WHERE phone_number like '%1344%';

/*
레코드 정렬하기(sorting)
    오름차순 정렬 : order by 컬럼명 asc (혹은 생략가능)
    내림차순 정렬 : order by 컬럼명 desc
    
    2개이상의 컬럼으로 정렬해야 할 경우 콤마로 구분해서 정렬한다.
    단, 이때 먼저 입력한 컬럼으로 정렬된 상태에서 두번째 컬럼이 정렬된다.
*/
/*
사원정보 테이블에서 급여가 낮은 순서에서 높은 순서로 인출되도록 정렬하여
조회하시오.
출력할 컬럼 : first_name, salary, email, phone_number
*/
SELECT first_name, salary, email, phone_number
    FROM employees
    ORDER BY salary asc;
SELECT first_name, salary, email, phone_number
    FROM employees
    ORDER BY salary;

/*
부서번호를 내림차순으로 정렬한 후 해당부서에서 낮은 급여를 받는 직원이 먼저
출력되도록 하는 SQL문은 작성하시오.
출력항목 : 사원번호, 이름, 성, 급여, 부서번호
*/
SELECT employee_id AS 사원번호, first_name 이름, last_name 성, salary 급여, department_id 부서번호
    FROM employees
    ORDER BY department_id desc, salary asc;

/*
is null 혹은 is not null
    : 값이 null이거나 null이 아닌 레코드 가져오기.
    컬럼중 null값을 허용하는 경우 값을 입력하지 않으면 null값이 
    되는데 이를 대상으로 select할 때 사용한다.
*/
-- 보너스율이 없는 사원을 조회하시오.
SELECT * FROM employees WHERE commission_pct IS NULL;
-- 영업사원이면서 급여가 8000이상인 사원을 조회하시오.
SELECT * FROM employees
    WHERE salary>=8000 and commission_pct IS NOT NULL;

/***********************
연습문제(scott계정에서 진행합니다.)
************************/
/*
1. 덧셈 연산자를 이용하여 모든 사원에 대해서 $300의 급여인상을 계산한후 
이름, 급여, 인상된 급여를 출력하시오.
*/
SELECT * FROM emp;
SELECT ename, sal, (sal+300) AS 인상된급여 FROM emp;

/*
2. 사원의 이름, 급여, 연봉을 수입이 많은것부터 작은순으로 출력하시오. 
연봉은 월급에 12를 곱한후 $100을 더해서 계산하시오.
*/
SELECT ename, sal, (sal*12+100) "연봉" FROM emp;
-- 정렬시 물리적으로 존재하는 컬럼명을 사용하는게 기본이다.
SELECT ename, sal, (sal*12+100) "연봉" FROM emp
    ORDER BY sal desc;
-- 물리적으로 존재하지 않은 컬럼이라면 계산식 그대로를 order by절에 기술한다.
SELECT ename, sal, (sal*12+100) "연봉" FROM emp
    ORDER BY (sal*12+100) desc;
SELECT ename, sal, (sal*12+100) "연봉" FROM emp
    ORDER BY 연봉 desc;
    
/*
3. 급여가  2000을 넘는 사원의 이름과 급여를 내림차순으로 정렬하여 출력하시오
*/
SELECT ename, sal FROM emp
    WHERE sal > 2000
    ORDER BY ename desc, sal desc;

/*
4. 사원번호가  7782인 사원의 이름과 부서번호를 출력하시오.
*/
SELECT ename, deptno FROM emp
    WHERE empno = 7782;

/*
5. 급여가 2000에서 3000사이에 포함되지 않는 사원의 이름과 급여를 출력하시오.
*/
SELECT ename, sal FROM emp
    WHERE NOT (sal >= 2000 AND sal <= 3000);
SELECT ename, sal FROM emp
    WHERE NOT (sal BETWEEN 2000 and 3000);

/*
6. 입사일이 81년2월20일 부터 81년5월1일 사이인 사원의 이름, 
담당업무, 입사일을 출력하시오.
*/
SELECT ename, job, hiredate FROM emp
    WHERE hiredate >= '81/02/20' AND hiredate <= '81/05/01';
SELECT ename, job, hiredate FROM emp
    WHERE hiredate BETWEEN '81/02/20' AND '81/05/01';

/*
7. 부서번호가 20 및 30에 속한 사원의 이름과 부서번호를 출력하되 이름을 
기준(내림차순)으로 출력하시오
*/
SELECT ename, deptno FROM emp
    WHERE deptno=20 OR deptno=30
    ORDER BY ename DESC;
SELECT ename, deptno FROM emp
    WHERE deptno IN(20, 30)
    ORDER BY ename DESC;

/*
8. 사원의 급여가 2000에서 3000사이에 포함되고 부서번호가 20 또는 30인 
사원의 이름, 급여와 부서번호를 출력하되 이름순(오름차순)으로 출력하시오
단, 비교연산자 사용 금지
*/
SELECT ename, sal, deptno FROM emp
    WHERE (sal BETWEEN 2000 AND 3000) AND deptno IN(20, 30)
    ORDER BY ename ASC;

/*
9. 1981년도에 입사한 사원의 이름과 입사일을 출력하시오. (like 연산자와 와일드카드 사용)
*/ 




