pipeline {

  // Environment Setup
  environment {
    AWS_PROFILENAME="jenkins"
  } // env

  // Build on a slave with docker (for pre-req?)
  agent { label 'docker' }

  stages {
    stage('Start Cumulus Deployment') {
      steps {
        // Send chat notification
        mattermostSend channel: "${CHAT_ROOM}", color: '#EAEA5C', endpoint: "${env.CHAT_HOST}", message: "Build started: ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>). See (<{$env.RUN_CHANGES_DISPLAY_URL}|Changes>)."
      }
    }
    stage('Clone and checkout DAAC repo/ref') {
      steps {
        sh "cd ${WORKSPACE}"
        sh "if [ ! -d \"daac-repo\" ]; then git clone ${env.DAAC_REPO} daac-repo; fi"
        sh "cd daac-repo && git fetch && git checkout ${env.DAAC_REF} && git pull && cd .."
        sh 'tree'
      }
    }
    stage('Build the CIRRUS deploy Docker image') {
      steps {
        sh """cd jenkinsbuild && \
              docker build -f nodebuild.Dockerfile -t cirrusbuilder .
           """
      }
    }
    stage('Deploy Cumulus within CIRRUS deploy Docker container') {
      environment {
        CMR_CREDS = credentials("${CMR_CREDS_ID}")
        URS_CREDS = credentials("${URS_CREDS_ID}")
        TOKEN_SECRET = credentials("${env.SECRET_TOKEN_ID}")/**/
      }
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: "${env.AWSCREDS}"]])  {

            sh """docker run --rm   --user `id -u` \
                                    --env TF_VAR_cmr_username='${CMR_CREDS_USR}' \
                                    --env TF_VAR_cmr_password='${CMR_CREDS_PSW}' \
                                    --env TF_VAR_urs_client_id='${URS_CREDS_USR}' \
                                    --env TF_VAR_urs_client_password='${URS_CREDS_PSW}' \
                                    --env TF_VAR_token_secret='${TOKEN_SECRET}' \
                                    --env DEPLOY_NAME='${DEPLOY_NAME}' \
                                    --env MATURITY_IN='${MATURITY}' \
                                    --env AWS_ACCESS_KEY_ID='${AWS_ACCESS_KEY_ID}' \
                                    --env AWS_SECRET_ACCESS_KEY='${AWS_SECRET_ACCESS_KEY}' \
                                    --env AWS_REGION='${AWS_REGION}' \
                                    --env DAAC_REPO='${DAAC_REPO}' \
                                    --env DAAC_REF='${DAAC_REF}' \
                                    -v \"${WORKSPACE}\":/workspace \
                                    cirrusbuilder \
                                    /bin/bash /workspace/jenkinsbuild/cumulusbuilder.sh
            """

        }// withCredentials
      }// steps
    }// stage
  } // stages
  // Send build status to Mattermost, Update build badge
  post {
    always {
      sh 'echo "done"'
    }
    success {
      mattermostSend channel: "${CHAT_ROOM}", color: '#CEEBD3', endpoint: "${env.CHAT_HOST}", message: "Build Successful: ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
    }
    failure {
      sh "env"
      sh "echo ${WORKSPACE}"
      sh "cd \"${WORKSPACE}\""
      sh "tree"

      mattermostSend channel: "${CHAT_ROOM}", color: '#FFBDBD', endpoint: "${env.CHAT_HOST}", message: "Build Failed:  🤬${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)🤬"

    }
    changed {
      sh "echo 'This will run only if the state of the Pipeline has changed' && echo 'For example, if the Pipeline was previously failing but is now successful'"
    }
  }

} // pipeline
