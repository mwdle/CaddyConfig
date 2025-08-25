@Library('JenkinsBitwardenUtils') _

// Define and apply job properties and parameters
properties([
    parameters([
        booleanParam(name: 'PULL_IMAGES', defaultValue: false, description: 'Pull latest images before deployment'),
        booleanParam(name: 'FORCE_DOWN', defaultValue: false, description: 'Force docker compose down before deployment'),
        booleanParam(name: 'UPDATE_PARAMETERS_NO_BUILD', defaultValue: false, description: 'Set this to true to update build parameters without executing deployment')
    ])
])

// First build registers parameters and exits
if (env.BUILD_NUMBER == '1') {
    echo """
    Jenkins is initializing this job and registering parameters.
    Please re-run the job if you want to start a real deployment.
    Skipping build...
    """
    currentBuild.result = 'NOT_BUILT'
    return
}

// If update parameters only mode is enabled, save parameters and exit
if (params.UPDATE_PARAMETERS_NO_BUILD) {
    echo "Update parameters mode enabled for this job. Deployment will not execute."
    echo "Successfully saved build parameters!"
    currentBuild.result = 'NOT_BUILT'
    return
}

def repoName = env.JOB_NAME.split('/')[1]

pipeline {
    agent {
        label 'docker' // See JCasC (jenkins.yaml)
    }
    
    options {
        skipDefaultCheckout(true)
        overrideIndexTriggers(false)
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                script {
                    withBitwardenEnv(itemName: repoName) {
                        echo "=== Building Docker Images ==="
                        sh 'docker compose build'
                    }
                }
            }
        }
        
        stage('Deploy') {
            steps {
                script {
                    withBitwardenEnv(itemName: repoName) {
                        echo "=== Deploying Services ==="
                        
                        if (params.FORCE_DOWN) {
                            echo "Force down requested"
                            sh 'docker compose down || true'
                        }
                        
                        if (params.PULL_IMAGES) {
                            echo "Pulling latest images"
                            sh 'docker compose pull --ignore-pull-failures'
                        }
                        
                        sh 'docker compose up -d'
                        
                        echo "Deployment status:"
                        sh 'docker compose ps'
                        
                        sleep 3
                        sh 'docker compose logs --tail=15'
                    }
                }
            }
        }
    }
    
    post {
        failure {
            script {
                sh '''
                    echo "Deployment failed. Showing logs:"
                    docker compose logs --tail=30 || true
                '''
            }
        }
        success {
            echo "Deployment completed successfully!"
        }
    }
}
