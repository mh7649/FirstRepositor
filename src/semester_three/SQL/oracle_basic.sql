/**
  Լ�����⣺
  ������Ĭ��ֵ, unique, not nullֱ���ڴ�����ʱָ��
  
  check,���Լ��һ���Ǵ������ʹ��alter table add constraint�ķ�ʽ
  
  ��һ�ű����±�
  create table table_name as select * from table_name;
  
  ��Ȩ
         GRANT SELECT, UPDATE ON EMP  TO user;
         GRANT UPDATE(SAL, HIREDATE)  ON EMP TO user;
  ȡ����Ȩ
         REVOKE SELECT, UPDATE ON EMP FROM user;
         
  oracle���� _ ƥ�䵥���ַ����� % ƥ�����ַ�
*/
drop table t_user;
create table t_user(
  id number primary key,
  email varchar2(50) not null,
  phone varchar2(11) not null,
  pwd varchar2(50) not null,
  gender varchar2(2) default 'o',
  birthday date
);

create table t_menu(
  id number primary key,
  food_name varchar2(50) not null,
  price number(5,2) not null,
  des varchar2(500)
);

create table t_order(
  id number primary key,
  user_id number,
  order_time date,
  spend number(5,2)
);

alter table t_order add constraint 
fk_user_id foreign key(user_id) references t_user(id);

alter table t_order modify order_time date default sysdate;

create table t_order_detail(
    id number primary key,
    order_id number,
    menu_id number,
    total_count number
);

alter table t_order_detail add constraint
fk_order_id foreign key(order_id) references t_order(id);

alter table t_order_detail add constraint
fk_menu_id foreign key(menu_id) references t_menu(id);

create table t_city(
  id number primary key,
  name varchar2(20) not null,
  parent_id number not null
);

insert into t_city(id, name, parent_id) values(0, '�й�'��0);
insert into t_city(id, name, parent_id) values(1, '����ʡ'��0);
insert into t_city(id, name, parent_id) values(2, '������'��1);
insert into t_city(id, name, parent_id) values(3, '�ϲ���'��1);

/**���ѯ����ʡ�����г���*/

select * from t_city where parent_id = (select id from t_city where name='����ʡ');

/**����������ʾ��*/
select c1.* from t_city c1, t_city c2 where c1.parent_id = c2.id and c2.name = '����ʡ';

/**������ʹ��, �뵽sql plus����*/
define a = 10;
select * from t_city where name = &a;--a��ֱֵ���滻��&a
define a; --�鿴
undefine a;--ɾ��

/**
         delete������־��¼��Ч�ʵ�
         truncate��������־��¼��Ч�ʸ�
         
         �޸ı����ƣ�Rename dept to new _dept
*/

create or replace view view_test
as
select * from t_user
with read only;

select * from view_test;

drop view view_test;

/**������Ψһ���� create index
           ����Ψһ���� create unique index  �ڴ���ΨһԼ�����ֶ��ϴ���
*/
select * from user_indexes; -- �鿴�û����� 
select * from user_ind_columns;--�鿴�����ֶ���Ϣ

select * from t_user;

select email as �û����� from t_user;

/**
       synonym ͬ��ʣ�����ı�����
*/
CREATE or replace public SYNONYM t_user_syn  FOR t_user;

select * from t_user_syn;

create or replace synonym view_user_syn for sys.view_test;
select * from view_user_syn;

drop synonym view_user_syn;

select * from DBA_SYNONYMS;-- ���ݿ������е�ͬ���
select * from ALL_SYNONYMS;
select * from User_SYNONYMS; -- �û�ͬ���

/**
       sequence
*/
drop sequence my_seq;

create sequence my_seq
minvalue 1
maxvalue 9999999999999
start with 1
increment by 1;

select my_seq.nextval from dual;
select my_seq.currval from dual;
insert into t_user(id, email, phone, pwd) values(my_seq.nextval, 'abc@qq.com', '18888888888', '888888');
select * from t_user;

select * from DBA_SEQUENCES;
select * from ALL_SEQUENCES;
select * from USER_SEQUENCES;

/**
��ռ�
ALTER TABLESPACE "APP" READ ONLY   ֻ��
ALTER TABLESPACE "APP" READ WRITE  �ɶ�д
 
ALTER DATABASE DATAFILE ��d:\oracle\oradata\study\myapp01.dbf�� autoextend on  --�Զ�����
	Resize 50m       --�ı��С
ALTER TABLESPACE ��MYAPP��
		ADD DATAFILE ��d:\oracle\oradata\study\mypp02.dbf�� size 10m;
*/
Select * from v$tablespace;-- �鿴��ռ�

CREATE TABLESPACE my_tablespace 
    LOGGING 
    DATAFILE  'H:\database\oracle\oradata\orcl1\my_tablespace.DBF'  SIZE 5M 
    REUSE 
    AUTOEXTEND ON NEXT 1M MAXSIZE 1000M;
    
create table t_test2
(
  id number primary key
) tablespace my_tablespace; -- ��ָ���ı�ռ��ﴴ����

alter tablespace my_tablespace offline;
alter tablespace my_tablespace online;

/**
      �����û�
*/
create user C##test -- 12C
  identified by "123456"
  default tablespace MY_TABLESPACE;
  
drop user C##my_name;
--����Ȩ��
grant insert, update, delete, index on T_TEST to C##NAME;
--ȡ����Ȩ
revoke insert, update on T_TEST1 from C##NAME;
delete from t_test1;

select * from user_role_privs;--��ɫ
select * from user_sys_privs;--ϵͳ��Ȩ��
select * from user_tab_privs;--����Ȩ��
select * from session_privs; --��ǰ�Ự��Ȩ��
