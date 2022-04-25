pipeline {
    agent any
    tools {
        maven  'M382' // configured in "Managing Jenkins" → "Global Tool Configuration"
    }
    stages {
        stage("Checkout"){
            steps{
                git branch:'main', url:'https://github.com/josefloressv/devops-cicd-container-java-SpringPetClinic.git'
            }
        }
        stage("Compile"){
            steps{
                sh 'mvn compile'
            }
        }
        stage("Test"){
            steps{
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage("Pakcage"){
            steps{
                sh 'mvn package'
            }
            post {
                success {
                    archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
                }
            }
        }
    }
    post{
        always{
            echo "========always========"
        }
        success{
            echo "========pipeline executed successfully ========"
        }
        failure{
            echo "========pipeline execution failed========"
        }
    }
}