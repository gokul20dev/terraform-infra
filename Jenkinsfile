pipeline {
    agent any

    parameters {
        choice(name: 'SERVICE', choices: ['vpc', 's3', 'load_balancer', 'lambda', 'ec2'], description: 'Select AWS Service to deploy')
        choice(name: 'ACTION',  choices: ['plan', 'apply', 'destroy'], description: 'Select Terraform Action')
        string(name: 'AWS_REGION',     defaultValue: 'ap-south-1', description: 'AWS Region')
        string(name: 'INSTANCE_TYPE',  defaultValue: 't2.micro',   description: 'EC2 instance type (only for EC2)')
    }

    environment {
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
                withCredentials([
                    string(credentialsId: 'aws-access-key',  variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    script {
                        // Decide which resources to create
                        def createVpc    = (params.SERVICE == 'vpc')
                        def createS3     = (params.SERVICE == 's3')
                        def createLb     = (params.SERVICE == 'load_balancer')
                        def createLambda = (params.SERVICE == 'lambda')
                        def createEc2    = (params.SERVICE == 'ec2')

                        // Build TF -var arguments
                        def tfVars = "-var='aws_region=${params.AWS_REGION}' " +
                                     "-var='create_vpc=${createVpc}' " +
                                     "-var='create_s3=${createS3}' " +
                                     "-var='create_lb=${createLb}' " +
                                     "-var='create_lambda=${createLambda}' " +
                                     "-var='create_ec2=${createEc2}' " +
                                     "-var='instance_type=${ createEc2 ? params.INSTANCE_TYPE : "" }'"

                        // plan → no auto-approve, apply/destroy → auto-approve
                        def autoFlag = (params.ACTION == 'plan') ? "" : " -auto-approve"

                        sh """
                            cd ${TF_STATE_DIR}
                            export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
                            export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
                            terraform ${params.ACTION} ${tfVars} ${autoFlag}
                        """
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
