[![Build Status](https://travis-ci.org/boosterconf/booster.png)](https://travis-ci.org/boosterconf/booster)

# Booster Conference site

## Setting up your environment

### Docker

Vagrant can be a hassle, especially for windows users who are dependent on hyper-v in the daily workflow, hence we have a docker option to run the app as we ll.

To use the dockerfile, do the following:

1. Navigate to the root of the repo.
2. Run docker build -t booster . The entire application is copied to the container and bundle install will be ran.
3. Setup a version of postgresql on the host machine.
4. Grab a copy of a database, or seed a new one with migrations. heroku pg:pull is great for pulling an existing copy, or try pg_restore -d boosterconf latest.dump --port 5432 --host localhost after creating a dump of the database. Note that the target database needs to be created first.
5. Run the container: docker run -p 3000:3000 -e s3_access_key_id=keyid -e s3_secret_access_key=secretaccesskey booster
7. Configure rubymine to use the container as a remote interpreter.

### Vagrant
Install Vagrant and VirtualBox, and checkout this repository. Then do the following steps. 

    $ cd booster
    $ vagrant up # Wait for some time for this to complete
    $ vagrant ssh
    $ cd /vagrant
    $ sh ./init.sh  # Wait for even longer. At the end of this script, you will be prompted for your heroku credentials, before the production database is pulled down.
    $ # If the previous steps have succeeded, continue
    $ ./getsecrets.sh #This will get S3 secrets from Heroku and store them in secrets.sh 
    $ ./start.sh

Test app in your host system browser, and verify that the booster conf home page is shown on localhost:3000. 
If failure, reach out to us on Slack. :)

### Database connection with Vagrant
    Applies to RubyMine:
    * Databases -> New connection (The pluss sign).
    * In the General tab
        * Host: 127.0.0.1
        * Database: boosterconf
        * User: vagrant
        * Pw: vagrant
        * URL: jdbc:postgresql://127.0.0.1/boosterconf
        
    *In the SSL / SSH tab:
        * Check Use SSH tunnel
        * Proxy Host: localhost
        * Port: 2222
        * Proxy user: vagrant
        * Auth type: Password
        * PW: vagrant
        * check remember password if you want to
## WSL

Install RVM : https://github.com/rvm/ubuntu_rvm

When adding remote SDK in rubymine select WSL, provide path to rvm instead of directly to the rub executuable. E.g: /usr/share/rvm/bin/rvm if you have used the ubuntu package above.
If not, your life will be miserable while you try to find out why rubymine does not download your gems properly.

Make sure you have a local instance of postgresql with a clean db running.
## Deploying to Heroku

Setup:

    # Install the heroku gem
    $ gem install heroku
    # Install your SSH keys (Uses ~/.ssh/id_rsa.pub)
    $ heroku keys:add
    $ cd booster
    $ git remote add production git@heroku.com:booster2019.git
    $ git remote add staging git@heroku.com:staging-boosterconf.git

Fool around:

    # remote console
    $ heroku console --app staging-boosterconf
    $ heroku console --app booster2019
    # Pull data from the heroku app to your local db
    $ dropdb boosterconf
    $ heroku pg:pull DATABASE_URL boosterconf --app booster2019

Update (push):

    $ git push [production|staging|master]
    #DB changes? remember to migrate the server
    $ heroku rake db:migrate --app [staging-boosterconf|booster2019]

Run tests:

    $ rake db:test:prepare RAILS_ENV=test
    # Run "old" tests"
    $ rake test
    # Run "spec" based tests: 
    $ rake spec
    # After tests have run, open up coverage/index.html in your browser for a coverage report by SimpleCov

Heroku SendGrid:
    # For å sjekke user/pass:
    $ heroku config --long --app booster2019
