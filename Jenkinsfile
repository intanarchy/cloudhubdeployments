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
                checkout scm
            }
        }

        stage('Prepare Settings') {
            steps {
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

        stage('Check & Build Docker Image') {
            steps {
                script {
                    // Silently check if the image exists. If it does, status will be 0.
                    def imageExists = bat(script: 'docker image inspect mulesoft-local-deployer:latest >nul 2>nul', returnStatus: true) == 0

                    if (!imageExists) {
                        echo "Image not found locally. Building a new delivery truck..."
                        bat 'docker build -t mulesoft-local-deployer:latest .'
                    } else {
                        echo "Image already exists locally! Skipping Docker build step to save time."
                    }
                }
            }
        }

        stage('Deploy/Update in CloudHub 2.0') {
            steps {
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
            bat 'if exist settings.xml del settings.xml'
        }
    }
}
