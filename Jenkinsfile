// It would be recommendable to store all files into a single repository to ensure optimal functionality

pipeline {
    agent any
    
    environment {
	
	GIT_REPO_IMG = 'ghcr.io/alvarodcr/hello-2048'		// Repository path where the GHCR_IMG image will be uploaded
	GIT_REPO_SSH = 'git@github.com:alvarodcr/hello-2048.git'// Git SSH repository
	GIT_TOKEN = 'ghrc_token'				// ghcr.io credential (token) 
	GIT_SSH = 'GITHUB'					// GIT SSH credentials
	GIT_USER = 'alvarodcr'					// Git username
	GHCR_IMG = 'hello2048'					// Image name that will be uploaded to ghcr.io
	AWS_KEY = 'ssh-amazon'					// AWS credentials for connecting via SSH
	AWS_ROOT_KEY = '2934977b-3b53-4065-8b4a-312c2259a9f3'	// AWS credential associated with creating instances
	ANSIBLE_INV = 'ansible/aws_ec2.yml' 			// Ansible inventory path
	ANSIBLE_PB = 'ansible/hello_2048.yml' 			// Ansible playbook path
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
                docker tag ${GIT_REPO_IMG}/${GHCR_IMG}:latest {$GIT_REPO_IMG}/${GHCR_IMG}:1.0.${BUILD_NUMBER}
                '''
                sshagent(['$GIT_SSH']) {
		    sh('git push ${GIT_REPO_SSH} --tags')
                }
	    }	                              
        }  
        
        stage('DOCKER --> LOGIN & PUSHING TO GHCR.IO') {
            steps{ 
		withCredentials([string(credentialsId: '${GIT_TOKEN}')]) {
		    sh 'echo ${GIT_TOKEN} | docker login ghcr.io -u ${GIT_USER} --password-stdin'
		    sh 'docker push ${GIT_IMG}:1.0.${BUILD_NUMBER}'
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
		withAWS(credentials: '${AWS_ROOT_KEY}') {
                    sh 'terraform apply -auto-approve -lock=false'                         
                }
            }
        }
	    
	stage('ANSIBLE --> SETTING AWS EC2 INSTANCE --> DEPLOYING <${GHCR_IMG}> CONTAINER') {
            steps {
		withAWS(credentials: '${AWS_ROOT_KEY}') {
		    ansiblePlaybook credentialsId: '${AWS_KEY}', inventory: '${ANSIBLE_INV}', playbook: '${ANSIBLE_PB}'                         
                }
            }
        }
    }     
}
