pipeline {
    agent any

    environment {
        AZURE_APP_NAME = 'hitzad-devopsdemo'
        AZURE_RESOURCE_GROUP = 'hitzad-devopsdemo_group-a9ec'
        AZURE_IMAGE_NAME = 'mosazhaw/node-web-app:latest'
    }

    stages {

        stage('📦 Checkout') {
            steps {
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
                            -Dsonar.projectKey=DevOpsDemo-Backend \
                            -Dsonar.host.url=http://sonarqube:9000 \
                            -Dsonar.token=$TOKEN
                        """
                    }
                }
            }
        }

        stage('🐳 Docker Build') {
            steps {
                sh '''
                    docker rm -f devopsdemo-container || true
                    docker build -t mosazhaw/node-web-app:latest .
                '''
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

                        echo "Deploying to Azure Web App..."
                        az webapp config container set \
                          --name $AZURE_APP_NAME \
                          --resource-group $AZURE_RESOURCE_GROUP \
                          --docker-custom-image-name $AZURE_IMAGE_NAME \
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
            echo '🎉 Deployment erfolgreich!'
        }
        failure {
            echo '❌ Fehler im Build-Prozess.'
        }
    }
}
