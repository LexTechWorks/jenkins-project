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
    }
}
