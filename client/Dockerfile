# build environment
FROM node:20.14.0-alpine AS build

RUN mkdir /app

WORKDIR /app

COPY package.json /app

COPY package-lock.json /app

RUN npm install

COPY . /app

RUN npm run build

# production environment
FROM nginx:1.25.0-alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY --from=build /app/nginx/nginx.conf /etc/nginx/conf.d/default.conf


EXPOSE 80 

CMD ["nginx", "-g", "daemon off;"]