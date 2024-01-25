#!/bin/bash

# Replace these variables with your actual information
REPO_URL="https://github.com/nishasalunke2101/Demo_INF.git"
BRANCH="main"
COMMIT_MESSAGE="1 commit message"
USERNAME="nishasalunke2101"
TOKEN="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"

# Specify the path to your local repository
REPO_PATH="/home/inferyx/git/Demo_INF"

# Navigate to the local repository directory
cd "$REPO_PATH" || exit

# Check if the repository is already initialized
if [ ! -d ".git" ]; then
    # Initialize the Git repository and set the remote origin
    git init
    git remote add origin "$REPO_URL"

    # Set credentials for the initial push
    git config credential.helper "store"
    git config user.name "$USERNAME"
    git config user.password "$TOKEN"
fi

# Git commands
git pull origin "$BRANCH"
echo "Hello, This is Jenkins Git! Pipeline101" > nish.txt
git add .
git commit -m "$COMMIT_MESSAGE"
git push origin "$BRANCH"

































# #!/bin/bash

# # Replace these variables with your actual information
# REPO_URL="https://github.com/nishasalunke2101/Demo_INF.git"
# BRANCH="main"
# COMMIT_MESSAGE="first commit message"

# # Specify the path to your local repository
# REPO_PATH="/home/inferyx/git/Demo_INF"

# # Navigate to the local repository directory
# cd "$REPO_PATH" || exit

# # Initialize the Git repository and set the remote origin
# #  git init
# #  git remote add origin "$REPO_URL"

# # Git commands
# git pull origin "$BRANCH"
# echo "Hello, This is Jenkins Git! Pipeline101" > monii.txt
# git add .
# git commit -m "$COMMIT_MESSAGE"
# git push origin "$BRANCH"

 





















