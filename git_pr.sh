#!/bin/bash

# check if gh is installed

if ! command -v gh &> /dev/null; then
echo " error: Github CLI (gh) is not installed"
echo "install via github cli"
exit 1

fi
# i'll be right back