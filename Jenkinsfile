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
          echo "RUN_E2E=${params.RUN_E2E}"
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

