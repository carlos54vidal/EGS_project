ARG NODE_VERSION=21.6.1

FROM node:${NODE_VERSION}-alpine 

# Install the Nest CLI globally
#RUN npm install -g @nestjs/cli

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Install development dependencies
#RUN npm install --only=dev

# Expose port 8040
EXPOSE 8040

CMD [ "npm", "run", "start:dev" ]
