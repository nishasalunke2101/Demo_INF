#!/bin/bash

# Replace these variables with your actual information
USERNAME="nishasalunke2101"
TOKEN="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"
REPO_URL="https://github.com/nishasalunke2101/Demo_INF.git"
BRANCH="main"
COMMIT_MESSAGE="1 commit message"

# Specify the path to your local repository
REPO_PATH="/home/inferyx/git/Demo_INF"

# Navigate to the local repository directory
cd "$REPO_PATH" || exit

# Check if the repository is already initialized
if [ ! -d ".git" ]; then
    # Initialize the Git repository and set the remote origin
    git init
    git remote add origin "$REPO_URL"
    
    # Set up credentials for the initial push
    git config credential.helper "store"
    echo -e "https://$USERNAME:$TOKEN@github.com" > "$REPO_PATH/.git/credentials"
fi

# Git commands
git pull origin "$BRANCH"
echo "Hello, This is Jenkins Git! Pipeline101" > nishuu.txt
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
# echo "Hello, This is Jenkins Git! Pipeline101" > File.txt
# git add .
# git commit -m "$COMMIT_MESSAGE"
# git push origin "$BRANCH"

 





















