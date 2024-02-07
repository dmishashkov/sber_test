FROM jenkins/jenkins:2.444



RUN jenkins-plugin-cli \
    --plugins \
    kubernetes \
    workflow-aggregator:596.v8c21c963d92d

USER jenkins