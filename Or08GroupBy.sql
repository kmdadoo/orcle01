/*****************
파일명 : Or08GroupBy.sql
그룹함수(select문 두번째)
설명 : 전체 레코드(row)에서 통계적인 결과는 구하기
    위해 하나 이상의 레코드를 그룹으로 묶어서 연산 후
    결과를 반환하는 함수 혹은 쿼리문
*******************/
-- HR 계정으로 하기

-- 사원테이블에서 담당업무 인출 : 총 107개가 인출 됨.
SELECT job_id FROM employees;

/*
distinct
    - 동일한 값이 있는 경우 중복된 레코드를 제거한 후 하나의 레코드만
    가져와서 보여준다.
    - 하나의 순수한 레코드이므로 통계적인 값을 계산할 수 없다.
*/
SELECT DISTINCT job_id FROM employees;

/*
group by 
    - 동일한 값이 있는 레코드를 하나의 그룹으로 묶어서 가져온다.
    - 보여지는건 하나의 레코드지만 다수의 레코드가 하나의 그룹으로 묶어진
    결과이므로 통계적인 값을 계산할 수 있다.
    - 최대, 최소, 평균, 합산 등의 연산이 가능하다.
*/
-- 각 담당업무별 직원수가 몇명인지 카운트 한다.
SELECT job_id, count(*) FROM employees GROUP BY job_id;

-- 검증을 위해 해당 업무를 통해 select 해서 인출되는 행의 개수와 비교해 본다.
SELECT first_name, job_id FROM employees WHERE job_id='FI_ACCOUNT';
SELECT first_name, job_id FROM employees WHERE job_id='ST_CLERK';

/*
group 절이 포함된 select문의 형식
    select
        컬럼1, 컬럼2,.......컬럼N 혹은 *(전체)
    from
        테이블명
    where 
        조건1 and 조건2 or 조건N....
    group by
        데이터 그룹화를 위한 컬럼명
    having
        그룹에서 찾을 조건
    order by
        데이터 정렬을 위한 컬럼과 정렬방식(asc 혹은 desc)
    ※ 쿼리의 실행순서
        from(테이블) -> where(조건) -> group by(그룹화) -> having(그룹조건) 
            -> select(컬럼지정) -> order by(정렬방식)
*/
/*
sum() : 합계를 구할 때 사용하는 함수
    - number 타입의 컬럼에서만 사용할 수 있다.
    - 필드명이 필요한 경우 as를 이용해서 별칭을 부여할 수 있다.
*/
-- 전체 직원의 급여의 합계를 출력하시오.
SELECT
    sum(salary) sumSalary1,
    to_char(sum(salary), '999,000') sumSalary2,
    ltrim(to_char(sum(salary), '$999,000')) sumSalary3,
    ltrim(to_char(sum(salary), 'L999,000')) sumSalary4
 FROM employees;

-- 10번 부서에 근무하는 사원들의 급여의 합계는 얼마인지 출력하시요.
SELECT
    sum(salary) "급여합계",
    to_char(sum(salary), '999,000') "세자리 컴머",
    ltrim(to_char(sum(salary), '999,000')) "좌측공백제거",
    ltrim(to_char(sum(salary), '$999,000')) "통화기호 삽입"
 FROM employees
 where department_id=10;

-- sum() 과 같은 그룹함수는 number타입인 컬럼에서만 사용할 수 있다.
SELECT sum(first_name) FROM employees; -- 에러 발생

/*
count() : 그릅화된 레코드의 개수를 카운트할 때 사용하는 함수.
*/
SELECT count(*) FROM employees;
SELECT count(employee_id) FROM employees;
/*
    count() 함수를 사용할 때는 위 2가지 방법 모드 가능하지만 *를
    사용할 것을 권장한다. 컬럼의 특성 혹은 데이터에 따른 방해를 
    받지 않으므로 실행속도가 빠르다.
*/
/*
count() 함수의
    사용법 1 : count(all 컬럼명)
        => 디폴트 사용법으로 컬럼 전체의 레코드를 기준으로 카운트 한다.
    사용법 2 : count(distinct 컬럼명)
        => 중복을 제거한 상태에서 카운트 한다.
*/
SELECT
    count(job_id) "담당업무 전체 갯수1",
    count(all job_id) "담당업무 전체 갯수2",
    count(distinct job_id) "담당업무 전체 갯수3"
 FROM employees;

/*
avg() : 평균값을 구할 때 사용하는 함수
*/
-- 전체 사원의 평균 급여는 얼마인지 출력하는 쿼리문을 작성하시오.
SELECT
    count(*) "전체직원수",
    sum(salary) "사원급여의 합",
    sum(salary) / count(*) "평균급여(직접계산)",
    avg(salary) "평균급여(avg() 함수)",
    trim(to_char(avg(salary), '$999,000')) "서식 및 공백 제거"
 FROM employees;

-- 영업팀(SALES)의 평균급여는 얼마인가요?
-- 1. 부서테이블의 영업팀의 부서번호가 무엇인지 확인한다.
/*
정보검색시 대소문자 혹은 공백이 포함된 경우 모든 레코드에 대해
문자열을 확인하는 것은 불가능하므로 일괄적인 규칙의 적용을 위해
upper()와 같은 변환함수를 사용하여 검색하는 것이 좋다.
*/
SELECT * FROM departments WHERE department_name=initcap('sales');
SELECT * FROM departments WHERE lower(department_name)='sales';
SELECT * FROM departments WHERE upper(department_name)=upper('sales');

-- 부서번호가 80인 것을 확인한 후 다음 쿼리문을 작성한다.
SELECT ltrim(to_char(avg(salary), '$999,000.00'))
 FROM employees WHERE department_id=80;

/*
min(), max() 함수 : 최대값, 최소값을 찾을 때 사용하는 함수
*/
-- 전체 사원중 가장 낮은 급여는 얼마인가요?
SELECT min(salary) FROM employees;

-- 전체 사원중 급여가 가장 낮은 직원은 누구인가요?
-- 아래쿼리문은 에러발생됨. 그룹함수는 일반컬럼에 사용할 수 없다.
SELECT first_name, salary FROM employees WHERE salary=min(salary);

-- 사원테이블에서 가장 낮은 급여인 2100을 받는 사원을 인출한다.
SELECT first_name, salary FROM employees WHERE salary=2100;

/*
    사원중 가장 낮은 급여는 min()으로 구할 수 있으나 가장 낮은 급여를 
    받는 사람은 아래와 같이 서브쿼리를 통해 구할 수 있다.
    따라서 문제에 따라 서브쿼리를 사용할지 여부를 결정해야한다.
*/
SELECT first_name, salary 
 FROM employees 
 WHERE salary=(SELECT min(salary) FROM employees);

/*
group by 절 : 여러개의 레코드를 하나의 그룹으로 그룹화하여 묶여진
    결과를 반환하는 쿼리문
    * distinct는 단순히 중복값을 제거함.
*/
-- 사원테이블에서 각 부서별 급여의 합계는 얼마인가요?
-- IT 부서의 급여 합계
SELECT sum(salary) FROM employees WHERE department_id=60;

-- Finance부서의 급여 합계
SELECT sum(salary) FROM employees WHERE department_id=100;

/*
step1 : 부서가 많은 경우 일일이 부서별로 확인할 수 없으므로 부서를 
    그룹화 한다. 중복이 제거된 결과로 보이지만 동일한 레코드가 하나의
    그룹으로 합쳐진 결과가 인출된다.
*/
SELECT department_id FROM employees GROUP BY department_id;

/*
step 2 : 각 부서별로 급여의 합계를 구할 수 있다. 4자리가 넘어가는 경우
    가독성이 떨어지므로 서식을 이용해서 세자리마다 콤마를 표시한다.
*/
SELECT department_id, sum(salary), trim(to_char(sum(salary), '999,000'))
 FROM employees
 GROUP BY department_id
 ORDER BY sum(salary) desc;

/*
퀴즈] 사원테이블에서 각 부서별 사원수와 평균 급여는 얼마인지 출력하는
    쿼리문을 작성하시오.
    출력결과 : 부서번호, 급여총합, 사원수, 평균급여
    출력시 부서번호를 기준으로 오름차순 정렬하시오.
*/
-- 기본형
SELECT
    department_id, sum(salary), count(*), avg(salary)
 FROM employees
 GROUP BY department_id
 ORDER BY department_id asc;

 -- 서식과 소수점 처리
SELECT
    department_id 부서번호, 
    rtrim(to_char(sum(salary), '999,000')) 급여총합, 
    count(*) 사원수, 
    rtrim(to_char(avg(salary), '999,000')) 평균급여
 FROM employees
 GROUP BY department_id
 ORDER BY department_id asc;

 /*
 앞에서 사용했던 쿼리문을 아래와 같이 수정하면 에러가 발생한다.
 group by 절에서 사용한 컬럼은 select절에서 사용할 수 있으나, 그외의
 단일 컬럼은 select절에서 사용할 수 없다.
 그룹화된 상태에서 특정 레코드 하나만 선택하는 것은 애매하기 때문이다.
 */
SELECT
    department_id, sum(salary), count(*), avg(salary), first_name
 FROM employees
 GROUP BY department_id;

 /*
 시나리오] 부서아이디가 50인 사원들의 직원총합, 평균 급여, 급여총합이
    얼마인지 출력하는 쿼리문을 작성하시오.
 */
 SELECT 
    '50번부서', 
    count(*) 직원총합, 
    rtrim(to_char(round(avg(salary)), '$9,000')) 평균급여, 
    rtrim(to_char(sum(salary), '$999,000')) 급여총합
 FROM employees 
 WHERE department_id=50
 GROUP BY department_id;
 
  /*
 having 절 : 물리적으로 존재하는 컬럼이 아닌 그룹함수를 통해 논리적으로
    생성된 컬럼의 조건을 추가할 때 사용한다.
    해당 조건을 where절에 추가하면 에러가 발생한다.
 */
  /*
 시나리오] 사원테이블에서 각 부서별로 근무하고 있는 직원의 담당업무별
    사원수와 평균급여가 얼마인지 출력하는 쿼리문을 작성하시오.
    단, 사원수가 10을 초과하는 레코드만 인출하시오.
 */
  /*
 같은 부서에 근무하더라도 담당업무는 다를수 있으므로 이 문제에서는
 group by 절에 2개의 컬럼을 명시해야 한다. 즉 부서로 그룹화 한 후
 다시 담당업무별로 그룹화한다.
 */
 SELECT 
    department_id, job_id, count(*), avg(salary)
 FROM employees
 WHERE count(*)>10 -- 여기서 에러 발생
 GROUP BY department_id, job_id;
 
  /*
    담당업무별 사원수는 물리적으로 존재하는 컬럼이 아니므로
    where절에 쓰면 에러가 발생한다. 이런 경우에는 having절에 조건을
    추가해야 한다.
    Ex) 급여가  3000인 사원 => 물리적으로 존재하므로 where절 사용
        평균 급여가 3000인 사원 => 논리적으로 존재하므로 having절 사용
                                    즉, 그룹함수를 통해 구할 수 있는 데이터임.
 */
SELECT 
    department_id, job_id, count(*), avg(salary)
 FROM employees
 GROUP BY department_id, job_id
 HAVING count(*)>10; -- 그릅의 조건은 having절에 기술한다.

/*
퀴즈] 담당업무별 사원의 최저급여를 출력하시오.
    단, (관리자(manager)가 없는 사원과 최저급여가 3000미만인 그룹)은 
    제외시키고, 결과를 급여의 내림차순으로 정렬하여 출력하시오.
*/
SELECT
    job_id, min(salary)
 FROM employees
 WHERE manager_id is not null
 GROUP BY job_id
 HAVING not (min(salary) < 3000)
 ORDER BY min(salary) desc;
/*
    문제에서는 급여의 내림차순으로 정렬하라는 지시사항이 있으나,
    현재 select되는 항목이 급여의 최소값이므로 order by 절에는
    min(salary)를 사용해야 한다.
*/

/*******************************************
연습문제
*******************************************/
--#해당 문제는 hr계정의 employees 테이블을 사용합니다.

/*
1. 전체 사원의 급여최고액, 최저액, 평균급여를 출력하시오. 컬럼의 별칭은 
아래와 같이 하고, 평균에 대해서는 정수형태로 반올림 하시오.(to_char 사용)
별칭) 급여최고액 -> MaxPay
급여최저액 -> MinPay
급여평균 -> AvgPay
*/
--round(), to_char() : 반올림 처리 되어 출력됨
--trunc() : 소수 이하를 잘라서 출력됨. 반올림되지 않음.
SELECT
    max(salary) MaxPay, min(salary) MinPay,
    to_char(round(avg(salary)), '$999,000') AvgPay
 FROM employees;

/*
2. 각 담당업무 유형별로 급여최고액, 최저액, 총액 및 평균액을 출력하시오. 
컬럼의 별칭은 아래와 같이하고 모든 숫자는 to_char를 이용하여 세자리마다 
컴마를 찍고 정수형태로 출력하시오.
별칭) 급여최고액 -> MaxPay
급여최저액 -> MinPay
급여평균 -> AvgPay
급여총액 -> SumPay
참고) employees 테이블의 job_id컬럼을 기준으로 한다.
*/
SELECT
    job_id,
    to_char(max(salary), '$999,000') MaxPay,
    to_char(min(salary), '$999,000') MinPay,
    to_char(sum(salary), '$999,000') SumPay,
    to_char(avg(salary), '$999,000') AvgPay
 FROM employees
 GROUP BY job_id;
    
/*
3. count() 함수를 이용하여 담당업무가 동일한 사원수를 출력하시오.
참고) employees 테이블의 job_id컬럼을 기준으로 한다.
*/
--물리적으로 존재하는 컬럼이 아니라면 함수 혹은 수식을 그대로 order by절에
--기술하면된다.
--수식이 너무 길다면 별칭을 기술해도 된다. 
SELECT
    job_id, count(*) 사원수
 FROM employees
 GROUP BY job_id
 ORDER BY count(*) desc;
 
 
 
-- SELECT문의 실행 순서는 FROM, WHERE, GROUP BY, HAVING, SELECT, ORDER BY 
-- 순으로 실행된다.(중요)







