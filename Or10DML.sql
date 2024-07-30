/*****************
파일명 : Or10DML.sql
DML : Data Manipulation Language(데이터 조작어)
설명 : 레코드를 조작할 때 사용하는 쿼리문. 앞에서 학습했던
    select문을 비롯하여 update(레코드 수정), delete(레코드 삭제),
    insert(레코드 입력)가 있다.
*******************/
-- study 계정으로 하기

/*
레코드 입력하기 : insert
    레코드 입력을 위한 쿼리로 문자형은 반드시 '로 감사야 한다.
    숫자형은 '없이 그냥 쓰면된다. 만약 숫자형을 '로 감싸면 자동으로
    변환되어 입력된다.
*/
-- 새로운 테이블 생성하기
CREATE TABLE tb_sample(
    dept_no number(10),
    dept_name varchar2(20),
    dept_loc varchar2(15),
    dept_manager varchar2(30)
);
-- 생성된 테이블의 구조 확인
DESC tb_sample;

-- 데이터 입력1 : 컬럼을 지정한 후 insert한다.
INSERT INTO tb_sample (dept_no, dept_name, dept_loc, dept_manager)
    VALUES(10, '기획실', '서울', '민지');
INSERT INTO tb_sample (dept_no, dept_name, dept_loc, dept_manager)
    VALUES(20, '전산팀', '수원', '쯔위');

-- 데이터 입력2 : 컬럼 지정없이 전체 컬럼을 대상으로 insert한다.
INSERT INTO tb_sample VALUES(30, '영업팀', '대구', '모모');
INSERT INTO tb_sample VALUES(40, '인사팀', '부산', '사나');

SELECT * FROM tb_sample;

/*
컬럼을 지정해서 insert하는 경우 데이터를 삽입하지 않을 컬럼을 지정할 수 
있다. 아래의 경우 dept_name이 null이 된다.
*/
INSERT INTO tb_sample (dept_no, dept_loc, dept_manager)
    VALUES(20, '수원', '채연');
    
SELECT * FROM tb_sample;

/*
    지금까지 작업(트랜잭션)을 그대로 유지하겠다는 명령으로 커밋을
    수행하지 않으면 외부에서는 변경된 레코드를 확인할 수 없다.
    여기서 말하는 외부란 Java/Jsp와 같은 Oracle이외의 프로그램을
    말한다.
    * 트랜잭션이란 송금과 같은 하나의 단위작업을 말한다.
*/
COMMIT;

-- 커밋 이후 새로운 레코드를 삽입하면 임시테이블에 저장된다.
INSERT INTO tb_sample VALUES(60, '금융팀', '광주', '사쿠라');
-- 오라클에서 확인하면 실제 삽입된것 처럼 보인다. 하지만 실제 반영되지 
-- 않은 상태이다.
SELECT * FROM tb_sample;
-- 롤백 명령으로 마지막 커밋 상태로 되돌릴 수 있다.
ROLLBACK;
-- 마지막에 입력한 '사쿠라'가 제거된다.
SELECT * FROM tb_sample;
/*
    rollback 명령은 마지막 커밋 상태로 되돌려준다.
    즉, commit 한 이전의 상태로는 롤백할 수 없다.
*/

/*
레코드 수정하기 : update
    형식] 
        update 테이블명
        set 컬럼1=값1, 컬럼2=값2, ...
        where 조건;
    * 조건이 없는 경우 모든 레코드가 한꺼번에 수정된다.
    * 테이블명 앞에 from이 들어가지 않는다.
*/
-- 부서번호 40인 레코드의 지역을 미국으로 수정하시오.
UPDATE tb_sample SET dept_loc='미국' WHERE dept_no=40;
-- 지역이 서울인 레코드의 매니저명을 '박진영'으로 수정하시오
UPDATE tb_sample SET dept_manager='박진영' WHERE dept_loc='서울';
SELECT * FROM tb_sample;

-- 모든 레코드를 대상으로 지역을 '부평'으로 변경하시오.
UPDATE tb_sample SET dept_loc='부평';
/*
    전체 레코드 대상이므로 where절을 쓰지 않는다.
*/
SELECT * FROM tb_sample;

/*
레코드 삭제하기 : delete
    형식] 
        delete from 테이블명 where 조건;
    * 레코드를 삭제하므로 delete 뒤에 컬럼을 명시하지 않는다.
*/
-- 부서번호가 10인 레코드를 삭제하시오.
DELETE FROM tb_sample WHERE dept_no=10;
SELECT * FROM tb_sample;
-- 레코드 전체를 삭제하시오.
DELETE FROM tb_sample;
/*
    where절이 없으므로 모든 레코드를 삭제한다.
*/
SELECT * FROM tb_sample;
-- 마지막에 커밋했던 지점으로 되돌린다.
ROLLBACK;
SELECT * FROM tb_sample;

/*
DML문 : 레코드를 입력 및 조작하는 쿼리문
(Data Manipulation Language : 데이터 조작어)
    레코드 입력 : insert into 테이블명 (컬럼) values (값)
    레코드 수정 : update 테이블명 set 컬럼=값 where 조건
    레코드 삭제 : delete from 테이블명 where 조건.
    * insert의 경우 컬럼을 생략할 수 있다.
    * delete의 경우 조건이 없으면 전체 삭제.
*/

--------------------------------------------------------
---------------연습문제
/*
1. DDL문 연습문제 2번에서 만든 “pr_emp” 테이블에 다음과 같이 레코드를 
삽입하시오.
1, '엄태웅', '어른승민', to_date('1975-11-21') -- 방법1
2, '이제훈', '대학생승민', to_date('1978-07-23') 
3, '한가인', '어른서연', to_date('1982-10-24')  -- 방법2
4, '배수지', '대학생서연', to_date('1988-05-21')
*/
DESC pr_emp;
-- 방법1
INSERT INTO pr_emp (eno, ename, job, regist_date)
    VALUES(1, '엄태웅', '어른승민', to_date('1975-11-21'));
INSERT INTO pr_emp (eno, ename, job, regist_date)
    VALUES(2, '이제훈', '대학생승민', to_date('1978-07-23'));
-- 방법2
INSERT INTO pr_emp VALUES(3, '한가인', '어른서연', to_date('1982-10-24'));
INSERT INTO pr_emp VALUES(4, '배수지', '대학생서연', to_date('1988-05-21'));

SELECT * FROM pr_emp;

/*
2. pr_emp 테이블의 eno가 짝수인 레코드를 찾아서 job 컬럼의 
내용을 다음과 같이 변경하시오.
job=job||'(짝수)'
*/
SELECT * FROM pr_emp WHERE mod(eno, 2)=0;
UPDATE pr_emp SET job=job||'(짝수)' WHERE mod(eno, 2)=0; 

SELECT * FROM pr_emp;

/*
3. pr_emp 테이블에서 job 이 대학생인 레코드를 찾아 이름만 삭제하시오. 
레코드는 삭제되면 안됩니다.
*/
SELECT * FROM pr_emp WHERE job LIKE '%대학생%';
UPDATE pr_emp SET ename='' WHERE job LIKE '%대학생%';

SELECT * FROM pr_emp;

/*
4.  pr_emp 테이블에서 등록일이 10월인 모든 레코드를 삭제하시오.
*/
--10월인 레코드를 인출한다. 
SELECT * FROM pr_emp WHERE regist_date LIKE '___10___';
SELECT * FROM pr_emp WHERE to_char(regist_date, 'mm')='10';
SELECT * FROM pr_emp WHERE substr(regist_date, 4, 2)='10';
--조건에 맞는 레코드를 삭제한다. 
DELETE FROM pr_emp WHERE to_char(regist_date, 'mm')='10';

SELECT * FROM pr_emp;
