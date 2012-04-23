EM-Openyale
-------

#### About:
This is a personal project to help me download Openyale videos much easier.  It uses Eventmachine to issue commands over the network.  It sends the jobs to Resque and uses ResqueStatus to monitor the progress of the downloads.  Postgres provides persistance through DataMapper.  Sinatra provides a frontend to the project.

#### Setup:
You will need to set up postgres and create the users/databases on your own.  Get Redis running.  Bundle Install, etc.

### Yaml Files:
Copy the config/*.yml.example files to config/database.yml, config/redis.yml, and em.yml.  Set the config_path in config/em.yml.  It is currently set to spec/config for convenience.

### Rake Tasks:
There's a few Rake tasks in the project:

* rake db:migrate # creates all the tables
* rake db:upgrade # reloads the schema
* rake console # provides a pry console
* there will be more tasks as i complete the services

### Services:
The project is composed of 3 services:

* ruby start.rb # to start the em-server
* rake resque:work # to process the downloads
* rackup config.ru # to start sinatra to monitor downloads progress

#### To Do:
I've worked on this for one night so far.  Still need to implement the Redis job to download the video, set up the EventMachine interface and set up Sinatra.  Hope to be done soon.