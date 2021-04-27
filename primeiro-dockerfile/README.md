Acesse o Terminal, navegue até a pasta do Dockerfile e builde a imagem Docker:

````
docker build -t first-dockerfile .
````

Suba o Container:
````
docker run -d -p 8080:80 first-dockerfile
````
