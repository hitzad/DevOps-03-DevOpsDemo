pipeline {
    agent any

    environment {
        AZURE_APP_NAME = 'hitzad-devopsdemo'
        AZURE_RESOURCE_GROUP = 'hitzad-devopsdemo_group-a9ec'
        DOCKER_IMAGE_NAME = 'hitzad/devopsdemo:latest'
        SONARQUBE_PROJECT_KEY = 'DevOpsDemo-Backend'
        SONARQUBE_HOST_URL = 'http://sonarqube:9000'
    }

    tools {
        nodejs 'NodeJS 22.11.0'
    }

    stages {

        stage('📦 Checkout') {
            steps {
                checkout scmGit(
                    branches: [[name: '*/main']],
                    extensions: [],
                    userRemoteConfigs: [[
                        credentialsId: 'GitHub-mosazhaw',
                        url: 'https://github.com/hitzad/DevOps-03-DevOpsDemo'
                    ]]
                )
            }
        }

        stage('🧪 Build & Test') {
            steps {
                dir('backend') {
                    sh 'chmod +x ./gradlew'
                    sh './gradlew test'
                }
                jacoco()
                junit testResults: '**/test-results/test/*.xml'
            }
        }

        stage('🔍 SonarQube Analyse') {
            steps {
                withCredentials([string(credentialsId: 'Sonarqube-Backend', variable: 'TOKEN')]) {
                    dir('backend') {
                        sh """
                            ./gradlew sonar \
                            -Dsonar.projectKey=$SONARQUBE_PROJECT_KEY \
                            -Dsonar.host.url=$SONARQUBE_HOST_URL \
                            -Dsonar.token=$TOKEN
                        """
                    }
                }
            }
        }

        stage('🐳 Docker Build & Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKERHUB_USER',
                    passwordVariable: 'DOCKERHUB_TOKEN')]) {
                    sh '''
                        docker rm -f devopsdemo-container || true

                        echo "🔨 Building image..."
                        docker build -t $DOCKER_IMAGE_NAME .

                        echo "🔐 Logging in to Docker Hub..."
                        echo $DOCKERHUB_TOKEN | docker login -u $DOCKERHUB_USER --password-stdin

                        echo "📤 Pushing image..."
                        docker push $DOCKER_IMAGE_NAME
                    '''
                }
            }
        }

        stage('🚀 Deploy to Azure') {
            steps {
                withCredentials([azureServicePrincipal(
                    credentialsId: 'azure-sp-devops',
                    subscriptionIdVariable: 'AZ_SUB_ID',
                    clientIdVariable: 'AZ_CLIENT_ID',
                    clientSecretVariable: 'AZ_CLIENT_SECRET',
                    tenantIdVariable: 'AZ_TENANT_ID')]) {

                    sh '''
                        az login --service-principal \
                          -u $AZ_CLIENT_ID -p $AZ_CLIENT_SECRET \
                          --tenant $AZ_TENANT_ID

                        echo "🚀 Deploying to Azure Web App..."
                        az webapp config container set \
                          --name $AZURE_APP_NAME \
                          --resource-group $AZURE_RESOURCE_GROUP \
                          --docker-custom-image-name $DOCKER_IMAGE_NAME \
                          --docker-registry-server-url https://index.docker.io

                        az webapp restart \
                          --name $AZURE_APP_NAME \
                          --resource-group $AZURE_RESOURCE_GROUP
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '🎉 Build und Deployment erfolgreich abgeschlossen!'
        }
        failure {
            echo '❌ Fehler im Pipeline-Prozess.'
        }
    }
}
