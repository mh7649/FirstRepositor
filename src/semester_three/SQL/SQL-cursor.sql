/**
	游标：
	1）游标实际上是一种能将多条数据记录的结果集中每次提取一条记录的机制
	2）游标提供了一种对从表中检索出的数据进行操作(获取，更新，删除)的灵活手段

	DECLARE <cursor_name> CURSOR [insensitive][scroll] FOR 
	Select statement


	DECLARE  <Cursor_Name> CURSOR 
	[LOCAL | GLOBAL]	 
	[FORWARD ONLY | SCROLL] 
	[STATIC | KEYSET | DYNAMIC |FAST_FORWARD] 
		   [READ_ONLY | SCROLL_LOCKS ]
	[TYPE_WARNING] 
	FOR <Select Statements> 
	[FOR READ ONLY|UPDATE [OF Column_name[,….N]]]

	创建游标时，如果没有添加游标的任何选项，而是使用默认值，则此游标默认为只进游戏
	forward_only,fetch first（抓取第一个）, fetch prior（抓取上一个）都不能使用

	游标的两个常用系统变量：
	@@fetch_status提取状态：
	 0表示提取成功
	 -1表示提取失败或不存在结果集中
	 -2表示提取的行不存在
	@@cursor_rows表示游标结果集的总行数
*/
DEALLOCATE my_cursor;
begin
	declare my_cursor cursor global scroll static for
	select id, email from t_user;

	declare @id uniqueidentifier; -- 声明了一个uniqueidentifier类型的变量，用于接收游标的第一个字段
	declare @email varchar(18);

	open my_cursor;
	declare @count int = 0;

	while @count < @@CURSOR_ROWS
		begin
			fetch next from my_cursor into @id, @email; -- 把查询的结果放入到指定的变量中，并且保持与select语句的字段顺序的一致
			print @id;
			print @email;
			set @count = @count + 1;
		end;
	close my_cursor;
end;

declare my_cursor1 cursor for
select * from t_user;


begin
	declare my_cursor2 cursor scroll for 
	select id, email, phone from t_user;

	open my_cursor2;
	fetch next from my_cursor2;
	fetch next from my_cursor2;
	fetch first from my_cursor2;
	fetch last from my_cursor2;
	fetch prior from my_cursor2;

	fetch absolute 2 from my_cursor2; -- 如果指定的行号大于总行数，则返回空结果
	fetch absolute -1 from my_cursor2; -- 如果n为负整数，则提取游标最后一行之前的第n行
	fetch absolute 0 from my_cursor2; -- 如果指定的行号为0，则返回空结果

	fetch first from my_cursor2; -- 1
	fetch relative 1 from my_cursor2; -- 2  相对于上一次游标的位置向前走指定行
	fetch relative -1 from my_cursor2; -- 1 相对于上一次游标的位置向后走指定行
	fetch relative 0 from my_cursor2; -- 1 同一行

	close my_cursor2;
	DEALLOCATE my_cursor2;
end;

begin
	declare my_cursor3 cursor for
	select * from t_user;

	open my_cursor3;
	fetch next from my_cursor3; -- 提取下一行记录，游标指向第一行
	update t_user set phone = '18888888888' where current of my_cursor3; -- 更新游标当前行的phone字段 
	fetch next from my_cursor3;
	update t_user set phone = '16666666666' where current of my_cursor3;
	delete from t_user where current of my_cursor3; -- 把游标指向的当前行删除

	close my_cursor3;
	deallocate my_cursor3;
end;