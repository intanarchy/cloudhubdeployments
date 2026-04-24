pipeline {
    agent any
    tools {
        maven 'Maven'
        jdk 'Java'
    }
    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Deploy to CloudHub') {
            steps {
                bat 'mvn clean deploy -DmuleDeploy'
            }
        }
    }
}