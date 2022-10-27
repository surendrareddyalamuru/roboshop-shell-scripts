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


DEFAULT_PASSWORD=$(sudo grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')

echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('mypass');
     FLUSH PRIVILEGES;"

# mysql_secure_installation

# mysql -uroot -pRoboShop@1

> uninstall plugin validate_password;

# curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"

# cd /tmp
# unzip mysql.zip
# cd mysql-main
# mysql -u root -pRoboShop@1 <shipping.sql
