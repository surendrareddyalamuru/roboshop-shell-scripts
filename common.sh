ID=$(id -u)
if [ $ID -ne 0 ]; then
  echo you should run this script as root user or with sudo privilages.
  exit 1
fi

statuscheck() {
  if [ $? -eq 0 ]; then
   echo -e status = "\e[32mSUCCESSS\e[0m"
  else
    echo -e status = "\e[31mFAILURE\e[0m"
    exit 1
  fi
}

APP_PREREQ() {

id roboshop &>>$LOG_FILE
if [ $? -ne 0 ]; then
 echo 'Add Roboshop Application User'
 useradd roboshop &>>$LOG_FILE
statuscheck $?
fi


echo 'download ${COMPONENT} Application Code'
curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>$LOG_FILE
statuscheck $?


cd /home/roboshop

echo "clean old app content"
rm -rf ${COMPONENT} &>>$LOG_FILE
statuscheck $?


echo 'Extract ${COMPONENT} Application Code'
unzip /tmp/${COMPONENT}.zip &>>$LOG_FILE
statuscheck $?



mv ${COMPONENT}-main ${COMPONENT}
cd /home/roboshop/${COMPONENT}
}

SYSTEMD_SETUP() {
  echo "update systemD service file"
  sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service &>>$LOG_FILE
  statuscheck $?

  echo 'setup ${COMPONENT} service'
  mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>$LOG_FILE
  statuscheck $?


  systemctl daemon-reload &>>$LOG_FILE
  systemctl enable ${COMPONENT} &>>$LOG_FILE

  echo "start ${COMPONENT} service"
  systemctl start ${COMPONENT} &>>$LOG_FILE
  statuscheck $?


}

Nodejs() {
echo "setup nodejs repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG_FILE
statuscheck $?


echo "install nodejs"
yum install nodejs -y  &>>$LOG_FILE
statuscheck $?

APP_PREREQ

echo 'install Nodejs Dependencies'
npm install &>>$LOG_FILE
statuscheck $?

SYSTEMD_SETUP

}

JAVA() {
   echo "install maven"
   yum install maven -y &>>$LOG_FILE
   statuscheck $?

   APP_PREREQ

  echo "download dependencies & make package"
  mvn clean package  &>>$LOG_FILE
  mv target/${COMPONENT}-1.0.jar ${COMPONENT}.jar  &>>$LOG_FILE
  statuscheck $?

SYSTEMD_SETUP

}