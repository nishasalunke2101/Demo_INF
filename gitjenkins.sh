#!/bin/bash

# Replace these variables with your actual information
REPO_URL="https://github.com/nishasalunke2101/Demo_INF.git"
BRANCH="main"
COMMIT_MESSAGE="first commit message"

# Specify the path to your local repository
REPO_PATH="/home/inferyx/git/Demo_INF"

# Navigate to the local repository directory
cd "$REPO_PATH" || exit

# Initialize the Git repository and set the remote origin
# git init
git remote add origin "$REPO_URL"

# Git commands
git pull origin "$BRANCH"
echo "Hello, Git!" > FILE1.txt
git add .
git commit -m "$COMMIT_MESSAGE"
git push origin "$BRANCH"























# #!/bin/bash

# # Replace these variables with your actual information
# REPO_URL="https://github.com/nishasalunke2101/Demo_INF.git"
# BRANCH="main"
# COMMIT_MESSAGE="first commit message"

# # Specify the path to your local repository
# REPO_PATH="/home/inferyx/nisha"

# # Navigate to the local repository directory
# cd "$REPO_PATH" || exit

# # Initialize the Git repository and set the remote origin
# # git init
# git remote add origin "$REPO_URL"

# # Git commands
# git pull origin "$BRANCH"

# # Check for conflicts
# if [ $? -ne 0 ]; then
#     echo "Error: Conflicts occurred. Resolve conflicts and commit the changes."
#     exit 1
# fi

# echo "Hello, Git!" > CBA.txt
# git add .
# git commit -m "$COMMIT_MESSAGE"
# git push origin "$BRANCH"
