//JENKINSFILE									//GITHUB --> DOCKER --> TERRAFORM --> ANSIBLE --> AWS

pipeline {
    agent any 
    options {
        timestamps()
        ansiColor('xterm')
    }

    environment {
        DOCKER_REPO_URL = 'ghcr.io/alvarodcr/hello-terraform/helloterraformpkg' // Docker repository URL
        GIT_SSH_CREDENTIALS = credentialsId('git-ssh') 				            // SSH credentials for Git
        //GIT_USERNAME = 'alvarodcr' 						                    // Git username
        GHCR_TOKEN_CREDENTIALS = credentials('ghrc_token') 			            // ghcr.io credentials (token)
        AWS_SSH_CREDENTIALS = credentials('ssh-amazon') 			            // SSH credentials for connecting to AWS
        AWS_CREDENTIALS = credentials('2934977b-3b53-4065-8b4a-312c2259a9f3')	// AWS credentials for creating instances AWS
        ANSIBLE_INVENTORY_PATH = 'ansible/aws_ec2.yml'				            // Ansible inventory path
        ANSIBLE_PLAYBOOK_PATH = 'ansible/hello_2048.yml' 			            // Ansible playbook path
    }

    stages {
        stage('DOCKER --> BUILDING & TAGGING IMAGE') {
            steps{
                sh """
                docker-compose build
                git tag 1.0.${BUILD_NUMBER}
                """
                sh "docker tag ${DOCKER_REPO_URL}:latest ${DOCKER_REPO_URL}:1.0.${BUILD_NUMBER}"
                sshagent([GIT_SSH_CREDENTIALS]) {
                    sh 'git push --tags'
                }
            }                              
        }  

        stage('DOCKER --> LOGIN & PUSHING TO GHCR.IO') {
            steps{ 
                withCredentials([GHCR_TOKEN_CREDENTIALS]) {
                    sh """
                    echo \${GHCR_TOKEN_CREDENTIALS} | docker login ghcr.io -u ${GIT_SSH_CREDENTIALS_USR} --password-stdin
                    docker push ${DOCKER_REPO_URL}:1.0.${BUILD_NUMBER}
                    """ 
                }
            }
        }   

        stage('TERRAFORM --> INIT & FMT & VALIDATE') {
            steps {
                sh 'terraform init && terraform fmt && terraform validate'
            }
        }

        stage('TERRAFORM --> BUILDING AWS EC2 INSTANCE') {
            steps {
                withAWS(credentials: AWS_CREDENTIALS) {
                    sh 'terraform apply -auto-approve -lock=false'                         
                }
            }
        }

        stage('ANSIBLE --> SETTING AWS EC2 INSTANCE') {
            steps {
                withAWS(credentials: AWS_CREDENTIALS) {
                    ansiblePlaybook colorized: true, credentialsId: AWS_SSH_CREDENTIALS, inventory: ANSIBLE_INVENTORY_PATH, playbook: ANSIBLE_PLAYBOOK_PATH                            
                }
            }
        }
    }     
}
