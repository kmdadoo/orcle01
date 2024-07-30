/*****************
파일명 : Or14Sequence&Index.sql
시퀀스 & 인덱스
설명 : 테이블의 기본키 필드에 순차적인 일련번호를 부여하는 시퀀스와
    검색 속도를 향상시킬 수 있는 인덱스
*******************/
-- study 계정으로 하기

/*
시퀀스
    - 테이블의 컬럼(필드)에 중복되지 않는 순차적인 일련번호를 부여한다.
    - 시퀀스는 테이블 생성 후 별도로 만들어야 한다. 즉 시퀀스는 테이블과
        독립적으로 저장되고 생성된다.
        
[시퀀스 생성 구문]
create sequence 시퀀스명
    [increment by N]    -> 증가치 설정
    [Start with N]      -> 시작값 지정
    [Minvalue n | NoMinvalue]       -> 시퀀스 최소값 지정 : 디폴트 1
    [Maxvalue n | NoMaxvalue]       -> 시퀀스 최대값 지정 : 디폴트 1.0000E+28
    [Cycle | No Cycle]              -> 최대/최소값에 도달할 경우 처음부터 다시
                                    시작할지 여부를 설정(Cycle로 지정하면 최대값까지
                                    증가 후 다시 시작값부터 재 시작됨)
    [Cache | NOCache]               -> cache 메모리에 오라클 서버가 시퀀스값을
                                    할당하는 여부를 지정    
주의사항
    1.start with 에 minvalue보다 작은 값을 지정할 수 없다. 즉 start with값은
    minvalue와 같거나 커야 한다.
    2.nocycle 로 설정하고 시퀀스를 계속 얻어올때 maxvalue에 지정값을 초과하면
    에러가 발생한다.
    3.primary key에 cycle옵션을 절대 지정하면 안 된다.
*/
CREATE TABLE tb_goods(
    g_idx number(10) primary key,
    g_name varchar2(30)
);
INSERT INTO tb_goods VALUES(1, '가나쵸콜릿');
INSERT INTO tb_goods VALUES(1, '새우깡');  -- 입력실패(제약조건 위배)

-- 시퀀스 설정
CREATE SEQUENCE seq_serial_num
    INCREMENT BY 1      -- 증가치 : 1
    START WITH 100      -- 초기값 : 100
    MINVALUE 99         -- 최소값 : 99
    MAXVALUE 110        -- 최대값 : 110
    CYCLE           -- 최대값 도달시 시작값부터 재시작할지 여부 : Yes
    NOCACHE;        -- 캐시메모리 사용 여부 : No
-- 데이터 사전에서 생성된 시퀀스 확인하기
SELECT * FROM user_sequences;

/*
다음 입력할 시퀀스(일련번호)를 반환한다. 실행할때마다 다음으로 넘어간다.
*/
SELECT seq_serial_num.NEXTVAL FROM dual;

INSERT INTO tb_goods VALUES (seq_serial_num.NEXTVAL, '꿀과베기1');
INSERT INTO tb_goods VALUES (seq_serial_num.NEXTVAL, '꿀과베기2');
INSERT INTO tb_goods VALUES (seq_serial_num.NEXTVAL, '꿀과베기3');
INSERT INTO tb_goods VALUES (seq_serial_num.NEXTVAL, '꿀과베기4');
INSERT INTO tb_goods VALUES (seq_serial_num.NEXTVAL, '꿀과베기5');
INSERT INTO tb_goods VALUES (seq_serial_num.NEXTVAL, '꿀과베기6');
INSERT INTO tb_goods VALUES (seq_serial_num.NEXTVAL, '꿀과베기7');
INSERT INTO tb_goods VALUES (seq_serial_num.NEXTVAL, '꿀과베기8');
INSERT INTO tb_goods VALUES (seq_serial_num.NEXTVAL, '꿀과베기9');
INSERT INTO tb_goods VALUES (seq_serial_num.NEXTVAL, '꿀과베기10');
INSERT INTO tb_goods VALUES (seq_serial_num.NEXTVAL, '꿀과베기11');
INSERT INTO tb_goods VALUES (seq_serial_num.NEXTVAL, '꿀과베기12');

/*
    시퀀스의 cycle 옵션에 의해 최대값에 도달하면 다시 처음부터 일련번호가
    생성되므로 무결성 제역조건에 위배된다. 즉 기본키에 사용할 시퀀스는
    cycle 옵션을 사용하지 않아야 한다.
*/
INSERT INTO tb_goods VALUES (seq_serial_num.NEXTVAL, '꿀과베기13');

SELECT * FROM tb_goods;
SELECT seq_serial_num.CURRVAL FROM dual;

/*
시퀀스 수정
    : start with 는 수정되지 않는다.
*/
ALTER SEQUENCE seq_serial_num
    INCREMENT BY 10
    MINVALUE 1
    NOMAXVALUE
    NOCYCLE
    NOCACHE;
    
-- 수정 후 데이터 사전에서 확인한다.
SELECT * FROM user_sequences;
-- 증가치가 10으로 적용된것을 확인한다.
SELECT seq_serial_num.NEXTVAL FROM dual;

-- 시퀀스 삭제
DROP SEQUENCE seq_serial_num;
SELECT * FROM user_sequences;

-- 일반적인 시퀀스 생성은 아래와 같이 하면 된다.
CREATE SEQUENCE seq_serial_num
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    NOMAXVALUE
    NOCYCLE
    NOCACHE;

/*
인덱스(Index)
    - 행의 검색속도를 향상시킬수 있는 객체
    - 인덱스는 명시적(create index)과 자동적(primary key, unique)
    으로 생성할 수 있다.
    - 컬럼에 대한 인덱스가 없으면 테이블 전체를 검색하게 된다.
    - 즉 인덱스는 쿼리의 성능을 향상시키는 것이 목적이다.
    - 인덱스는 아래와 같은 경우에 설정한다.
        1.where조건이나 join조건에 자주 사용하는 컬럼
        2.광범위한 값을 포함하는 컬럼
        3.많은 null값을 포함하는 컬럼
*/
DESC tb_goods;
SELECT * FROM tb_goods;

-- 인덱스 생성하기. 특정 테이블의 컬럼을 지정하여 생성한다.
CREATE INDEX tb_goods_name_idx ON tb_goods (g_name);
-- 생성한 인덱스 확인하기
/*
    데이터 사전에서 확인하면 PK 혹은 unique로 지정된 컬럼은 자동으로 인덱스가 
    생성되므로 이미생성된 인덱스도 같이 확인된다.
*/
SELECT * FROM user_ind_columns;
/*
특정 테이블의 인덱스 확인
    : 데이터 사전에 등록시 대문자로 입력되므로 upper와 같은 변환함수를 
    사용하면 편리하다.
*/
SELECT * FROM user_ind_columns WHERE table_name=UPPER('tb_goods');

-- 굉장히 많은 레코드가 있다고 가정했을 때 검색 속도의 향상이 있다.
SELECT * FROM tb_goods WHERE g_name LIKE '%꿀%';

-- 인덱스 삭제
DROP INDEX tb_goods_name_idx;

-- 인덱스 수정 : 수정은 불가능하다. 삭제 후 다시 생성해야 한다.


