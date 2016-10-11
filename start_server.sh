#!/bin/bash

unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
elif [[ "$unamestr" == 'Darwin' ]]; then
 /Applications/Docker.app/Contents/MacOS/Docker & 
fi

#rails server
#foreman start -c web=1,user=0,redis=1 #sidekiq
foreman start -c web=1,user=4,other=1,mailer=1,redis=1
# Server config
#foreman start -c web=1,user=6,other=1,mailer=1
