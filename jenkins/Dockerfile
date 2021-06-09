FROM jenkins/jenkins:lts-jdk11

ARG JENKINS_USERNAME=demouser
ARG JENKINS_PASSWORD=demo@pass123

ENV JENKINS_USERNAME $JENKINS_USERNAME
ENV JENKINS_PASSWORD $JENKINS_PASSWORD
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

RUN echo "Starting installation of Jenkins Plugins" \
    && /usr/local/bin/install-plugins.sh \
                              "git" \
                              "azure-commons" \
                              "azure-acs" \
                              "azure-app-service" \
                              "azure-cli" \
                              "azure-credentials" \
                              "azure-keyvault" \
                              "terraform" \
                              "workflow-aggregator" \
                              "pipeline-github" \
    && echo "Done"

COPY ./default-user.groovy /usr/share/jenkins/ref/init.groovy.d/
