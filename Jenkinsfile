pipeline {
    agent any

    environment {
        // Core Configuration
        IMAGE_NAME = "hasannkhann07/react-private"
        IMAGE_TAG  = "v${env.BUILD_NUMBER}"
        
        // Define the manual path to your scanner here
        SONAR_SCANNER_PATH = "/opt/sonar-scanner/bin/sonar-scanner"
    }

        stage('SonarQube Analysis') {
            steps {
                // withSonarQubeEnv still handles the URL and Token for you
                withSonarQubeEnv('SonarQube') {
                    sh """
                        ${SONAR_SCANNER_PATH} \
                        -Dsonar.projectKey=react-app \
                        -Dsonar.sources=. \
                        -Dsonar.exclusions=node_modules/**,public/**
                    """
                }
            }
        }

        stage('Build & Push Image') {
            environment {
                DOCKER_CREDS = credentials('dockerhub-creds')
            }
            steps {
                sh '''
                    echo "$DOCKER_CREDS_PSW" | docker login -u "$DOCKER_CREDS_USR" --password-stdin
                    docker build -t $IMAGE_NAME:$IMAGE_TAG .
                    docker push $IMAGE_NAME:$IMAGE_TAG
                    docker logout
                '''
            }
        }

        stage('Security Scan (Trivy)') {
            steps {
                sh "trivy image --severity HIGH,CRITICAL --exit-code 0 $IMAGE_NAME:$IMAGE_TAG"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                    sh """
                        kubectl --kubeconfig=${KUBECONFIG} apply -f react-deployment.yaml
                        kubectl --kubeconfig=${KUBECONFIG} set image deployment/react-app-deployment \
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
