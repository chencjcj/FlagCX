pipeline {
  agent {
    kubernetes {
      label 'vci-cuda-agent'
      defaultContainer 'cuda'
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
  - name: cuda
    image: nvcr.io/nvidia/cuda:12.4.1-devel-ubuntu22.04
    resources:
      limits:
        nvidia.com/gpu: "1"
      requests:
        cpu: "8"
        memory: "10Gi"
    securityContext:
      capabilities:
        add:
          - IPC_LOCK
          - SYS_RESOURCE
    command:
    - cat
    tty: true
"""
    }
  }
  stages {
    stage('Run Unit Tests and Generate Coverage') {
      steps {
        container('cuda') {
          sh 'chmod +x ./test/script/auto_script.sh && ./test/script/auto_script.sh'
        }
      }
      post {
        always {
          cobertura coberturaReportFile: 'coverage.xml'
        }
      }
    }
    stage('Check Coverage Threshold') {
      steps {
        script {
          def coverage = currentBuild.rawBuild.getAction(hudson.plugins.cobertura.CoberturaBuildAction)
            ?.getCoverage(hudson.plugins.cobertura.targets.CoverageMetric.LINE)
            ?.getPercentage() ?: 0
          echo "Code coverage: ${coverage}%"
          if (coverage < 90) {
            error "Code coverage below 90%, fail the build."
          }
        }
      }
    }
  }
}

