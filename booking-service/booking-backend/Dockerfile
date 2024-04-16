ARG NODE_VERSION=21.6.1

FROM node:${NODE_VERSION}-alpine 

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

EXPOSE 4040/tcp

CMD [ "npm", "run", "start:dev" ]
