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
       feat/test
                echo '🚀 Trigger condition met. Running e2e tests...'

                echo 'Hello Jenkins...'
            }
        }
        stage('Check PR Comment') {
            steps {
                script {
                    def comment = env.CHANGE_COMMENT ?: ''
                    echo "PR comment: ${comment}"

                    if (!comment.contains("🚀") && !comment.contains(":rocket:")) {
                        echo "No rocket emoji found in comment, skipping e2e tests."
                        currentBuild.result = 'SUCCESS'
                        return
                    }
                }
            }
        }
        stage('Run Baseline E2E Tests') {
            steps {
                echo 'Running baseline e2e training...'
        main
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

