LOG_FILE=/tmp/catalogue
echo 'settingup nodejs repos'
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/catalogue
echo status = $?

yum install nodejs -y
useradd roboshop
$ curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
$ cd /home/roboshop
$ unzip /tmp/catalogue.zip
$ mv catalogue-main catalogue
$ cd /home/roboshop/catalogue
$ npm install
