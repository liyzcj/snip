# mysql

Mysql 是一个常用的数据库管理系统。

## ops

Mysql 运营维护相关指令。

### docker install

拉去对应版本的镜像：

```bash
docker pull mysql:8
```

启动镜像：

```bash
docker run \
  -v "$PWD/data":/var/lib/mysql \
  --name mysql \
  --security-opt seccomp=unconfined \
  -e MYSQL_ROOT_PASSWORD=liyanzhe \
  -p 3306:3306 \
  -d mysql:8
```

`--security-opt seccomp=unconfined`：数据库服务使用了 NUMA 操作的 mbin，但是 Docker 中该选项默认是关闭的。

### brew install

搜索可用的版本

```bash
brew search mysql
```

安装指定版本的 Mysql

```bash
brew install mysql@5.6
```

### yum install

采用官方的 yum 源安装 mysql-commity-server

在[**官方 yum 仓库下载页面**](https://dev.mysql.com/downloads/repo/yum/)下载对应系统版本的 mysql 仓库，例如对于 centos7

```bash
wget https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
```

安装 yum 源

```Bash
rpm -Uvh mysql80-community-release-el7-3.noarch.rpm
```

选择要安装的版本,首先查看所有可用的版本：

```Bash
yum repolist all | grep mysql
```

激活要安装的版本，以 Mysql 5.7 为例：

```bash
yum-config-manager --disable mysql80-community
yum-config-manager --enable mysql57-community

```

查看以及激活的仓库是否正确：

```Bash
yum repolist enabled | grep mysql
```

对于 Centos 8，需要禁用默认自带的 Module `yum module disable mysql`

执行安装命令：

```Bash
yum install mysql-community-server
```

修改配置，默认的配置文件位置可以通过命令查看：

```Bash
mysqld --verbose --help|grep -A 1 'Default options'
```

启动 Mysql 服务

```Bash
systemctl start mysqld
```

### package install

YUM 安装会自动执行很多步骤，包含创建默认的配置文件、创建 msyql 用户，初始化数据库等。

如果要自己手动安装，这些都要手动执行。

1. 创建用户

```Bash
useradd -m mysql
```

由于安全原因， mysql 不支持使用 root 用户执行，只要不是 root 用户就行。

从[**官方的下载地址**](https://dev.mysql.com/downloads/mysql/)直接下载对应系统和版本的安装包，并解压，例如：

```Bash
wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.36-el7-x86_64.tar.gz
```

解压之后，创建配置文件，采用自定义的配置文件也行，放到默认的配置文件位置也行。

配置文件中必须知道安装包的位置、数据的位置等：

```ini
[client]
port            = 3306
socket          = /tmp/mysql.sock


# The MySQL server
[mysqld]
basedir=/home/mysql/mysql-5.7.36-el7-x86_64
datadir=/home/mysql/mysql-5.7.36-el7-x86_64/data
tmpdir=/home/mysql/mysql-5.7.36-el7-x86_64/tmp
default-storage-engine=innodb
max_connections=1000
character-set-server=utf8
port            = 3306
socket          = /tmp/mysql.sock
skip-external-locking
key_buffer_size = 32M
max_allowed_packet = 32M
table_open_cache = 64
sort_buffer_size = 128M
net_buffer_length = 128M
read_buffer_size = 128M
read_rnd_buffer_size = 8M
myisam_sort_buffer_size = 8M


innodb_data_home_dir=/home/mysql/mysql-5.7.36-el7-x86_64/data
innodb_log_group_home_dir=/home/mysql/mysql-5.7.36-el7-x86_64/data
innodb_buffer_pool_size = 1024M
# innodb_additional_mem_pool_size = 128M
innodb_log_file_size = 32M
innodb_log_buffer_size = 32M
innodb_flush_log_at_trx_commit = 1
innodb_lock_wait_timeout = 60
innodb_file_per_table = 1

[mysqldump]
quick
max_allowed_packet = 32M

[mysql]
no-auto-rehash
default-character-set=utf8

[myisamchk]
key_buffer_size = 20M
sort_buffer_size = 20M
read_buffer = 2M
write_buffer = 2M

```

初始化数据库，需要手动初始化数据库：

```bash
./bin/mysqld --defaults-file=./conf/my.cnf --initialize
```

启动数据库，最好采用 `mysqld_safe` 命令启动守护进程来启动数据库：

```bash
./bin/mysqld_safe --defaults-file=./conf/my.cnf > /dev/null &
```

### config

启动数据库服务之后，还需要对数据库进行一些配置才能使用。

#### 密码设置

数据库在第一次初始化的时候会给 `root` 用户生成一个默认的随机密码。

如果是采用 YUM 的方式部署，可以通过如下命令获取密码：

```bash
grep 'temporary password' /var/log/mysqld.log
```

如果是手动初始化，则在标准输出中应该能看到生成的密码。

通过本地的客户端连接数据库修改密码：

```bash
mysql -u root -p
```

```SQL
ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyNewPass4!';
```

或者

```sql
set password for 'root'@'localhost'=password('MyNewPass4!');
```

#### 配置远程登录

默认情况下，root 用户是不允许远程登录的，如果需要远程登录，可以进行修改：

```sql
use mysql;
UPDATE user SET Host='%' WHERE User='root';
flush privileges;
```

但是不推荐让 `root` 用户能够远程登录，可以创建一个新的用户：

```sql
CREATE USER 'xiaoming'@'localhost' IDENTIFIED BY 'newpasswd';
-- 设置权限
grant all on *.* to 'xiaoming'@'%';
```
