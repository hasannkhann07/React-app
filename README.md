React CI/CD Pipeline on AWS with Jenkins

This repository demonstrates a full CI/CD pipeline for a React application, moving from local testing to cloud deployment on AWS, fully automated with Jenkins, GitHub webhooks, and branch-specific pipelines.

🚀 Features

SCM Integration: Pulls code directly from GitHub, triggered automatically via webhooks

Branch-specific Pipelines: Build and deploy only specific branches, ignoring the rest

Docker Integration: Builds versioned Docker images and pushes them to Docker Hub

Kubernetes Deployment: Deploys apps to an AWS-hosted Kubernetes cluster (master & worker nodes)

Security & Quality Checks: Integrated Trivy for vulnerability scanning and SonarQube for code quality

Secrets & Networking: Handles image pull secrets and cluster networking

🏗 Architecture
GitHub → Jenkins (CI/CD) → Docker Build & Push → Kubernetes (AWS Cluster)

AWS setup:

1 Master node

1 Worker node

1 Jenkins server

⚡ Getting Started
Prerequisites

AWS account with EC2 instances for master, worker, and Jenkins

Docker & Kubernetes installed on nodes

Jenkins installed on your server

GitHub repository with React application

Pipeline Setup

Configure SCM integration in Jenkins to connect your GitHub repository.

Set up GitHub webhooks to trigger Jenkins jobs automatically on push events.

Configure Trivy and SonarQube for security and code quality scans.

Define branch-specific pipelines in the Jenkinsfile to build only desired branches.

Deploy the app to the Kubernetes cluster.

📜 Jenkins Pipeline Overview
pipeline {
    agent any
    environment {
        IMAGE_NAME = "your-dockerhub-username/react-app"
        IMAGE_TAG  = "v${env.BUILD_NUMBER}"
    }
    stages {
        stage('SCM Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/your-username/your-repo.git'
            }
        }
        stage('Build & Test') {
            steps {
                sh 'npm install'
                sh 'npm run build'
            }
        }
        stage('Security Scan') {
            steps {
                sh 'trivy image ${IMAGE_NAME}:${IMAGE_TAG}'
            }
        }
        stage('Code Quality') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh 'sonar-scanner'
                }
            }
        }
        stage('Docker Build & Push') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'
                sh 'docker push ${IMAGE_NAME}:${IMAGE_TAG}'
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f k8s/'
            }
        }
    }
}
🔑 Key Takeaways

CI/CD is more than automation—it connects code, containers, networking, and infrastructure

Integrating security and code quality early in the pipeline ensures safer deployments

Branch-specific pipelines improve efficiency and reduce deployment risks

Cloud deployments provide real-world experience with AWS, Kubernetes, and Jenkins

📖 Contributing

Contributions are welcome! You can:

Improve security scanning

Add multi-branch deployment strategies

Optimize Kubernetes orchestration

Feel free to fork this repo and enhance the pipeline for your projects.
