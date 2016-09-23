#!/bin/bash

# starting processes needed by the webserver
# redis - An in-memory database (inpersistent)
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
  # start the redis server here
  echo "START REDIS NOT IMPLEMENTED"
elif [[ "$unamestr" == 'Darwin' ]]; then
  # starting the via brew installed redis server
  brew services start redis
fi

#foreman start -c web=1,user=4,other=1,mailer=1
# Server config
rails server
#foreman start -c web=1,user=6,other=1,mailer=1
