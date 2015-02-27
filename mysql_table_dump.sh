#!/bin/bash

#Provide schema/database name
DB_NAME=$1

#Provide the wildcard for the table name here
TABLE_NAME_WILDCARD=$2
TMP_FILE='/tmp/table_names.csv'
QUERY="select table_name from information_schema.tables where table_name like '$TABLE_NAME_WILDCARD' AND table_schema = '$DB_NAME' INTO OUTFILE '$TMP_FILE' FIELDS TERMINATED BY ',';"
mysql -u root -p -e "$QUERY"

cat $TMP_FILE |
{
        while read -r line
        do
                TABLES="${TABLES} ${line}"
                echo $TABLES
        done ;
        mysqldump -u root -p ${DB_NAME}${TABLES} > /tmp/${DB_NAME}.${TABLE_NAME_WILDCARD}.sql
}

rm -f $TMP_FILE
