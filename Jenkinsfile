pipeline {
    agent { node { label 'terraform-node' } } 
    parameters {
        choice(name: 'Deployment_Type', choices: ['apply', 'destroy'], description: 'The deployment type')
    }
    environment {
        SLACK_CHANNEL = '#devops'  // Set your Slack channel
        SLACK_CREDENTIAL = 'qq'      // Set this in Jenkins Credentials
    }
    stages {
        stage('1. Terraform init') {
            steps {
                echo 'Terraform init phase'
                sh 'terraform init'
            }
        }
        stage('2. Terraform plan') {
            steps {
                echo 'Terraform plan phase'
                sh 'AWS_REGION=us-east-2 terraform plan'
            }
        }
        stage('3. Manual Approval') {
            input {
                message "Should we proceed?"
                ok "Yes, we should."
                parameters {
                    choice(name: 'Manual_Approval', choices: ['Approve', 'Reject'], description: 'Approve or Reject the deployment')
                }
            }
            steps {
                echo "Deployment ${Manual_Approval}"
            }          
        }
        stage('4. Terraform Deploy') {              
            steps { 
                echo "Terraform ${params.Deployment_Type} phase"  
                sh "AWS_REGION=us-east-2 terraform ${params.Deployment_Type} --auto-approve"
                sh """scripts/update-kubeconfig.sh"""
                sh """scripts/install_helm.sh""" 
            }
        }
        stage('5. Slack Notification') {
            steps {
                slackSend (
                    channel: "${SLACK_CHANNEL}",
                    color: '#00FF00',  // Green for success
                    message: "Terraform deployment completed successfully: ${params.Deployment_Type}"
                )
            }
        }
    }
    post {
        failure {
            slackSend (
                channel: "${SLACK_CHANNEL}",
                color: '#FF0000',  // Red for failure
                message: "Terraform deployment failed: ${params.Deployment_Type}. Manual Approval: ${Manual_Approval}"
            )
        }
    }
}
