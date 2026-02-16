pipeline {
    agent any 

    environment {
        IMAGE_NAME = "hasannkhann07/react-private"
        IMAGE_TAG  = "V1.2.0"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/hasannkhann07/React-app'
            }
        }

        stage('Building Image') {
            steps {
                // Docker now handles npm install & npm build internally!
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Pushing to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                    echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin
                    docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    """
                }        
            }
        }
    }

    post {
        success { echo " Successfully built and pushed image!" }
        failure { echo " Pipeline failed." }
    }
}
