pipeline{
    agent any

    environment {
      REPO = 'devops2030/chatapp'
    }
    stages{
      stage('Pull'){
        steps{
          echo "========executing A========"
          git url: 'git@github.com:BLshlomo/chatapp.git', branch: 'dev', credentialsId: 'admin'
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
        steps {
          script {
            img = docker.build (env.REPO, "-f chat.Dockerfile .")
          }
        }
      }
      /* stage('E2E') {
        script {
          sh "docker container stop chat && docker rm chat || :"
          img.withRun('-p 9000:5000 --name chat') {
            sh './tests.sh chat 9000'
          }
        }
      } */
      stage('E2E') {
        options {
          timeout(time: 2, unit: "MINUTES")
        }
        post {
          always{
            echo "========always========"
            sh 'docker-compose down'
          }
        }
        parallel {
          stage('Runtime') {
            steps {
              sh 'docker-compose up'
            }
          }
          stage('E2E') {
            steps {
              sh './tests.sh localhost 9000'
              sh 'docker-compose down'
            }
          }
        }
      }
      /* stage ('Publish') {
        steps {
          script {
            docker.withRegistry('https://registry.hub.docker.com', 'docker') {
              if ("${env.BRANCH_NAME}" =~ 'dev') {
                img.push("dev-${GIT_COMMIT}") 
              }
              else if ("${env.BRANCH_NAME}" =~ 'staging') {
                img.push("staging-${GIT_COMMIT}") 
              }
              else if ("${env.BRANCH_NAME}" =~ 'master') {
                img.push("1.0.${BUILD_NUMBER}") 
              }           
            }
          }
        }
      } */
    }
    post{
        always{
            echo "========always========"
            sh 'printenv'
        }
        success{
            echo "========pipeline executed successfully ========"
        }
        failure{
            echo "========pipeline execution failed========"
        }
    }
}