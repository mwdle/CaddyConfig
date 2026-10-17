@Library("JenkinsPipelines") _ // See https://github.com/mwdle/JenkinsPipelines

boolean disableIndexTriggers = env.BRANCH_NAME != 'main'

quadletPipeline(
    disableIndexTriggers: disableIndexTriggers,
    podmanSecretMappings: [
        [
            type: 'string',
            credentialsId: 'caddy_cloudflare_api_token'
        ],
        [
            type: 'string',
            credentialsId: 'caddy_email'
        ]
    ]
)
