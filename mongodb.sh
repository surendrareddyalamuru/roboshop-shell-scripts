LOG_FILE=/tmp/mongodb

echo 'settingup mondodb repo file'
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
echo status = $?

echo 'installing mongodb server'
yum install -y mongodb-org &>>$LOG_FILE
echo status = $?

echo 'update mongodb listen addresss'
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
echo status = $?

echo 'starting mongodb service'
systemctl enable mongod &>>$LOG_FILE
systemctl start mongod &>>$LOG_FILE
systemctl restart mongod  &>>$LOG_FILE
echo status = $?

echo 'downloading mongodb schema'
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG_FILE
echo status = $?

cd /tmp

echo 'extracting mongodb schema file'
unzip mongodb.zip  &>>$LOG_FILE
echo status = $?

cd mongodb-main

echo 'load catalogue service schema'
mongo < catalogue.js  &>>$LOG_FILE
echo status = $?

echo 'load users service schema'
mongo < users.js  &>>$LOG_FILE
echo status = $?
