/**
触发器的基本概念：
	一种特殊的存储过程.	只针对特定的事件进行响应执行,不需要去进行调用执行.	由一些T-SQL语句构成,完成特定的业务规则.分类：	DDL触发器：create, drop, alter	DML触发器：update, delete, insertdeleted表和inserted表：	触发器可以访问两个逻辑表—inserted、deleted表	deleted表存放由于执行delete或update语句而要从表中删除的所有行。 	inserted表存放由于执行insert或update语句而要向表中插入的所有行	执行插入操作时：		INSERT 触发器执行下列操作：			向Inserted表中插入一个新行的副本。			检查Inserted逻辑表确定是否要阻止该插入操作。			如果所插入的行中的值是有效的，则将该行插入到触发器表中。
*/
use xinwen;
go
create trigger db_safe
on database
for
	DROP_TABLE,ALTER_TABLE,CREATE_TABLE
as
	print '不能对数据库进行创建表，删除表，修改表的操作';
	rollback transaction;

create table test_1(
	id int primary key
);

drop table t_user;

go
create trigger table_safe
on t_user --指定具体的表或视图。如果是对视图添加触发器，则for改写成instead of
for
	delete, update, insert -- 支持多个触发事件
as
	print '不能对表进行删除，更新，插入操作';
	rollback tran;

delete from t_user;

drop trigger table_safe;

go
create trigger insert_user
on t_user
for insert
as
	if (select pwd from inserted) = '123456'
		begin
			print '密码太简单';
			rollback tran;
		end;
	else
		print '插入成功';

insert into t_user(email, pwd) values('abcdef@qq.com', '123456'); 

go
create trigger delete_user
on t_user
for delete
as 
	if (select email from deleted) like '%@126%' 
		begin
			print '不能删除126邮箱的记录';
			rollback tran;
		end;
	else
		print '删除成功';

drop trigger delete_user;

select * from t_user;
delete from t_user where email = '123@126.com';

go
create trigger update_user
on t_user
for update
as
 if (select email from inserted) like '%@qq.com%'
	begin
		print '拒绝QQ邮箱！';
		rollback;
	end;
else 
	print '更新成功';

update t_user set email = 'abcd@qq.com' where email = 'test1@qq.com'; 

go
create view view_user
as
	select * from t_user;
go
create trigger view_user_tri
on view_user
instead of update
as
	if (select email from inserted) like '%@qq.com%'
		begin
			print '拒绝QQ邮箱！';
			rollback;
		end;
	else 
		print '更新成功';

go
create trigger update_user_email
on t_user
for update
as 
	if update(email) -- 判断是否对指定的字段进行了更新
		begin
			print '不能更新邮箱';
			rollback tran;
		end;

update t_user set email = 'abc' where email = 'bcd@126.com';

/**
	查看用户定义的所有触发器及触发事件
*/
select * from sys.triggers;select * from sys.trigger_eventsselect * from sys.triggers t, sys.trigger_events e where e.object_id = t.object_id;/**	禁用与激活触发器	DISABLE|ENABLE TRIGGER {trigger_name |ALL } on {object_name|database|all server}*/disable trigger db_safe on database;enable trigger db_safe on database;

