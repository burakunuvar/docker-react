

# docker build .
# docker build -f Dockerfile.dev .
# use an existing docker image as a base
# delete local dependencies to prevent duplication


=> build Dockerfile.dev
```
$ docker build -f Dockerfile.dev .
```

=> give a reference to local, to track updates no the fly
```
$ docker run -p 3000:3000 -v /app/node_modules -v "$(pwd):/app" <imageID>
```
=> `-v /app/node_modules ` is for using what already exists in container
=> ` "$(pwd):/app"` is for mapping : local to container

=> or use a docker-compose.yml

```
version: '3'
services:
  react-app:
    build:
      context: .
      dockerfile: Dockerfile.dev
    ports:
      - "3000:3000"
    volumes :
      - /app/node_modules
      - .:/app
```

=> tests have 2 options
  : via shell

```
$ docker run <id> command
$ docker run -it <id> npm run test
$ docker run -it <id> sh
  > npm run test
$ docker run -v /app/node_modules -v "$(pwd):/app" -it <id> npm run test
```
=> while running , tests will not be updated without volume mapping
=> you might need to use exec and reference volume for updating tests

```
$ docker exec <id>
```

  : test via new container

```
tests:
  build:
    context: .
    dockerfile: Dockerfile.dev
  volumes :
    - /app/node_modules
    - .:/app
  command : ["npm","run","test"]
```

=> Multi-Step Docker builds needed for build phase

```
# Build phase

FROM node:alpine as builder
WORKDIR '/app'
COPY ./package.json ./
RUN npm install
COPY ./ ./
RUN npm run build

# run phase

FROM nginx
EXPOSE 80
COPY --from=builder /app/build /usr/share/nginx/html

```
