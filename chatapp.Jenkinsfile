pipeline{
    agent any

    environment {
    REPO = 'devops2030/chatapp'
    }
    stages{
      stage('Pull'){
        steps{
          echo "========executing A========"
          git url: 'git@github.com:BLsolomon/terraform-ted-search.git', branch: 'dev', credentialsId: 'admin'
        }
        post{
          always{
              echo "========always========"
          }
          success{
              echo "========A executed successfully========"
          }
          failure{
              echo "========A execution failed========"
          }
        }
      }
      stage('Build') {
       script {
          img = docker.build env.REPO
        }
      }
      stage('E2E') {
        script {
          sh "docker container stop chat && docker rm chat || :"
          img.withRun('-p 9000:5000 --name chat') {
            sh './tests.sh chat 9000'
          }
        }
      }
    }
    post{
        always{
            echo "========always========"
        }
        success{
            echo "========pipeline executed successfully ========"
        }
        failure{
            echo "========pipeline execution failed========"
        }
    }
}