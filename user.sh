LOG_FILE=/tmp/user

source common.sh

echo "download nodejs repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG_FILE
StatusCheck $?

echo "install nodejs"
yum install nodejs -y  &>>$LOG_FILE
StatusCheck $?


$ curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip"
$ cd /home/roboshop
$ unzip /tmp/user.zip
$ mv user-main user
$ cd /home/roboshop/user
$ npm install