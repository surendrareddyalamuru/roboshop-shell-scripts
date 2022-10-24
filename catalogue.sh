LOG_FILE=/tmp/catalogue

echo 'setup nodejs repos'
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/catalogue
echo status = $?

echo 'install nodejs'
yum install nodejs -y &>>/tmp/catalogue
echo status = $?

echo 'Add Roboshop Application User'
useradd roboshop &>>/tmp/catalogue
echo status = $?

echo 'Download Catalogue Application Code'
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>/tmp/catalogue
echo status = $?

cd /home/roboshop

echo 'Extract Catalogue Application Code'
unzip /tmp/catalogue.zip &>>/tmp/catalogue
echo status = $?


mv catalogue-main catalogue
cd /home/roboshop/catalogue

echo 'install Nodejs Dependencies'
npm install &>>/tmp/catalogue
echo status = $?

echo 'setup catalogue service'
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>/tmp/catalogue
echo status = $?


systemctl daemon-reload
systemctl start catalogue
systemctl enable catalogue
