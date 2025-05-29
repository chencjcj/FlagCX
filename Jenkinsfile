properties([
  parameters([
    booleanParam(name: 'RUN_E2E', defaultValue: false, description: '是否运行E2E测试')
  ])
])

pipeline {
  agent any

  stages {
    stage('Verify') {
      steps {
        echo '✅ Running on Jenkins agent'
        sh 'env | grep -i proxy || true'
      }
    }

    stage('Unit Tests') {
      steps {
        sh '''
          echo "Running  Unit test...."
        '''
      }
    }

    stage('E2E test') {
      when {
        expression { return params.RUN_E2E }
      }
      steps {
        sh '''
          echo "Running E2E tests..."
        '''
      }
    }

    stage('Complete') {
      steps {
        echo '🎉 Pipeline completed successfully!'
      }
    }
  }
}
