pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Prepare Settings') {
            steps {
                // Generates the settings.xml file locally for Maven to use
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

        stage('Build Local Docker Image') {
            steps {
                // Builds the image and saves it to your local Docker Desktop
                bat 'docker build -t mulesoft-local-deployer:latest .'
            }
        }

        stage('Deploy to CloudHub 2.0') {
            steps {
                // Injects Jenkins credentials and runs the temporary deployment container
                withCredentials([
                    string(credentialsId: 'anypoint-client-id', variable: 'CLIENT_ID'),
                    string(credentialsId: 'anypoint-client-secret', variable: 'CLIENT_SECRET')
                ]) {
                    bat '''
                    docker run --rm mulesoft-local-deployer:latest clean deploy -Danypoint.client_id=%CLIENT_ID% -Danypoint.client_secret=%CLIENT_SECRET% -DmuleDeploy -DskipTests
                    '''
                }
            }
        }
    }
    
    post {
        always {
            // Self-cleanup
            bat 'if exist settings.xml del settings.xml'
        }
    }
}
