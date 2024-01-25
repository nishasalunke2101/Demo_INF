# #!/bin/bash

# # Replace these variables with your actual information
# REPO_URL="https://github.com/nishasalunke2101/Demo_INF.git"
# BRANCH="main"
# COMMIT_MESSAGE="first commit message"

# # Specify the path to your local repository
# <<<<<<< HEAD
# REPO_PATH="/home/inferyx/git/Demo_INF"
# =======
# REPO_PATH="/home/inferyx/nisha"
# >>>>>>> 5f39bb35e6dcbd919f680b53685751c9df8dd43c

# # Navigate to the local repository directory
# cd "$REPO_PATH" || exit

# # Initialize the Git repository and set the remote origin
# # git init
# git remote add origin "$REPO_URL"

# # Git commands
# git pull origin "$BRANCH"
# <<<<<<< HEAD
# echo "Hello, Git!" > FILE1.txt
# =======
# echo "Hello, Git!" > Pipeline_git.txt
# >>>>>>> 5f39bb35e6dcbd919f680b53685751c9df8dd43c
# git add .
# git commit -m "$COMMIT_MESSAGE"
# git push origin "$BRANCH"



# <<<<<<< HEAD









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
echo "Hello, This is Jenkins Git! Pipeline" > file9.txt
git add .
git commit -m "$COMMIT_MESSAGE"
git push origin "$BRANCH"























