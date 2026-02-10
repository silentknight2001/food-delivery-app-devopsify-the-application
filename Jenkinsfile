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
                checkout scm   // auto-detects branch (master / develop)
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $DOCKER_IMAGE:latest ."
            }
        }

        stage('Test') {
            steps {
                echo "🧪 Running tests..."
                // Example test (dummy for frontend app)
                sh "test -f /var/www/html/index.html || true"
            }
        }

        stage('Push Docker Image') {
            when {
                branch 'master'
            }
            steps {
                withDockerRegistry(
                    credentialsId: "$DOCKER_CREDS",
                    url: 'https://index.docker.io/v1/'
                ) {
                    sh "docker push $DOCKER_IMAGE:latest"
                }
            }
        }

        stage('Deploy to Prod (EC2)') {
            when {
                branch 'master'
            }
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
            echo "✅ Pipeline completed successfully for branch: ${env.BRANCH_NAME}"
        }
        failure {
            echo "❌ Pipeline failed for branch: ${env.BRANCH_NAME}"
        }
    }
}
