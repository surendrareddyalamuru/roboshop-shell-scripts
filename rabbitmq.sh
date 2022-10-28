COMPONENT=rabbitmq

LOG_FILE=/tmp/${COMPONENT}

source common.sh

echo "setup rabbitmq repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$LOG_FILE
statuscheck $?

echo "setup erlang repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$LOG_FILE
statuscheck $?

echo "install erlang"
yum install erlang -y &>>$LOG_FILE
statuscheck $?

echo "install rabbitmq"
yum install rabbitmq-server -y  &>>$LOG_FILE
statuscheck $?

echo "start rabbitmq server"
systemctl enable rabbitmq-server &>>$LOG_FILE
systemctl start rabbitmq-server &>>$LOG_FILE
statuscheck $?

echo "add application user in rabbitmq"
rabbitmqctl add_user roboshop roboshop123 &>>$LOG_FILE
statuscheck $?

echo "add application user tags in rabbitmq"
rabbitmqctl set_user_tags roboshop administrator &>>$LOG_FILE
statuscheck $?

echo "add permissions for app user in rabbitmq"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG_FILE
statuscheck $?