// Secure function to execute closure with Bitwarden secrets
def withBitwardenSecrets(Closure body) {
    withCredentials([
        usernamePassword(credentialsId: 'bitwarden-api-key', 
                       usernameVariable: 'BW_CLIENTID', 
                       passwordVariable: 'BW_CLIENTSECRET'),
        string(credentialsId: 'bitwarden-master-password', 
               variable: 'BITWARDEN_MASTER_PASSWORD')
    ]) {
        def repoName = env.JOB_NAME.tokenize('/').last()
        
        // Step 1: Configure and authenticate (separate from data retrieval)
        sh '''
            set +x  # Disable command echoing for security
            bw config server "$BITWARDEN_SERVER_URL"
            bw login --apikey
        '''
        
        // Step 2: Get session token cleanly
        def sessionToken = sh(
            script: '''
                set +x
                echo "$BITWARDEN_MASTER_PASSWORD" | bw unlock --raw
            ''',
            returnStdout: true
        ).trim()
        
        // Step 3: Retrieve the secret data with clean session (only this outputs to stdout)
        // Use single quotes and shell variable substitution to avoid Groovy interpolation
        def envVars = sh(
            script: '''
                set +x
                bw get item "''' + repoName + '''" --session "''' + sessionToken + '''" | jq -r '.notes'
            ''',
            returnStdout: true
        ).trim()
        
        // Step 4: Clean logout
        sh '''
            set +x
            bw logout
        '''
        
        // Parse environment variables in memory only
        def envList = []
        envVars.split('\n').each { line ->
            line = line.trim()
            if (line && line.contains('=') && !line.startsWith('#')) {
                envList.add(line)
            }
        }
        
        // Execute the closure with environment variables set
        withEnv(envList) {
            body()
        }
    }
}

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
                    withBitwardenSecrets {
                        sh '''
                            docker compose build
                        '''
                    }
                }
            }
        }
        
        stage('Deploy') {
            steps {
                script {
                    withBitwardenSecrets {
                        sh '''
                            # Optional: Force down
                            if [ "$FORCE_DOWN" = "true" ]; then
                                echo "Force down requested"
                                docker compose down || true
                            fi
                            
                            # Optional: Pull images
                            if [ "$PULL_IMAGES" = "true" ]; then
                                echo "Pulling latest images"
                                docker compose pull --ignore-pull-failures
                            fi
                            
                            # Deploy
                            docker compose up -d
                            
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
