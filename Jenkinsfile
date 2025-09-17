pipeline {
  agent any
  environment {
    AWS_REGION   = 'us-east-1'
    ECR_REPO     = '833371734412.dkr.ecr.us-east-1.amazonaws.com/flask-jenkins-demo'
    IMAGE_NAME   = 'flask-jenkins-demo'
    IMAGE_TAG    = 'latest'   // pode usar "${BUILD_NUMBER}" se preferir
    ECR_REGISTRY = '833371734412.dkr.ecr.us-east-1.amazonaws.com'
  }

  stages {
    stage('Build Docker Image') {
      steps {
        sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG .'
      }
    }

    stage('Test Local Image') {
      steps {
        sh '''
          CONTAINER_ID=$(docker run -d -p 5000 --rm $IMAGE_NAME:$IMAGE_TAG)
          sleep 5
          CONTAINER_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CONTAINER_ID)
          curl --fail http://$CONTAINER_IP:5000/ || (docker logs $CONTAINER_ID && false)
          docker stop $CONTAINER_ID
        '''
      }
    }

    stage('Push to ECR') {
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

            # login no REGISTRY (sem o /repo)
            aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY

            # tag e push
            docker tag $IMAGE_NAME:$IMAGE_TAG $ECR_REPO:$IMAGE_TAG
            docker push $ECR_REPO:$IMAGE_TAG
          '''
        }
      }
    }

    stage('Test from ECR') {
      steps {
        sh '''
          docker pull $ECR_REPO:$IMAGE_TAG
          CONTAINER_ID=$(docker run -d -p 5000 --rm $ECR_REPO:$IMAGE_TAG)
          sleep 5
          CONTAINER_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CONTAINER_ID)
          curl --fail http://$CONTAINER_IP:5000/ || (docker logs $CONTAINER_ID && false)
          docker stop $CONTAINER_ID
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
