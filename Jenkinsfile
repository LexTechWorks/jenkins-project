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
                    def containerId = app.id
                    def containerIp = sh(script: "docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${containerId}", returnStdout: true).trim()
                    sh "curl --fail http://${containerIp}:5000/"
                    app.stop()
                }
            }
        }
    }
}
