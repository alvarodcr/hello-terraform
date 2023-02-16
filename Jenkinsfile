pipeline {
  agent any
  options {timestamps()}
  stages {


    stage('AWS EC2 instance - Terraform --> Validando main.tf') {
        steps {
            dir(/home/sinensia/hello-terraform){
                sh 'terraform apply'
            }
        }
    }

    stage('AWS EC2 instance - Terraform --> Aplicando main.tf') {
      steps {
        withAWS(credentials: 'aws-creds', region: 'eu-west-1') {
            dir(/home/sinensia/hello-terraform) {
                sh 'terraform apply -auto-approve'
            }
        }
      }
    }
}

