LOG_FILE=/tmp/catalogue

ID=$(id -u)
if [ $ID -ne 0 ]; then
  echo you should run this script as root user or with sudo privilages.
  exit 1
fi

echo 'setup nodejs repos'
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG_FILE
if [ $? -eq 0 ]; then
 echo status = SUCCESSS
else
  echo status = FAILURE
  exit 1
fi

echo 'install nodejs'
yum install nodejs -y &>>$LOG_FILE
if [ $? -eq 0 ]; then
 echo status = SUCCESSS
else
  echo status = FAILURE
  exit 1
fi

id roboshop &>>$LOG_FILE
if [ $? -ne 0 ]; then
 echo 'Add Roboshop Application User'
 useradd roboshop &>>$LOG_FILE
 if [ $? -eq 0 ]; then
  echo status = SUCCESSS
 else
   echo status = FAILURE
   exit 1
 fi
fi

echo 'Download Catalogue Application Code'
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG_FILE
if [ $? -eq 0 ]; then
 echo status = SUCCESSS
else
  echo status = FAILURE
  exit 1
fi

cd /home/roboshop

echo "clean old app content"
rm -rf catalogue &>>$LOG_FILE
if [ $? -eq 0 ]; then
 echo status = SUCCESSS
else
  echo status = FAILURE
  exit 1
fi

echo 'Extract Catalogue Application Code'
unzip /tmp/catalogue.zip &>>$LOG_FILE
if [ $? -eq 0 ]; then
 echo status = SUCCESSS
else
  echo status = FAILURE
  exit 1
fi


mv catalogue-main catalogue
cd /home/roboshop/catalogue

echo 'install Nodejs Dependencies'
npm install &>>$LOG_FILE
if [ $? -eq 0 ]; then
 echo status = SUCCESSS
else
  echo status = FAILURE
  exit 1
fi

echo 'setup catalogue service'
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>$LOG_FILE
if [ $? -eq 0 ]; then
 echo status = SUCCESSS
else
  echo status = FAILURE
  exit 1
fi


systemctl daemon-reload
systemctl start catalogue
systemctl enable catalogue
