pipeline {
    agent any

    tools {
        maven 'Maven3'
        jdk 'JDK21'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Deploy to CloudHub') {
            steps {
                bat 'mvn clean deploy -DmuleDeploy -s C:\\Users\\inver\\.m2\\settings.xml'
            }
        }
    }
}