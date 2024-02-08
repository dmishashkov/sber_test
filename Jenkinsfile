podTemplate(yaml: '''
        apiVersion: v1
        kind: Pod
        metadata:
          labels:
            hello: there
        spec:
          serviceAccountName: creator
          containers:
          - name: helm
            image: alpine/helm:3.6.0
            command:
            - cat
            tty: true
''') {
  node(POD_LABEL) {
    stage('Temp') {
      git url: 'https://github.com/dmishashkov/sber_test.git', branch: 'main'
      container('helm') {
        stage('Install My Chart') {
          sh 'helm install my-nginx ./nginx-chart'
        }
      }
    }

  }
}