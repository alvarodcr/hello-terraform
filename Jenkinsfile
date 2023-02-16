pipeline {
  agent any
  environment {
    TF_PLUGIN_CACHE_DIR = "${HOME}/.terraform.d/plugin-cache"
  }
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
        withAWS(credentials: '2934977b-3b53-4065-8b4a-312c2259a9f3', region: 'eu-west-1') {
            dir(/home/sinensia/hello-terraform) {
                sh 'terraform apply -auto-approve'
            }
        }
      }
    }
  
}
