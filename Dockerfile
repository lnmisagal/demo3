FROM bauson/com:ubiphp81 
# mirrored from registry.redhat.io/ubi9/php-81
USER root
ENV TZ=Asia/Manila
RUN sed -i 's/#DocumentRoot/DocumentRoot/g' /etc/httpd/conf/httpd.conf && \
    sed -i 's#/opt/app-root/src#/opt/app-root/src/public#g' /etc/httpd/conf/httpd.conf && \
    sed -i 's/enabled=1/enabled=0/g' /etc/yum/pluginconf.d/subscription-manager.conf && \
    yum update -y && yum reinstall tzdata -y && yum upgrade -y && yum clean all && \
    sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 500M/g' /etc/php.ini && \
    sed -i 's/post_max_size = 8M/post_max_size = 500M/g' /etc/php.ini && \
    sed -i 's:variables_order = "GPCS":variables_order = "GPCES":g' /etc/php.ini && \
    rm -fR /tmp/sessions && \
    /usr/libexec/container-setup && rpm-file-permissions && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    echo "<?php phpinfo(); ?>" > index.php

#COPY entrypoint.sh /entrypoint.sh
#RUN chmod +x /entrypoint.sh && cat /entrypoint.sh

#COPY . .
#RUN composer install
#RUN chmod 777 storage -R 
CMD ["/entrypoint.sh"]
