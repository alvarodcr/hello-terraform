pipeline {
  agent any
  options {timestamps()}
  stages {

    stage('AWS EC2 instance - Terraform --> Validando main.tf') {
        steps {
                sh 'terraform validate'
            
        }
    }

    stage('AWS EC2 instance - Terraform --> Aplicando main.tf') {
      steps {
        withAWS(credentials: '2934977b-3b53-4065-8b4a-312c2259a9f3') {
                sh 'terraform apply -auto-approve'
        }
      }
    }
  }
}

