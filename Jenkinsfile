pipeline {
    agent any 
    stages {

        stage('Checkout') { 
            steps {
                echo '📦 Checkout'
                checkout scmGit(
                    branches: [[name: '*/main']], 
                    extensions: [], 
                    userRemoteConfigs: [[
                        credentialsId: 'GitHub-mosazhaw', 
                        url: 'https://github.com/devopszhaw/DevOps-03-DevOpsDemo'
                    ]]
                )
            }
        }

        stage('Build & Test') { 
            steps {
                echo '🛠️ Build Backend'
                dir('backend') {
                    sh 'chmod +x ./gradlew'
                    sh './gradlew test'    
                }

                jacoco()
                junit testResults: '**/test-results/test/*.xml'
            }
        }

        stage('SonarQube Analyse Backend') {
            steps {
                withCredentials([string(credentialsId: 'Sonarqube-Backend', variable: 'TOKEN')]) {
                    dir('backend') {
                        sh './gradlew sonar ' +
                           '-Dsonar.projectKey=DevOpsDemo-Backend ' +
                           '-Dsonar.projectName=\'DevOpsDemo-Backend\' ' +
                           '-Dsonar.host.url=http://sonarqube:9000 ' +
                           '-Dsonar.token=$TOKEN'
                    }
                }
            }
        }

        stage('SonarQube Analyse Frontend') {
            steps {
                withCredentials([string(credentialsId: 'Sonarqube-Frontend', variable: 'TOKEN')]) {
                    dir('frontend') {
                        nodejs('NodeJS 22.11.0') {
                            sh 'npx sonar-scanner ' +
                               '-Dsonar.host.url=http://sonarqube:9000 ' +
                               '-Dsonar.projectKey=DevOpsDemo-Frontend ' +
                               '-Dsonar.projectName=\'DevOpsDemo-Frontend\' ' +
                               '-Dsonar.token=$TOKEN'
                        }
                    }
                }
            }
        }

        stage('Docker') {
            steps {
                echo '🐳 Docker Build'
                sh '''
                    export DOCKER_HOST=tcp://host.docker.internal:2375
                    docker build -t mosazhaw/devopsdemo .
                '''
            }
        }

    }
}


