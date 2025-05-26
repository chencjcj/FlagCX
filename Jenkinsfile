pipeline {
  agent {
    kubernetes {
      label 'vci-agent'
      defaultContainer 'jnlp'
      yaml """
apiVersion: v1
kind: Pod
spec:
  nodeSelector:
    jenkins-agent: "true"
  tolerations:
  - key: "vci.vke.volcengine.com/node-type"
    operator: "Equal"
    value: "vci"
    effect: "NoSchedule"
  containers:
  - name: jnlp
    image: jenkins/inbound-agent:latest
    args:
    - \$(JENKINS_SECRET)
    - \$(JENKINS_NAME)
"""
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
  stages {
    stage('Verify') {
      steps {
        echo '✅ Running on vci-node1-cn-shanghai-a'
        sh 'hostname'
      }
    }
  }
}
