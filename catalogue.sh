LOG_FILE=/tmp/catalogue

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
  f
}

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



systemctl daemon-reload
systemctl start catalogue
systemctl enable catalogue
