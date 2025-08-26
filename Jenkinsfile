@Library('JenkinsBitwardenUtils') _

// Define and apply job properties and parameters
properties([
    parameters([
        booleanParam(name: 'PULL_IMAGES', defaultValue: false, description: 'Pull latest images before deployment'),
        booleanParam(name: 'FORCE_DOWN', defaultValue: false, description: 'Force docker compose down before deployment'),
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

def repoName = env.JOB_NAME.split('/')[1]

node('docker') {   
    stage('Checkout') {
        checkout scm
    }

    withBitwardenEnv(itemName: repoName) {
        stage('Build') {
            echo "=== Building Docker Images ==="
            sh 'docker compose build'
        }

        stage('Deploy') {
            echo "=== Deploying Services ==="
            if (params.FORCE_DOWN) {
                echo "Force down requested: Executing `docker compose down` before redeploy"
                sh 'docker compose down || true'
            }
            if (params.PULL_IMAGES) {
                echo "Pulling latest images"
                sh 'docker compose pull'
            }
            sh 'docker compose up -d'
            
            echo "Deployment status:"
            sh 'docker compose ps'
            sleep 3
            sh 'docker compose logs --tail=15'
        }
    }
}
