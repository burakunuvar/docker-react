# Build phase

FROM node:alpine as builder
WORKDIR '/app'
COPY ./package.json ./
RUN npm install
COPY ./ ./
RUN npm run build

# run phase

FROM nginx

# needed for AWS only
EXPOSE 80
# needed for AWS onlys

COPY --from=builder /app/build /usr/share/nginx/html

#default command is start nginx, we don`t have to specifically add
