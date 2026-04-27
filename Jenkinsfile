pipeline {
    agent any

    stages {
        stage('Set Build Name') {
            steps {
                script {
                    currentBuild.displayName = "Manual-Mule-Deploy-#${env.BUILD_NUMBER}"
                    currentBuild.description = "Manual Docker deployment to CloudHub 2.0"
                }
            }
        }

        stage('Checkout Code') {
            steps {
                // Pulls your latest code from GitHub into the Jenkins workspace
                checkout scm
            }
        }
        
        stage('Prepare Docker Environment') {
            steps {
                // Dynamically create the settings.xml file with placeholder passwords
                bat '''
                echo ^<?xml version="1.0" encoding="UTF-8"?^> > settings.xml
                echo ^<settings^> >> settings.xml
                echo   ^<servers^> >> settings.xml
                echo     ^<server^> >> settings.xml
                echo       ^<id^>anypoint-exchange-v3^</id^> >> settings.xml
                echo       ^<username^>~~~Client~~~^</username^> >> settings.xml
                echo       ^<password^>${anypoint.client_id}~${anypoint.client_secret}^</password^> >> settings.xml
                echo     ^</server^> >> settings.xml
                echo   ^</servers^> >> settings.xml
                echo ^</settings^> >> settings.xml
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build the "delivery truck" using the Dockerfile in your repository
                bat 'docker build -t mulesoft-local-deployer:latest .'
            }
        }

        stage('Deploy to CloudHub 2.0') {
            steps {
                // Grab the real passwords securely stored in Jenkins
                withCredentials([
                    string(credentialsId: 'anypoint-client-id', variable: 'CLIENT_ID'),
                    string(credentialsId: 'anypoint-client-secret', variable: 'CLIENT_SECRET')
                ]) {
                    // Run the container, pass in the real passwords, deploy, and self-destruct (--rm)
                    bat '''
                    docker run --rm mulesoft-local-deployer:latest clean deploy -Danypoint.client_id=%CLIENT_ID% -Danypoint.client_secret=%CLIENT_SECRET% -DmuleDeploy -DskipTests
                    '''
                }
            }
        }
    }
    
    post {
        always {
            // Delete the settings.xml file so passwords aren't left sitting on your hard drive
            bat 'if exist settings.xml del settings.xml'
        }
    }
}