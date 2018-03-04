/**
	存储过程：
		是SQL语句和可选控制语句的预编译集合,以一个名称存储并作为一个单元处理.

		用来执行管理任务或封装复杂的业务规则的T-SQL语句组成.

		存放在服务器端,可以通过应用程序来进行调用执行的一个批处理

	优点：
		执行速度快
		数据访问速度更快
		实现多个程序共享应用程序逻辑
		能够屏蔽数据库的结构，实现更高的安全性
		减少网络流通量
*/

/**
	创建存储过程
	CREATE PROC [ EDURE ] procedure_name [ ; number ]    [ { @parameter data_type }        [ VARYING ] [ = default ] [ OUTPUT ]    ] [ ,...n ] 
[ WITH    { RECOMPILE | ENCRYPTION } ] 
[ FOR REPLICATION ] 
AS sql_statement [ ...n ] 

修改存储过程只是把create改成alter，其他语法与create一样

*/
/**
	使用存储过程的限制
	CREATE PROCEDURE定义自身可以包括任意数量和类型的SQL语句，但以下语句除外，不能在存储过程的任何位置使用这些语句，如表所示：
	CREATE AGGREGATE	CREATE RULE
	CREATE DEFAULT	CREATE SCHEMA
	CREATE或ALTER FUNCTION	CREATE或ALTER TRIGGER
	CREATE或ALTER PROCEDURE	CREATE或ALTER VIEW
	SET PARSEONLY	SET SHOWPLAN_ALL
	SET SHOWPLAN_TEXT	SET SHOWPLAN_XML
	USE database_name

	在存储过程内调用的过程可以访问所有在调用过程中创建的对象

	在存储过程中可使用2100个参数

	只要内存空间足够，可以在存储过程中创建任意多个局部变量。

	存储过程的最大大小为128 MB

*/

create procedure proc_all_users
as
begin
	begin transaction
		insert into t_user(email, pwd) values('123@126.com', '123456');
		update t_user set pwd = '654321';
		select * from t_user;
	if @@ERROR <= 0
		begin
			commit transaction
		end;
	else
		begin 
			rollback transaction;
		end;
end;

drop procedure proc_all_users;
go
execute proc_all_users;
go
/**
	参数的使用
*/
drop procedure proc_user_by_email;
go
create procedure proc_user_by_email
	@email varchar(50),
	@pwd varchar(36),
	@id uniqueidentifier output,
	@phone varchar(11) output
as
begin
	select @id = id, @phone = phone from t_user where email = @email and pwd = @pwd;
end;
go
begin
	declare @id uniqueidentifier;
	declare @phone varchar(11);
	execute proc_user_by_email 'abc@126.com', '654321', @id output, @phone output;
	print @id;
	print @phone
end
go
/**
插入数据，如果数据存在，则提示，如果不存在，则插入
*/
drop procedure proc_add_user;
go
create procedure proc_add_user
	@email varchar(50),
	@pwd varchar(36),
	@phone varchar(11),
	@result int output
as
begin
	declare @count int = (select count(id) from t_user where email = @email);
	if @count = 0
		begin 
		--插入
			insert into t_user(email, pwd, phone) values(@email, @pwd, @phone);
			-- set @result = 1;
			select @result = 1;
		end;
	else 
		begin
		--提示
			set @result = 0;
		end;
end;
go
begin
	declare @result int;
	execute proc_add_user 'abcd@126.com', '123456', '18888888888', @result output;
	if @result = 0
		print '用户已经存在';
	else 
		print '添加成功';
end;
go
declare my_cursor cursor
for
select * from t_user;
go

begin
	open my_cursor;
	fetch next from my_cursor;
	close my_cursor
end;
go
create procedure my_proc
as
begin
	open my_cursor;
	fetch next from my_cursor;
	close my_cursor;
end;

execute my_proc;

go
create procedure my_proc1
as
delete from t_user where email = 'abcd@126.com';

go
drop procedure my_proc2;
go
create procedure my_proc2
	@id varchar(36) output,
	@email varchar(50) output
as
select @id = id, @email = email from t_user;
go
execute my_proc2;

go

create proc money_proc
	@money float
as
	begin
	declare @extra float;
	if @money <= 10000
		set @extra = @money * 0.05;
	else if @money > 10000 and @money <= 50000
		set @extra = @money * 0.06;
	else
		set @extra = @money * 0.08;
	insert into t_money(total_money, extra) values(@money, @extra);
	end;
go

exec money_proc 10000000;


