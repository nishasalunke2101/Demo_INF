pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Clone or checkout the repository
                    //checkout([$class: 'GitSCM', branches: [[name: 'main']], userRemoteConfigs: [[url: 'https://github.com/nishasalunke2101/Demo_INF.git']]])
                      checkout([$class: 'GitSCM', branches: [[name: 'main']], userRemoteConfigs: [[url: 'https://github.com/nishasalunke2101/Demo_INF.git', credentialsId: 'nishasalunke2101']]])
                }
            }
        }

        stage('Git Pull') {
            steps {
                script {
                    // Perform a git pull
                    sh 'git pull origin main'
                }
            }
        }

        stage('Make Changes') {
            steps {
                script {
                    // Perform necessary changes
                    // For example, you can create or modify files in your workspace
                    sh 'echo "Hello, Jenkins!" > Jenkinsfile.txt'

                    // Add the changes to the index
                    sh 'git add .'
                }
            }
        }

        stage('Git Commit') {
            steps {
                script {
                    // Commit the changes
                    sh 'git commit -m "1.3"'
                }
            }
        }

        stage('Git Push') {
            steps {
                script {
                    // Push the changes to the remote repository
                    sh 'git push origin main'
                }
            }
        }
    }
}
