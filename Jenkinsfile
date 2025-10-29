pipeline {
    agent any

    parameters {
        string(name: 'AWS_REGION', defaultValue: 'ap-south-1', description: 'AWS Region to deploy in')
        choice(name: 'ACTION', choices: ['plan', 'apply', 'destroy'], description: 'Select Terraform Action')
        string(name: 'INSTANCE_TYPE', defaultValue: 't2.micro', description: 'EC2 instance type')
        string(name: 'VPC_NAME', defaultValue: 'my-vpc', description: 'VPC name or environment')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        TF_STATE_DIR = '/var/jenkins_home/terraform_state'
    }

    stages {
        stage('Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Execute') {
            steps {
                script {
                    if (params.ACTION == 'plan') {
                        sh "terraform plan -var 'aws_region=${AWS_REGION}' -var 'instance_type=${INSTANCE_TYPE}' -var 'vpc_name=${VPC_NAME}'"
                    } 
                    else if (params.ACTION == 'apply') {
                        sh "terraform apply -auto-approve -var 'aws_region=${AWS_REGION}' -var 'instance_type=${INSTANCE_TYPE}' -var 'vpc_name=${VPC_NAME}'"
                    } 
                    else if (params.ACTION == 'destroy') {
                        sh "terraform destroy -auto-approve -var 'aws_region=${AWS_REGION}' -var 'instance_type=${INSTANCE_TYPE}' -var 'vpc_name=${VPC_NAME}'"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Terraform ${params.ACTION} completed successfully!"
        }
        failure {
            echo "❌ Terraform ${params.ACTION} failed. Check the logs."
        }
    }
}
