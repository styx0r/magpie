# Config file for foreman

 # start rails server
web: bundle exec rails server
 # start rails server on public domain
#web: passenger start

#Start worker pools for development
#delayed_job
#user: QUEUE=userjobs bundle exec rake jobs:work
#other: QUEUE=default bundle exec rake jobs:work
#mailer: QUEUE=mailer bundle exec rake jobs:work
#redis: redis-server

#sidekiq
user: bundle exec sidekiq -q userjobs -C config/sidekiq.yml
other: bundle exec sidekiq -q default
mailer: bundle exec sidekiq -q mailer
redis: redis-server
