if [-z "$1"]; then
echo "pass the branch name"
echo "usage: push new feature locally to remote branch"
exit 1
fi 

BRANCH_NAME = $1
BASE_BRANCH = "main"

echo "updating '$BASE_BRANCH' ..."

git checkout $BASE_BRANCH
git pull origin $BASE_BRANCH 
# pull is fetch + merge , fetch from remote  and update locally

# switch to local branch here main and update with whatever has changed on remote branch(main)

echo "creating and Switching to new branch '$BRANCH_NAME' ...."
git checkout -b $BRANCH_NAME

echo "putting new branch to remote to setup tracking ..."
git push -u origin $BRANCH_NAME

echo "Done ! you are now on '$BRANCH_NAME'"