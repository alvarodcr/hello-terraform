//GITHUB-LOCAL-DOCKER-TERRAFORM-AWS-ANSIBLE

pipeline {
    agent any
    
    environment {
	
	GIT_REPO_PKG = 'ghcr.io/alvarodcr/hello-terraform'		// GHCR_PKG package repository
	GIT_REPO_SSH = 'git@github.com:alvarodcr/hello-terraform.git'	// GIT SSH repository
	//GIT_SSH_CN = "git-ssh"						// GIT SSH credentials
	GIT_USER = 'alvarodcr'						// GIT username
	//GHCR_TOKEN = 'ghrc_token'					// ghcr.io credential (token) 
	GHCR_PKG = 'helloterraformpkg'					// PKG name that will be uploaded to ghcr.io
	//AWS_KEY_INS = 'ssh-amazon'					// AWS credentials for connecting via SSH
	//AWS_ROOT_KEY = '2934977b-3b53-4065-8b4a-312c2259a9f3'		// AWS credential associated with creating instances
	//ANSIBLE_INV = 'aws_ec2.yml' 					// Ansible inventory path
	//NSIBLE_PB = 'hello_2048.yml' 					// Ansible playbook path
    }
  
    options {
        timestamps()
        ansiColor('xterm')
    }
	
    stages {
        
	stage('DOCKER --> BUILDING IMAGE') {
            steps{
		sh '''
		docker-compose build
                git tag 1.0.${BUILD_NUMBER}
                docker tag ${GIT_REPO_PKG}/${GHCR_PKG}:latest ${GIT_REPO_PKG}/${GHCR_PKG}:1.0.${BUILD_NUMBER}
                '''
		sshagent(['git-ssh']) {
		sh 'git push --tags'
		}
	    }	                              
        }  
        
        stage('DOCKER --> LOGIN & PUSHING TO GHCR.IO') {
            steps{ 
		withCredentials([string(credentialsId: 'ghrc_token', variable: 'TOKEN_GIT')]) {
		    sh '''
		    echo $TOKEN_GIT | docker login ghcr.io -u ${GIT_USER} --password-stdin
		    docker push ${GIT_REPO_PKG}/${GHCR_PKG}:1.0.${BUILD_NUMBER}
		    docker push ${GIT_REPO_PKG}/${GHCR_PKG}:latest
		    '''		
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
		withAWS(credentials: '2934977b-3b53-4065-8b4a-312c2259a9f3') {
                    sh 'terraform apply -auto-approve -lock=false'                         
                }
            }
        }
	    
	stage('ANSIBLE --> SETTING AWS EC2 INSTANCE --> DEPLOYING ${GHCR_PKG} CONTAINER') {
            steps {
		withAWS(credentials: '2934977b-3b53-4065-8b4a-312c2259a9f3') {
		    ansiblePlaybook colorized: true, credentialsId: 'ssh-amazon', inventory: 'ansible/aws_ec2.yml', playbook: 'ansible/hello_2048.yml'                            
		}
            }
        }
    
    }     
}
