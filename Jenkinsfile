pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/vshaldb/tf-aws.git'
            }
        }
        stage('Backend Creation') {
            steps {
                sh 'chmod +x CreateBackend.sh'
                sh './CreateBackend.sh tfaws ap-south-1'
            }
        }
        stage('Terraform init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }
        stage('Terraform apply') {
            steps {
                sh 'terraform apply "tfplan"'
            }
        }
        
    }
}