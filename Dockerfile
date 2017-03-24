FROM ubuntu:14.04
LABEL MAINTAINER clarkzjw <clark.zhao@daocloud.io>

RUN \
    apt-get update && \
    apt-get install -y ksh zip apache2 php5 libapache2-mod-php5 php5-dev php-pear && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /opt/ibm && \
    mkdir -p /var/www/html

COPY ./ibm_data_server_driver_package_linuxx64_v11.1.tar.gz /opt/ibm/dsdriver.tar.gz
COPY ./ibm_db2-1.9.9.tgz /opt/ibm/ibm_db2-1.9.9.tgz
COPY ./Technology_Explorer_v4.2_for_IBM_DB2.tar.gz /var/www/html/Technology_Explorer_v4.2_for_IBM_DB2.tar.gz

RUN \
    cd /opt/ibm && \
    tar -xf dsdriver.tar.gz && \
    tar -xf ibm_db2-1.9.9.tgz && \
    cd dsdriver && \
    chmod 755 installDSDriver && \
    ksh installDSDriver && \
    cd ../ibm_db2-1.9.9 && \
    phpize && \
    ./configure --with-IBM_DB2=/opt/ibm/dsdriver && \
    make && \
    make install && \
    echo "extension = ibm_db2.so" >> /etc/php5/apache2/php.ini && \
    cd /var/www/html && \
    tar -xf ./Technology_Explorer_v4.2_for_IBM_DB2.tar.gz && \
    rm -rf /var/www/html/Technology_Explorer_v4.2_for_IBM_DB2.tar.gz && \
    rm -rf /opt/ibm/dsdriver.tar.gz && \
    rm -rf /opt/ibm/ibm_db2-1.9.9.tgz && \
    rm -rf /var/www/html/index.html && \
    chown -R root:root /var/www/html && \
    chmod -R 755 /var/www/html && \
    service apache2 restart

CMD ["apachectl", "-D", "FOREGROUND"]
