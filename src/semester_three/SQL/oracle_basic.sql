/**
  约束问题：
  主键，默认值, unique, not null直接在创建表时指定
  
  check,外键约束一般是创建表后使用alter table add constraint的方式
  
  从一张表创建新表
  create table table_name as select * from table_name;
  
  授权
         GRANT SELECT, UPDATE ON EMP  TO user;
         GRANT UPDATE(SAL, HIREDATE)  ON EMP TO user;
  取消授权
         REVOKE SELECT, UPDATE ON EMP FROM user;
         
  oracle中用 _ 匹配单个字符，用 % 匹配多个字符
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

insert into t_city(id, name, parent_id) values(0, '中国'，0);
insert into t_city(id, name, parent_id) values(1, '江西省'，0);
insert into t_city(id, name, parent_id) values(2, '赣州市'，1);
insert into t_city(id, name, parent_id) values(3, '南昌市'，1);

/**请查询江西省的所有城市*/

select * from t_city where parent_id = (select id from t_city where name='江西省');

/**自身表关联的示例*/
select c1.* from t_city c1, t_city c2 where c1.parent_id = c2.id and c2.name = '江西省';

/**变量的使用, 请到sql plus中跑*/
define a = 10;
select * from t_city where name = &a;--a的值直接替换掉&a
define a; --查看
undefine a;--删除

/**
         delete会做日志记录，效率低
         truncate不会做日志记录，效率高
         
         修改表名称：Rename dept to new _dept
*/

create or replace view view_test
as
select * from t_user
with read only;

select * from view_test;

drop view view_test;

/**创建不唯一索引 create index
           创建唯一索引 create unique index  在带有唯一约束的字段上创建
*/
select * from user_indexes; -- 查看用户索引 
select * from user_ind_columns;--查看索引字段信息

select * from t_user;

select email as 用户邮箱 from t_user;

/**
       synonym 同义词（对象的别名）
*/
CREATE or replace public SYNONYM t_user_syn  FOR t_user;

select * from t_user_syn;

create or replace synonym view_user_syn for sys.view_test;
select * from view_user_syn;

drop synonym view_user_syn;

select * from DBA_SYNONYMS;-- 数据库中所有的同义词
select * from ALL_SYNONYMS;
select * from User_SYNONYMS; -- 用户同义词

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
表空间
ALTER TABLESPACE "APP" READ ONLY   只读
ALTER TABLESPACE "APP" READ WRITE  可读写
 
ALTER DATABASE DATAFILE ‘d:\oracle\oradata\study\myapp01.dbf’ autoextend on  --自动扩张
	Resize 50m       --改变大小
ALTER TABLESPACE ‘MYAPP’
		ADD DATAFILE ‘d:\oracle\oradata\study\mypp02.dbf’ size 10m;
*/
Select * from v$tablespace;-- 查看表空间

CREATE TABLESPACE my_tablespace 
    LOGGING 
    DATAFILE  'H:\database\oracle\oradata\orcl1\my_tablespace.DBF'  SIZE 5M 
    REUSE 
    AUTOEXTEND ON NEXT 1M MAXSIZE 1000M;
    
create table t_test2
(
  id number primary key
) tablespace my_tablespace; -- 在指定的表空间里创建表

alter tablespace my_tablespace offline;
alter tablespace my_tablespace online;

/**
      创建用户
*/
create user C##test -- 12C
  identified by "123456"
  default tablespace MY_TABLESPACE;
  
drop user C##my_name;
--授予权限
grant insert, update, delete, index on T_TEST to C##NAME;
--取消授权
revoke insert, update on T_TEST1 from C##NAME;
delete from t_test1;

select * from user_role_privs;--角色
select * from user_sys_privs;--系统级权限
select * from user_tab_privs;--表级别权限
select * from session_privs; --当前会话的权限
