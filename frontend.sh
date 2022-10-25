LOG_FILE=/tmp/frontend

source common.sh

echo installing nginx
yum install nginx -y &>>$LOG_FILE
statuscheck $?

echo downloading web content
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILE
statuscheck $?

cd /usr/share/nginx/html &>>$LOG_FILE

echo removing older web content
rm -rf * &>>/tmp/frontend
statuscheck $?

echo extracting web content
unzip /tmp/frontend.zip &>>$LOG_FILE
statuscheck $?

mv frontend-main/static/* . &>>$LOG_FILE
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE

echo starting nginx
systemctl enable nginx &>>$LOG_FILE
systemctl restart nginx &>>$LOG_FILE
statuscheck $?