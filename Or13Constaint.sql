/*****************
파일명 : Or13Constaint.sql
제약조건
설명 : 테이블 생성시 필요한 여러가지 제약조건에 대해 학습한다.
*******************/
-- study 계정으로 하기

/*
primary key : 기본키
    - 참조 무결성을 유지하기 위한 제약조건
    - 하나의 테이블에 하나의 기본키만 설정할 수 있다.
    - 키본키로 설정된 컬럼은 중복된 값이나 Null값을 입력할 수 없다.
    - 주로 레코드 하나를 특정하기 위해 사용된다.
*/
/*
형식1] 인라인 방식 : 컬럼 생성시 우측에 제약 조건을 기술한다.
    create table 테이블명(
        컬럼명 자료형(크기) [constaint 제약명] primary key
    );
    * []대괄호 부분은 생략 가능하고, 생략시 제약명을 시스템이
    자동으로 부여한다.
*/
CREATE TABLE tb_primary1(
    idx number(10) primary key,
    user_id varchar2(30),
    user_name varchar2(50)
);
DESC tb_primary1;

/*
제약 조건 및 테이블 목록 확인하기
    tab : 현재 계정에 생성된 테이블의 목록을 확인할 수 있다.
    user_cons_columns : 테이블에 지정된 제약조건과 컬러명의 간략한
        정보를 저장한다.
    user_constraints : 테이블에 지정된 제약조건의 보다 상세한 정보를
        저장한다.
    * 이와 같이 제약조건이나 뷰, 프로시저등의 정보를 저장하고 있는
        시스템 테이블을 "데이터 사전"이라고 한다.
*/
SELECT * FROM tab;
SELECT * FROM user_cons_columns;
SELECT * FROM user_constraints;

-- 레코드 입력
INSERT INTO tb_primary1(idx, user_id, user_name)
    VALUES(1, 'ilsan1', '일산');
INSERT INTO tb_primary1(idx, user_id, user_name)
    VALUES(2, 'ilsan2', '중앙로');

INSERT INTO tb_primary1(idx, user_id, user_name)
    VALUES(2, 'ilsan3', '오류발생');
/*
    무결성 제약조건 위배로 에러가 발생한다. PK로 지정된 컬럼 idx에는
    중복된 값을 입력할 수 없다.
*/

INSERT INTO tb_primary1 values(3, 'white', '화이트');
-- PK로 지정된 컬럼에는 null값을 입력할 수 없다.
INSERT INTO tb_primary1 values('', 'black', '블랙');

SELECT * FROM tb_primary1;

UPDATE tb_primary1 SET idx=1 WHERE user_name='유산슬'; -- 변경 안됨
UPDATE tb_primary1 SET user_name='유산슬' WHERE idx=2; -- 변경됨
/*
    update문은 정상이지만 idx값이 이미 존재하는 1로 변경했으므로
    제약조건 위배로 오류가 발생한다.
*/

/*
형식2] 아웃라인 방식
    create table 테이블명 (
        컬럼명 자료형(크기)
        [constraint 제약명] primary key (컬럼명)
    );
*/
CREATE TABLE tb_primary2(
    idx number(10),
    user_id varchar2(30),
    user_name varchar2(50),
    constraint my_pk1 primary key (user_id)
);
DESC tb_primary2;
SELECT * FROM user_cons_columns;
SELECT * FROM user_constraints;

INSERT INTO tb_primary2 VALUES(1, 'white', '화이트1');
INSERT INTO tb_primary2 VALUES(2, 'white', '화이트2'); -- 저장 안됨, 무결성 제약조건 위반

SELECT * FROM tb_primary2;

/*
형식3] 테이블을 생성한 후 alter문으로 제약조건 추가
    alter table 테이블명 add [constraint 제약명] primary key (컬럼명);
*/
CREATE TABLE tb_primary3(
    idx number(10),
    user_id varchar2(30),
    user_name varchar2(50)
);
/*
    테이블을 생성한 후 alter명령을 통해 제약조건을 부여할 수 있다.
    제약명의 경우 생략이 가능하다.
*/
ALTER TABLE tb_primary3 ADD CONSTRAINTS tb_primary3_pk
    primary key (user_name);
-- 데이터 사전에서 제약조건 확인하기
SELECT * FROM user_constraints;
-- 제약조건은 테이블을 대상으로 하므로 테이블이 삭제되면 같이 삭제된다.
DROP TABLE tb_primary3;
-- 확인시 휴지통에 들어간 것을 볼수 있다.
SELECT * FROM user_cons_columns;

-- PK는 테이블당 하나만 생성할 수 있다. 따라서 해당 문장은 에러가 발생한다.
CREATE TABLE tb_primary4(
    idx number(10) primary key,
    user_id varchar2(30) primary key,
    user_name varchar2(5)
);

/*
unique : 유니크
    - 값의 중복을 허용하지 않는 제약조건으로
    - 숫자, 문자는 중복을 허용하지 않는다.
    - 하지만 null값에 대해서는 중복을 허용한다.
    - unique는 한 테이블에 2개이상 적용할 수 있다.
*/
CREATE TABLE tb_unique(
    -- idx컬럼은 단독으로 unique가 지정된다.
    idx number unique not null,
    name varchar2(30),
    telephone varchar2(20),
    nickname varchar2(30),
    /*
        2개의 컬럼을 합쳐서 지정한다. 이경우 동일한 제약조건으로
        unique가 지정된다.
    */
    unique(telephone, nickname)
);
SELECT * FROM user_constraints;
-- 레코드 입력
INSERT INTO tb_unique(idx, name, telephone, nickname)
    VALUES(1, '아이린', '010-1111-1111', '레드벨벳');
INSERT INTO tb_unique(idx, name, telephone, nickname)
    VALUES(2, '웬디', '010-2222-2222', '');
INSERT INTO tb_unique(idx, name, telephone, nickname)
    VALUES(3, '슬기', '', '');
-- unique 는 중복을 허용하지 않는 제약조건이지만 null은 여러개 들어갈 수 있다.  
SELECT * FROm tb_unique;

-- idx컬럼에 중복된 값이 입력되므로 오류가 발생한다.
INSERT INTO tb_unique(idx, name, telephone, nickname)
    VALUES(1, '예린', '010-3333-3333', ''); 

INSERT INTO tb_unique VALUES(4, '정우성', '010-4444-4444', '영화배우');
INSERT INTO tb_unique VALUES(5, '이정재', '010-5555-5555', '영화배우');  -- 입력
INSERT INTO tb_unique VALUES(6, '황정민', '010-4444-4444', '영화배우'); -- 오류
/*
    telephone과 nickname은 동일한 제약명으로 설정되었으므로 두개의
    컬럼이 동시에 동일한 값을 가지는 경우가 아니라면 중복된 값이 하용된다.
    즉, 4번과 5번은 서로 다른 데이터로 인식하므로 입력되고, 4번과 6번은 
    동일한 데이터로 인식되어 에러가 발생한다.
*/
SELECT * FROM tb_unique;
SELECT * FROM user_cons_columns;

/*
Foreign Key : 외래키, 참조키
    - 외래키는 참조 무결성을 유지하기 위한 제약조건으로
    - 만약 테이블간에 외래키가 설정되어 있다면 자식테이블에 참조값이
        존재할 경우 부모테이블의 레코드는 삭제할 수 없다.
    
    형식1] 인라인 방식
        create table 테이블명(
        컬럼명 자료형 [constraint 제약명]
            references 부모테이블명 (참조할 컬럼명)
        );
*/  
CREATE TABLE tb_foreign1( -- 자식 테이블
    f_idx number(10) primary key,
    f_name varchar2(50),
    /*
        자식테이블인 tb_foreign1에서 부모테이블인 tb_primary2의 user_id컬럼을
        참조하는 외래키를 생성한다.
    */
    f_id varchar2(30) constraint tb_foreign_fk1
        references tb_primary2(user_id)
);
--CREATE TABLE tb_primary2( -- 부모 테이블
--    idx number(10),
--    user_id varchar2(30),
--    user_name varchar2(50),
--    constraint my_pk1 primary key (user_id)
--);
-- 부모 테이블에는 레코드 1개 삽입되어 있음.
SELECT * FROM tb_primary2;
-- 자식 테이블에는 레코드가 없는 상태임.
SELECT * FROM tb_foreign1;
-- 오류 발생. 부모테이블에는 gildong이라? 아이디가 없음.
INSERT INTO tb_foreign1 VALUES(1, '홍길동', 'gildong');
-- 입력 성공. 부모테이블에 white라는 아이디가 있음.
INSERT INTO tb_foreign1 VALUES(1, '홍길동', 'white');

/*
    자식테이블에서 참조하는 레코드가 있으므로, 부모테이블의 레코드를 삭제할 수
    없다. 이 경우 반드시 자식 테이블의 레코드를 먼저 삭제한 후 부모테이블의
    레코드를 삭제해야 한다.
*/
-- 오류 발생
DELETE FROM tb_primary2 WHERE user_id='white';

-- 자식테이블의 레코드를 먼저 삭제한 후 ...
DELETE FROM tb_foreign1 WHERE f_id='white';
-- 부모 테이블의 레코드를 삭제하면 정상 처리 된다.
DELETE FROM tb_primary2 WHERE user_id='white';

-- 모든 레코드가 삭제된 상태이다.
SELECT * FROM tb_foreign1;
SELECT * FROM tb_primary2;
/*
    2개의 테이블이 외래키(참조키)가 설정되어 있는 경우
    부모테이블의 참조할 레코드가 없다면 자식테이블에 insert할 수 없다.
    자식테이블의 부모를 참조하는 레코드가 남아있으면 부모테이블의
    레코드를 delete할 수 없다.
*/

/*
형식2] 아웃라인 방식
    create table 테이블명(
        컬럼명 자료형,
        [constaint 제약명] foreign key(컬럼명)
            references 부모테이블 (참조할 컬럼)
        );
*/
CREATE TABLE tb_foreign2(
    f_id number primary key,
    f_name varchar2(30),
    f_date date,
    foreign key (f_id) references tb_primary1 (idx)
);
SELECT * FROM user_cons_columns;
SELECT * FROM user_constraints;
/*
    데이터 사전에서 제약조건 확인시의 플래그
    P : Primary key
    R : Refernce integrity 즉 Foreign key 를 뜻한다.
    C : Check 혹은 Not null
    U : Unique
*/
/*
형식3] 테이블 생성 후 alter 문으로 외래키 제약조건 추가
    alter table 테이블명 add [constraint 제약명]
        foreign key (컬럼명)
            references 부모테이블 (참조 컬럼명)
*/
CREATE TABLE tb_foreign3(
    idx number primary key,
    f_name varchar2(30),
    f_idx number(10)
);
ALTER TABLE tb_foreign3 ADD
    foreign key (f_idx) references tb_primary1 (idx);
SELECT * FROM user_cons_columns;
/*
    하나의 부모테이블에 둘 이상의 자식테이블이 외래키를 설정할 수 있다.
*/
/*
외래키 삭제 옵션
[on delete cascade]
    : 부모레코드 삭제시 자식레코드까지 같이 삭제된다.
    형식] 
        컬럼명 자료형 references 부모테이블 (pk컬럼)
            on delete cacade;
[on dalete set null]
    :부모레코드 삭제시 자식레코드 값이 null로 변경된다.
    형식]
        컬럼명 자료형 references 부모테이블 (pk컬럼)
            on delete set null
* 실무에서 스펨게시물을 남긴 회원과 그 게시글을 일괄적으로 삭제해야할 때
    사용할 수 있는 옵션이다. 단, 자식테이블의 모든 레코드가 삭제되므로 
    사용에 주의해야 한다.
*/
CREATE TABLE tb_primary4(
    user_id varchar2(30) primary key,
    user_name varchar2(100)
);

CREATE TABLE tb_foreign4(
    f_idx number(10) primary key,
    f_name varchar2(30),
    user_id varchar2(30) constraints tb_foreign4_fk
        references tb_primary4 (user_id) on delete cascade
);
/*
    외래키가 설정된 경우 반드시 부모테이블에 레코드를 먼저 입력한 후
    자식 테이블에 입력해야 한다.
*/
INSERT INTO tb_primary4 VALUES ('student', '훈련생1');
INSERT INTO tb_foreign4 VALUES (1, '스팸1입니다.', 'student');
INSERT INTO tb_foreign4 VALUES (2, '스팸2입니다.', 'student');
INSERT INTO tb_foreign4 VALUES (3, '스팸3입니다.', 'student');
INSERT INTO tb_foreign4 VALUES (4, '스팸4입니다.', 'student');
INSERT INTO tb_foreign4 VALUES (5, '스팸5입니다.', 'student');
INSERT INTO tb_foreign4 VALUES (6, '스팸6입니다.', 'student');
INSERT INTO tb_foreign4 VALUES (7, '스팸7입니다.', 'student');
-- 부모키가 없으므로 레코드를 삽입할 수 없다. 오류 발생
INSERT INTO tb_foreign4 VALUES (8, '난???누구??', 'teacher');

-- 앞에서 삽입한 레코드가 입력되어있는 상태임.
SELECT * FROM tb_primary4;
SELECT * FROM tb_foreign4;

/*
    부모테이블에서 레코드를 삭제할 경우 on delete cascade 옵션에 의해
    자식쪽까지 모든 레코드가 삭제된다. 만약 해당 옵션을 주지않은 상태로
    외래키를 생성했다면 레코드는 삭제되지 않고 오류가 발생하게 된다.
*/
DELETE FROM tb_primary4 WHERE user_id='student';

-- 부모 자식 테이블의 모든 레코드가 삭제된다.
SELECT * FROM tb_primary4;
SELECT * FROM tb_foreign4;

--------------------------------------------------------------------
-- on delete set null 옵션 테스트
CREATE TABLE tb_primary5(
    user_id varchar2(30) primary key,
    user_name varchar2(100)
);

CREATE TABLE tb_foreign5(
    f_idx number(10) primary key,
    f_name varchar2(30),
    user_id varchar2(30) constraints tb_foreign5_fk
        references tb_primary5 (user_id) on delete set null
);

INSERT INTO tb_primary5 VALUES ('student', '훈련생1');
INSERT INTO tb_foreign5 VALUES (1, '스팸1입니다.', 'student');
INSERT INTO tb_foreign5 VALUES (2, '스팸2입니다.', 'student');
INSERT INTO tb_foreign5 VALUES (3, '스팸3입니다.', 'student');
INSERT INTO tb_foreign5 VALUES (4, '스팸4입니다.', 'student');
INSERT INTO tb_foreign5 VALUES (5, '스팸5입니다.', 'student');
INSERT INTO tb_foreign5 VALUES (6, '스팸6입니다.', 'student');
INSERT INTO tb_foreign5 VALUES (7, '스팸7입니다.', 'student');

SELECT * FROM tb_primary5;
SELECT * FROM tb_foreign5;

/*
    on delete set null 옵션으로 자식테이블의 레코드는 삭제되지 않고, 참조키
    부분만 null값으로 변경된다. 따라서 더이상 참조할 수 없는 레코드로 변경된다.
*/
DELETE FROM tb_primary5 WHERE user_id='student';

-- 부모테이블의 레코드는 삭제된다.
SELECT * FROM tb_primary5;
-- 자식테이블의 레코드는 남아있다. 단, 참조컬럼이 null로 변경된다.
SELECT * FROM tb_foreign5;

/*
not null : null 값을 허용하지 않는 제약조건
    형식]
        create table 테이블명 (
            컬럼명 자료형 not null,
            컬럼명 자료형 null <- null 을 허용한다는 의미로 작성했지만 
                                    이렇게 사용하지 않는다. null을 기술하지
                                    않으면 자동으로 허용한다는 의미가 된다.
        );
*/
CREATE TABLE tb_not_null(
    m_idx number(10) primary key,   -- PK이므로 NN
    m_id varchar2(20) not null,     -- NN
    m_pw varchar2(30) null, -- null 허용.(일반적으로 이렇게 사용 안함.)
    m_name varchar2(40)     -- null 허용.(이와같이 사용)
);
DESC tb_not_null;
-- 10~30까지는 정상적으로 입력된다.
INSERT INTO tb_not_null VALUES(10, 'hong1', '1111','홍길동');
INSERT INTO tb_not_null VALUES(20, 'hong2', '2222','');
INSERT INTO tb_not_null VALUES(30, 'hong3', '','');
-- m_id는 NN으로 지정되었으므로 null값을 삽입할 수 없어 오류가 발생한다.
INSERT INTO tb_not_null VALUES(40, '', '','');
-- 입력 성공  space도 문자이므로 입력된다.
INSERT INTO tb_not_null VALUES(50, ' ', '5555','오길동');

-- 오류발생. PK에는  null값을 입력할 수 없다. 컬럼을 명시하지 않으면 null이
-- 입력된다.
INSERT INTO tb_not_null (m_id, m_pw, m_name)
    VALUES('hong6', '6666','육길동');
INSERT INTO tb_not_null (m_idx, m_id, m_name)
    VALUES(70,'hong7', '육길동');

SELECT * FROM tb_not_null;

/*
default : insert 시 아무런 값도 입력하지 않았을때 자동으로 삽입되는
    데이터를 지정할 수 있다.
*/
CREATE TABLE tb_default(
    id varchar2(30) not null,
    pw varchar2(50) default 'gwer'
);
INSERT INTO tb_default VALUES('aaaa', '1234');  -- 1234 입력됨.
INSERT INTO tb_default (id) VALUES('bbbb'); -- 컬럼자체가 없으므로 default 값입력
INSERT INTO tb_default VALUES('cccc', ''); -- null 값 입력
INSERT INTO tb_default VALUES('dddd', ' '); -- 공백(space) 입력
INSERT INTO tb_default VALUES('eeee', default); -- default값 입력
/*
    default 값을 입력하려면 insert문에서 컬럼 자체를 제외시키거나
    default 키워드를 사용해야 한다.
*/
SELECT * FROM tb_default;

/*
check : Domain(자료형) 무결성을 유지하기 위한 제약조건으로 해당 컬럼에
    잘못된 데이터가 입력되지 않도록 유지하는 제약조건이다.
*/
CREATE TABLE tb_check1(
    gender char(1) not null
        constraint check_gender
            check (gender in ('M', 'F'))
);
INSERT INTO tb_check1 VALUES('M');
INSERT INTO tb_check1 VALUES('F');
-- check 제약조건 위배로 오류 발생
INSERT INTO tb_check1 VALUES('T');
-- 입력된 데이터가 컬럼의 크기보다 크므로 오류 발생
INSERT INTO tb_check1 VALUES('여성');
SELECT * FROM tb_check1;

-- 10이하의 값만 입력할 수 있는 check 제약조건 지정
CREATE TABLE tb_check2(
    sale_count number not null
        check (sale_count<=10)
);
INSERT INTO tb_check2 VALUES (9);
INSERT INTO tb_check2 VALUES (10);
-- 제약조건 위배로 입력실패
INSERT INTO tb_check2 VALUES (11);
SELECT * FROm tb_check2;





