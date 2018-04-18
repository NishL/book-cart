# Configure production grade server locally with Apache and Passenger

## Install Apache2 

1. Make sure you have apache installed `sudo apt-get install apache2`
2. Install the passenger gem: `gem install passenger --version 5.0.29 --no-ri --no-rdoc`
3. Install the apache module for passenger: `passenger-install-apache2-module`
4. If any dependencies are missing you will know from the command that you have just run.
    a) I ran into an issue where we're given the wrong hint for installing missing apache2 dependencies on Ubuntu 16.04.
       It produces the following ouput: `To install Apache 2 development headers: Please install it with apt-get install apache2-threaded-dev`
       Running that command won't work, instead you should run: `apt-get install apache2-dev`. Then continue.
5. Passenger will tell you that you need to add some lines to the Apache configuration file. Copy them and add them to the bottom of the file.
6. If you have trouble finding the configuration file, then run `apachectl -V | grep HTTPD_ROOT` to find the directory. 
   Then run `apachectl -V | grep SERVER_CONFIG_FILE` to find out which file to edit.
7. The file may, by default only allow readonly access, so, to edit the file used `sudo`, example: `sudo vim /etc/apache2/apache2.conf`.
8. Run the installer again and it will make sure you've done everything correctly.


## Deploying Locally

The previous step is only done once per server. This next step is done once per application.

1. Create file in `/etc/apache2/sites-available/` called bookcart.conf (/etc/apache2/sites-available/bookcart.conf) with the following:

```
# Virtual Host for book-cart app
<VirtualHost *:80>
  ServerName local.bookcart.com
  DocumentRoot /home/test/Projects/rails/book-cart/public
  SetEnv SECRET_KEY_BASE "asdfasdf5654asdf5asdf5a56f4etc"
  <Directory ~/Projects/rails/book-cart/public/>
    AllowOverride all
    Options -MultiViews
    Require all granted
  </Directory>
</VirtualHost>
```
You can run bin/rails secret to generate a key, and of course it should not be checked into source control.

2. Enable the site with the following command: `sudo a2ensite bookart`.

3. Then run: `sudo service apache2 reload`, followed by `sudo apachectl restart`.

4. Next the client needs to be configured so that it maps the hostname chosen to the correct machine. This is done is a file named `/etc/hosts`.
   Add the following line: `127.0.0.1 local.bookcart.com`.

That should be it!


