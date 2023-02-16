def GIT_IMG=ghcr.io/alvarodcr/hello-2048/		#Ruta del repositorio donde se subira la imagen de GHCR_IMG
def GIT_SSH=git@github.com:alvarodcr/hello-2048.git	#Ruta SSH del repositorio de GIT
def GHCR_IMG=hello2048					#Nombre de la imagen de ghcr.io
def DOCKER_USER=alvarodcr				#Nombre del usuario de GIT
def TOKEN_GIT=ghrc_token				#Credencial para loguearse en ghcr.io
def AWS_KEY=ssh-amazon					#Credencial para conectarse por SSH a las isntancias de AWS
def AWS_ROOT_KEY=					#Credencial asociada a la creacion de instancia en AWS
def ANSIBLE_INV=ansible/aws_ec2.yml 			#Ruta del inventario de Ansible
def ANSIBLE_PB=ansible/hello_2048.yml 			#Ruta del playbook de Ansible
	
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
		withCredentials([string(credentialsId: '$TOKEN_GIT', variable: 'GIT_TOKEN')]) {
		    sh 'echo $GIT_TOKEN | docker login ghcr.io -u $DOCKER_USER --password-stdin'
                    sh 'docker push $REPO:1.0.${BUILD_NUMBER}'
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
	    
    	stage('ANSIBLE --> SETTING AWS EC2 INSTANCE --> DEPLoYING <HELLO-2048> CONTAINER') {
            steps {
            	withAWS(credentials: '$AWS_ROOT_KEY') {
                    ansiblePlaybook credentialsId: '$AWS_KEY', inventory: '$ANSIBLE_INV', playbook: '$ANSIBLE_PB'                         
                }
            }
        }
    }     
}
