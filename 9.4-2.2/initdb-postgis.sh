#!/bin/sh

set -e

# Perform all actions as $POSTGRES_USER
export PGUSER="$POSTGRES_USER"

# Create the 'template_postgis' template db
"${psql[@]}" <<- 'EOSQL'
CREATE DATABASE template_postgis;
UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template_postgis';
EOSQL

# Load PostGIS into both template_database and $POSTGRES_DB
for DB in template_postgis "$POSTGRES_DB"; do
	echo "Loading PostGIS extensions into $DB"
	"${psql[@]}" --dbname="$DB" <<-'EOSQL'
		CREATE EXTENSION postgis;
		CREATE EXTENSION postgis_topology;
		CREATE EXTENSION fuzzystrmatch;
		CREATE EXTENSION postgis_tiger_geocoder;
EOSQL
done


# Restrict subnet to IPv4 private networks
sed -i '$ d' $PG_CONF_DIR/$PG_CONF_HBA
echo "host    all             all             172.16.0.0/12               md5" >> $PG_CONF_DIR/$PG_CONF_HBA
echo "host    all             all             10.0.0.0/8                 md5" >> $PG_CONF_DIR/$PG_CONF_HBA
echo "host    all             all             192.168.0.0/16                 md5" >> $PG_CONF_DIR/$PG_CONF_HBA
echo "host    all             all             169.254.0.0/16                 md5" >> $PG_CONF_DIR/$PG_CONF_HBA
# Listen on all ip addresses
echo "listen_addresses = '*'" >> $PG_CONF_DIR/$PG_CONF
echo "port = 5432" >> $PG_CONF_DIR/$PG_CONF

# Enable ssl on postgres != 9.1
if [ "$POSTGRES_MAJOR" != '9.1' ]; then
  echo "ssl = true" >> $PG_CONF_DIR/$PG_CONF
  echo "ssl_cert_file = '/etc/ssl/certs/ssl-cert-snakeoil.pem'" >> $PG_CONF_DIR/$PG_CONF
  echo "ssl_key_file = '/etc/ssl/private/ssl-cert-snakeoil.key'" >> $PG_CONF_DIR/$PG_CONF
fi