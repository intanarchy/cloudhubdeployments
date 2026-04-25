pipeline {
    agent any

    tools {
        maven 'Maven3'
        jdk 'JDK21' 
    }

    stages {
        // --- NEW STAGE ADDED HERE ---
        stage('Set Build Name') {
            steps {
                script {
                    // This changes "#4" to something like "Mule-Deploy-#4"
                    currentBuild.displayName = "Mule-Deploy-#${env.BUILD_NUMBER}"
                    
                    // Optional: You can also add a description below the name
                    currentBuild.description = "Deploying cloudhubdeployments to Sandbox"
                }
            }
        }
        // ----------------------------

        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Code Quality Analysis') {
            steps {
                withCredentials([string(credentialsId: 'sonar-token', variable: 'mulesoft-cicd-token')]) {
                    bat 'mvn clean verify sonar:sonar -Dsonar.projectKey=cloudhubdeployments -Dsonar.projectName="CloudHub Deployments" -Dsonar.host.url=http://localhost:9000 -Dsonar.token=%mulesoft-cicd-token%'
                }
            }
        }

        stage('Build & Deploy to CloudHub') {
            steps {
                bat 'mvn clean deploy -DmuleDeploy -s C:\\Users\\inver\\.m2\\settings.xml'
            }
        }
    }
}