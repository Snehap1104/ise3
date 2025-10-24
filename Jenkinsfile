// Declarative Pipeline for CI/CD of a Java/Docker application
pipeline {
    // Define the agent where the pipeline stages will run.
    agent any

    // Define environment variables
    environment {
        // !!! UPDATED PLACEHOLDERS BELOW !!!
        // 1. Replace this with your Docker Hub username
        DOCKER_HUB_USER = 'sneha2311' // <-- UPDATED to your username
        // 2. Define the image name 
        IMAGE_NAME = 'ise3'  // <-- UPDATED to your image name
        
        // Configuration Variables (usually left as is)
        IMAGE_TAG = "${DOCKER_HUB_USER}/${IMAGE_NAME}:${env.BUILD_NUMBER}"
        DOCKER_CRED_ID = 'dockerhub_c' // Jenkins Credential ID for Docker Hub <-- UPDATED
        
        // Container Name (re-added as requested)
        CONTAINER_NAME = 'ise3' // <-- UPDATED to ise3
    }

    stages {
        stage('Build Java Application') {
            steps {
                // Use a temporary Docker container for Maven build to keep the agent clean
                script {
                    // CHANGED: Switched to the highly stable and modern 'maven:3-openjdk-21' tag.
                    // This often resolves unexpected image pulling issues on Windows agents.
                    docker.image('maven:3-openjdk-21').inside {
                        bat 'echo "Building Java application with Maven..."'
                        // Package the app, skipping tests
                        bat 'mvn clean package -DskipTests'
                    }
                }
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                // Securely load and use Docker Hub credentials
                withCredentials([usernamePassword(credentialsId: DOCKER_CRED_ID, passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    bat 'echo "Logging into Docker Hub..."'
                    // NOTE: bat is used here as well for compatibility
                    bat "echo %DOCKER_PASSWORD% | docker login -u %DOCKER_USERNAME% --password-stdin"

                    bat 'echo "Building Docker Image: %IMAGE_TAG%"'
                    // Build the Docker image using the Dockerfile and tag it
                    bat "docker build -t %IMAGE_TAG% ."

                    bat 'echo "Pushing Docker Image to Docker Hub..."'
                    bat "docker push %IMAGE_TAG%"
                }
            }
        }

        stage('Cleanup') {
            steps {
                bat 'echo "Removing local Docker image to save space..."'
                // Optional: remove the locally built image
                bat "docker rmi %IMAGE_TAG% || true"
            }
        }
    }

    post {
        always {
            echo 'Pipeline job finished.'
        }
    }
}
