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

echo "update roboshop config file"
sed -i -e '/catalogue/ s/localhost/catalogue.roboshop.internal/' -e '/user/ s/localhost/user.roboshop.internal/' -e '/cart/ s/localhost/cart.roboshop.internal/' -e '/shipping/ s/localhost/shipping.roboshop.internal/' -e '/payment/ s/localhost/payment.roboshop.internal/' /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE
statuscheck $?

echo starting nginx
systemctl enable nginx &>>$LOG_FILE
systemctl restart nginx &>>$LOG_FILE
statuscheck $?