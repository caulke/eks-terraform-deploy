pipeline {
    agent { node { label 'terraform-node' } } 
    parameters {
                choice(name: 'deploy_choice', choices:['apply','destroy'], description:'The deployment type')
                  }
    environment {
        SLACK_CHANNEL = '#devops'
        SLACK_CREDENTIAL = 'qq'  // Set this in Jenkins Credentials
    }
    stages {
        stage('1.Terraform init') {
            steps {
                echo 'terraform init phase'
                sh 'terraform init'
            }
        }
        stage('2.Terraform plan') {
            steps {
                echo 'terraform plan phase'
                sh 'AWS_REGION=us-east-2 terraform plan'
            }
        }
        stage('3.Manual Approval') {
            input {
                message "Should we proceed?"
                ok "Yes, we should."
                parameters {
                    choice (name: 'Manual_Approval', choices: ['Approve','Reject'], description: 'Approve or Reject the deployment')
                }
            }
            steps {
                echo "Deployment ${Manual_Approval}"
            }          
        }
        stage('4.Terraform Deploy') {              
            steps { 
                echo 'Terraform ${params.deploy_choice} phase'  
                sh "AWS_REGION=us-east-2 terraform ${params.deploy_choice} -target=module.vpc -target=module.eks --auto-approve"
                sh("""scripts/update-kubeconfig.sh""")
                sh("""scripts/observerbility-addon.sh""")
                sh "AWS_REGION=us-east-2 terraform ${params.deploy_choice} --auto-approve"
            }
        }
        stage('5. Slack Notification') {
            steps {
                slackSend (
                    channel: "${SLACK_CHANNEL}",
                    color: '#00FF00',  // Green for success
                    message: "Terraform deployment completed successfully: ${params.deploy_choice}"
                )
            }
        }
    }
    post {
        failure {
            slackSend (
                channel: "${SLACK_CHANNEL}",
                color: '#FF0000',  // Red for failure
                message: "Terraform deployment failed: ${params.deploy_choice}"
            )
        }
    }
}
