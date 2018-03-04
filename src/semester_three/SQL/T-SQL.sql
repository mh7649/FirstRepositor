/**
1��������
	�Ѷ��������ϵ�һ���ļ��У�����ִ�д��ļ��е��������
	���ļ���֮Ϊ�������ļ�

	windowsƽ̨��dos���bat�ļ�
	linuxƽ̨��shell�ű����sh�ļ�

	SQL Server��sql�������ļ���sql�ļ�

2��T-SQL,Transact SQL ΢��˾���ڱ�׼��SQL��չ��һ��SQL�����������
*/
use xinwen;--ʹ���ĸ����ݿ�
go
/**������Ѵ��ڣ���ɾ���˱����´���*/
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
ϵͳ������
@@��ͷ
@@version �汾
@@ERROR ���һ��sql�Ĵ���ţ�û�д����򷵻�0
@@LANGUAGE		��ǰʹ�õ����Ե�����
@@MAX_CONNECTIONS	���Դ�����ͬʱ���ӵ������
@@ROWCOUNT		����һ�� SQL ���Ӱ�������
@@SERVERNAME		���ط�����������
@@SERVICENAME		�ü�����ϵ� SQL ���������
@@TIMETICKS		��ǰ�������ÿָ�����ڵ�΢����
@@TRANCOUNT		��ǰ���Ӵ򿪵�������
@@CURSOR_ROWS		����򿪵��α��е�����
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
�����������븳ֵ
*/
begin
	declare @var_a int;
	declare @var_b varchar(50);
	set @var_a = 10;
	set @var_b = 'test';
	select @var_a;
	select @var_b;

	declare @var_c int = 100; --�����Ӹ�ֵ
	declare @var_d varchar(50) = 'test';
	select @var_c;
	select @var_d;

	select @var_a + @var_c;
	select @var_b + @var_d;
	select substring(@var_b, 1, 2); -- �ַ�����1��ʼ
end;

/**
	���飺begin...end��Χ��������c��java��{}
*/

/**
	������֧�ṹ��
	if
		begin
			����
		end;
	else if 
		begin
			����
		end;
	else
		begin
			����
		end;
*/
begin
	declare @var int = 60;
	if @var > 100
		begin
			print '����>100';
			print 'test';
		end;
	else if @var > 50
		begin
			print '����>50��<=100';
		end;
	else
		begin
			print '����!>100';
		end;
end;

/**
	while����ѭ��
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
	goto��ת��ָ���ı�ǩ������Ҫ����
*/
begin
	label:print 'test';
	print 'test1';
	return;--ֱ�ӽ������������
	goto label;
end;

/**
	case����
	case:when:then
*/
begin
	select *, 
	case classify 
		when '����' then '���±���'
		when '����' then '����ͷ��'
	end 
	from classify;
end;

/**
	waitfor delay 'ʱ���֣���'
	waitfor time 'ʱ���֣���'
*/
begin
	print '���';
	waitfor delay '0:0:10'; -- �ӳ�ָ��ʱ��
	print '����';
end;

/**
	����(transaction)��һϵ��������Ĳ��裬ֻ�е����в��趼�ɹ��ˣ��˼��������ɹ��������һ������
	ʧ���ˣ���˼�����ʧ�ܡ���ʧ���ˣ��ع���rollback�������ݿ�ԭʼ״̬
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
		rollback; -- �ع����ݿ�
	end catch
end;