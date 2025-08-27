#!/bin/bash

################
# Aims to cleanup local branches that have been merged remotely successfully.
################

BASE_BRANCH = "main"
echo "fetching latest state from remote"

# updates your remote tracking Branche(origin/main) without tracking your local branches.
git fetch --prune
git checkout $BASE_BRANCH
git pull origin $BASE_BRANCH

echo "finding and deleting local branch that have been merged successfully"
# list all branches merged into base_branch , exclude all the line that match (don't delete base branch even accidentally)
# takes lines of input and send them as argument to a command -r : run only if input is non-empty avoid running git branch -d without branch name..

git branch --merged $BASE_BRANCH | grep -v "r\* $BASE_BRANCH" | xargs -r git branch -d

echo "cleanup Complete"