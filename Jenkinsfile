pipeline {
    agent any

    environment {
        // Using BUILD_NUMBER makes every version unique (v1, v2, v3...)
        IMAGE_NAME = "hasannkhann07/react-private"
        IMAGE_TAG  = "v${env.BUILD_NUMBER}" 
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/hasannkhann07/React-app'
            }
        }

        stage('Build Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Push Image') {
            environment {
                // Jenkins automatically creates _USR and _PSW suffixes
                DOCKER_HUB = credentials('dockerhub-creds')
            }
            steps {
                // Use single quotes to satisfy the security warning
                sh 'echo ${DOCKER_HUB_PSW} | docker login -u ${DOCKER_HUB_USR} --password-stdin'
                sh 'docker push ${IMAGE_NAME}:${IMAGE_TAG}'
            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
        success {
            echo "Successfully pushed ${IMAGE_NAME}:${IMAGE_TAG}"
        }
    }
}
