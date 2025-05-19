# Use an official Node.js image as the base image .. suuported files # alpine is lighwieghted os
FROM node:18-alpine 

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json files
COPY package.json .

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .


# Run the application
CMD ["npm", "start"]
