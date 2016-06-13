# Restrict snakeoil ssh key permission so prostgres won't complain when using it
chmod 600 /etc/ssl/private/ssl-cert-snakeoil.key

CONF="/etc/postgresql/9.3/main/postgresql.conf"

# Restrict subnet to IPv4 private networks
echo "host    all             all             172.16.0.0/12               md5" >> /etc/postgresql/9.3/main/pg_hba.conf
echo "host    all             all             10.0.0.0/8                 md5" >> /etc/postgresql/9.3/main/pg_hba.conf
echo "host    all             all             192.168.0.0/16                 md5" >> /etc/postgresql/9.3/main/pg_hba.conf
echo "host    all             all             169.254.0.0/16                 md5" >> /etc/postgresql/9.3/main/pg_hba.conf
# Listen on all ip addresses
echo "listen_addresses = '*'" >> /etc/postgresql/9.3/main/postgresql.conf
echo "port = 5432" >> /etc/postgresql/9.3/main/postgresql.conf

# Enable ssl
echo "ssl = true" >> $CONF
echo "ssl_cert_file = '/etc/ssl/certs/ssl-cert-snakeoil.pem'" >> $CONF 
echo "ssl_key_file = '/etc/ssl/private/ssl-cert-snakeoil.key'" >> $CONF 