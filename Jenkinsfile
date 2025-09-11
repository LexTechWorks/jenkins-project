pipeline {
    agent any
    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build('flask-jenkins-demo')
                }
            }
        }
        stage('Run Container') {
            steps {
                script {
                    docker.image('flask-jenkins-demo').run('-d -p 5000:5000')
                }
            }
        }
    }
}
