/opt/cloudera/parcels/CDH/bin/hive --database "mydb" -e "set hive.execution.engine=mr; INSERT INTO mydb.$1 SELECT * FROM mydb_tmp.TMP_$1"
