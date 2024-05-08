ARG NODE_VERSION=21.6.1

FROM node:${NODE_VERSION}-alpine 

# Install the Nest CLI globally
RUN npm install -g @nestjs/cli

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

# Install development dependencies
RUN npm install --only=dev

# Build the application
RUN npm run build

EXPOSE 4040/tcp

CMD [ "npm", "run", "start:dev" ]
