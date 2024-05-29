#!/bin/bash

SERVER_USER="odoo17"
SERVER_IP="192.168.50.105"
APP_NAME="nextjs-app"
APP_DIR="/home/odoo17/Next-App"

echo "Connecting to the server and deploying the app..."

ssh $SERVER_USER@$SERVER_IP << EOF
  cd $APP_DIR
  echo "Pulling the latest changes from the repository..."
  git pull origin master

#   echo "Installing any new dependencies..."
#   npm install

  echo "Building the Next.js app..."
  npm run build

  echo "Restarting the app using PM2..."
  pm2 restart $APP_NAME || pm2 start npm --name "$APP_NAME" -- start

  echo "Saving the PM2 process list..."
  pm2 save

  echo "Deployment complete!"
EOF
