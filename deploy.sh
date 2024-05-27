#!/bin/bash

SERVER_USER="odoo17"
SERVER_IP="192.168.50.105"
APP_NAME="nextjs-app"
APP_DIR="/home/odoo17/Next-App"

# Build the Next.js app locally
echo "Building the Next.js app..."
npm run build

# Transfer the app to the server
echo "Transferring the app to the server..."
scp -r . odoo17@192.168.50.105:/home/odoo17/Next-App

# SSH into the server and deploy the app
echo "Deploying the app on the server..."
ssh odoo17@192.168.50.105 << EOF
cd /home/odoo17/Next-App
npm install
pm2 restart nextjs-app || pm2 start npm --name "nextjs-app" -- start
pm2 save
exit
EOF

echo "Deployment complete!"
