/**
1、批处理
	把多个命令组合到一个文件中，批量执行此文件中的所有命令。
	此文件称之为批处理文件

	windows平台，dos命令：bat文件
	linux平台，shell脚本命令：sh文件

	SQL Server，sql批处理文件，sql文件

2、T-SQL,Transact SQL 微软公司基于标准的SQL扩展的一套SQL程序设计语言
*/
use xinwen;--使用哪个数据库
go
/**如果表已存在，则删除此表，重新创建*/
create table t_test (
	id int primary key,
	test varchar(50) not null
);
go
insert into t_test(id, test) values(1, 'test');
go
select * from t_test;
go
/**
系统变量：
@@开头
@@version 版本
@@ERROR 最后一个sql的错误号，没有错误则返回0
@@LANGUAGE		当前使用的语言的名称
@@MAX_CONNECTIONS	可以创建的同时连接的最大数
@@ROWCOUNT		受上一个 SQL 语句影响的行数
@@SERVERNAME		本地服务器的名称
@@SERVICENAME		该计算机上的 SQL 服务的名称
@@TIMETICKS		当前计算机上每指令周期的微秒数
@@TRANCOUNT		当前连接打开的事务数
@@CURSOR_ROWS		最近打开的游标中的行数
*/
select @@VERSION;
go
select @@error;
go
select @@CPU_BUSY;
go
select @@SERVERNAME;
go 
select @@SERVICENAME;

/**
变量的声明与赋值
*/
begin
	declare @var_a int;
	declare @var_b varchar(50);
	set @var_a = 10;
	set @var_b = 'test';
	select @var_a;
	select @var_b;

	declare @var_c int = 100; --声明加赋值
	declare @var_d varchar(50) = 'test';
	select @var_c;
	select @var_d;

	select @var_a + @var_c;
	select @var_b + @var_d;
	select substring(@var_b, 1, 2); -- 字符串从1开始
end;

/**
	语句块：begin...end包围，类似于c或java中{}
*/

/**
	条件分支结构：
	if
		begin
			语句块
		end;
	else if 
		begin
			语句块
		end;
	else
		begin
			语句块
		end;
*/
begin
	declare @var int = 60;
	if @var > 100
		begin
			print '变量>100';
			print 'test';
		end;
	else if @var > 50
		begin
			print '变量>50且<=100';
		end;
	else
		begin
			print '变量!>100';
		end;
end;

/**
	while条件循环
*/
begin
	declare @var int = (select id from t_test);
	while @var > -5
		begin 
			print @var;
			set @var = @var - 1;
		end;
end;

begin
	declare @var int = 5;
	while 1 = 1
		begin
			print @var;
			set @var = @var - 1;
			if @var = 0
				begin
					break;
				end;
		end;
end;

begin
	declare @var int = 5;
	while 1 = 1
		begin
			set @var = @var - 1;
			if @var = 1
				begin
					continue;
				end;
			print @var;
			if @var = -1
				begin
					break;
				end;
		end;
end;

/**
	goto跳转到指定的标签处。不要乱用
*/
begin
	label:print 'test';
	print 'test1';
	return;--直接结束整个程序块
	goto label;
end;

/**
	case语句块
	case:when:then
*/
begin
	select *, 
	case classify 
		when '军事' then '军事别名'
		when '娱乐' then '娱乐头条'
	end 
	from classify;
end;

/**
	waitfor delay '时：分：秒'
	waitfor time '时：分：秒'
*/
begin
	print '你好';
	waitfor delay '0:0:10'; -- 延迟指定时间
	print '不好';
end;

/**
	事务(transaction)：一系列做事情的步骤，只有当所有步骤都成功了，此件事情才算成功，如果有一个步骤
	失败了，则此件事情失败。当失败了，回滚（rollback）到数据库原始状态
*/
SET XACT_ABORT ON;
go
begin
	begin try
		begin tran -- transaction
			insert into t_test(id, test) values(5, 'test');
			insert into t_test(id, test) values('11', 11);
		commit tran
	end try
	begin catch
		rollback; -- 回滚数据库
	end catch
end;