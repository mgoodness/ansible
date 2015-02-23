#!/bin/bash

USER=mgood
PASSWORD=mgoodGBP123

DUMP_DIR=/home/mgood/dumps

DATABASES="GBP_Punch Guess Host_Names PHP ps Web_Alerts \
	Web_Change_Log Web_Customer Web_Dashboard Web_JobTrack Web_Users \
	Web_Project_Management Web_Reporting Web_RFQ Website Web_Timeclock"

ADMIN_USER=admin
ADMIN_PASS=adminP4ss

VAGRANT_HOST=192.168.50.5

LIVE_HOST=db3.gbpinc.com

DATA_FILE=$(date -I)_live-data.sql
ROUTINES_FILE=$(date -I)_live-routines.sql

function usage
{
	echo 'usage: loadsql.sh [--clear | [--load | --dump [| --routines]]]'
}

function set_permissions {
	# First parameter is $destination

	echo "Setting user permissions..."
	mysql --compress --quick --verbose --host=$1 --user=$ADMIN_USER \
	--password=$ADMIN_PASS --execute \
	"GRANT ALL ON *.* TO 'predictor'@'%' WITH GRANT OPTION; \
	UPDATE mysql.user SET Password=PASSWORD('bsp4ssw0rd') WHERE User='predictor'; \
	GRANT ALL ON *.* TO 'projmanag'@'%' WITH GRANT OPTION; \
	UPDATE mysql.user SET Password=PASSWORD('a1terj0bs42') WHERE User='projmanag'; \
	GRANT ALL ON *.* TO '$USER'@'%' WITH GRANT OPTION; \
	UPDATE mysql.user SET Password=PASSWORD('$PASSWORD') WHERE User='$USER'; \
	FLUSH PRIVILEGES;"
	echo "done."
}

function clear {
	# First parameter is $destination

	echo "Dropping existing databases..."
	for i in $(mysql --host=$1 --user=$ADMIN_USER --password=$ADMIN_PASS \
	--execute "SHOW DATABASES" | \
	egrep -v "Database|mysql|information_schema|performance_schema"); do
		mysql --compress --quick --verbose --host=$1 --user=$ADMIN_USER \
		--password=$ADMIN_PASS --execute "DROP DATABASE $i"
	done
	echo "done."
}

function cleanup {
	# First parameter is $DATA_FILE or $ROUTINES_FILE
	if [ -f "$DUMP_DIR/$1" ]; then
		rm -rf "$DUMP_DIR/$1"
	fi
}

function dump_routines {
	cleanup "$ROUTINES_FILE"

	echo "Dumping live routines to $DUMP_DIR/$ROUTINES_FILE..."
	mysqldump --no-create-info --no-data --routines --skip-triggers --compress \
	--skip-opt --verbose --host=$LIVE_HOST --user=$USER --password=$PASSWORD \
	--result-file="$DUMP_DIR/$ROUTINES_FILE" --databases $DATABASES
	echo "done."
}

function dump_data {
	cleanup "$DATA_FILE"

	echo "Dumping live data to $DUMP_DIR/$DATA_FILE..."
	mysqldump --compress --opt --verbose --host=$LIVE_HOST --user=$USER \
	--password=$PASSWORD --result-file="$DUMP_DIR/$DATA_FILE" \
	--databases $DATABASES
	echo "done."
}

function load {
	# First parameter is $destination
	# Second parameter is $DATA_FILE or $ROUTINES_FILE

	set_permissions $1
	
	echo "Importing from $DUMP_DIR/$2..."
	mysql --compress --quick --host=$1 --user=$ADMIN_USER \
	--password=$ADMIN_PASS < "$DUMP_DIR/$2"
	echo "done."
}

function reset_passwords {
	# First parameter is $destination

	echo "Resetting user passwords..."
	mysql --compress --quick --verbose --host=$1 --user=$ADMIN_USER \
	--password=$ADMIN_PASS --execute \
	"UPDATE Web_Users.Users SET password = MD5('test');"
	echo "done."
}

do_clear=0
do_dump=0
do_load=0
do_routines=0
destination=$VAGRANT_HOST

while [ "$1" != "" ]; do
	case $1 in
		--clear )		do_clear=1
						;;
		--dump )		do_dump=1
						;;
		--routines )	do_routines=1
						;;
		--load )		do_load=1
						;;
		* )				usage
						exit 1
	esac
	shift
done

if [ $do_dump -eq 1 ]; then
	dump_data

	if [ $do_routines -eq 1 ]; then
		dump_routines
	fi
fi

if [ $do_clear -eq 1 -a "$destination" != "" ]; then
	clear "$destination"
fi

if [ $do_load -eq 1 -a "$destination" != "" ]; then
	load "$destination" "$DATA_FILE"
	reset_passwords "$destination"
fi

if [ $do_routines -eq 1 -a "$destination" != "" ]; then
	load "$destination" "$ROUTINES_FILE"
fi
