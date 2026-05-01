pipeline {
    agent any

    stages {
        stage('Set Build Name') {
            steps {
                script {
                    // This renames the build in the Jenkins UI
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
                    // Ask Docker if the image exists and capture the output
                    def imageId = bat(script: 'docker images -q mulesoft-local-deployer:latest', returnStdout: true).trim()
                    
                    // Clean up the output to get just the ID string
                    if (imageId.contains("\n")) {
                        def lines = imageId.split("\n")
                        imageId = lines[lines.length - 1].trim()
                    }

                    // If the ID is empty, the image doesn't exist, so build it.
                    if (imageId == "") {
                        echo "Image not found locally. Building a new delivery truck..."
                        bat 'docker build -t mulesoft-local-deployer:latest .'
                    } else {
                        // If it has an ID, skip the build step entirely
                        echo "Image already exists (ID: ${imageId}). Skipping Docker build step!"
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
                    // If the app doesn't exist, this creates it. 
                    // If the app is already running, this safely updates it.
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
