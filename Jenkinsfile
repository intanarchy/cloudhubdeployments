pipeline {
    agent any

    tools {
        maven 'Maven3'
        jdk 'JDK21' 
    }

    stages {
        stage('Set Build Name') {
            steps {
                script {
                    currentBuild.displayName = "Mule-Deploy-#${env.BUILD_NUMBER}"
                    currentBuild.description = "Deploying cloudhubdeployments to Sandbox"
                }
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Code Quality Analysis') {
            steps {
                // FIXED: credentialsId now matches your Jenkins setup perfectly
                withCredentials([string(credentialsId: 'mulesoft-cicd-token', variable: 'mulesoft-cicd-token')]) {
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