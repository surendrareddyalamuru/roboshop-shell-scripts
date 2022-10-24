LOG_FILE=/tmp/frontend
echo installing nginx
yum install nginx -y &>>$LOG_FILE
echo status = $?

echo downloading web content
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILE
echo status = $?

cd /usr/share/nginx/html &>>$LOG_FILE

echo removing older web content
rm -rf * &>>/tmp/frontend
echo status = $?

echo extracting web content
unzip /tmp/frontend.zip &>>$LOG_FILE
echo status = $?

mv frontend-main/static/* . &>>$LOG_FILE
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE

echo starting nginx
systemctl enable nginx &>>$LOG_FILE
systemctl restart nginx &>>$LOG_FILE
echo status = $?