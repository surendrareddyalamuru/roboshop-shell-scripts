LOG_FILE=/tmp/catalogue

ID=$(id -u)
if [ $ID -ne 0 ]; then
  echo you should run this script as root user or with sudo privilages.
  exit 1
fi

echo 'setup nodejs repos'
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/catalogue
if [ $? -eq 0 ]; then
 echo status = SUCCESSS
else
  echo status = FAILURE
  exit 1
fi

echo 'install nodejs'
yum install nodejs -y &>>/tmp/catalogue
if [ $? -eq 0 ]; then
 echo status = SUCCESSS
else
  echo status = FAILURE
  exit 1
fi

echo 'Add Roboshop Application User'
useradd roboshop &>>/tmp/catalogue
if [ $? -eq 0 ]; then
 echo status = SUCCESSS
else
  echo status = FAILURE
  exit 1
fi

echo 'Download Catalogue Application Code'
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>/tmp/catalogue
if [ $? -eq 0 ]; then
 echo status = SUCCESSS
else
  echo status = FAILURE
  exit 1
fi

cd /home/roboshop

echo 'Extract Catalogue Application Code'
unzip /tmp/catalogue.zip &>>/tmp/catalogue
if [ $? -eq 0 ]; then
 echo status = SUCCESSS
else
  echo status = FAILURE
  exit 1
fi


mv catalogue-main catalogue
cd /home/roboshop/catalogue

echo 'install Nodejs Dependencies'
npm install &>>/tmp/catalogue
if [ $? -eq 0 ]; then
 echo status = SUCCESSS
else
  echo status = FAILURE
  exit 1
fi

echo 'setup catalogue service'
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>/tmp/catalogue
if [ $? -eq 0 ]; then
 echo status = SUCCESSS
else
  echo status = FAILURE
  exit 1
fi


systemctl daemon-reload
systemctl start catalogue
systemctl enable catalogue
