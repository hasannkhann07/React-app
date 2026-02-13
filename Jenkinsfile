pipeline {
  agent any 

  envorinment {
    IMAGE_NAME = "hasannkhann07/react-private"
    IMAGE_TAG = "V1.2.0"
  }
  stages{
    stage('Code'){
      steps{
        git branch: 'main',
          url: 'https://github.com/hasannkhann07/React-app'
      }
  }
    stage('Install dependencies'){
      steps{
        sh 'npm install'
      }
    }
    stage('Build code'){
      steps{
        sh 'npm build run'
      }
    }
    stage('building image'){
      steps{
        sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG .
      }
    }
    stage('Pushing to docker hub'){
      steps{
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER 
                    docker push $IMAGE_NAME:$IMAGE_TAG
                    '''
                }        
      }
    }
}

      post {
        success {
            echo "✅ Build & Push Successful"
        }
        failure {
            echo "❌ Pipeline Failed"
        }
    }
}
