//Must be configured for each module. This is just a basic sample CI pipeline

pipeline {
    agent any

    environment {
        ARTIFACTORY_URL = 'https://myartifactory.example.com/artifactory'
        RELEASE_VERSION = '1.0.0' // Can be configured or passed as a parameter
        EMAIL_SUCCESS = 'success@domain.com'
        EMAIL_FAILURE = 'failure@domain.com'
    }

    stages {
        stage('Terraform Linter Validation') {
            steps {
                script {
                    sh 'which tflint || { wget https://github.com/terraform-linters/tflint/releases/download/v0.50.2/tflint_linux_amd64.zip; unzip tflint_linux_amd64.zip -d /usr/local/bin; }'
                    sh 'tflint --version'
                    sh 'tflint'
                }
            }
        }

        stage('Go Test') {
            steps {
                script {
                    sh 'go version'
                    sh 'go run ./test/...'
                }
            }
        }

        stage('Build Artifact') {
            steps {
                script {
                    sh 'tar -czvf release-${RELEASE_VERSION}.tar.gz .'
                }
            }
        }

        stage('Push to Artifactory') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ssh-artifactory-credentials', keyFileVariable: 'SSH_KEY')]) {
                    script {
                        sh """
                        scp -i $SSH_KEY release-${RELEASE_VERSION}.tar.gz ${ARTIFACTORY_URL}/my-repo/release-${RELEASE_VERSION}/
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            mail to: "${EMAIL_SUCCESS}",
                 subject: "Success: Deployment to Artifactory",
                 body: "The deployment of release ${RELEASE_VERSION} to Artifactory was successful."
        }
        failure {
            mail to: "${EMAIL_FAILURE}",
                 subject: "Failure: Deployment to Artifactory",
                 body: "The deployment of release ${RELEASE_VERSION} to Artifactory failed. Check Jenkins logs for more details."
        }
        always {
            // Clean up workspace after the build
            cleanWs()
        }
    }
}
