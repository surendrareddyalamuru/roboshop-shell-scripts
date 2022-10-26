LOG_FILE=/tmp/user

source common.sh

echo "setup nodejs repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG_FILE
statuscheck $?


echo "install nodejs"
yum install nodejs -y  &>>$LOG_FILE
statuscheck $?

id roboshop &>>$LOG_FILE
if [ $? -ne 0 ]; then
 echo 'Add Roboshop Application User'
 useradd roboshop &>>$LOG_FILE
statuscheck $?
fi



echo 'Download user Application Code'
curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip" &>>$LOG_FILE
statuscheck $?


cd /home/roboshop

echo "clean old app content"
rm -rf user &>>$LOG_FILE
statuscheck $?


echo 'Extract user Application Code'
unzip /tmp/user.zip &>>$LOG_FILE
statuscheck $?



mv user-main user
cd /home/roboshop/user

echo 'install Nodejs Dependencies'
npm install &>>$LOG_FILE
statuscheck $?

echo "update systemD service file"
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' /home/roboshop/user/systemd.service &>>$LOG_FILE
statuscheck $?

echo 'setup user service'
mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service &>>$LOG_FILE
statuscheck $?


systemctl daemon-reload &>>$LOG_FILE
systemctl enable user &>>$LOG_FILE

echo "start user service"
systemctl start user &>>$LOG_FILE
statuscheck $?