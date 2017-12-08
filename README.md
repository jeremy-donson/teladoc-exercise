# teladoc-exercise
# jjdonson@gmail
### github url: https://github.com/jeremy-donson/teladoc-exercise
### diagram url: https://cacoo.com/diagrams/5Vt6Zpua9yAqJmBI
--
# 1. Create the Dockerfile for postgres service

cd apps/web/
python3 create_postgres_dockerfile.py
cd ..

# 2. Build and run the Docker containers

time docker-machine create -d virtualbox dev;
eval "$(docker-machine env dev)"

time docker-compose build
time docker-compose up -d
time docker-compose run web env
time docker-compose logs

# How to cache locally? ??

# 3. Create or re-initialize the database
docker-compose run --rm web python ./instance/db_create.py

Go to your favorite web browser and open:

    http://192.168.99.100:5000  $ Check the IP address using 'docker-machine ip'

# Stop and remove all docker containers.
docker ps -aq.
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)

# Remove docker-machine named dev
# docker-machine rm dev

## Key Python Modules Used

- Flask - web framework
- Jinga2 - templating engine
- SQLAlchemy - ORM (Object Relational Mapper)
- Flask-Bcrypt - password hashing
- Flask-Login - support for user management
- Flask-Migrate - database migrations
- Flask-WTF - simplifies forms
- itsdangerous - helps with user management, especially tokens

This application is written using Python 3.6.1.
The database used is PostgreSQL.

Docker is the recommended tool for running in development and production.

----

Test without docker:
$ cd app
$ python3 -m venv venv
$ for i in $(ls | grep -v venv); do cp -r $i  ; done
$ cd venv
$ source bin/activate
$ pip3 install -r web/requirements.txt

Get Postgres and Nginx running....

$ psql -p 5432 -U postgres --password
POSTGRES_USER = 'teladoc'
POSTGRES_PASSWORD = 'flask_recipes'

Run app.
Curl url.
