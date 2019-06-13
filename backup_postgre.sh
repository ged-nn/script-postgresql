#!/bin/sh
PATH=/etc:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

backup() {

	PGPASSWORD=password
	export PGPASSWORD
	dbUser=postgres
	database=$1
	pathB="/usr/data/backup/postgresql/${database}"

	mkdir -p "${pathB}"
#echo find $pathB \( -name "*-1[^5].*" -o -name "*-[023]?.*" \) -ctime +61 -delete
	pg_dump -U $dbUser $database | gzip > $pathB/pgsql_$(date "+%Y-%m-%d_%H-%M-%S").sql.gz
	unset PGPASSWORD
}


get_bd_list() {
	 psql -U postgres  -l -A -q -t | awk -F \| '{print $1}' | grep -v -E '^(Имя|template0|postgres|template1|Список)'

}

DB_LIST=`get_bd_list`
for DB_CUR in "${DB_LIST}"
do
	backup ${DB_CUR}
done
