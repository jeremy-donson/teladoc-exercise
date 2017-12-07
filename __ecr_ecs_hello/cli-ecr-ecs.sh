# CREATE PROJECT DIR AND GET IN THERE!
mkdir ecr_ecs_hello
cd ecr_ecs_hello/

# CREATE DOCKERFILE
cat $1 > Dockerfile <<EOF
FROM ubuntu:12.04

# Install dependencies
RUN apt-get update -y
RUN apt-get install -y apache2

# Install apache and write hello world message
RUN echo "Hello World!" > /var/www/index.html

# Configure apache
RUN a2enmod rewrite
RUN chown -R www-data:www-data /var/www
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80

CMD ["/usr/sbin/apache2", "-D",  "FOREGROUND"]
EOF

# Build docker image
docker build -t hello-world .

# Check docker image
docker images --filter reference=hello-world

# Run new image
docker run -p 8089:80 hello-world


docker-machine ip machine-name

curl http://localhost:80