#! /bin/bash

version=`sudo cat /etc/redhat-release 2> /dev/null | grep -o -P '[\.\d]*'`

if [[ $? -ne 0 ]];then 
	echo -e "\033[31mThis script only support CentOS 7 or Higher\033[0m"
	exit 1
elif [[ `expr $version` -lt 7 ]]; then
	echo -e "\033[31mThis script only support CentOS 7 or Higher\033[0m"
	exit 1
fi

sudo yum install curl -y
sudo curl -L "https://get.docker.com/" | sh
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

read -p "input your couchdb username" username
read -s -p "input your couchdb password" password

mkdir ~/couchdb
cd ~/couchdb

sed -i 's/USER_NAME/$username/g' docker-compose.yml
sed -i 's/USER_PASS/$password/g' docker-compose.yml 

docker-compose up -d 
docker volume create couchdb-data

sudo cp couchdb /usr/local/bin/couchdb
sudo chmod +x /usr/local/bin/couchdb

echo -e "\033[32mCouchdb installed successfully\033[0m"
echo -e "\033[33mNote: please open 5984 port\033[0m"

echo -e "\033[31mRemember your admin account and password\033[0m"
echo "username: "$username
echo "password: "$password

echo -e "use command 'couchdb' to manage it"