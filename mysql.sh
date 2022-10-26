LOG_FILE=/tmp/mysql

source common.sh

echo "setup mysql repos"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>$LOG_FILE
statuscheck $?


echo "disable mysql default module to enable 5.7 mysql"
dnf module disable mysql -y &>>$LOG_FILE
statuscheck $?

echo "install mysql"
yum install mysql-community-server -y &>>$LOG_FILE
statuscheck $?

echo "start mysql service"
systemctl enable mysqld &>>$LOG_FILE
systemctl start mysqld &>>$LOG_FILE
statuscheck $?

DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')


echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD
 ('${ROBOSHOP_MYSQL_PASSWORD}');
FLUSH PRIVILEGES;" >/tmp/root-pass.sql

echo "show databases;" |mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD}  &>>$LOG_FILE
if [ $? -ne 0 ];then
 echo "change the default root password"
 mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}" </tmp/root-pass.sql &>>$LOG_FILE
 statuscheck $?
fi

echo 'show plugins'| mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD} 2>/dev/null | grep validate_password  &>>$LOG_FILE
if [ $? -ne 0 ]; then
  echo "uninstall password validation plugin"
  echo "uninstall plugin validate_password;" | mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD} &>>$LOG_FILE
  statuscheck $?
fi

echo "download schema"
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>$LOG_FILE
statuscheck $?

echo "extract schema"
 cd /tmp
 unzip -o mysql.zip &>>$LOG_FILE
statuscheck $?

cd mysql-main

echo "load schema"
mysql -u root -p${ROBOSHOP_MYSQL_PASSWORD} <shipping.sql &>>$LOG_FILE
statuscheck $?
