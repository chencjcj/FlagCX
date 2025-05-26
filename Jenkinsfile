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
