/**
 SQL Server Management Studio
 GUI工具用于管理和操作数据库及数据库对象

 数据库引擎：一个SQLServer数据库系统可以配置多个数据库引擎，但是默认只有一个MSSQLSERVER

数据库服务：要正常使用SQL Server，则数据库服务必须启动
win+x->计算机管理->服务和应用程序->服务->SQL开头的服务
右键我的电脑->管理->服务和应用程序->服务->SQL开头的服务

SQLServer的配置管理器中也可以对服务进行管理，还可以网络协议进行管理

表设计：电子商务，完成商品下单功能
表设计：手表微商团队，每个人都可以进行进货，销售，记录进货情况及销售情况

ER图：Entity, Relation   实体关系图 
	PowerDesigner, Microsoft Visio(图形绘制)
	方形表示实体
	橢圓表示属性
	菱形表示关系
	连接线

数据库设计范式：
1NF第一范式：每一个字段都不可分割(原子性)
2NF第二范式：不包含部分依赖. 
	首先是 1NF，另外包含两部分内容，一是表必须有一个主键(主关键字)；
	二是没有包含在主键中的列必须完全依赖于主键，而不能只依赖于主键的一部分
3NF第三范式：如果关系模式R（U，F）中的所有非主属性对于任何候选关键字都不存在传递依赖，则称关系R属于第三范式

基本原则：
	1）关联关系（主键(尽量不出现组合主键)+外键)
	2）不出现数据冗余
	3）字段不可分割

任务：
	请设计一个今日头条新闻发布系统的数据库表
	1）今日头条有个人充当的媒体
	2）新闻分类
	3）自媒体可以发表新闻，发表新闻时直接选择新闻分类
	4）新闻可以发表评论

	ER图画出来，表设计出来

*/

/******************************************
SQL高级查询 
子查询：
*/
insert into t_user(email, pwd) values('abc@126.com', '123456');
insert into t_user(email, pwd) values('bcd@126.com', '123456');

insert into classify(classify) values('军事');
insert into classify(classify) values('娱乐');
insert into classify(classify) values('国际');

insert into news(user_id, classify_id, title) values('2f3009b2-35e9-481a-9105-10142014f5b1', '49d10b5d-47cd-4ec8-a02a-1fec67bd59a6', '星罗云布');
insert into news(user_id, classify_id, title) values('6B0DE1E5-C663-4AB8-84A8-FFFFFFC86FD4', '3da1b2aa-a630-4713-9e7c-648eaec7b591', '毛片');

/**
请查询出分类为娱乐的所有新闻
*/
select n.* from news n, classify c where n.classify_id = c.id and c.classify = '娱乐';

/**
= 后使用的是子查询，使用查询的结果作为条件。=后的子查询只能返回单个结果，如果返回多个结果，
则应该使用in
*/
select * from news where classify_id != (select id from classify where classify = '娱乐');

/**
请查询出分类为娱乐和国际的所有新闻
*/
select * from news where classify_id 
in (select id from classify where classify = '娱乐' or classify = '国际');

/**
请查询发布了国际新闻的用户信息
*/
select u.* from t_user u, classify c, news n where 
u.id = n.user_id and n.classify_id = c.id and c.classify = '国际';

select * from t_user where id = 
(select user_id from news where classify_id =
(select id from classify c where c.classify = '国际'));

/**
 把所有国际新闻的描述信息都设置成abc
*/
update news set des = 'abc' where classify_id = (select id from classify where classify = '国际');

/**
删除所有分类为国际的新闻
*/
delete from news where classify_id = (select id from classify where classify = '国际');

insert into news(user_id, classify_id, title) values('2f3009b2-35e9-481a-9105-10142014f5b1', (select id from classify where classify = '国际'), '一带一路中国');

/****************************************
	连接查询
	where连接   内连接

	join
	内连接 inner join，直接写join，则默认就是inner join
	外连接
		左外连接:以left join左边的表为主表，右边的表为次表，
			如果主表的数据没有出现在次表中，则主表的数据查询出来，而次表的数据用NULL补齐
		右外连接:以right join右边的表为主表，左边的表为次表，
			如果主表的数据没有出现在次表中，则主表的数据查询出来，而次表的数据用NULL补齐
		全外连接：full join 综合左外和右外连接的情况
	交叉连接：cross join 笛卡尔积
*/

/**
请查询出所有的新闻(包括作者和新闻分类)
*/
select n.*, u.email, c.classify from 
news n, t_user u, classify c 
where n.user_id = u.id and n.classify_id = c.id;

select n.*, u.email, c.classify from news n inner join t_user u on n.user_id = u.id
inner join classify c on n.classify_id = c.id;

/**
	请查询出分类为国际的所有新闻
*/
select n.* from news n, classify c where n.classify_id = c.id and c.classify = '国际';

select n.* from news n join classify c on n.classify_id = c.id and c.classify = '国际';

/**
	查询出所有人发布的所有新闻
*/
select * from news n join t_user u on n.user_id = u.id;

select * from news n left outer join t_user u on n.user_id = u.id;

select * from news n right outer join t_user u on n.user_id = u.id;
select * from t_user u left outer join news n on n.user_id = u.id;

select * from t_user u cross join news n;

/**
exists 关键字
判断是否存在，返回的是true或者false

以后当使用到in或not in，请多思考一下能否使用exists和not exists
*/

select n.* from news n where n.classify_id in (select id from classify);

/**
查询有发布过新闻的用户
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

 5 * 3 = 15 次比较， 外部的t_user每条记录都查询了一遍，总共查询了5遍t_user
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
 2 == 2 ? Y   查询一次t_user
 3 == 3 ? Y   查询一次t_user
 4 == 4 ? Y   查询一次t_user
 5 == 5 ？N   

 总共只查询了3次t_user
 
*/
select u.* from t_user u where exists(select user_id from news where news.user_id = u.id);
/**
查询没有发布过新闻的用户
*/
select u.* from t_user u where not exists(select user_id from news where news.user_id = u.id);

/**
	union关键字可以把多个查询的结果联合到一起
	前提条件：多个查询的表的字段数要一致，查询出的结果的列名称默认为第一个查询的列名称
*/
select u.* from t_user u where u.email = 'abc@126.com'
union
select u.* from t_user u where u.email = 'bcd@126.com';

select t_1.* from t_1
union
select t_2.* from t_2;

/**************************************************
索引

索引是对数据库表中一个或多个列的值进行排序的结构
索引提供指针以指向存储在表中指定列的数据值，然后根据指定的排序次序排列这些指针 

索引能够更加方便快速地查询数据库记录
主键字段默认添加了索引字段，通过主键字段去查询数据库，可以有效地提升查询效率

为了提升查询效率，有必要对部分字段添加索引
1）经常用作where条件的值
2）不经常进行数据更新的字段添加索引（数据的改变会导致数据库重新进行索引）

索引的分类：
1）聚集索引（clustered一般指主键索引）：表中各行的物理顺序与键值的逻辑（索引）顺序相同。表只能包含一个聚集索引
2）非聚集索引(nonclustered)指定表的逻辑顺序，一个表最多只能有249个非聚集索引
*/
select * from t_user where id = '2f3009b2-35e9-481a-9105-10142014f5b1';

/**
 为字段创建索引
*/
create index idx_user_email on t_user(email);
select * from t_user where email = '1232372001@qq.com';

create index idx_user_name_phone on t_user(name, phone);

/**删除索引*/
drop index t_user.idx_user_email;

/**
索引的填充因子
fillfactor默认为0。当索引的数据页满时如何扩充页面
*/
create index idx_user_pwd on t_user(pwd) with fillfactor = 5;

/**
通过sysindexes系统视图可以查询出数据库的索引信息
*/
select * from sysindexes where name = 'idx_user_email';

/**通过sp_helpindex存储过程查看指定的索引*/
sp_helpindex t_user;

/**
在数据表上右键选择全文检索来创建全文检索
全文检索*/
select * from t_user where contains(email, '"com"');
select * from t_user where freetext(email, '"com"');

/****************************************
 视图
 投影：一个select语句查询出的结果放入到另外一张表中，这张表假设称之为temp表
		select * from temp; ======> 映射成原始的sql语句
		temp投影表称之为视图，视图是一个虚拟表

数据的来源表称之为基表

	select很复杂，想拿感兴趣的字段此时可以采用视图

视图的作用：
	筛选表中的一些敏感数据

	防止用户访问未经许可的数据.

	简化数据的操作

基本规则：
	1）创建视图的select语句不能使用order by，也不能使用into语句
	2）如果基表只有一个表，则可以通过视图来更新，插入，删除数据，会反应到基表
	3）如果基表是多个表，则不要对视图进行插入，更新，删除操作


*/
/**
请查询出所有的新闻(包括作者和新闻分类)
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

insert into view_classify(classify) values('军事');
update view_classify set classify = '社会' where id = 'DC79AEC4-A5F4-479A-81AB-760B0503302B';
delete from view_classify where classify = '社会';
go;

create view my_view as select * from t_user;
go;
alter view my_view as select * from news;
go;
select * from my_view;
drop view my_view;

/**通过sys.all_views视图查看数据库的所有视图*/
select * from sys.all_views where name = 'all_news';

/*************************
聚合函数：对一组值进行操作，返回单一的汇总值
标量函数：对单一值进行操作，返回单一值．
字符串函数，数学函数据，系统函数，时间日期函数都属于标量函数
排名函数：对记录中每行进行排序
行集函数：像表引用一样使用，函数返回对象

聚合函数
count()
max()
min()
avg()
sum()

getdate( )返回当前系统日期和时间
select getdate()

dateadd( )返回给指定日期加上一个时间间隔后的日期
select dateadd(month,3,getdate())

datediff( )返回跨两个指定日期的日期间隔数和时间间隔数
select datediff(day,’2007-4-3’,'2007-4-9')

datename( )返回表示指定日期的指定日期部分的字符串
select datename(year,getdate())

datepart( )指定要返回的日期部分的参数 
select datepart(month,getdate())

day、month、year指日期的部分

数学函数：
ABS(绝对值)	DEGREES	RAND（随机数）
ACOS	EXP	ROUND（四舍五入）
ASIN	FLOOR	SIGN
ATAN	LOG	SIN
ATN2	LOG10	SQRT（开方）
CEILING	PI	SQUARE（平方）
COS	POWER（n次方）	TAN
COT	RADIANS	

字符串函数：
ASCII()转ascii值	NCHAR()返回nchar值	SOUNDEX()
CHAR()转字符值	PATINDEX()返回子字符串第一次出现的位置	SPACE()
CHARINDEX()	QUOTENAME()添加分隔符	STR()
DIFFERENCE()	REPLACE()替换函数	STUFF()
LEFT()从左边截	REPLICATE()	****SUBSTRING()求子串
***LEN()返回长度	REVERSE()反转	UNICODE()返回unicode编码
****LOWER()转小写	RIGHT()从右边截	****UPPER()转大写
LTRIM()从左边去子串	RTRIM()从右去子串

类型转换函数
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
	SQL Server的安全管理
	1）身份验证：windows, SQL Server
	2）创建用户：
		a、GUI工具  安全性-》登录名-》新建登录名（此时创建的用户并没有权限去访问相关的数据库）
		b、命令：CREATE LOGIN [wang] WITH PASSWORD='123456', DEFAULT_DATABASE=[xinwen], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
		c、sp_addlogin 'test','123456';


	权限:add_user, delete_user, update_user, query_all_user
	角色:admin, normal_user
	用户:abc@126.com, abc@qq.com, abc@126.com  admin   abc@qq.com  normal_user

	权限可以绑定到角色，即一个角色可以拥有多个权限
	用户可以绑定到时角色，即一个角色可以拥有多个用户

	角色：
	sysadmin系统管理员（拥有所有的权限）
	public公开的角色（基本没什么权限）
	db_owner数据库拥有者

	1）给用户指定角色
		sa账号操作：用户名上点击右键-》属性-》服务器角色-》勾选想要的角色

	2)给用户指定权限
		sa账号操作：任意数据库-》属性-》权限-》查看服务器权限（不是指当前数据库的权限）
		-》选中用户-》勾选权限-》确定

		sa账号操作：用户名上右键点击-》属性-》用户映射-》选择想要的数据库
		-》test1->db_owner   (让某个用户拥有某个数据库a)

		sa账号操作：a数据库右键点击-》属性-》权限-》搜索用户-》选择用户-》设置权限
		
		sa账号操作：选择a数据库中的某个表-》属性-》权限-》设置权限-》插入拒绝，更新拒绝

		grant:授权
		revoke:取消授权

		grant 权限（update, delete, select, insert） on table (column) to user;
*/

