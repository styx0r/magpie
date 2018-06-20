# Welcome to Magpie

MAGPIE is a web server application designed for collaborative work between
scientists, especially in the field of bio- and life-sciences.
It can be used within scientific groups, as well as in a larger scale
on public servers. A demo server is available
[here](https://magpie.imb.medizin.tu-dresden.de).

## Getting Started

### Preinstalled Image

1. Install _Virtualbox_, following the description [here](https://www.virtualbox.org/wiki/Downloads).

2. Download the _guest image_ from [here](https://magpie.imb.medizin.tu-dresden.de/magpie-vbox-image.zip) and
   unzip the downloaded _guest image_ to ~/VirtualBox VMs.
   
       $ mkdir ~/VirtualBox VMs
       $ unzip ~/Downloads/magpie-vbox-image.zip -d ~/VirtualBox VMs/

3. Add and configure the _Virtualbox image_ by clicking on _New_. After, put in the _name_ (Magpie), _type_ (Linux),
   _version_ (Ubuntu 64-bit). Set memory size to at least 4096 MB (depending on your system). Furthermore,
   set hard disk to _use an existing virtual hard disk file_ and choose the _.vdi_ file of the extracted
   _guest image_ (~/VirtualBox VMs/Magpie-Image/Magpie.vdi). See here:

![add image to virtualbox](https://magpie.imb.medizin.tu-dresden.de/VirtualBoxAddImage.png)  
       
   Click on _Create_.

4. Configure the number of CPUs used (_Settings_ -> _System_ -> _Processor_) to at least 2 and enabling PAE/NX by clicking on _Enable PAE/NX_.  Set the attached network adapter (_Settings_ -> _Network_ -> _Adapter 1_) to _Bridged Adapter_.

![cpu config in virtualbox](https://magpie.imb.medizin.tu-dresden.de/VirtualBoxCPUConfig.png)
![ntwork config in virtualbox](https://magpie.imb.medizin.tu-dresden.de/VirtualBoxNetworkConfig.png)

5. Start the guest image

    Note: In case needed, the password is magpie.
    
6. Now you are able to connect by open up a browser (in host OR guest) and go to URL:

       $ magpie.local:3000
       
7. The administrative login is the following:

       $ Email: admin@admin.com
       $ Password: admin_password_17
       
8. Happy modelling ... :)

### Manual Installation (tested under Ubuntu 18.04)

1. Install ruby and rails according to the official instructions. You can find the instructions for Ubuntu, Windows and Mac OSX
    [here](https://gorails.com/setup). There is no need to install MySQL or PostgreSQL.

2. Install necessary packages and gems:

       $ sudo apt-get install docker.io libmagic-dev redis-server libssl1.0-dev

       $ gem install foreman

3.  stop redis-server and turn off start on boot-up

       $ sudo update-rc.d redis-server disable

       $ /etc/init.d/redis-server stop

4. Adding user to the docker group:

       $ sudo usermod -aG docker $(whoami)

   **Afterwards you need to log off and log on.**

5. Download the magpie project from github. If git is not installed you can
   either download it directly from [here](https://github.com/christbald/magpie/archive/master.zip) or install as follows:

       $ git clone https://github.com/christbald/magpie.git

6. Change into the magpie directory and install the bundles:

       $ cd magpie
       $ bundle install

7. Create the database with default entries and prepare the docker image:

       $ rails db:reset

8. Start the rails server:

       $ ./start_server.sh

9. Now you are able to connect by open up a browser and go to URL:

       $ localhost:3000
       
10. Happy modelling ... :)        
