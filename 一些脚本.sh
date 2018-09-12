7.不过提交后JIRA设置了延时,不能马上看到,得修改
Subversion Revision Indexing Service
com.atlassian.jira.plugin.ext.subversion.revisions.RevisionIndexService  
Delay (mins) 值
svn up
svn merge ../calc/trunk -c413
svn merge -r 48:50 ../dev


svn log |grep -B 3 TES |grep r |awk '{print $1}' |grep -E -o "[0-9]+"
#grep -B 3 TES:输出含TES的行及它前面的3行
#awk '{print $1}' ：输出第一列
#grep -E -o "[0-9]+"：输出每行的数字
wtime=`date -d "a month ago" +%Y-%m-%d`
ntime=`date +%Y-%m-%d`
svn log -r {$wtime}:{$ntime} |grep -B 3 TES |grep r |awk '{print $1}' |grep -E -o "[0-9]+"

#筛选出一个月内提交的log中含TES的svn版本号


#获取自定义字段的值：
1、用getissue获取customfield
2、触发条件中获取对应customfield值
3、在pipeline调用

array1=($(svn log -r {$wtime}:{$ntime} |grep -B 3 TES |grep r |awk '{print $1}' |grep -E -o "[0-9]+"))