pipeline {
  agent any
  options {
    timestamps()
    ansiColor('xterm')
  }
  stages {

    stage('AWS EC2 instance - Terraform --> Validando main.tf') {
        steps {
                sh 'cd /home/sinensia/hello-terraform && terraform validate'
            
        }
    }

    stage('AWS EC2 instance - Terraform --> Aplicando main.tf') {
      steps {
        withAWS(credentials: '2934977b-3b53-4065-8b4a-312c2259a9f3') {
               sh 'cd /home/sinensia/hello-terraform && terraform apply -auto-approve'
        }
      }
    }
  }
}

