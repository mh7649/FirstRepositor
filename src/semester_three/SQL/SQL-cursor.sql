/**
	�α꣺
	1���α�ʵ������һ���ܽ��������ݼ�¼�Ľ������ÿ����ȡһ����¼�Ļ���
	2���α��ṩ��һ�ֶԴӱ��м����������ݽ��в���(��ȡ�����£�ɾ��)������ֶ�

	DECLARE <cursor_name> CURSOR [insensitive][scroll] FOR 
	Select statement


	DECLARE  <Cursor_Name> CURSOR 
	[LOCAL | GLOBAL]	 
	[FORWARD ONLY | SCROLL] 
	[STATIC | KEYSET | DYNAMIC |FAST_FORWARD] 
		   [READ_ONLY | SCROLL_LOCKS ]
	[TYPE_WARNING] 
	FOR <Select Statements> 
	[FOR READ ONLY|UPDATE [OF Column_name[,��.N]]]

	�����α�ʱ�����û������α���κ�ѡ�����ʹ��Ĭ��ֵ������α�Ĭ��Ϊֻ����Ϸ
	forward_only,fetch first��ץȡ��һ����, fetch prior��ץȡ��һ����������ʹ��

	�α����������ϵͳ������
	@@fetch_status��ȡ״̬��
	 0��ʾ��ȡ�ɹ�
	 -1��ʾ��ȡʧ�ܻ򲻴��ڽ������
	 -2��ʾ��ȡ���в�����
	@@cursor_rows��ʾ�α�������������
*/
DEALLOCATE my_cursor;
begin
	declare my_cursor cursor global scroll static for
	select id, email from t_user;

	declare @id uniqueidentifier; -- ������һ��uniqueidentifier���͵ı��������ڽ����α�ĵ�һ���ֶ�
	declare @email varchar(18);

	open my_cursor;
	declare @count int = 0;

	while @count < @@CURSOR_ROWS
		begin
			fetch next from my_cursor into @id, @email; -- �Ѳ�ѯ�Ľ�����뵽ָ���ı����У����ұ�����select�����ֶ�˳���һ��
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

	fetch absolute 2 from my_cursor2; -- ���ָ�����кŴ������������򷵻ؿս��
	fetch absolute -1 from my_cursor2; -- ���nΪ������������ȡ�α����һ��֮ǰ�ĵ�n��
	fetch absolute 0 from my_cursor2; -- ���ָ�����к�Ϊ0���򷵻ؿս��

	fetch first from my_cursor2; -- 1
	fetch relative 1 from my_cursor2; -- 2  �������һ���α��λ����ǰ��ָ����
	fetch relative -1 from my_cursor2; -- 1 �������һ���α��λ�������ָ����
	fetch relative 0 from my_cursor2; -- 1 ͬһ��

	close my_cursor2;
	DEALLOCATE my_cursor2;
end;

begin
	declare my_cursor3 cursor for
	select * from t_user;

	open my_cursor3;
	fetch next from my_cursor3; -- ��ȡ��һ�м�¼���α�ָ���һ��
	update t_user set phone = '18888888888' where current of my_cursor3; -- �����α굱ǰ�е�phone�ֶ� 
	fetch next from my_cursor3;
	update t_user set phone = '16666666666' where current of my_cursor3;
	delete from t_user where current of my_cursor3; -- ���α�ָ��ĵ�ǰ��ɾ��

	close my_cursor3;
	deallocate my_cursor3;
end;