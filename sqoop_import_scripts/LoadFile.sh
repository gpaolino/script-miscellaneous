hive --database "mydb_tmp" -e " LOAD DATA LOCAL INPATH '/mnt/myshare/da_caricare/$3/TMP_$1*.dat' OVERWRITE INTO TABLE mydb_tmp.TMP_$1;"
