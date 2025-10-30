pipeline {
    agent any


    parameters {
        choice(name: 'SERVICE', choices: ['vpc', 's3', 'load_balancer', 'lambda', 'ec2'], description: 'Select AWS Service to deploy')
        choice(name: 'ACTION', choices: ['plan', 'apply', 'destroy'], description: 'Select Terraform Action')
        string(name: 'AWS_REGION', defaultValue: 'ap-south-1', description: 'AWS Region')
       // string(name: 'INSTANCE_TYPE', defaultValue: 't2.micro', description: 'Used only if SERVICE=ec2')
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

                    // ✅ Build Terraform command dynamically
                    def terraformCmd = """
                        cd $TF_STATE_DIR &&
                        terraform ${params.ACTION} -auto-approve \
                        -var='aws_region=${params.AWS_REGION}' \
                        -var='create_vpc=${params.SERVICE == "vpc"}' \
                        -var='create_s3=${params.SERVICE == "s3"}' \
                        -var='create_lb=${params.SERVICE == "load_balancer"}' \
                        -var='create_lambda=${params.SERVICE == "lambda"}' \
                        -var='create_ec2=${params.SERVICE == "ec2"}' \
                        -var='instance_type=${params.INSTANCE_TYPE}'
                    """

                    // ✅ Handle Terraform Plan separately (no auto-approve)
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
