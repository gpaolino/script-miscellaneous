hive --database "mydb_tmp" -e "TRUNCATE TABLE $1_SQOO"
hive --database "mydb" -e "TRUNCATE TABLE $1"
echo "Tabelle $1 troncate"
