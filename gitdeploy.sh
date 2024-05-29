#!/bin/bash

SERVER_USER="odoo17"
SERVER_IP="192.168.50.105"
APP_NAME="nextjs-app"
APP_DIR="/home/odoo17/Next-App"

echo "Connecting to the server and deploying the app..."

ssh $SERVER_USER@$SERVER_IP << EOF
  # Navigate to the app directory
  cd $APP_DIR
  if [ $? -ne 0 ]; then
    echo "Failed to navigate to app directory. Exiting."
    exit 1
  fi

  echo "Pulling the latest changes from the repository..."
  git pull origin master
  if [ $? -ne 0 ]; then
    echo "Failed to pull from git repository. Exiting."
    exit 1
  fi

  echo "Installing any new dependencies..."
  npm install
  if [ $? -ne 0 ]; then
    echo "Failed to install dependencies. Exiting."
    exit 1
  fi

  echo "Building the Next.js app..."
  npm run build
  if [ $? -ne 0 ]; then
    echo "Failed to build the Next.js app. Exiting."
    exit 1
  fi

  echo "Restarting the app using PM2..."
  pm2 restart $APP_NAME || pm2 start npm --name "$APP_NAME" -- start
  if [ $? -ne 0 ]; then
    echo "Failed to restart the app using PM2. Exiting."
    exit 1
  fi

  echo "Saving the PM2 process list..."
  pm2 save
  if [ $? -ne 0 ]; then
    echo "Failed to save the PM2 process list. Exiting."
    exit 1
  fi

  echo "Deployment complete!"
EOF

if [ $? -ne 0 ]; then
  echo "Failed to connect to the server or an error occurred during deployment. Exiting."
  exit 1
fi
