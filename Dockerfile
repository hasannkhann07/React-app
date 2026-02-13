# ---------------- Stage 1: Build ----------------
FROM node:20-alpine AS build

# Set working directory inside container
WORKDIR /app

# Copy dependency definitions first
COPY package*.json ./

# Install dependencies (cached if package*.json doesn't change)
RUN npm install

# Copy the rest of the source code
COPY . .

# Build the React app (production)
RUN npm run build

# ---------------- Stage 2: Production image ----------------
FROM nginx:alpine

# Copy only the build output from the first stage
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
