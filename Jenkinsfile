def dockerCompose = "version: \"3\"\nservices:\n  httpd:\n    build: .\n    image: ghcr.io/alvarodcr/hello-docker/hello2048:${BUILD_NUMBER}\n    ports:\n      - \"80:80\""

pipeline {
    agent any
    options {timestamps()}
	
    stages {
        stage('IMAGE'){
            steps{
		dir('/home/sinensia/hello-2048'){
                sh '''
                docker-compose build
                git tag 1.0.${BUILD_NUMBER}
                docker tag ghcr.io/alvarodcr/hello-2048/hello2048:v1 ghcr.io/alvarodcr/hello-2048/hello2048:1.0.${BUILD_NUMBER}
                '''
                sshagent(['GITHUB']) {
                    sh('git push git@github.com:alvarodcr/hello-2048.git --tags')
		    }
	        }               
            }      
        }  
        
        stage('GIT_LOGIN'){
            steps{ 
		withCredentials([string(credentialsId: 'ghrc_token', variable: 'GIT_TOKEN')]){
		    sh 'echo $GIT_TOKEN | docker login ghcr.io -u alvarodcr --password-stdin'
                    sh 'docker push ghcr.io/alvarodcr/hello-2048/hello2048:1.0.${BUILD_NUMBER}'
		}
            }
        }
      
        stage('SSH_AWS') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId:'ssh-amazon', keyFileVariable: 'AWS_SSH_KEY')]) {
			sh "ssh -i $AWS_SSH_KEY ec2-user@18.203.102.209 'mdkir app_hello-2048_${BUILD_NUMBER} && cd app_hello-2048_${BUILD_NUMBER} && touch docker-compose.yml && cat $dockerCompose > docker-compose.yml'"
			sh "ssh -i $AWS_SSH_KEY ec2-user@18.203.102.209 'docker pull ghcr.io/alvarodcr/hello-2048/hello2048:1.0.${BUILD_NUMBER} && docker-compose up -d'"
                }
            }
        }
    }     
}
