pipeline {
    agent any
    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPO = '833371734412.dkr.ecr.us-east-1.amazonaws.com/flask-jenkins-demo'
        IMAGE_NAME = 'flask-jenkins-demo'
    }
    stages {
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Push to ECR') {

                    stage('Test Local Image') {
                        steps {
                            sh '''
                                CONTAINER_ID=$(docker run -d $IMAGE_NAME:latest)
                                sleep 5
                                CONTAINER_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CONTAINER_ID)
                                curl --fail http://$CONTAINER_IP:5000/
                                docker stop $CONTAINER_ID
                                docker rm $CONTAINER_ID
                            '''
                        }
                    }
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-access-key',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    sh '''
                        aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                        aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                        aws configure set region $AWS_REGION

                        aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO
                        docker tag $IMAGE_NAME:latest $ECR_REPO:latest
                        docker push $ECR_REPO:latest
                    '''
                }
            }
        }

        stage('Test from ECR') {
            steps {
                sh '''
                    docker pull $ECR_REPO:latest
                    CONTAINER_ID=$(docker run -d $ECR_REPO:latest)
                    sleep 5
                    CONTAINER_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CONTAINER_ID)
                    curl --fail http://$CONTAINER_IP:5000/
                    docker stop $CONTAINER_ID
                    docker rm $CONTAINER_ID
                '''
            }
        }
            stage('Deploy to ECS Fargate') {
                steps {
                    withCredentials([[ 
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-access-key',
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    ]]) {
                        sh '''
                            aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                            aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                            aws configure set region $AWS_REGION

                            aws ecs update-service \
                              --cluster project-z \
                              --service project-z-task-service-itif3wy9 \
                              --force-new-deployment \
                              --region $AWS_REGION
                        '''
                    }
                }
            }
    }
}
