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
        stage('Test Container') {
            steps {
                script {
                    def app = docker.image('flask-jenkins-demo').run('-d -p 5000:5000')
                    sleep 5
                    sh 'curl --fail http://localhost:5000/'
                    app.stop()
                }
            }
        }
    }
}
