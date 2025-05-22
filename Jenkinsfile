pipeline {
    agent any

    parameters {
        string(name: 'ghprbCommentBody', defaultValue: '', description: 'GitHub PR 评论内容')
    }

    stages {
        stage('Init') {
            steps {
                echo "📥 Received PR comment: ${params.ghprbCommentBody}"
            }
        }

        stage('Run Baseline E2E Tests') {
            when {
                expression {
                    return params.ghprbCommentBody.contains('🚀') || params.ghprbCommentBody.contains(':rocket:')
                }
            }
            steps {
                echo '🚀 Trigger condition met. Running e2e tests...'
            }
        }

        stage('Skip E2E') {
            when {
                expression {
                    return !(params.ghprbCommentBody.contains('🚀') || params.ghprbCommentBody.contains(':rocket:'))
                }
            }
            steps {
                echo '❌ No rocket emoji detected. Skipping e2e.'
            }
        }
    }

    post {
        always {
            echo '🎯 Pipeline finished.'
        }
    }
}

