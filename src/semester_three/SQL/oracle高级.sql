create table t_emp(
  id number primary key,
  name varchar2(20) not null,
  salary number(6,2)
) tablespace my_tablespace;

create sequence emp_seq
minvalue 1
maxvalue 99999999
start with 1
increment by 1;

insert into t_emp(id, name, salary) values(emp_seq.nextval, 'aa', 5000);
insert into t_emp(id, name) values(emp_seq.nextval, 'bb');

--请查询出用户的工资水平，如果工资为空，则指定为3000元
select name, nvl(salary, 3000) from t_emp; -- nvl把空值转化成指定的值

select ascii('a') from dual; -- 获取ascii码
select chr(97) from dual; -- 通过指定的ascii码获取字符
select concat('a', 'b') from dual; -- 字符串的连接
select INITCAP('veni,vedi,vici') from dual; --首字符变大写

select instr('testabcdafa', 'a', 6, 2) from dual; -- 索引从1开始   从某个字符串的指定位置开始索引子串，并返回子串出现的索引
select length('dfsdfsdfsdf') from dual; --返回字符串的长度

select lower('ksdlfjAAAFSDfhsdlfkjsdf') from dual; -- 转化成小写
select upper('dfjlkdfjAfdjlfksdfjlkd') from dual; -- 转化成大写
/**
       rpad补齐到右边，lpad补齐到左边
       lpad('tech', 7);       将返回' tech'

lpad('tech', 2); 将返回'te'

lpad('tech', 8, '0'); 将返回'0000tech'

lpad('tech on the net', 15, 'z'); 将返回 'tech on the net'

lpad('tech on the net', 16, 'z'); 将返回 'ztech on the net'
*/

/**
   ltrim(x,y) 函数是按照y中的字符一个一个截掉x中的字符，并且是从左边开始执行的，只要遇到y中有的字符, x中的字符都会被截掉, 直到在x的字符中遇到y中没有的字符为止函数命令才结束 .

把c1中最右边的字符去掉，使其第后一个字符不在c2中，如果没有c2，那么c1就不会改变。
*/

select replace('uptown', 'up', 'down') from dual;
select substr('uptown', 2, 3) from dual; -- 从指定索引开始，取指定个数的字符

select trim('  sdjflkdj  ') from dual; -- 去除左右空格


select add_months(sysdate, 1) from dual;
select last_day(add_months(sysdate, 1)) from dual;
select trunc(sysdate, 'yyyy-MM-dd') from dual where 1 = 1; -- ORA-01898 精度说明符过多

select to_char(1) from dual;
select to_char(sysdate, 'yyyy-MM-dd HH:mm:ss') from dual; -- 把时间输出为指定格式的字符串
select to_date('2017-06-07', 'yyyy-MM-dd') from dual; -- 字符串转化成时间

select * from t_user;
set SERVEROUTPUT on; -- 请到命令窗口下运行
/**隐式游标*/
 BEGIN  
        UPDATE t_user SET phone='13666666666' WHERE id=3;   
         IF SQL%FOUND THEN    
        DBMS_OUTPUT.PUT_LINE('成功修改手机号！');   
        COMMIT;    
        ELSE  
        DBMS_OUTPUT.PUT_LINE('修改手机号失败！');   
         END IF;    
        END;
        
/**
显式游标
*/
declare
  v_email varchar2(50);
  v_phone varchar2(11);
  cursor my_cursor is
  select email, phone from t_user where id = 3; 
  begin
    open my_cursor;
    fetch my_cursor into v_email, v_phone;
    dbms_output.put_line(v_email || ', ' || v_phone); -- \\ 字符串的连接
    close my_cursor;
  end; 

/**
  使用以下游标循环的方式，会自动开启和关闭游标
*/  
declare
  cursor my_cursor_1 is
  select email, phone from t_user; 
  begin
    for user_record in my_cursor_1 loop
        dbms_output.put_line(user_record.email || ', ' || user_record.phone); -- \\ 字符串的连接
    end loop;
  end;    
  
  
declare
  v_email varchar2(50);
  v_phone varchar2(11);
  cursor my_cursor is
  select email, phone from t_user; 
  begin
    open my_cursor;
    for i in 1..2 loop
      fetch my_cursor into v_email, v_phone;
      dbms_output.put_line(v_email || ', ' || v_phone); -- \\ 字符串的连接
    end loop;
    close my_cursor;
  end; 
  
  
create or replace procedure proc_user
is
v_email varchar2(50);
v_phone varchar2(11);
begin
       update t_user set phone = '18888888888' where id = 3;
       commit;
end;


select * from t_user;
create or replace procedure proc_user1
(
p_id in number,
p_phone in varchar2
)
is
begin
  update t_user set phone = p_phone where id = p_id;
  commit;
end;
--exec proc_user1(3, '13888888888');

create or replace procedure proc_user2
(
p_id in number,
p_phone out varchar2
)
is 
begin
  select phone into p_phone from t_user where id = p_id;
end;

create table t_user_his as select * from t_user; -- t_user_his的表结构与t_user表一致，其实把表数据放到user表中
select * from t_user_his;
drop table t_user_his;

create table C##NAME.t_user_his as select * from C##NAME.t_user_ori where 1 = 2;

create or replace trigger tri_user
before insert or delete or update
on C##NAME.t_user_ori
for each row
  begin
    insert into C##NAME.t_user_his values(:old.id, :old.email); -- 对于update和delete才有old
  end;
  
insert into C##NAME.t_user_ori values(1, 'adfsadfd');
insert into C##NAME.t_user_ori values(2, 'fdfdfdf');
update C##NAME.t_user_ori set email = 'dfdfd' where id = 2;
delete from C##NAME.t_user_ori where id = 2;

select * from C##NAME.t_user_ori;
select * from C##NAME.t_user_his;

create or replace trigger tri_user1
before insert or delete or update
on C##NAME.t_user_ori
for each row
  begin
    if :new.id = 2 then
      dbms_output.put_line(:new.email);
      dbms_output.put_line('已经存在此用户');
    end if;
  end;
