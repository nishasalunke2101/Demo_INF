#!/bin/bash

<<<<<<< HEAD
    stages {
        stage('Checkout') {
            steps {
                script {
                    // Clone or checkout the repository
                    //checkout([$class: 'GitSCM', branches: [[name: 'master']], userRemoteConfigs: [[url: 'https://github.com/nishasalunke2101/Demo_INF.git']]])
                      checkout([$class: 'GitSCM', branches: [[name: 'master']], userRemoteConfigs: [[url: 'https://github.com/nishasalunke2101/Demo_INF.git', credentialsId: 'nishasalunke2101']]])
                }
            }
        }

        stage('Git Pull') {
            steps {
                script {
                    // Perform a git pull
                    sh 'git pull origin master'
                }
            }
        }
=======
# Replace these variables with your actual information
REPO_URL="https://github.com/nishasalunke2101/Demo_INF.git"
BRANCH="master"
COMMIT_MESSAGE="first commit message"

# Specify the path to your local repository
REPO_PATH="/home/inferyx/nisha"
>>>>>>> 3361cf15caa21b725ce866e988e498b26ea5e3cc

# Navigate to the local repository directory
cd "$REPO_PATH" || exit

# Initialize the Git repository and set the remote origin
git init
git remote add origin "$REPO_URL"

<<<<<<< HEAD
        stage('Git Commit') {
            steps {
                script {
                    // Commit the changes
                    sh 'git commit -m "1.5"'
                }
            }
        }

        stage('Git Push') {
            steps {
                script {
                    // Push the changes to the remote repository
                    sh 'git push origin master'
                }
            }
        }
    }
}
=======
# Git commands
git pull origin "$BRANCH"
echo "Hello, Git!" > file11.txt
git add .
git commit -m "$COMMIT_MESSAGE"
git push origin "$BRANCH"
>>>>>>> 3361cf15caa21b725ce866e988e498b26ea5e3cc
