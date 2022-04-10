hadoop fs -rm -r  /user/my-user/sqoop/$1
sqoop import --connect jdbc:oracle:thin:@orahost:port/orainstance --username my-user --password my-password --table $1 --target-dir /user/my-user/sqoop/$1 -m $2 --fields-terminated-by , --escaped-by \\ --enclosed-by '§' --hive-delims-replacement ' ' > $1_log.txt
