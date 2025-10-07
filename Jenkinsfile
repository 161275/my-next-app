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
                npm start &
                resp=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000)
                echo resp
                '''
            }
        }
        // stage('docker build'){
        //     sh '''
        //     docker build -t my-next-app .
        //     '''
        // }
    }
}