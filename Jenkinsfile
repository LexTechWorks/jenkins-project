pipeline {
    agent any
    stages {
        stage('Clone') {
            steps {
                git 'https://github.com/LexTechWorks/jenkins-project.git'
            }
        }
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
