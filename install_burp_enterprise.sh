#***********************************************************
# Apt Update
#**********************************************************

sudo apt update -y


#***********************************************************
# Install and Configure Maria DB 
#***********************************************************

sudo apt install -y mariadb-server 
sudo systemctl enable mariadb
sudo systemctl start mariadb


#***********************************************************
# Generate and set MYSQL credentials
#***********************************************************

sudo sh -c "apt-get install -y pwgen > /dev/null 2>&1"
NEW_MYSQL_ROOT_PASSWORD=`pwgen -c -n -1 20` > /dev/null 2>&1
MYSQL_beagent_PASSWORD=`pwgen -c -n -1 20` > /dev/null 2>&1
MYSQL_beserver_PASSWORD=`pwgen -c -n -1 20` > /dev/null 2>&1
echo "MYSQL ROOT PASSWORD: ${NEW_MYSQL_ROOT_PASSWORD}" >> /root/passwords.txt
echo "MYSQL BEAGENT PASSWORD: ${MYSQL_beserver_PASSWORD}" >> /root/passwords.txt
echo "MYSQL BESERVER PASSWORD: ${MYSQL_beagent_PASSWORD}" >> /root/passwords.txt
chmod 600 /root/passwords.txt

#***********************************************************
# Create MYSQL DB and USER
#***********************************************************

sudo sh -c "mysql -uroot mysql -e \"CREATE DATABASE burpenterprise\""
sudo sh -c "mysql -uroot mysql -e \"CREATE USER beserver\""
sudo sh -c "mysql -uroot burpenterprise -e \"GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER ON burpenterprise.* TO 'beserver'@'localhost' IDENTIFIED BY '${MYSQL_beserver_PASSWORD}'\""
sudo sh -c "mysql -uroot mysql -e \"CREATE USER beagent\""
sudo sh -c "mysql -uroot burpenterprise -e \"GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER ON burpenterprise.* TO 'beagent'@'localhost' IDENTIFIED BY '${MYSQL_beagent_PASSWORD}'\""

#sudo sh -c "mysql -uroot mysql -e \"ALTER USER 'root'@'localhost' IDENTIFIED BY '${NEW_MYSQL_ROOT_PASSWORD}'\""



#***********************************************************
# Download burp 
#***********************************************************

mkdir /etc/burp

wget "https://onedrive.live.com/download?cid=E7B1244EB32C92BE&resid=E7B1244EB32C92BE%214375&authkey=AOdInnq5cq6GzS4" -O /etc/burp/burp.sh


