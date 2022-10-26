LOG_FILE=/tmp/catalogue

source common.sh

echo 'setup nodejs repos'
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG_FILE
statuscheck $?

echo 'install nodejs'
yum install nodejs -y &>>$LOG_FILE
statuscheck $?


id roboshop &>>$LOG_FILE
if [ $? -ne 0 ]; then
 echo 'Add Roboshop Application User'
 useradd roboshop &>>$LOG_FILE
statuscheck $?
fi

echo 'Download Catalogue Application Code'
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG_FILE
statuscheck $?


cd /home/roboshop

echo "clean old app content"
rm -rf catalogue &>>$LOG_FILE
statuscheck $?


echo 'Extract Catalogue Application Code'
unzip /tmp/catalogue.zip &>>$LOG_FILE
statuscheck $?



mv catalogue-main catalogue
cd /home/roboshop/catalogue

echo 'install Nodejs Dependencies'
npm install &>>$LOG_FILE
statuscheck $?


echo 'setup catalogue service'
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>$LOG_FILE
statuscheck $?



systemctl daemon-reload &>>$LOG_FILE
systemctl enable catalogue &>>$LOG_FILE

echo "start catalogue service"
systemctl start catalogue &>>$LOG_FILE
statuscheck $?
