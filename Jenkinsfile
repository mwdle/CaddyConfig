// Define job properties and parameters
def jobProperties = [
    parameters([
        booleanParam(name: 'PULL_IMAGES', defaultValue: false, description: 'Pull latest images before deployment'),
        booleanParam(name: 'FORCE_DOWN', defaultValue: false, description: 'Force docker compose down before deployment'),
        booleanParam(name: 'UPDATE_PARAMETERS_NO_BUILD', defaultValue: false, description: 'Set this to true to update build parameters without executing deployment')
    ])
]

// First build registers parameters and exits
if (env.BUILD_NUMBER == '1') {
    echo """
    Jenkins is initializing this job and registering parameters.
    Please re-run the job if you want to start a real deployment.
    Skipping build...
    """
    properties(jobProperties)
    currentBuild.result = 'NOT_BUILT'
    return
}

// Skip builds triggered by branch indexing after the initial build
if (currentBuild.getBuildCauses().toString().contains('BranchIndexingCause')) {
    echo "Skipping build triggered by branch indexing after the first build"
    currentBuild.result = 'NOT_BUILT'
    return
}

// Apply job properties
properties(jobProperties)

// If update parameters only mode is enabled, save parameters and exit
if (params.UPDATE_PARAMETERS_NO_BUILD) {
    echo "Update parameters mode enabled for this job. Deployment will not execute."
    echo "Successfully saved build parameters!"
    currentBuild.result = 'NOT_BUILT'
    return
}

pipeline {
    agent {
        label 'docker'
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
        
        stage('Deploy') {
            steps {
                withCredentials([
                    usernamePassword(credentialsId: 'bitwarden-api-key', 
                                   usernameVariable: 'BW_CLIENTID', 
                                   passwordVariable: 'BW_CLIENTSECRET'),
                    string(credentialsId: 'bitwarden-master-password', 
                           variable: 'BITWARDEN_MASTER_PASSWORD')
                ]) {
                    script {
                        def repoName = env.JOB_NAME.tokenize('/').last()
                        
                        sh '''
                            set +x  # Disable command echoing for security
                            
                            # Configure and authenticate with Bitwarden
                            bw config server "$BITWARDEN_URL"
                            bw login --apikey
                            
                            # Get session and retrieve secrets in one secure operation
                            export BW_SESSION=$(echo "$BITWARDEN_MASTER_PASSWORD" | bw unlock --raw)
                            
                            # Get the secret data and parse it directly in shell
                            # Export each valid environment variable from the secure note
                            while IFS= read -r line; do
                                # Skip empty lines and comments
                                if [[ -n "$line" && "$line" == *"="* && "$line" != "#"* ]]; then
                                    # Export each environment variable
                                    export "$line"
                                fi
                            done < <(bw get item "''' + repoName + '''" --session "$BW_SESSION" | jq -r '.notes')
                            
                            # Clean logout
                            bw logout
                            
                            # Now run deployment with all environment variables set
                            # Optional: Force down
                            if [ "$FORCE_DOWN" = "true" ]; then
                                echo "Force down requested"
                                docker compose down || true
                            fi
                            
                            # Optional: Pull images
                            if [ "$PULL_IMAGES" = "true" ]; then
                                echo "Pulling latest images"
                                docker compose pull
                            fi
                            
                            # Deploy with build
                            docker compose up -d --build
                            
                            # Verify deployment
                            echo "Deployment status:"
                            docker compose ps
                            
                            # Show recent logs
                            sleep 3
                            docker compose logs --tail=10
                        '''
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
