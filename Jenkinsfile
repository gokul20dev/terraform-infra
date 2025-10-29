pipeline {
    agent any

    parameters {
        string(name: 'AWS_REGION', defaultValue: 'ap-south-1', description: 'AWS Region to deploy in')
        choice(name: 'ACTION', choices: ['plan', 'apply', 'destroy'], description: 'Select Terraform Action')
        choice(name: 'SERVICE', choices: ['vpc', 's3', 'load_balancer', 'lambda'], description: 'Select AWS Service to deploy')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        TF_STATE_DIR = '/var/jenkins_home/terraform_state'
    }

    stages {
        stage('Init') {
            steps {
                sh '''
                echo "🧱 Setting up Terraform working directory..."
                mkdir -p $TF_STATE_DIR
                cp -r *.tf $TF_STATE_DIR/
                cd $TF_STATE_DIR
                terraform init
                '''
            }
        }

        stage('Terraform Action') {
            steps {
                script {
                    sh 'cd $TF_STATE_DIR'

                    def terraformCmd = """
                        cd $TF_STATE_DIR &&
                        terraform ${params.ACTION} -auto-approve \
                        -var='aws_region=${AWS_REGION}' \
                        -var='create_vpc=${params.SERVICE == "vpc"}' \
                        -var='create_s3=${params.SERVICE == "s3"}' \
                        -var='create_lb=${params.SERVICE == "load_balancer"}' \
                        -var='create_lambda=${params.SERVICE == "lambda"}'
                    """

                    if (params.ACTION == 'plan') {
                        sh terraformCmd.replace("-auto-approve", "")
                    } else {
                        sh terraformCmd
                    }
                }
            }
        }
    }

    post {
        success {
            echo "✅ Terraform ${params.ACTION} for ${params.SERVICE} completed successfully!"
        }
        failure {
            echo "❌ Terraform ${params.ACTION} for ${params.SERVICE} failed. Check the logs."
        }
    }
}
