#It would be recommendable to store all files into a single repository to ensure optimal functionality

def GIT_IMG=ghcr.io/alvarodcr/hello-2048		#Repository path where the GHCR_IMG image will be uploaded
def GIT_SSH=git@github.com:alvarodcr/hello-2048.git	#Git repository SSH
def GIT_TOKEN=ghrc_token				#Credential for logging into ghcr.io
def GHCR_IMG=hello2048					#Name of the image that will be uploaded to ghcr.io
def DOCKER_USER=alvarodcr				#Git username
def AWS_KEY=ssh-amazon					#Credential for connecting to AWS instances via SSH
def AWS_ROOT_KEY=2934977b-3b53-4065-8b4a-312c2259a9f3	#Credential associated with creating instances in AWS
def ANSIBLE_INV=ansible/aws_ec2.yml 			#Path of the Ansible inventory
def ANSIBLE_PB=ansible/hello_2048.yml 			#Path of the Ansible playbook
	
pipeline {
    agent any
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
                docker tag $GIT_IMG/$GHCR_IMG$:latest $GIT_IMG/$GHCR_IMG:1.0.${BUILD_NUMBER}
                '''
                sshagent(['GITHUB']) {
                    sh('git push $GIT_SSH --tags')
                }
	    }	                              
        }  
        
        stage('DOCKER --> LOGIN & PUSHING TO GHCR.IO') {
            steps{ 
		withCredentials([string(credentialsId: '$GIT_TOKEN')]) {
		    sh 'echo $GIT_TOKEN | docker login ghcr.io -u $DOCKER_USER --password-stdin'
                    sh 'docker push $GIT_IMG:1.0.${BUILD_NUMBER}'
		}
            }
        }   
        
        stage('TERRAFORM --> INIT & VALIDATE') {
            steps {
                sh 'terraform init'
		sh 'terraform validate'
            }
        }
         
        stage('TERRAFORM --> BUILDING AWS EC2 INSTANCE') {
            steps {
            	withAWS(credentials: '$AWS_ROOT_KEY') {
                    sh 'terraform apply -auto-approve -lock=false'                         
                }
            }
        }
	    
    	stage('ANSIBLE --> SETTING AWS EC2 INSTANCE --> DEPLOYING <$GHCR_IMG> CONTAINER') {
            steps {
            	withAWS(credentials: '$AWS_ROOT_KEY') {
                    ansiblePlaybook credentialsId: '$AWS_KEY', inventory: '$ANSIBLE_INV', playbook: '$ANSIBLE_PB'                         
                }
            }
        }
    }     
}
