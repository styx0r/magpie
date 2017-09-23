# Welcome to Magpie

MAGPIE is a web server application designed for collaborative work between
scientists, especially in the field of bio- and life-sciences.
It can be used within scientific groups, as well as in a larger scale
on public servers. A demo server is available
[here](https://magpie.imb.medizin.tu-dresden.de).

## Getting Started

### Preinstalled Image

1. Download the guest image from [here](https://magpie.imb.medizin.tu-dresden.de/magpie-image.zip)

2. Install [Virtualbox](https://www.virtualbox.org/wiki/Downloads) and import the guest image

3. Start the guest image, open a terminal and run the following:

       $ cd magpie
       $ ./start_server.sh

    Note: The password is magpie.
    
4. Now you are able to connect by open up a browser and go to URL:

       $ localhost:3000

### Manual Installation

1. Install ruby and rails according to the official instructions. You can find the instructions for Ubuntu, Windows and Mac OSX
    [here](https://gorails.com/setup). There is no need
       to install MySQL or PostgreSQL.

2. Install necessary packages:

       $ sudo apt-get install docker.io libmagic-dev redis-server

3. Adding user to the docker group:

       $ sudo usermod -aG docker $(whoami)

   Afterwards you need to log off and log on.

4. Download the magpie project from github. If git is not installed you can
   either download it directly from [here](https://github.com/christbald/magpie/archive/master.zip) or install as follows:

       $ git clone https://github.com/christbald/magpie.git

5. Change into the magpie directory and install the bundles:

       $ cd magpie
       $ bundle install

6. Create the database with default entries and prepare the docker image:

       $ rails db:reset

7. Start the rails server:

       $ ./start_server.sh

8. Now you are able to connect by open up a browser and go to URL:

       $ localhost:3000
 
