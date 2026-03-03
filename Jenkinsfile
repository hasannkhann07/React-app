pipeline {
    agent any

    environment {
        IMAGE_NAME = "hasannkhann07/react-private"
        IMAGE_TAG  = "v${env.BUILD_NUMBER}"
        SONAR_SCANNER_PATH = "/opt/sonar-scanner/bin/sonar-scanner"
    }



        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') { 
                    sh """
                        ${SONAR_SCANNER_PATH} \
                        -Dsonar.host.url=http://13.61.21.58:9000 \
                        -Dsonar.projectKey=react-app-hasan \
                        -Dsonar.sources=. \
                        -Dsonar.exclusions=node_modules/**,public/**
                    """
                }
            }
        }

        stage('Build Image') {
            environment {
                DOCKER_CREDS = credentials('dockerhub-creds')
            }
            steps {
                sh '''
                    echo "$DOCKER_CREDS_PSW" | docker login -u "$DOCKER_CREDS_USR" --password-stdin
                    docker build -t $IMAGE_NAME:$IMAGE_TAG .
                '''
            }
        }

        stage('Security Scan (Trivy)') {
            steps {
                sh "trivy image --severity HIGH,CRITICAL --exit-code 0 $IMAGE_NAME:$IMAGE_TAG"
            }
        }

        stage('Push Image') {
            steps {
                sh "docker push $IMAGE_NAME:$IMAGE_TAG"
                sh "docker logout"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                    sh """
                        export KUBECONFIG=$KUBECONFIG
                        kubectl apply -f react-deployment.yaml
                        kubectl set image deployment/react-app-deployment \
                            react-container=${IMAGE_NAME}:${IMAGE_TAG}
                    """
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
