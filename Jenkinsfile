pipeline {
    agent any

    environment {
        IMAGE_NAME = "hasannkhann07/react-private"
        IMAGE_TAG  = "V1.2.0"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/hasannkhann07/React-app'
            }
        }

        stage('Build Image') {
            steps {
                // Building the React app inside Docker (using the multi-stage Dockerfile)
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Push Image') {
            environment {
                // This automatically creates DOCKER_HUB_USR and DOCKER_HUB_PSW
                DOCKER_HUB = credentials('dockerhub-creds')
            }
            steps {
                // Use single quotes to prevent Groovy leaks and correctly pass to shell
                sh 'echo ${DOCKER_HUB_PSW} | docker login -u ${DOCKER_HUB_USR} --password-stdin'
                sh 'docker push ${IMAGE_NAME}:${IMAGE_TAG}'
            }
        }
    }

    post {
        always {
            // Good practice: don't leave your credentials on the Jenkins runner
            sh 'docker logout'
        }
        success {
            echo " Image ${IMAGE_NAME}:${IMAGE_TAG} is now on Docker Hub!"
        }
    }
}
