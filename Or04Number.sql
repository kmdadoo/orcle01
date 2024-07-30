/*****************
파일명 : Or04Number.sql
숫자(수학) 관련 함수
설명 : 숫자데이터를 처리하기 위한 숫자관련 함수를 알아보자.
    테이블 생성시 number 타입으로 선언된 컬럼에 저장된 데이터를
    대상으로 한다.
*******************/
-- HR 계정으로 하기

-- 현재 접속한 계정에 생성된 테이블, 뷰를 보여준다.
SELECT * FROM tab;

/*
Dual 테이블
    : 하나의 행으로 결과를 출력하기 위해 제공되는 테이블로
    오라클에서 자동으로 생성되는 논리적 테이블이다.
    vachar2(1)로 정의된 dummy라는 단 하나의 컬럼으로 구성되어있다.
*/
SELECT * FROM dual;
SELECT 1+2 FROM dual;

/*
abs() : 절대값 구하기
*/
SELECT abs(12000) FROM dual;
SELECT abs(-9000) FROM dual;
SELECT abs(salary) "급여의 절대값" FROM employees;

/*
trunc() : 소수점을 특정자리수에서 잘라낼때 사용하는 함수
    형식 : trunc(컬럼 혹은 값, 소수 이하 자릿수)
        두번재 인자가
            양수일때 : 주어진 숫자만큼 소수점을 표현
            없을때 : 정수부만 표현. 즉 소수점 아래부분은 버려짐
            음수일때 : 정수부를 숫자만큼 자르고 나머지를 0으로 채움
*/
SELECT trunc(12345.12345, 2) FROM dual;
SELECT trunc(12345.12345) FROM dual;
SELECT trunc(12345.12345, -2) FROM dual;
-- 금액이라면 100단위이하 절삭과 같은 형태로 활용할 수 있다.

/*
시나리오] 사원테이블에서 영업사원이 1000불에 대한 커미션을 계산하여 
    급여에 합한 결과를 출력하는 쿼리문을 작성하시오.
    Ex) 급여 : 1000, 보너스율 : 0.1
        => 1000 + (1000*0.1) = 1100
*/
-- 1. 영업사원을 먼저 찾아 인출하시오.(영업사원은 job_id가 SA_XX로 되어있다.
SELECT * FROM employees WHERE job_id LIKE 'SA_%';
-- 영업사원은 커미션을 받기때문에 값이 저장되어있다.)
SELECT * FROM employees WHERE commission_pct IS NOT NULL;
-- 2. 커미션을 계산하여 이름(first_name)과 함께 출력한다.
SELECT first_name, salary, commission_pct, (salary + (salary*commission_pct))
    FROM employees WHERE job_id LIKE 'SA_%';
-- 3. 커미션을 소수점 1자리까지만으로 금액 계산하기
SELECT first_name, salary, trunc(commission_pct,1), 
        (salary + (salary*trunc(commission_pct,1)))
    FROM employees WHERE job_id LIKE 'SA_%';
-- 4. 계산식이 포함된 컬럼명을 별칭을 부여한다.
SELECT first_name, salary, trunc(commission_pct,1) comm_pct, 
        (salary + (salary*trunc(commission_pct,1))) AS TotalSalary
    FROM employees WHERE job_id LIKE 'SA_%';
-- 정렬이 이해가 안될때 하나더 
SELECT * FROM employees WHERE commission_pct IS NOT NULL order by commission_pct asc, first_name desc;
SELECT * FROM employees WHERE commission_pct IS NOT NULL order by trunc(commission_pct,1);
/*
소수점 관련함수
    ceil() : 소수점 이하를 무조건 올림처리
    floor() : 무조건 버림 처리
    round(값, 자리수) : 반올림 처리
        두번째 인자가
            있을때 : 숫자만큼 소수점이 표현되므로 그 다음수가 5이상이면 올림, 
            5미만이면 버림.
            없을때 : 소수점 첫번째자리가 5이상이면 올림, 5미만이면 버림.
*/
SELECT ceil(32.8) FROM dual;
SELECT ceil(32.2) FROM dual;

SELECT floor(32.8) FROM dual;
SELECT floor(32.2) FROM dual;

SELECT round(0.123), round(0.533) FROM dual;
-- 첫번째 항목 : 소수이하 6자리까지 표현하므로 7을 올림처리한다.
-- 두번째 항목 : 소수이하 4자리까지 표현하므로 1을 버림처리한다.
SELECT round(0.1234567, 6), round(2.345612, 4) FROM dual;

/*
mod() : 나머지를 구하는 함수
power() : 거듭제곱을 구하는 함수
sqrt() : 제곱근(루트)을 구하는 함수
*/
SELECT mod(99, 4) "99를 4로 나눈 나머지" FROM dual;
SELECT power(2,10) "2의 10승" FROM dual;
SELECT sqrt(49) "49의 제곱근" FROM dual;

/*
연습문제] 사원테이블에서 보너스율이 있는 사원만 인출한 후 보너스율을 
    소수점 1자리로 표현하시오. 보너스율로 오름차순으로 정렬.
    출력내용 : 이름, 성, 급여, 보너스율
*/
-- 1.커미션이 있는 사원만 인출
SELECT first_name, last_name, salary, commission_pct
    FROM employees
    WHERE commission_pct IS NOT NULL;
-- 2.소수점 처리하기 
SELECT first_name, last_name, salary, trunc(commission_pct, 1) "보너스율"
    FROM employees
    WHERE commission_pct IS NOT NULL
    ORDER BY 보너스율;
