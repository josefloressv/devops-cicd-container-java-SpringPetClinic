pipeline{
    agent any
    tools {
        // configured in "Managing Jenkins" → "Global Tool Configuration"
        maven  'M382'
    }
    environment {
        CODE_REPO = 'https://github.com/josefloressv/devops-cicd-container-java-SpringPetClinic.git'
        ECR_REPO_NAME = 'app02-java'
    }
    parameters{
        string(
            name: "BRANCH",
            defaultValue: "main"
        )
    }
    stages{
        stage("Prepare") {
            steps{
                cleanWs()
                script {
                    if (env.BRANCH == null || env.BRANCH == "") {
                        error "BRANCH is required"
                    }
                    currentBuild.displayName = "#${BUILD_NUMBER} ${env.BRANCH}"
                }
            }
        }
        stage("Checkout"){
            steps{
                git branch:'main', url:env.CODE_REPO
            }
        }
        stage("Compile"){
            steps{
                sh 'mvn compile'
            }
        }
        stage("Unit Test"){
            steps{
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage("Package"){
            steps{
                sh 'mvn package'
            }
            post {
                success {
                    archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
                }
            }
        }
        stage("Build Docker image") {
            steps{
                script {
                    sh "docker build -t ${GLOBAL_AWS_ACCOUNT}.dkr.ecr.us-east-1.amazonaws.com/${env.ECR_REPO_NAME}:latest ."
                }
            }
        }
        stage("Docker Login") {
            steps{
                script {
                    sh 'docker login --username AWS --password \$(aws ecr get-login-password --region us-east-1) ${GLOBAL_AWS_ACCOUNT}.dkr.ecr.us-east-1.amazonaws.com'
                }
            }
        }
        stage("Push Docker image") {
            steps{
                script {
                    sh "docker push ${GLOBAL_AWS_ACCOUNT}.dkr.ecr.us-east-1.amazonaws.com/${env.ECR_REPO_NAME}:latest"
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