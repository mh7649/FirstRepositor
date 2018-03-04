
/** 
 1、事务
	一件事情由多个步骤组成，如果其中一个步骤失败，则整件事情就是失败的，并且需要
	回滚到原始状态，只有当所有步骤都成功，则整件事情才算成功，此时才可以提交。
	称之为事务

	放到数据库层次，每一个步骤都可以看成是一个sql语句，只有所有的sql语句都成功，才可以提交到
	数据库，否则数据库需要回滚
 
 2、事务的基本特征：
	1）原子性：事务中的每一个步骤都是不可拆分的
	2）一致性：保证数据的一致性
	3）隔离性：同一时间段执行多个事务，每个事务互不干扰
	4）持久性：事务执行成功得反映到数据库


3、事务的一些问题：
	丢失或覆盖更新		当两个或多个事务选择同一行，然后基于最初选定的值更新该行时，会发生丢失更新问题		每个事务都不知道其它事务的存在		最后的更新将重写由其它事务所做的更新，这将导致数据丢失

	未确认的相关性(脏读)		当第二个事务选择其它事务正在更新的行时，会发生未确认的相关性问题		第二个事务正在读取的数据还没有确认并且可能由更新此行的事务所更改

	不一致的分析（非重复读）		当第二个事务多次访问同一行而且每次读取不同的数据时，会发生不一致的分析问题		在不一致的分析中，第二个事务读取的数据是由已进行了更改的事务提交的		不一致的分析涉及多次（两次或更多）读取同一行，而且每次信息都由其它事务更改；因而该行被非重复读取	幻像读		当对某行执行插入或删除操作，而该行属于某个事务正在读取的行的范围时，会发生幻像读问题		事务第一次读的行范围显示出其中一行已不复存在于第二次读或后续读中，因为该行已被其它事务删除		同样，由于其它事务的插入操作，事务的第二次或后续读显示有一行已不存在于原始读中	隔离级别：		未提交读(READ UNCOMMITTED )		提交读(READ COMMITTED )		可重复读(REPEATABLE READ)		可串行读(SERIALIZABLE)


补充：
	1）并发：同一时间段执行多个事情（NIO, Netty, Mina）
	2）数据持久化：把数据保存到数据库中的过程
*/
SET XACT_ABORT ON; -- 开启异常处理机制
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
	begin transaction my_tran -- my_tran为事务的回滚点，事务开始时候的状态
		insert into classify(classify) values('互联网fsfsdfsdfsdfsdfsdfdfsdfsdfsdfsd');
		insert into classify(classify) values('电影');
	if @@ERROR > 0
		begin
			print @@ERROR;
			rollback transaction my_tran; -- 如果错误号大于0，则说明事务有错，应该回滚
		end;
	else
		begin
			commit transaction; -- 否则事务执行成功，提交事务
		end;
end;
