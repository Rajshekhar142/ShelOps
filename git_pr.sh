#!/bin/bash

# Aims to create a pr from your current Branch

# check if gh is installed

if ! command -v gh &> /dev/null; then
echo " error: Github CLI (gh) is not installed"
echo "install via github cli"
exit 1

fi
# i'll be right back
CURRENT_BRANCH = $(git rev-parse --abbrev -ref HEAD)
BASE_BRANCH = "main"

echo "putting current Branch '$CURRENT_BRANCH' to remote..."
git push

echo "Creating a pull Request  ...."
gh pr create --base "$BASE_BRANCH -- head "${CURRENT_BRANCH}" --web"