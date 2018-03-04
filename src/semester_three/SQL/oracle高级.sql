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

--���ѯ���û��Ĺ���ˮƽ���������Ϊ�գ���ָ��Ϊ3000Ԫ
select name, nvl(salary, 3000) from t_emp; -- nvl�ѿ�ֵת����ָ����ֵ

select ascii('a') from dual; -- ��ȡascii��
select chr(97) from dual; -- ͨ��ָ����ascii���ȡ�ַ�
select concat('a', 'b') from dual; -- �ַ���������
select INITCAP('veni,vedi,vici') from dual; --���ַ����д

select instr('testabcdafa', 'a', 6, 2) from dual; -- ������1��ʼ   ��ĳ���ַ�����ָ��λ�ÿ�ʼ�����Ӵ����������Ӵ����ֵ�����
select length('dfsdfsdfsdf') from dual; --�����ַ����ĳ���

select lower('ksdlfjAAAFSDfhsdlfkjsdf') from dual; -- ת����Сд
select upper('dfjlkdfjAfdjlfksdfjlkd') from dual; -- ת���ɴ�д
/**
       rpad���뵽�ұߣ�lpad���뵽���
       lpad('tech', 7);       ������' tech'

lpad('tech', 2); ������'te'

lpad('tech', 8, '0'); ������'0000tech'

lpad('tech on the net', 15, 'z'); ������ 'tech on the net'

lpad('tech on the net', 16, 'z'); ������ 'ztech on the net'
*/

/**
   ltrim(x,y) �����ǰ���y�е��ַ�һ��һ���ص�x�е��ַ��������Ǵ���߿�ʼִ�еģ�ֻҪ����y���е��ַ�, x�е��ַ����ᱻ�ص�, ֱ����x���ַ�������y��û�е��ַ�Ϊֹ��������Ž��� .

��c1�����ұߵ��ַ�ȥ����ʹ��ں�һ���ַ�����c2�У����û��c2����ôc1�Ͳ���ı䡣
*/

select replace('uptown', 'up', 'down') from dual;
select substr('uptown', 2, 3) from dual; -- ��ָ��������ʼ��ȡָ���������ַ�

select trim('  sdjflkdj  ') from dual; -- ȥ�����ҿո�


select add_months(sysdate, 1) from dual;
select last_day(add_months(sysdate, 1)) from dual;
select trunc(sysdate, 'yyyy-MM-dd') from dual where 1 = 1; -- ORA-01898 ����˵��������

select to_char(1) from dual;
select to_char(sysdate, 'yyyy-MM-dd HH:mm:ss') from dual; -- ��ʱ�����Ϊָ����ʽ���ַ���
select to_date('2017-06-07', 'yyyy-MM-dd') from dual; -- �ַ���ת����ʱ��

select * from t_user;
set SERVEROUTPUT on; -- �뵽�����������
/**��ʽ�α�*/
 BEGIN  
        UPDATE t_user SET phone='13666666666' WHERE id=3;   
         IF SQL%FOUND THEN    
        DBMS_OUTPUT.PUT_LINE('�ɹ��޸��ֻ��ţ�');   
        COMMIT;    
        ELSE  
        DBMS_OUTPUT.PUT_LINE('�޸��ֻ���ʧ�ܣ�');   
         END IF;    
        END;
        
/**
��ʽ�α�
*/
declare
  v_email varchar2(50);
  v_phone varchar2(11);
  cursor my_cursor is
  select email, phone from t_user where id = 3; 
  begin
    open my_cursor;
    fetch my_cursor into v_email, v_phone;
    dbms_output.put_line(v_email || ', ' || v_phone); -- \\ �ַ���������
    close my_cursor;
  end; 

/**
  ʹ�������α�ѭ���ķ�ʽ�����Զ������͹ر��α�
*/  
declare
  cursor my_cursor_1 is
  select email, phone from t_user; 
  begin
    for user_record in my_cursor_1 loop
        dbms_output.put_line(user_record.email || ', ' || user_record.phone); -- \\ �ַ���������
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
      dbms_output.put_line(v_email || ', ' || v_phone); -- \\ �ַ���������
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

create table t_user_his as select * from t_user; -- t_user_his�ı�ṹ��t_user��һ�£���ʵ�ѱ����ݷŵ�user����
select * from t_user_his;
drop table t_user_his;

create table C##NAME.t_user_his as select * from C##NAME.t_user_ori where 1 = 2;

create or replace trigger tri_user
before insert or delete or update
on C##NAME.t_user_ori
for each row
  begin
    insert into C##NAME.t_user_his values(:old.id, :old.email); -- ����update��delete����old
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
      dbms_output.put_line('�Ѿ����ڴ��û�');
    end if;
  end;
