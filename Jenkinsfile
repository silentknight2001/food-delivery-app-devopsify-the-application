pipeline {
    agent { label 'ec2' }

    environment {
        DOCKER_IMAGE = "nayan2001/food-app"
        CONTAINER_NAME = "food-app"
        DOCKER_CREDS = "docker-cred"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/silentknight2001/food-delivery-app-devopsify-the-application.git'
            }
        }
        stage('Build and tag Docker Image') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker', url: 'https://index.docker.io/v1/') {
                       sh 'docker build -t nayan2001/food-app:latest .'
                  }
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker', url: 'https://index.docker.io/v1/') {
                       sh 'docker push nayan2001/food-app:latest'
                  }
                }
            }
        }

        stage('Deploy on EC2') {
            steps {
                sh '''
                docker stop $CONTAINER_NAME || true
                docker rm $CONTAINER_NAME || true

                docker pull $DOCKER_IMAGE:latest

                docker run -d \
                --name $CONTAINER_NAME \
                -p 80:80 \
                --restart always \
                $DOCKER_IMAGE:latest
                '''
            }
        }
    }

    post {
        success {
            echo "✅ CI/CD done. App is LIVE on EC2!"
        }
        failure {
            echo "❌ Pipeline failed."
        }
    }
}