1)说明
系统存储过程sp_MSforeachtable和sp_MSforeachdb,是微软提供的两个不公开的存储过程,从ms sql 6.5开始。
存放在SQL Server的MASTER数据库中。

2)参数说明:
@command1 nvarchar(2000),          --第一条运行的SQL指令
@replacechar nchar(1) = N'?',      --指定的占位符号
@command2 nvarchar(2000)= null,    --第二条运行的SQL指令
@command3 nvarchar(2000)= null,    --第三条运行的SQL指令
@whereand nvarchar(2000)= null,    --可选条件来选择表
@precommand nvarchar(2000)= null,  --执行指令前的操作(类似控件的触发前的操作)
@postcommand nvarchar(2000)= null  --执行指令后的操作(类似控件的触发后的操作)

3)举例
--统计数据库里每个表的详细情况
exec sp_MSforeachtable @command1="sp_spaceused '?'"
--获得每个表的记录数和容量:
EXEC sp_MSforeachtable @command1="print '?'",
@command2="sp_spaceused '?'",
@command3= "SELECT count(*) FROM ? "
--获得所有的数据库的存储空间:
EXEC sp_MSforeachdb   @command1="print '?'",
@command2="sp_spaceused "
--检查所有的数据库
EXEC sp_MSforeachdb   @command1="print '?'",
@command2="DBCC CHECKDB (?) "
--更新PUBS数据库中已t开头的所有表的统计:
EXEC sp_MSforeachtable @whereand="and name like 't%'",
@replacechar='*',
@precommand="print 'Updating Statistics.....' print ''",
@command1="print '*' update statistics * ",
@postcommand= "print''print 'Complete Update Statistics!'"
--删除当前数据库所有表中的数据
sp_MSforeachtable @command1='Delete from ?'
sp_MSforeachtable @command1 = "TRUNCATE TABLE ?"

4)参数@whereand的用法
@whereand参数在存储过程中起到指令条件限制的作用,具体的写法如下:
@whereend,可以这么写 @whereand=' AND o.name in (''Table1'',''Table2'',.......)'
例如:我想更新Table1/Table2/Table3中NOTE列为NULL的值
sp_MSforeachtable @command1='Update ? Set NOTE='''' Where NOTE is NULL',@whereand=' AND o.name in (''Table1'',''Table2'',''Table3'')'

5)"?"在存储过程的特殊用法,造就了这两个功能强大的存储过程
这里"?"的作用,相当于DOS命令中、以及我们在WINDOWS下搜索文件时的通配符的作用。