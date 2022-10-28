COMPONENT=dispatch


LOG_FILE=/tmp/${COMPONENT}

source common.sh

echo "install golang"
yum install golang -y &>>$LOG_FILE
statuscheck $?


APP_PREREQ

echo "initiate dispatch"
go mod init dispatch &>>$LOG_FILE
statuscheck $?

echo "get dispatch"
go get &>>$LOG_FILE
statuscheck $?

echo "build dispatch"
go build &>>$LOG_FILE
statuscheck $?

SYSTEMD_SETUP

