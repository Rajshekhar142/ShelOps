#!/bin/bash

# fail-fast : exit immediately if any command fails
# this is a crucial setting for robust scripts
set -e
# makes the script end if any command return a non zero value

# --- configuration ---

APP_URL="http://your-app-domain.com/health"
REMOTE_USER="user"
REMOTE_SERVER="your_server"
REMOTE_APP_DIR="/var/www/my-app"
PM2_APP_NAME="my-app"

# the rollback function 
rollback(){
    echo "Deployment failed! Starting automatic callback ..."
    # ssh server and in remote app_dir just reset the git tree to last stable version and install the dependencies from .json and lockfile , restart node package manger and run the app..
    ssh $REMOTE_USER@$REMOTE_SERVER "cd $REMOTE_APP_DIR && git reset --hard $LAST_STABLE_COMMIT && npm install && pm2 restart $PM2_APP_NAME"
    echo "rollback complete. Application restored to commit $LAST_STABLE_COMMIT."
    exit 1
}

# trap Errors: IF ANY COMMAND FAILS (DUE TO SET -E) execute the rollback function.
# this is the "magic" that triggers our rollback on any error.

trap 'rollback' ERR

# --- Main Script Logic------
echo "starting Deployment.... "

# Step 1: "Save the Game" - Get the current commit hash on the server.
echo "💾 Recording last stable commit..."
LAST_STABLE_COMMIT=$(ssh $REMOTE_USER@$REMOTE_SERVER "cd $REMOTE_APP_DIR && git rev-parse HEAD")
echo "Last stable commit is: $LAST_STABLE_COMMIT"

# Step 2: "Fight the Boss" - Perform the deployment on the server.
echo "🚚 Pulling latest code, installing dependencies, and building..."
ssh $REMOTE_USER@$REMOTE_SERVER "cd $REMOTE_APP_DIR && git pull origin main && npm install && npm run build && pm2 restart $PM2_APP_NAME"

# Step 3: Verify the deployment with a health check.
echo "⏳ Waiting 5 seconds for the app to restart..."
sleep 5

echo "🩺 Performing health check..."
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" $APP_URL)

if [ $HTTP_STATUS -eq 200 ]; then
  echo "✅ Health check passed! Deployment successful."
  exit 0
else
  echo "❌ Health check FAILED with status code: $HTTP_STATUS"
  # The trap will catch this failure because we'll force an error.
  # The 'false' command is a simple way to trigger the ERR trap.
  false
fi