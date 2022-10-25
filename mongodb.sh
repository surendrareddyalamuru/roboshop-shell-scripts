LOG_FILE=/tmp/mongodb

source common.sh

echo 'settingup mondodb repo file'
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
statuscheck $?

echo 'installing mongodb server'
yum install -y mongodb-org &>>$LOG_FILE
statuscheck $?

echo 'update mongodb listen addresss'
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
statuscheck $?

echo 'starting mongodb service'
systemctl enable mongod &>>$LOG_FILE
systemctl start mongod &>>$LOG_FILE
systemctl restart mongod  &>>$LOG_FILE
statuscheck $?

echo 'downloading mongodb schema'
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG_FILE
statuscheck $?

cd /tmp

echo 'extracting mongodb schema file'
unzip -o mongodb.zip &>>$LOG_FILE
statuscheck $?

cd mongodb-main

echo 'load catalogue service schema'
mongo < catalogue.js &>>$LOG_FILE
statuscheck $?

echo 'load users service schema'
mongo < users.js &>>$LOG_FILE
statuscheck $?
