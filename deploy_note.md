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

