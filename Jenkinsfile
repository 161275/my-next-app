pipeline {
    agent any
    stages {
        stage('build dev') {
            agent {
                docker {
                    image 'node:18-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                npm ci 
                npm run build
                '''
            }
        }
        stage('docker build'){
            steps {
                sh '''
                docker build -t my-next-app .
                '''
            }
            
        }
    }
}