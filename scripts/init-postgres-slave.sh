#!/bin/bash
reppassword=$1
masterip=$2
PGSQL_DATA='/var/lib/postgresql/data'

# Stop database services
echo " Stopping DB" >> INSTALL_LOG
sudo /etc/init.d/postgresql stop
# Clear current data directory (excluding posgresql.conf & pg_hba.conf)
echo " Cleaning old data directory [$PGSQL_DATA]" >> INSTALL_LOG
sudo rm -rf !($PGSQL_DATA/postgresql.conf|$PGSQL_DATA/pg_hba.conf)

# Configure node to host_standby node
echo " Adding slave config to [$PGSQL_DATA/postgresql.conf]" >> INSTALL_LOG
sudo echo "hot_standby = on" >> $PGSQL_DATA/postgresql.conf
sudo echo "primary_conninfo = 'host=${masterip} port=5432 user=repuser password=${reppassword}'" >> ${PGSQL_DATA}/postgresql.conf;
sudo echo "promote_trigger_file = '/tmp/postgresql.trigger.5432'" >> ${PGSQL_DATA}/postgresql.conf;
# Add standby signal file
echo " Adding standby.signal file." >> INSTALL_LOG
sudo touch $PGSQL_DATA/standby.signal 

# Start database services
echo " Starting DB" >> INSTALL_LOG
sudo /etc/init.d/postgresql start

