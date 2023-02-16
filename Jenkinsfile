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
		docker-compose build
                git tag 1.0.${BUILD_NUMBER}
                docker tag ghcr.io/alvarodcr/hello-2048/hello2048:latest ghcr.io/alvarodcr/hello-2048/hello2048:1.0.${BUILD_NUMBER}
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
        
        stage('VALiDATING TERRAFORM --> MAIN.CFG') {
            steps {
                sh 'terraform validate'
            
            }
        }
         
        stage('TERRAFORM --> BUILDING INSTANCE AWS EC2 INSTANCE') {
            steps {
            	withAWS(credentials: '2934977b-3b53-4065-8b4a-312c2259a9f3') {
                    sh 'terraform apply -auto-approve -lock=false'
                                        
                }
            }
        }
    	stage('ANSIBLE --> SETTING AWS EC2 INSTANCE') {
            steps {
            	withAWS(credentials: '2934977b-3b53-4065-8b4a-312c2259a9f3') {
                    ansiblePlaybook credentialsId: 'ssh-amazon', inventory: 'ansible/aws_ec2.yml', playbook: 'ansible/hello_2048.yml'
                                        
                }
            }
        }
    }     
}
