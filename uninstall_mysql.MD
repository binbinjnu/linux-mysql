# 卸载mysql

```sh
yum remove  mysql mysql-server mysql-libs mysql-server // 1.快速删除
rpm -qa | grep -i mysql // 查找残留文件
yum remove *** // 将查询出来的文件逐个删除
whereis mysql // 查找残留目录
rm –rf *** // 逐条删除目录
```
