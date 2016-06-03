# Config file for foreman

 # start rails server
web: bundle exec rails server

#Start worker pools for development
user: QUEUE=userjobs bundle exec rake jobs:work
other: QUEUE=default bundle exec rake jobs:work
mailer: QUEUE=mailer bundle exec rake jobs:work
