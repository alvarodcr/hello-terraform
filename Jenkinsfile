pipeline {
    agent any
    options {
        timestamps()
        ansiColor('xterm')
    }
	
    stages {
        stage('BUILDING IMAGE'){
            steps{
                sh '''
                cd /home/sinensia/hello-2048
                git config --global --add safe.directory /home/sinensia/hello-2048
		docker-compose build
                sudo --ask-become-pass git tag 1.0.${BUILD_NUMBER}
                docker tag ghcr.io/alvarodcr/hello-2048/hello2048:v1 ghcr.io/alvarodcr/hello-2048/hello2048:1.0.${BUILD_NUMBER}
                '''
                sshagent(['GITHUB']) {
                    sh('git push git@github.com:alvarodcr/hello-2048.git --tags')
                }               
            }      
        }  
        
        stage('PUSING DOCKER IMAGE TO GHCR.IO'){
            steps{ 
		        withCredentials([string(credentialsId: 'ghrc_token', variable: 'GIT_TOKEN')]){
		            sh 'echo $GIT_TOKEN | docker login ghcr.io -u alvarodcr --password-stdin'
                    sh 'docker push ghcr.io/alvarodcr/hello-2048/hello2048:1.0.${BUILD_NUMBER}'
		        }
            }
        }   
        
        stage('VALiDATING TERRAFORM MAIN.CFG') {
            steps {
                sh 'cd /home/sinensia/hello-terraform && terraform validate'
            
            }
        }
         
        stage('APPLYING TERRAFORM --> BUILDING INSTANCE ON AWS EC2') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId:'ssh-amazon', keyFileVariable: 'AWS_SSH_KEY')]) {
	                withAWS(credentials: '2934977b-3b53-4065-8b4a-312c2259a9f3') {
                        sh 'cd /home/sinensia/hello-terraform && terraform apply -auto-approve -lock=false'
                        AnsiblePlaybook(
                            credentialsId: '2934977b-3b53-4065-8b4a-312c2259a9f3', 
                            inventory: '/home/sinensia/aws_ec2.yml', 
                            playbook: '/home/sinensia/hello_2048.yml'
                        )                    
                    }
                }
            }
        }
    }     
}
