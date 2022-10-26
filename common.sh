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

id roboshop &>>$LOG_FILE
if [ $? -ne 0 ]; then
 echo 'Add Roboshop Application User'
 useradd roboshop &>>$LOG_FILE
statuscheck $?
fi