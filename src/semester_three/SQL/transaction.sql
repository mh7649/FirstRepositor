
/** 
 1������
	һ�������ɶ��������ɣ��������һ������ʧ�ܣ��������������ʧ�ܵģ�������Ҫ
	�ع���ԭʼ״̬��ֻ�е����в��趼�ɹ����������������ɹ�����ʱ�ſ����ύ��
	��֮Ϊ����

	�ŵ����ݿ��Σ�ÿһ�����趼���Կ�����һ��sql��䣬ֻ�����е�sql��䶼�ɹ����ſ����ύ��
	���ݿ⣬�������ݿ���Ҫ�ع�
 
 2������Ļ���������
	1��ԭ���ԣ������е�ÿһ�����趼�ǲ��ɲ�ֵ�
	2��һ���ԣ���֤���ݵ�һ����
	3�������ԣ�ͬһʱ���ִ�ж������ÿ�����񻥲�����
	4���־��ԣ�����ִ�гɹ��÷�ӳ�����ݿ�


3�������һЩ���⣺
	��ʧ�򸲸Ǹ���

	δȷ�ϵ������(���)

	��һ�µķ��������ظ�����


���䣺
	1��������ͬһʱ���ִ�ж�����飨NIO, Netty, Mina��
	2�����ݳ־û��������ݱ��浽���ݿ��еĹ���
*/
SET XACT_ABORT ON; -- �����쳣��������
begin
	begin try
		begin tran
			insert into classify(classify) values('sdjflksdjflksdfjlksdjflksdfjlksdfjlksdfjlsdkfjlksdfjlksdfj');
			insert into classify(classify) values('10000');
		commit tran;
	end try
	begin catch
		rollback
	end catch
end;

begin
	begin transaction my_tran -- my_tranΪ����Ļع��㣬����ʼʱ���״̬
		insert into classify(classify) values('������fsfsdfsdfsdfsdfsdfdfsdfsdfsdfsd');
		insert into classify(classify) values('��Ӱ');
	if @@ERROR > 0
		begin
			print @@ERROR;
			rollback transaction my_tran; -- �������Ŵ���0����˵�������д���Ӧ�ûع�
		end;
	else
		begin
			commit transaction; -- ��������ִ�гɹ����ύ����
		end;
end;