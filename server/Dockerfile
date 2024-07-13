# build stage
FROM node:20.14.0-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install 
COPY . .
RUN npm run build 

# production stage
FROM node:20.14.0-alpine AS production
ENV WORKDIR=/usr/src/app
ENV PORT=3000
RUN mkdir -p ${WORKDIR}
RUN chown -R node:node ${WORKDIR}
WORKDIR ${WORKDIR}
COPY --chown=node:node package*.json ./
USER node
RUN npm install --production
COPY --chown=node:node --from=build /app/dist ./dist
EXPOSE 3000
CMD ["node", "dist/server.js"]
