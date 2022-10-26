LOG_FILE=/tmp/mysql

source common.sh

echo "setup mysql repos"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>$LOG_FILE
statuscheck $?


echo "disable mysql default module to enable 5.7 mysql"
dnf module disable mysql &>>$LOG_FILE
statuscheck $?

echo "install mysql"
yum install mysql-community-server -y &>>$LOG_FILE
statuscheck $?

echo "start mysql service"
systemctl enable mysqld &>>$LOG_FILE
systemctl start mysqld &>>$LOG_FILE
statuscheck $?

# grep temp /var/log/mysqld.log

# mysql_secure_installation

# mysql -uroot -pRoboShop@1

> uninstall plugin validate_password;

