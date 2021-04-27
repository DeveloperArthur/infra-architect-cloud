docker network create minharede

docker run -d --network=minharede -p 80:80 nginx

docker run -d --network=minharede -e MYSQL_ROOT_PASSWORD=teste mysql