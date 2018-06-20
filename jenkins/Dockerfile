FROM jenkins/jenkins:lts

USER root
RUN apt-get update \
      && apt-get install -y sudo curl\
      && apt-get install -y libltdl7\
      && rm -rf /var/lib/apt/lists/*\
      && curl -sL https://deb.nodesource.com/setup_8.x | bash \
      && apt install -y nodejs \
      && npm install -g yarn \
      && wget https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.2.0.1227-linux.zip \
      && unzip sonar-scanner-cli-3.2.0.1227-linux.zip \
      && rm -rf sonar-scanner-cli-3.2.0.1227-linux.zip \
      && export PATH=$PATH:/sonar-scanner-3.2.0.1227-linux/bin

# Install Git and dependencies
RUN dpkg --add-architecture i386 \
 && apt-get update \
 && apt-get install -y file git curl zip libncurses5:i386 libstdc++6:i386 zlib1g:i386 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists /var/cache/apt

# Set up environment variables
ENV ANDROID_HOME="/usr/share/android-sdk-linux" \
    SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip" \
    GRADLE_URL="https://services.gradle.org/distributions/gradle-4.5.1-all.zip"

# Download Android SDK
RUN mkdir "$ANDROID_HOME" .android \
 && cd "$ANDROID_HOME" \
 && curl -o sdk.zip $SDK_URL \
 && unzip sdk.zip \
 && rm sdk.zip \
 && yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses \
 && chmod 777 /usr/share/android-sdk-linux/tools/android \
 && chmod 777 /usr/share/android-sdk-linux/tools/bin/sdkmanager \
 && chmod 777 /usr/share/android-sdk-linux/tools/bin/avdmanager \
 && export ANDROID_HOME=/usr/share/android-sdk-linux \
 && export PATH=$PATH:/sonar-scanner-3.2.0.1227-linux/bin

# Install Gradle
RUN wget $GRADLE_URL -O gradle.zip \
 && unzip gradle.zip \
 && mv gradle-4.5.1 /usr/share/gradle \
 && rm gradle.zip \
 && mkdir /usr/share/.gradle

ENV PATH="/usr/share/gradle/bin:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:${PATH}"

RUN echo 'export SLAVE_AAPT_TIMEOUT=60' >> /root/.bashrc \
 && echo 'export ANDROID_HOME=/usr/share/android-sdk' >> /root/.bashrc \
 && find /sonar-scanner-3.2.0.1227-linux -type d -exec chmod 777 {} \; \
 && echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

USER jenkins

RUN export PATH=$PATH:/sonar-scanner-3.2.0.1227-linux/bin

COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/plugins.txt 

# Adding default Jenkins Seed Job
COPY jobs/job-dsl-seed-job.xml /usr/share/jenkins/ref/jobs/job-dsl-seed-job/config.xml

############################################
# Configure Jenkins
############################################
# Jenkins settings
COPY config/config.xml /usr/share/jenkins/ref/config.xml

# Jenkins Settings, i.e. Maven, Groovy, ...
COPY config/hudson.tasks.Maven.xml /usr/share/jenkins/ref/hudson.tasks.Maven.xml
COPY config/hudson.plugins.groovy.Groovy.xml /usr/share/jenkins/ref/hudson.plugins.groovy.Groovy.xml
COPY config/maven-global-settings-files.xml /usr/share/jenkins/ref/org.jenkinsci.plugins.configfiles.GlobalConfigFiles.xml

# SSH Keys & Credentials
COPY config/credentials.xml /usr/share/jenkins/ref/credentials.xml
COPY config/ssh-keys/cd-demo /usr/share/jenkins/ref/.ssh/id_rsa
COPY config/ssh-keys/cd-demo.pub /usr/share/jenkins/ref/.ssh/id_rsa.pub

# tell Jenkins that no banner prompt for pipeline plugins is needed
# see: https://github.com/jenkinsci/docker#preinstalling-plugins
RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
