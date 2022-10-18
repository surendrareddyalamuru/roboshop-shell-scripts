echo installing nginx
yum install nginx -y &>>/tmp/frontend
echo status = $?

echo downloading web content
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>/tmp/frontend
echo status = $?

cd /usr/share/nginx/html &>>/tmp/frontend

echo removing older web content
rm -rf * &>>/tmp/frontend
echo status = $?

echo extracting web content
unzip /tmp/frontend.zip &>>/tmp/frontend
echo status = $?

mv frontend-main/static/* . &>>/tmp/frontend
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>/tmp/frontend

echo starting nginx
systemctl enable nginx &>>/tmp/frontend
systemctl restart nginx &>>/tmp/frontend
echo status = $?