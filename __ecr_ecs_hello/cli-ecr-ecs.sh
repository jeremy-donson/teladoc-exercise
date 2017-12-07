# ECR

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
RUN echo "Hello World" > /var/www/index.html

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


# docker-machine ip machine-name

PASS=$(aws ecr get-login --no-include-email)
echo $PASS
docker login -u AWS -p
unset PASS

EXPECTED='Hello World'
ACTUAL=$(curl http://localhost:8089)
if [ $ACTUAL -eq $EXPECTED ]
  then
  echo "IT WORKED"
  else
  exit 1
fi

# Create ecr repo and tag it
# aws ecr describe-repositories
TAG='hello-world'
# aws ecr delete-repository --repository-name ${TAG}
URI=$( aws ecr create-repository --repository-name ${TAG} | grep Uri | awk -F '\"' '{print $4}' )
echo ${URI}

# tag
docker tag ${TAG} ${URI}

# push
docker push ${URI}

aws ecr list-images --repository-name ${TAG}
# {"imageIds": [{"imageDigest": "sha256:4265535aaa456b2e7ce7bc45fe5980adf67fbc9e7c7ad49dd2bad25e9ce5f4b4","imageTag": "latest"}]}

aws ecr describe-images --repository-name ${TAG}
# {"imageDetails": [ { "registryId": "589424541475",repositoryName": "hello-world",imageDigest": "sha256:4265535aaa456b2e7ce7bc45fe5980adf67fbc9e7c7ad49dd2bad25e9ce5f4b4","imageTags": ["latest"],"imageSizeInBytes": 82060056,"imagePushedAt": 1512610747.0}]}

##  ECS
$CLUSTER_NAME='TEST1'
aws ecs create-cluster --cluster-name ${CLUSTER_NAME}
# {"family": "sample-fargate", "networkMode": "awsvpc", "containerDefinitions": [{"name": "fargate-app", "image": "httpd:2.4", "portMappings": [{"containerPort": 80,"hostPort": 80,"protocol": "tcp"}], "essential": true, "entryPoint": ["sh","-c"], "command": ["/bin/sh -c \"echo '<html> <head> <title>Amazon ECS Sample App</title> <style>body {margin-top: 40px; background-color: #333;} </style> </head><body> <div style=color:white;text-align:center> <h1>Amazon ECS Sample App</h1> <h2>Congratulations!</h2> <p>Your application is now running on a container in Amazon ECS.</p> </div></body></html>' >  /usr/local/apache2/htdocs/index.html && httpd-foreground\""]}], "requiresCompatibilities": ["FARGATE"], "cpu": "256", "memory": "512"}

mkdir tasks
cat $1 > tasks/sample_tasks.json <<EOF
{
    "family": "sample-fargate", 
    "networkMode": "awsvpc", 
    "containerDefinitions": [
        {
            "name": "fargate-app", 
            "image": "httpd:2.4", 
            "portMappings": [
                {
                    "containerPort": 80, 
                    "hostPort": 80, 
                    "protocol": "tcp"
                }
            ], 
            "essential": true, 
            "entryPoint": [
                "sh",
		"-c"
            ], 
            "command": [
                "/bin/sh -c \"echo '<html> <head> <title>Amazon ECS Sample App</title> <style>body {margin-top: 40px; background-color: #333;} </style> </head><body> <div style=color:white;text-align:center> <h1>Amazon ECS Sample App</h1> <h2>Congratulations!</h2> <p>Your application is now running on a container in Amazon ECS.</p> </div></body></html>' >  /usr/local/apache2/htdocs/index.html && httpd-foreground\""
            ]
        }
    ], 
    "requiresCompatibilities": [
        "FARGATE"
    ], 
    "cpu": "256", 
    "memory": "512"
}
EOF

PWD=$(pwd)
aws ecs register-task-definition --cli-input-json file://${PWD}/tasks/fargate-task.json

aws ecs list-task-definitions

# Create a service
SERVICE_NAME='TEST_SERVICE'
aws ecs create-service --cluster fargate-cluster --service-name ${SERVICE_NAME} --task-definition sample-fargate:1 --desired-count 2 --launch-type "FARGATE" --network-configuration "awsvpcConfiguration={subnets=[subnet-abcd1234],securityGroups=[sg-abcd1234]}"

# List services
aws ecs list-services --cluster ${CLUSTER_NAME}

# Describe running services
aws ecs describe-services --cluster ${CLUSTER_NAME} --services

# Stop services


:'

NAME
       ecs -

DESCRIPTION
       Amazon  EC2  Container Service (Amazon ECS) is a highly scalable, fast,
       container management service that makes it easy to run, stop, and  man-
       age  Docker  containers  on a cluster of EC2 instances. Amazon ECS lets
       you launch and stop  container-enabled  applications  with  simple  API
       calls,  allows  you to get the state of your cluster from a centralized
       service, and gives you access to many familiar Amazon EC2 features like
       security groups, Amazon EBS volumes, and IAM roles.

       You  can  use Amazon ECS to schedule the placement of containers across
       your cluster based on your  resource  needs,  isolation  policies,  and
       availability  requirements. Amazon EC2 Container Service eliminates the
       need for you to operate your own cluster management  and  configuration
       management  systems  or worry about scaling your management infrastruc-
       ture.

AVAILABLE COMMANDS
 create-cluster
 create-service
 delete-attributes
 delete-cluster
 delete-service
 deregister-container-instance
 deregister-task-definition
 describe-clusters
 describe-container-instances
 describe-services
 describe-task-definition
 describe-tasks
 discover-poll-endpoint
 help
 list-attributes
 list-clusters
 list-container-instances
 list-services
 list-task-definition-families
 list-task-definitions
 list-tasks
 put-attributes
 register-container-instance
 register-task-definition
 run-task
 start-task
 stop-task
 submit-container-state-change
 submit-task-state-change
 update-container-agent
 update-container-instances-state
 update-service
 wait
'