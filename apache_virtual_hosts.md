# Virtual Hosts on Linux
## Configuring Virtual Host on Apache

The example of Virtual Host configuration shown in this tutorial is  name-based, since it relies on the website's domain name to distinguish requests. There is another IP-based mode, when multiple domains have to be each associated with a different IP address.

In the example of this tutorial, mypersonaldomain.com will be used as a domain, but you will have to use an existing domain that you own.

By accessing the IP address of the Server where you have just installed Apache, you can normally find the content of your website inside a public folder at var/www/html.

If you want to host multiple websites, it’s therefore easy to see how to create as many folders as there are websites provided that, for each website, the configuration file of the virtual host which will make it accessible via the web, is correctly set up.

So, move inside/var/www and create the folder for your site. For your convenience, you may assign the corresponding domain name to each folder:

`cd ~/var/www`

`sudo mkdir -p mypersonaldomain.com/html/`

Define your current user as owner of those folders and assign the right permissions for reading and editing files:

`sudo chown -R $USER:$USER /var/www/mypersonaldomain.com/html `

`sudo chmod -R 755 /var/www/mypersonaldomain.com `

All you have to do is generate the configuration file for your virtual host, by typing:

`sudo vi /etc/apache2/sites-available/mypersonaldomain.com.conf`

Paste the following content into the editor just opened, paying attention to replace mypersonaldomain.com  with your domain every time. 
```
VirtualHost *:80>
ServerAdmin admin@mypersonaldomain.com   
ServerName mypersonaldomain.com
ServerAlias www.mypersonaldomain.com
DocumentRoot /var/www/mypersonaldomain.com/html
ErrorLog ${APACHE_LOG_DIR}/error.log
CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>`
```

In each configuration, 
    - `ServerAdmin` refers to the sysadmin email, 
    - `ServerName` refers to the name of the Virtual Host, 
    - `ServerAlias` define how it is translated by the server when DocumentRoot identifies the path where its contents on the server disk are. Finally, 
    - `ErrorLog` and 
    - `CustomLog` contain the path of the system log files.

Save and close using the `:wq` and confirm by pressing ENTER.

## Virtual Host configuration

Then, enable the new site and disable the default Apache configuration:

`sudo a2ensite mypersonaldomain.com.conf`

`sudo a2dissite 000-default.conf`

To verify that everything uses the syntax provided by Apache, use the integrated tool by typing:

`sudo apache2ctl configtest`

The answer `Syntax OK` should be returned. Then, restart Apache to apply the changes and have the web server use your configuration file.

`sudo systemctl restart apache2`  

If the configuration of the Virtual Host was successful, the message contained in the HTML page previously created in the domain folder will be shown.

## Creating the second Apache Virtual Host

The creation of the second Virtual Host with Apache is a very simple operation: you just need to repeat the operations previously carried out. For this second virtual host mypersonaldomain2.com is used as domain .

Create the folder of the second site:

`sudo mkdir -p /var/www/mypersonaldomain2.com/html`

Define the owner of the folder:

`sudo chown -R $USER:$USER /var/www/mypersonaldomain2.com/html`

Set permissions:

`sudo chmod -R 755 /var/www/mypersonaldomain2.com` 

Generate the configuration file also for the second Virtual Host:
```
<VirtualHost *:80>
ServerAdmin admin@mypersonaldomain2.com
ServerName mypersonaldomain2.com
ServerAlias www.mypersonaldomain2.com
DocumentRoot /var/www/mypersonaldomain2.com/html
ErrorLog ${APACHE_LOG_DIR}/error.log
CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

Enable the configuration file of the second Virtual Host:

`sudo a2ensite mypersonaldomain2.com.conf`

Check that the syntax is correct:

`sudo apache2ctl configtest`

Restart Apache:

sudo systemctl restart apache2 
