pipeline {
    agent any
    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPO = '833371734412.dkr.ecr.us-east-1.amazonaws.com/flask-jenkins-demo'
    }
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build('flask-jenkins-demo')
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-access-key',
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    ]]) {
                        sh """
                            aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                            aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                            aws configure set region $AWS_REGION
                            aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO
                            docker tag flask-jenkins-demo:latest $ECR_REPO:latest
                            docker push $ECR_REPO:latest
                        """
                    }
                }
            }
        }

        stage('Test from ECR') {
            steps {
                script {
                    def app = docker.image("${ECR_REPO}:latest").run('-d')
                    sleep 5
                    def containerId = app.id
                    def containerIp = sh(
                        script: "docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${containerId}",
                        returnStdout: true
                    ).trim()
                    sh "curl --fail http://${containerIp}:5000/"
                    app.stop()
                }
            }
        }
    }
}
