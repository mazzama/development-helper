# How to run

docker run -d --hostname my-rabbit --name rabbit_local -e RABBITMQ_DEFAULT_USER=guest -e RABBITMQ_DEFAULT_PASS=guest -p 5672:5672 -p 15672:15672 rabbitmq:3.11.8-management