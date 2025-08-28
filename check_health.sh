# app.get('/health' , (req,res)=>{
# res.status(200).send('ok');})
# for a route that returns wheather the running services are fine or nah....
# to call and health endpoint after deployment.

#!/bin/bash
PORT_N = 4000
# LOOK HOW CAN U REFER THIS NO. OR API , LIKE U DO IN GITIGNORE RATHER THAN HARDCODING IT..
APP_URL = "http://localhost:'$PORT_N'/health"

# standard deployment steps
# pull main repo
git pull origin main
npm install 
npm run build
# a build command that uses prepares the app ready for production. 

# CheckPoint 1:
ssh user@your-server "pm2 restart my-app"
# ssh a powerful command that connects to your remote server
# pm2 is a popular process manager for nodejs application 
# this restarts an app to apply new change(pm2 restart my-app)


sleep 5
# the sleep command that allows the time to reset and wait till service start running again such that http status 
# gets a valid value with reason being delay.

# checkPoint 2;
# curl ; A tool to transfer data from or to a server
# -s : the slient flag that stops from showing progress bar in command line
# -o /dev/null: Send the actual body of repsonse to black hole cuz do not care
# -w : to tell The write-out flag tells curl: "After you have completed the entire request, print out the information I specify here." curl has a list of internal variables you can access. %{http_code} is one of them

HTTP_STATUS = $(curl -s -o /dev/null -w "% {http_code} $APP_URL")

if[$HTTP_STATUS -eq 200]; then
echo "service is up n running"
exit 0
else 
echo "Some Error Occured $HTTP_STATUS error"
exit 1
fi
