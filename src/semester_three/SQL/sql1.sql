/**
 SQL Server Management Studio
 GUI�������ڹ���Ͳ������ݿ⼰���ݿ����

 ���ݿ����棺һ��SQLServer���ݿ�ϵͳ�������ö�����ݿ����棬����Ĭ��ֻ��һ��MSSQLSERVER

���ݿ����Ҫ����ʹ��SQL Server�������ݿ�����������
win+x->���������->�����Ӧ�ó���->����->SQL��ͷ�ķ���
�Ҽ��ҵĵ���->����->�����Ӧ�ó���->����->SQL��ͷ�ķ���

SQLServer�����ù�������Ҳ���ԶԷ�����й�������������Э����й���

����ƣ��������������Ʒ�µ�����
����ƣ��ֱ�΢���Ŷӣ�ÿ���˶����Խ��н��������ۣ���¼����������������

ERͼ��Entity, Relation   ʵ���ϵͼ 
	PowerDesigner, Microsoft Visio(ͼ�λ���)
	���α�ʾʵ��
	�E�A��ʾ����
	���α�ʾ��ϵ
	������

���ݿ���Ʒ�ʽ��
1NF��һ��ʽ��ÿһ���ֶζ����ɷָ�(ԭ����)
2NF�ڶ���ʽ����������������. 
	������ 1NF������������������ݣ�һ�Ǳ������һ������(���ؼ���)��
	����û�а����������е��б�����ȫ������������������ֻ������������һ����
3NF������ʽ�������ϵģʽR��U��F���е����з������Զ����κκ�ѡ�ؼ��ֶ������ڴ�����������ƹ�ϵR���ڵ�����ʽ

����ԭ��
	1��������ϵ������(�����������������)+���)
	2����������������
	3���ֶβ��ɷָ�

����
	�����һ������ͷ�����ŷ���ϵͳ�����ݿ��
	1������ͷ���и��˳䵱��ý��
	2�����ŷ���
	3����ý����Է������ţ���������ʱֱ��ѡ�����ŷ���
	4�����ſ��Է�������

	ERͼ������������Ƴ���

*/

/******************************************
SQL�߼���ѯ 
�Ӳ�ѯ��
*/
insert into t_user(email, pwd) values('abc@126.com', '123456');
insert into t_user(email, pwd) values('bcd@126.com', '123456');

insert into classify(classify) values('����');
insert into classify(classify) values('����');
insert into classify(classify) values('����');

insert into news(user_id, classify_id, title) values('2f3009b2-35e9-481a-9105-10142014f5b1', '49d10b5d-47cd-4ec8-a02a-1fec67bd59a6', '�����Ʋ�');
insert into news(user_id, classify_id, title) values('6B0DE1E5-C663-4AB8-84A8-FFFFFFC86FD4', '3da1b2aa-a630-4713-9e7c-648eaec7b591', 'ëƬ');

/**
���ѯ������Ϊ���ֵ���������
*/
select n.* from news n, classify c where n.classify_id = c.id and c.classify = '����';

/**
= ��ʹ�õ����Ӳ�ѯ��ʹ�ò�ѯ�Ľ����Ϊ������=����Ӳ�ѯֻ�ܷ��ص��������������ض�������
��Ӧ��ʹ��in
*/
select * from news where classify_id != (select id from classify where classify = '����');

/**
���ѯ������Ϊ���ֺ͹��ʵ���������
*/
select * from news where classify_id 
in (select id from classify where classify = '����' or classify = '����');

/**
���ѯ�����˹������ŵ��û���Ϣ
*/
select u.* from t_user u, classify c, news n where 
u.id = n.user_id and n.classify_id = c.id and c.classify = '����';

select * from t_user where id = 
(select user_id from news where classify_id =
(select id from classify c where c.classify = '����'));

/**
 �����й������ŵ�������Ϣ�����ó�abc
*/
update news set des = 'abc' where classify_id = (select id from classify where classify = '����');

/**
ɾ�����з���Ϊ���ʵ�����
*/
delete from news where classify_id = (select id from classify where classify = '����');

insert into news(user_id, classify_id, title) values('2f3009b2-35e9-481a-9105-10142014f5b1', (select id from classify where classify = '����'), 'һ��һ·�й�');

/****************************************
	���Ӳ�ѯ
	where����   ������

	join
	������ inner join��ֱ��дjoin����Ĭ�Ͼ���inner join
	������
		��������:��left join��ߵı�Ϊ�����ұߵı�Ϊ�α�
			������������û�г����ڴα��У�����������ݲ�ѯ���������α��������NULL����
		��������:��right join�ұߵı�Ϊ������ߵı�Ϊ�α�
			������������û�г����ڴα��У�����������ݲ�ѯ���������α��������NULL����
		ȫ�����ӣ�full join �ۺ�������������ӵ����
	�������ӣ�cross join �ѿ�����
*/

/**
���ѯ�����е�����(�������ߺ����ŷ���)
*/
select n.*, u.email, c.classify from 
news n, t_user u, classify c 
where n.user_id = u.id and n.classify_id = c.id;

select n.*, u.email, c.classify from news n inner join t_user u on n.user_id = u.id
inner join classify c on n.classify_id = c.id;

/**
	���ѯ������Ϊ���ʵ���������
*/
select n.* from news n, classify c where n.classify_id = c.id and c.classify = '����';

select n.* from news n join classify c on n.classify_id = c.id and c.classify = '����';

/**
	��ѯ�������˷�������������
*/
select * from news n join t_user u on n.user_id = u.id;

select * from news n left outer join t_user u on n.user_id = u.id;

select * from news n right outer join t_user u on n.user_id = u.id;
select * from t_user u left outer join news n on n.user_id = u.id;

select * from t_user u cross join news n;

/**
exists �ؼ���
�ж��Ƿ���ڣ����ص���true����false

�Ժ�ʹ�õ�in��not in�����˼��һ���ܷ�ʹ��exists��not exists
*/

select n.* from news n where n.classify_id in (select id from classify);

/**
��ѯ�з��������ŵ��û�
*/

/**
 t_user
 1
 2
 3
 4
 5

 news user_id
 2
 3
 4

 5 * 3 = 15 �αȽϣ� �ⲿ��t_userÿ����¼����ѯ��һ�飬�ܹ���ѯ��5��t_user
*/
select u.* from t_user u where u.id in(select user_id from news);

/**
 t_user
 1
 2
 3
 4
 5

 news user_id
 2
 3
 4

 1 == 1 ? N 
 2 == 2 ? Y   ��ѯһ��t_user
 3 == 3 ? Y   ��ѯһ��t_user
 4 == 4 ? Y   ��ѯһ��t_user
 5 == 5 ��N   

 �ܹ�ֻ��ѯ��3��t_user
 
*/
select u.* from t_user u where exists(select user_id from news where news.user_id = u.id);
/**
��ѯû�з��������ŵ��û�
*/
select u.* from t_user u where not exists(select user_id from news where news.user_id = u.id);

/**
	union�ؼ��ֿ��԰Ѷ����ѯ�Ľ�����ϵ�һ��
	ǰ�������������ѯ�ı���ֶ���Ҫһ�£���ѯ���Ľ����������Ĭ��Ϊ��һ����ѯ��������
*/
select u.* from t_user u where u.email = 'abc@126.com'
union
select u.* from t_user u where u.email = 'bcd@126.com';

select t_1.* from t_1
union
select t_2.* from t_2;

/**************************************************
����

�����Ƕ����ݿ����һ�������е�ֵ��������Ľṹ
�����ṩָ����ָ��洢�ڱ���ָ���е�����ֵ��Ȼ�����ָ�����������������Щָ�� 

�����ܹ����ӷ�����ٵز�ѯ���ݿ��¼
�����ֶ�Ĭ������������ֶΣ�ͨ�������ֶ�ȥ��ѯ���ݿ⣬������Ч��������ѯЧ��

Ϊ��������ѯЧ�ʣ��б�Ҫ�Բ����ֶ��������
1����������where������ֵ
2���������������ݸ��µ��ֶ�������������ݵĸı�ᵼ�����ݿ����½���������

�����ķ��ࣺ
1���ۼ�������clusteredһ��ָ���������������и��е�����˳�����ֵ���߼���������˳����ͬ����ֻ�ܰ���һ���ۼ�����
2���Ǿۼ�����(nonclustered)ָ������߼�˳��һ�������ֻ����249���Ǿۼ�����
*/
select * from t_user where id = '2f3009b2-35e9-481a-9105-10142014f5b1';

/**
 Ϊ�ֶδ�������
*/
create index idx_user_email on t_user(email);
select * from t_user where email = '1232372001@qq.com';

create index idx_user_name_phone on t_user(name, phone);

/**ɾ������*/
drop index t_user.idx_user_email;

/**
�������������
fillfactorĬ��Ϊ0��������������ҳ��ʱ�������ҳ��
*/
create index idx_user_pwd on t_user(pwd) with fillfactor = 5;

/**
ͨ��sysindexesϵͳ��ͼ���Բ�ѯ�����ݿ��������Ϣ
*/
select * from sysindexes where name = 'idx_user_email';

/**ͨ��sp_helpindex�洢���̲鿴ָ��������*/
sp_helpindex t_user;

/**
�����ݱ����Ҽ�ѡ��ȫ�ļ���������ȫ�ļ���
ȫ�ļ���*/
select * from t_user where contains(email, '"com"');
select * from t_user where freetext(email, '"com"');

/****************************************
 ��ͼ
 ͶӰ��һ��select����ѯ���Ľ�����뵽����һ�ű��У����ű�����֮Ϊtemp��
		select * from temp; ======> ӳ���ԭʼ��sql���
		tempͶӰ���֮Ϊ��ͼ����ͼ��һ�������

���ݵ���Դ���֮Ϊ����

	select�ܸ��ӣ����ø���Ȥ���ֶδ�ʱ���Բ�����ͼ

��ͼ�����ã�
	ɸѡ���е�һЩ��������

	��ֹ�û�����δ����ɵ�����.

	�����ݵĲ���

��������
	1��������ͼ��select��䲻��ʹ��order by��Ҳ����ʹ��into���
	2���������ֻ��һ���������ͨ����ͼ�����£����룬ɾ�����ݣ��ᷴӦ������
	3����������Ƕ������Ҫ����ͼ���в��룬���£�ɾ������


*/
/**
���ѯ�����е�����(�������ߺ����ŷ���)
*/
select n.*, u.email, c.classify from news n join t_user u on n.user_id = u.id
join classify c on n.classify_id = c.id;

go;

create view all_news as
(select n.*, u.email, c.classify from news n join t_user u on n.user_id = u.id
join classify c on n.classify_id = c.id);
go;

select * from all_news order by classify;

go;

create view all_news_1 as select * from all_news;
go;
select * from all_news_1;

go;
create view view_classify as select * from classify;
go;
select * from view_classify;

insert into view_classify(classify) values('����');
update view_classify set classify = '���' where id = 'DC79AEC4-A5F4-479A-81AB-760B0503302B';
delete from view_classify where classify = '���';
go;

create view my_view as select * from t_user;
go;
alter view my_view as select * from news;
go;
select * from my_view;
drop view my_view;

/**ͨ��sys.all_views��ͼ�鿴���ݿ��������ͼ*/
select * from sys.all_views where name = 'all_news';

/*************************
�ۺϺ�������һ��ֵ���в��������ص�һ�Ļ���ֵ
�����������Ե�һֵ���в��������ص�һֵ��
�ַ�����������ѧ�����ݣ�ϵͳ������ʱ�����ں��������ڱ�������
�����������Լ�¼��ÿ�н�������
�м��������������һ��ʹ�ã��������ض���

�ۺϺ���
count()
max()
min()
avg()
sum()

getdate( )���ص�ǰϵͳ���ں�ʱ��
select getdate()

dateadd( )���ظ�ָ�����ڼ���һ��ʱ�����������
select dateadd(month,3,getdate())

datediff( )���ؿ�����ָ�����ڵ����ڼ������ʱ������
select datediff(day,��2007-4-3��,'2007-4-9')

datename( )���ر�ʾָ�����ڵ�ָ�����ڲ��ֵ��ַ���
select datename(year,getdate())

datepart( )ָ��Ҫ���ص����ڲ��ֵĲ��� 
select datepart(month,getdate())

day��month��yearָ���ڵĲ���

��ѧ������
ABS(����ֵ)	DEGREES	RAND���������
ACOS	EXP	ROUND���������룩
ASIN	FLOOR	SIGN
ATAN	LOG	SIN
ATN2	LOG10	SQRT��������
CEILING	PI	SQUARE��ƽ����
COS	POWER��n�η���	TAN
COT	RADIANS	

�ַ���������
ASCII()תasciiֵ	NCHAR()����ncharֵ	SOUNDEX()
CHAR()ת�ַ�ֵ	PATINDEX()�������ַ�����һ�γ��ֵ�λ��	SPACE()
CHARINDEX()	QUOTENAME()��ӷָ���	STR()
DIFFERENCE()	REPLACE()�滻����	STUFF()
LEFT()����߽�	REPLICATE()	****SUBSTRING()���Ӵ�
***LEN()���س���	REVERSE()��ת	UNICODE()����unicode����
****LOWER()תСд	RIGHT()���ұ߽�	****UPPER()ת��д
LTRIM()�����ȥ�Ӵ�	RTRIM()����ȥ�Ӵ�

����ת������
convert(type, column_name);

*/
select GETDATE();
select dateadd(month,3,getdate());
select datediff(day, '2017-4-3', '2017-4-9');
select datename(day,getdate());
select datepart(month,getdate());

select ROW_NUMBER() over(order by id), * from t_user; 
select rank() over(order by id), * from t_user; 

select sqrt(4);
select power(2, 10);
select pi();
select SQUARE(8);

/**
	SQL Server�İ�ȫ����
	1�������֤��windows, SQL Server
	2�������û���
		a��GUI����  ��ȫ��-����¼��-���½���¼������ʱ�������û���û��Ȩ��ȥ������ص����ݿ⣩
		b�����CREATE LOGIN [wang] WITH PASSWORD='123456', DEFAULT_DATABASE=[xinwen], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
		c��sp_addlogin 'test','123456';


	Ȩ��:add_user, delete_user, update_user, query_all_user
	��ɫ:admin, normal_user
	�û�:abc@126.com, abc@qq.com, abc@126.com  admin   abc@qq.com  normal_user

	Ȩ�޿��԰󶨵���ɫ����һ����ɫ����ӵ�ж��Ȩ��
	�û����԰󶨵�ʱ��ɫ����һ����ɫ����ӵ�ж���û�

	��ɫ��
	sysadminϵͳ����Ա��ӵ�����е�Ȩ�ޣ�
	public�����Ľ�ɫ������ûʲôȨ�ޣ�
	db_owner���ݿ�ӵ����

	1�����û�ָ����ɫ
		sa�˺Ų������û����ϵ���Ҽ�-������-����������ɫ-����ѡ��Ҫ�Ľ�ɫ

	2)���û�ָ��Ȩ��
		sa�˺Ų������������ݿ�-������-��Ȩ��-���鿴������Ȩ�ޣ�����ָ��ǰ���ݿ��Ȩ�ޣ�
		-��ѡ���û�-����ѡȨ��-��ȷ��

		sa�˺Ų������û������Ҽ����-������-���û�ӳ��-��ѡ����Ҫ�����ݿ�
		-��test1->db_owner   (��ĳ���û�ӵ��ĳ�����ݿ�a)

		sa�˺Ų�����a���ݿ��Ҽ����-������-��Ȩ��-�������û�-��ѡ���û�-������Ȩ��
		
		sa�˺Ų�����ѡ��a���ݿ��е�ĳ����-������-��Ȩ��-������Ȩ��-������ܾ������¾ܾ�

		grant:��Ȩ
		revoke:ȡ����Ȩ

		grant Ȩ�ޣ�update, delete, select, insert�� on table (column) to user;
*/

