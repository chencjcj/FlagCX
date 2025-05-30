properties([
  parameters([
    booleanParam(name: 'RUN_E2E', defaultValue: false, description: '是否运行E2E测试')
  ])
])

pipeline {
  agent none

  stages {
    stage('Pre-commit Check') {
      agent {
        kubernetes {
          cloud 'bp-k8s-cluster'
          label 'unit-test-agent'
          defaultContainer 'main'
          yaml """
apiVersion: v1
kind: Pod
metadata:
  namespace: jenkins
spec:
  hostNetwork: false
  priorityClassName: higher-priority-job
  volumes:
    - name: dshm
      emptyDir:
        medium: Memory
        sizeLimit: "50G"
  containers:
    - name: jnlp
      image: harbor.local.clusters/bp/jenkins/inbound-agent:latest
      imagePullPolicy: IfNotPresent
      args:
        - -webSocket
        - \$(JENKINS_SECRET)
        - \$(JENKINS_NAME)
      env:
        - name: http_proxy
          value: http://10.1.2.1:7890
        - name: https_proxy
          value: http://10.1.2.1:7890
        - name: no_proxy
          value: localhost,127.0.0.1,jenkins,jenkins.jenkins.svc

    - name: main
      image: harbor.local.clusters/bp/megatron-mla:25.02_cuda128_vllm084_20250527_ci_v3
      imagePullPolicy: IfNotPresent
      command: ["sleep", "inf"]
      env:
        - name: http_proxy
          value: http://10.1.2.1:7890
        - name: https_proxy
          value: http://10.1.2.1:7890
        - name: no_proxy
          value: localhost,127.0.0.1,jenkins,jenkins.jenkins.svc
      volumeMounts:
        - name: dshm
          mountPath: /dev/shm
      resources:
        limits:
          nvidia.com/gpu: '1'
      securityContext:
        capabilities:
          add: [IPC_LOCK, SYS_RESOURCE]
"""
        }
      }
      steps {
        container('main') {
          sh '''
             echo "skip................."
          '''
        }
      }
    }

    stage('Run Unit Tests and Generate Coverage') {
      agent { label 'unit-test-agent' }
      steps {
        container('main') {
          sh '''
             chmod +x ./test/script/chen.sh
             ./test/script/chen.sh
          '''
        }
      }
    }
    
    stage('E2E test') {
      when {
        expression { return params.RUN_E2E }
      }
      agent {
        kubernetes {
          cloud 'bp-k8s-cluster'
          label 'e2e-agent'
          defaultContainer 'main'
          yaml """
apiVersion: v1
kind: Pod
metadata:
  namespace: jenkins
spec:
  hostNetwork: false
  priorityClassName: higher-priority-job
  volumes:
    - name: dshm
      emptyDir:
        medium: Memory
        sizeLimit: "50G"
  containers:
    - name: jnlp
      image: harbor.local.clusters/bp/jenkins/inbound-agent:latest
      imagePullPolicy: IfNotPresent
      args:
        - -webSocket
        - \$(JENKINS_SECRET)
        - \$(JENKINS_NAME)
      env:
        - name: http_proxy
          value: http://10.1.2.1:7890
        - name: https_proxy
          value: http://10.1.2.1:7890
        - name: no_proxy
          value: localhost,127.0.0.1,jenkins,jenkins.jenkins.svc

    - name: main
      image: harbor.local.clusters/bp/your-e2e-image:latest
      imagePullPolicy: IfNotPresent
      command: ["sleep", "inf"]
      env:
        - name: http_proxy
          value: http://10.1.2.1:7890
        - name: https_proxy
          value: http://10.1.2.1:7890
        - name: no_proxy
          value: localhost,127.0.0.1,jenkins,jenkins.jenkins.svc
      volumeMounts:
        - name: dshm
          mountPath: /dev/shm
      resources:
        limits:
          nvidia.com/gpu: '1'
      securityContext:
        capabilities:
          add: [IPC_LOCK, SYS_RESOURCE]
"""
        }
      }
      steps {
        container('main') {
          sh '''
            echo "Running E2E tests...#####################################"    
          '''
        }
      }
    }

    stage('Complete') {
      steps {
        echo '🎉 Pipeline completed successfully!'
      }
    }
  }
}
