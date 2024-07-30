/*****************
파일명 : Or16View.sql
View (뷰)
설명 : View는 테이블로부터 생성된 가상의 테이블로 물리적으로는 존재하지 
    않고 논리적으로 존재하는 테이블이다.
*******************/
-- hr 계정으로 하기

/*
뷰의 생성
형식]
    create[or replace] view 뷰이름[(컬럼1, 컬럼2,...)]
    as
    select * from 테이블명 where 조건
        혹은 join 문도 가능함.
*/
/*
시나리오] hr계정의 사원테이블에서 담당업무가 ST_CLERK인 사원 정보를
    조회할 수 있는 View를 생성하시오.
    출력항목 : 사원아이디, 이름, 직무 아이디, 입사일, 부서아이디
*/
-- 1.조건대로 select하기
SELECT
    employee_id, first_name, job_id, hire_date, department_id
 FROM employees
 WHERE job_id='ST_CLERK';   -- 20개 인출

-- 2.뷰 생성하기
CREATE VIEW view_employees
    AS
    SELECT
        employee_id, first_name, job_id, hire_date, department_id
     FROM employees
     WHERE job_id='ST_CLERK';
    
-- 3.뷰 실행하기 : select문을 실행한 것과 동일한 결과가 인출됩니다. 
SELECT * FROM view_employees;

-- 4.데이터 사전에서 뷰 확인하기
-- 생성시 사용한 쿼리문이 그대로 저장되는걸 알수 있다.
SELECT * FROm user_views;

/*
뷰 수정하기
    : 뷰 생성 문자에 or replace 만 추가하면 된다.
    해당 뷰가 존재하면 수정되고, 존재하지 않으면 새롭게 생성된다.
    따라서 처음 뷰를 생성할 때부터 사용해도 무방하다.
*/
/*
시나리오] 앞에서 생성한 뷰를 다음과 같이 수정하시오.
    기존컬럼인 employee_id, first_name, job_id, hire_date, department_id를
    id, fname, jobid, hdate, deptid로 수정하여 뷰를 생성하시오.
*/
CREATE OR REPLACE VIEW view_employees
    (id, fname, jobid, hdate, deptid)
    AS
    SELECT
        employee_id, first_name, job_id, hire_date, department_id
     FROM employees
     WHERE job_id='ST_CLERK';
SELECT * FROM view_employees;

/*
퀴즈] 위에서 생성한 view_employees 뷰를 아래 조건에 맞게 수정하시오.
    직무아이디 ST_MAN 인 사원의 사원번호, 이름, 이메일, 메니져아이디를
    조회할 수 있도록 수정하시오.
    뷰의 컬럼명은 e_id, name, email, m_id로 지정한다. 단, 이름은 
    first_name과 last_name이 연결된 형태로 출력하시오.
*/
--- 문제의 조건대로 select문작성
SELECT 
    employee_id, concat(first_name||' ', last_name), email, manager_id
 FROM employees WHERE job_id='ST_MAN';
-- 뷰 생성시 컬럼의 별칭을 부여한다.
CREATE OR REPLACE VIEW view_employees (e_id, name, email, m_id)
    AS
    SELECT 
        employee_id, concat(first_name||' ', last_name), email, manager_id
     FROM employees WHERE job_id='ST_MAN';
-- 뷰를 통해서 결과 확인
SELECT * FROM view_employees;

/*
퀴즈] 사원번호, 이름, 연봉을 계산하여 출력하는 뷰를 생성하시오.
    컬럼의 이름은 emp_id, l_name, annul_sal로 지정하시오.
    연봉계산식 -> (급여 + (급여*보너스율))*12
    뷰이름 : v_emp_salary
    단, 연봉은 세자리마다 컴마가 삽입되어야 한다.
*/
SELECT
    employee_id, last_name,
    rtrim(to_char((salary+(salary*nvl(commission_pct,0)))*12, '$999,000')) "연봉"
 FROM employees
 ORDER BY 연봉 DESC;
 
CREATE OR REPLACE VIEW v_emp_salary (emp_id, l_name, annul_sal)
    AS
    SELECT
        employee_id, last_name,
        rtrim(to_char((salary+(salary*nvl(commission_pct,0)))*12, '$999,000')) "연봉"
     FROM employees
     ORDER BY 연봉 DESC;
     
SELECT * FROM v_emp_salary;

/*
- 조인을 통한 View 생성
시나리오] 사원테이블과 부서테이블, 지역테이블을 INNER 조인하여 다음 조건에 맞는
    뷰를 생성하시오. USING 사용
    출력항목 : 사원번호, 전체이름, 부서번호, 부서명, 입사일자, 지역명
    뷰의 명칭 : v_emp_join
    뷰의 컬럼 : empid, fullname, deptid, deptname, hdate, locname
    컬럼의 출력형태 :
        fullname => first_name + last_name
        hdate => 0000년 00월 00일
        locname => XXX주의 YYY (ex: Texas주의 Southlake)
*/
-- 1.문제의 조건에 해당하는 select문 작성
SELECT
    employee_id, first_name||' ' ||last_name, department_id, department_name,
    to_char(hire_date, 'yyyy"년"mm"월"dd"일"'), 
    state_province||'주의 '||city
 FROM employees
    INNER JOIN departments USING(department_id)
    INNER JOIN locations USING(location_id);

-- 2. view 생성
CREATE OR REPLACE VIEW v_emp_join
    (empid, fullname, deptid, deptname, hdate, locname)
    AS
    SELECT
        employee_id, first_name||' ' ||last_name, department_id, department_name,
        to_char(hire_date, 'yyyy"년"mm"월"dd"일"'), 
        state_province||'주의 '||city AS "지역"
     FROM employees
        INNER JOIN departments USING(department_id)
        INNER JOIN locations USING(location_id)
    ORDER BY 지역;
-- 3. 복잡한 쿼리문을 view를 통해 간단히 조회할 수 있다. 
SELECT * FROM v_emp_join;



