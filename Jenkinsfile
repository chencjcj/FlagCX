pipeline {
    agent any
    parameters {
        string(name: 'ghprbCommentBody', defaultValue: '', description: 'PR 评论内容')
    }
    stages {
        stage('Build') {
            when {
                expression { 
                    return params.ghprbCommentBody =~ /(🚀|:rocket:)/
                }
            }
            steps {
                echo "Triggered by PR comment: ${params.ghprbCommentBody}"
                echo "Hello Jenkins"
            }
        }
    }
}

