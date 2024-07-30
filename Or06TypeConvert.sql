/*****************
파일명 : Or06TypeConvert.sql
형변환 함수 / 기타함수
설명 : 데이터 타입을 다른 타입으로 변환해야 할때 사용하는 함수와 기타함수
*******************/
-- HR 계정으로 하기

/*
sysdate : 현재날짜와 시간을 초단위로 반환해준다. 주로 게시판이나 
    회원가입에서 새로운 게시물이 있을 때 입력한 날짜를 표현하기 위해
    사용된다.
*/
SELECT sysdate FROM dual;

/*
날짜 포멧 : 오라클은 대소문자를 구분하지 않으므로, 서식문자 역시 구분하지 
    않는다. 따라서 mm과 MM은 동일한 결과를 출력한다.
*/
SELECT to_char(sysdate, 'yyyy/mm/dd') FROM dual;
SELECT to_char(sysdate, 'YY-MM-DD') FROM dual;

-- 현재 날짜를 "오늘은 0000년 00월 00일 입니다."와 같은 형태로 출력하시오. 안됨
SELECT to_char(sysdate, '오늘은 yyyy년 mm월 dd일 입니다') "과연될까" FROM dual;

/*
-(하이픈), /(슬러쉬) 외의 문자는 인식하지 못하므로 서식문자를 제외한
 나머지 문자열을 "(더블쿼테이션)으로 묶어줘야 한다. 서식문자를 감싸는게
  아님에 주의해야 한다.
*/
SELECT to_char(sysdate, '"오늘은 "yyyy"년 "mm"월 "dd"일 입니다"') "이젠된다" FROM dual;

-- 요일이나 년도를 표현하는 서식문자들
SELECT
    to_char(sysdate, 'day') "요일(금요일)",
    to_char(sysdate, 'dy') "요일(금)",
    to_char(sysdate, 'mon') "월(6월)",
    to_char(sysdate, 'mm') "월(06)",
    to_char(sysdate, 'month') "월",
    to_char(sysdate, 'yy') "두자리 년도",
    to_char(sysdate, 'dd') "일을 숫자로 표현",
    to_char(sysdate, 'ddd') "1년중 몇번째 일"
    FROM dual;

/*
시나리오] 사원테이블에서 사원의 입사일을 다음과 같이 출력할 수 있도록
    서식을 지정하여 쿼리문을 작성하시오.
    출력] 0000년 00월 00일 0요일
*/
SELECT first_name, last_name, hire_date,
    to_char(hire_date, 'yyyy"년 "mm"월 "dd"일 "dy"요일"') "입사일"
    FROM employees
    ORDER BY hire_date;

/*
시간 포멧 : 현재시간을 00:00:00 형태로 표시하기
    또는 날짜와 시간을 동시에 표현할 수도 있다.
*/
SELECT
    to_char(sysdate, 'HH:MI:SS'),
    to_char(sysdate, 'hh:mi:ss'),
    to_char(sysdate, 'hh24:mi:ss'),
    to_char(sysdate, 'yyyy-mm-dd HH24:MI:SS') "현재시간"
    FROM dual;

/*
숫자 포멧
    0 : 숫자의 자리수를 나타내며 자리수가 맞지 않는 경우 0으로 자리를 채운다.
    9 : 0과 동일하지만, 자리수가 맞지않는 경우 공백으로 채운다.
*/
SELECT
    12345,
    to_char(12345, '000,000'),
    to_char(12345, '999,999'),
    ltrim(to_char(12345, '999,999')),
    ltrim(to_char(12345, '999,000'))
    FROM dual;

-- 통화표시 : L => 각나라에 맞는 통화표시가 된다. 우리나라는 원으로 표시됨.
SELECT to_char(1000000, 'L9,999,000') FROM dual;

/*
숫자 변환 함수
    to_number() : 문자형 데이터를 숫자형으로 변환한다.
*/
-- 두개의 문자가 숫자로 변환되어 덧셈의 결과를 출력한다.
SELECT to_number('123') + to_number('456') FROM dual;
-- 숫자가 아닌 문자가 섞여있어 에러가 발생한다.
SELECT to_number('123a') + to_number('456') FROM dual;

/*
to_date()
    : 문자열 데이터를 날짜형식으로 변환해서 출력해준다. 기본서식은
    년/월/일 순으로 지정된다.
*/
SELECT 
    to_date('2024-06-20') "날짜 기본형식1",
    to_date('20240620') "날짜 기본형식2",
    to_date('2024/06/20') "날짜 기본형식3"
    FROM dual;

/*
날짜 포멧이 년-월-일 순이 아닌 경우에는 오라클이 인식하지 못하여 에러가
발생된다. 이때는 날짜서식을 이용해 오라클이 인식할 수 있도록 처리해야한다.
*/
SELECT to_date('20-06-2024') FROM dual; -- 에러

/*
퀴즈] '2024-06-20 13:49:30'와 같은 형태의 문자열을 날짜로 인식할수 
    있도록 쿼리문을 작성하시오.
*/
-- 날짜 서식을 인식하지 못하므로 에러가 발생한다.
SELECT to_date('2024-06-20 13:49:30') FROM dual;

-- 방법1 : 문자열을 잘라서 사용한다.
-- 문자열을 아래와 같이 수정한다면 날짜서식으로 인식할 수 있다.
SELECT to_date('2024-06-20') FROM dual;
-- substr() 함수로 문자영르 날자부분만 잘라서 to_date()의 인자로 사용한다.
SELECT substr('2024-06-20 13:49:30', 1, 10) "문자열 자르기", 
    to_date(substr('2024-06-20 13:49:30', 1, 10)) "날짜를 서식으로 변경"
    FROM dual;

-- 방법2 : 날짜와 시간 서식을 활용한다.
SELECT 
    to_date('2024-06-20 13:49:30', 'yyyy-mm-dd hh24:mi:ss') 
    FROM dual;

/*
퀴즈] 문자열 '2023/12/25'는 어떤 요일인지 변환함수를 통해 출력해보시오.
    단, 문자열은 임의로 변경할 수 없다.
*/
SELECT
    to_date('2023/12/25') " 1단계:날짜서식확인",
    to_char(sysdate, 'day') "2단계:요일서식확인",
    to_char(to_date('2023/12/25'), 'day') "3단계:조합"
    FROM dual;

/*
퀴즈] 문자열 '2024년12월25일'은 어떤 요일인지 변환함수를 통해 출력해 보시오.
    단 문장열은 임의로 변경할 수 없습니다.
*/
SELECT
    to_date('2024년12월25일', 'yyyy"년"mm"월"dd"일"') "1단계:날짜서식변경",
    to_char(to_date('2024년12월25일', 'yyyy"년"mm"월"dd"일"'), 'day') "2단계:요일출력"
    FROM dual;

/*
nvl() : null값을 다른 데이터로 변경하는 함수
    형식] nvl(컬럼명, 데체할 값)
*/
-- 이와같이 덧셈을 하면 영업사원이 아닌 경우 급여가 null이 출력된다.
-- 따라서 값이 null컬럼은 별도의 처리가 필요하다.
SELECT salary+commission_pct FROM employees;
-- null 값을 0으로 변경한 후 연산을 진행하므로 정상적인 결과가 출력된다.
SELECT first_name, commission_pct, salary+nvl(commission_pct, 0)
    FROM employees;

/*
decode() : java의 switch문과 비슷하게 특정값에 해당하는 출력문이 있는
    경우 사용한다.
    형식] decode(컬럼명,
                    값1, 결과1, 값2, 결과2, ....
                    기본값)
    * 내부적인 코드값을 문자열로 변환하여 출력할 때 많이 사용된다.
*/
SELECT first_name, last_name, department_id,
    decode(department_id,
        10, 'Administration',  -- 경영관리팀
        20, 'Marketing',  -- 마켓팅팀
        30, 'Purchasing',   -- 구매팀
        40, 'Human Resources',  --인사관리팀
        50, 'Shipping',  -- 물류팀
        60, 'IT',   -- it 팀
        70, 'Public Relations', -- 홍보팀
        80, 'Sales',   -- 영업팀
        90, 'Excutive', -- 경영팀
        100, 'Finance', -- 재무팀
        110, 'Accounting', '부서명 확인 안됨') AS department_name  -- 회계팀
    FROM employees;

/*
case() : java의 if~else문과 비슷한 역활을 하는 함수
    형식] case
            when 조건1, then 값1
            when 조건2, then 값2
            ......
            else 기본값
          end
*/
/*
시나리오] 사원테이블에서 각 부서번호에 해당하는 부서명을 출력하는 쿼리문을 
    case문을 이용해서 작성하시오
*/
SELECT first_name, last_name, department_id,
    case
         -- when 조건 then 값
        when department_id=10 then 'Administration'  -- 경영관리팀
        when department_id=20 then 'Marketing'  -- 마켓팅팀
        when department_id=30 then 'Purchasing'   -- 구매팀
        when department_id=40 then 'Human Resources'  --인사관리팀
        when department_id=50 then 'Shipping'  -- 물류팀
        when department_id=60 then 'IT'   -- it 팀
        when department_id=70 then 'Public Relations' -- 홍보팀
        when department_id=80 then 'Sales'   -- 영업팀
        when department_id=90 then 'Excutive' -- 경영팀
        when department_id=100 then 'Finance' -- 재무팀
        when department_id=110 then 'Accounting' -- 회계팀
        else '부서명 없음'
    end team_name
 FROM employees
 ORDER BY department_id ASC;

/*************************
연습문제
*************************/
--scott계정에서 진행합니다.

/*
1. substr() 함수를 사용하여 사원들의 입사한 년도와 입사한 달만 출력하시오.
*/
SELECT * FROM emp;
SELECT hiredate,
    substr(hiredate, 1, 5) "입사년월"
 FROM emp;

/*
2. substr()함수를 사용하여 4월에 입사한 사원을 출력하시오. 
즉, 연도에 상관없이 4월에 입사한 모든사원이 출력되면 된다.
*/
SELECT * FROM emp
    WHERE substr(hiredate, 4, 2)='04';

/*
3. mod() 함수를 사용하여 사원번호가 짝수인 사람만 출력하시오.
*/
SELECT * FROM emp
    WHERE mod(empno, 2)=0;




