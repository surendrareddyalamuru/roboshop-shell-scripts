LOG_FILE=/tmp/redis

source common.sh

echo "install redis repos"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOG_FILE
statuscheck $?

echo "enable redis module 5.7"
dnf module enable redis:remi-6.2 -y &>>$LOG_FILE
statuscheck $?

echo "install redis"
yum install redis -y &>>$LOG_FILE
statuscheck $?


echo "update redis listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf  &>>$LOG_FILE
statuscheck $?

echo "enable redis"
systemctl enable redis &>>$LOG_FILE
statuscheck $?

echo "starting redis"
systemctl start redis &>>$LOG_FILE
statuscheck $?