#!/bin/sh
# wait until MariaDB is really available
maxcounter=25
counter=1

if [ -f /var/lib/mysql/usda_nndsr.completed ]; then
    echo "usda_nndsr_mysql already loaded"
    exit 0
fi

while ! mysql -u"root" -p"$MYSQL_ROOT_PASSWORD" -e "show databases;" -h"$MYSQL_HOST"; do
    sleep 1
    counter=`expr $counter + 1`
    if [ $counter -gt $maxcounter ]; then
        >&2 echo "We have been waiting for MySQL too long already; failing."
        exit 1
    fi;
done
echo "Loading usda_nndsr_mysql ..."
cd /nutriana/usda_nndsr/dist;
mysql --local_infile=1 -v -u root -p"$MYSQL_ROOT_PASSWORD" -h"$MYSQL_HOST" < ./usda_nndsr_mysql.sql
echo "usda_nndsr_mysql completed"
touch /var/lib/mysql/usda_nndsr.completed
