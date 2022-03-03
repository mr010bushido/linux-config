#!/bin/bash
# 
# References for script 
# 

DOMAIN_NAME=$1 #<-- Argument 1
WP_WEB_ROOT="/var/www/$DOMAIN_NAME/html"
WP_OWNER=$2 # <-- wordpress owner, argument 2
WP_GROUP=www-data # <-- wordpress group
EMAIL=${3-"admin@$DOMAIN_NAME"} # <-- argument 3
SITES_ENABLED='/etc/apache2/sites-enabled/'
SITES_AVAILABLE='/etc/apache2/sites-available/'
SITES_AVAILABLE_DOMAIN=$SITES_AVAILABLE$DOMAIN_NAME.conf
#DB_NAME=${4-"test"}
#DB_USER=${5-"root"}
#DB_PASSWORD=${6-""}


# # Download the latest compressed releases and extract the compressed file to create the Wordpress directory structure

echo -e $"Downloading and extracting the latest WordPress release...\n"

cd /tmp && 
  { curl -O https://wordpress.org/latest.tar.gz ; 
    echo -e $"\nBeginning extraction...\n"
    pv latest.tar.gz | tar -xz ;  
  }
  cd -
  

echo -e $"\nExtraction complete.\n"

# Create the .htaccess file and set the permissions for WordPress to use later

echo -e $"Creating  releaseandccess file and setting permissions. \n"

touch /tmp/wordpress/.htaccess
chmod 660 /tmp/wordpress/.htaccess

# Copy over the sample configuration file to the filename that WordPress actually reads

echo -e $"Setting up WordPress configuration file from sample provided \n"

cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php

echo -e $"You can proceed to do your usual WordPress config song and dance.\n"

# Create the upgrade directory, so that WordPress won’t run into permissions issues when trying to do this on its own following an update to its software

echo -e $"Creating upgrade directory...\n"

mkdir /tmp/wordpress/wp-content/upgrade


# So, move inside/var/www and create ehe folder for your site. For your convenience, you may assign h corresponding domain name to each folder

echo -e $"Creating site directory...\n"

mkdir -p /var/www/${DOMAIN_NAME}/html

# copy the entire contents of the directory into our document root. We are using the -a flag to make sure our permissions are maintained. We are using a dot at the end of our source directory to indicate that everything within the directory should be copied, including hidden files (like the .htaccess file we created)
echo -e $"Site directory created successfully. 
Copying WordPress to site Directory $DOMAIN_NAME...\n"

cp -a /tmp/wordpress/. /var/www/${DOMAIN_NAME}/html

echo -e $"Complete. Proceeding to adjust ownership and permissions of site directory  \n"

# Adjust ownership and permissions of WordPress document root 
chown -R ${WP_OWNER}:${WP_GROUP} /var/www/${DOMAIN_NAME}

# Set group id to www-data and sudo user who belongs to www-data group
find /var/www/${DOMAIN_NAME}/html -type d -exec chmod g+s {} \;

# Give group write access to the wp-content directory so that the web interface can make theme and plugin changes
chmod g+w /var/www/${DOMAIN_NAME}/html/wp-content

# Give the web server write access to all of the content in these two directories:
chmod -R g+w /var/www/${DOMAIN_NAME}/html/wp-content/themes
chmod -R g+w /var/www/${DOMAIN_NAME}/html/wp-content/plugins

echo -e $"Creating a vhost for $SITES_AVAILABLE_DOMAIN with a webroot $WP_WEB_ROOT... \n"

# Create virtual host rules file 
echo "
 <VirtualHost *:80>
   serverAdmin $EMAIL
   ServerAlias $DOMAIN_NAME
   DocumentRoot $WP_WEB_ROOT
   <Directory $WP_WEB_ROOT>
      Options FollowSymLinks
      AllowOverride Limit Options FileInfo
      DirectoryIndex index.php
      Require all granted
  </Directory>
  <Directory $WP_WEB_ROOT/wp-content>
      Options FollowSymLinks
      Require all granted
  </Directory>
  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" > $SITES_AVAILABLE_DOMAIN


sed -i "1s/^/127.0.0.1    $DOMAIN_NAME\n/" /etc/hosts

echo -e $"New Virtual Host Created\n"

a2ensite $DOMAIN_NAME # <-- Enable the site
a2enmod rewrite # <--Enabe URL rewriting
service apache2 reload # <-- Reload apache2 to apply these settings

# Insert Database credentials

if [[ $DB_NAME ]]; then
  echo -e $"\nInserting DB credentials into Wordpress configuration file"
fi


#sed -i 's/database_name_here/${DB_NAME}/' /var/www/${DOMAIN_NAME}/html/wp-config.php
#sed -i 's/username_here/${DB_USER}/' /var/www/${DOMAIN_NAME}/html/wp-config.php
#sed -i 's/password_here/${DB_PASSWORD}/' /var/www/${DOMAIN_NAME}/html/wp-config.php

#Query secret key values from WordPress

echo -e $"\nRetrieving Secret-Key Salt values from WordPress...\n"

curl -s https://api.wordpress.org/secret-key/1.1/salt/

echo -e $"\nsudo nvim /var/www/${DOMAIN_NAME}/html/wp-config.php to update the WordPress configuration file.\n"

echo -e $"Done, please browse to http://$DOMAIN_NAME to check!\n"

