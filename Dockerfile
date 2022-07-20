FROM arm32v7/alpine:3.14

MAINTAINER Anas Tlili <atlilirs@gmail.com>

ARG SONAR_VERSION=9.5.0.56709

ENV WRAPPER_VERSION=3.5.17 \
    ANT_VERSION=1.10.12 \
    ANT_HOME=/usr/share/ant \
    SONARQUBE_VERSION=${SONAR_VERSION} \
    SONARQUBE_HOME=/sonarqube-${SONAR_VERSION}

EXPOSE 9000

RUN addgroup -S sonarqube && adduser -S sonarqube -G sonarqube

RUN apk add --no-cach wget unzip alpine-sdk openjdk8

RUN wget --no-check-certificate https://download.tanukisoftware.com/wrapper/${WRAPPER_VERSION}/wrapper_prerelease_${WRAPPER_VERSION}.tar.gz \
        && wget http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz \
        && wget --no-check-certificate https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SONAR_VERSION}.zip \
        && tar -xvzf wrapper_prerelease_${WRAPPER_VERSION}.tar.gz \
        && tar -xvzf apache-ant-${ANT_VERSION}-bin.tar.gz \
        && unzip sonarqube-${SONAR_VERSION}.zip \
        && rm -f wrapper_prerelease_${WRAPPER_VERSION}.tar.gz \
        apache-ant-${ANT_VERSION}-bin.tar.gz \
        sonarqube-${SONAR_VERSION}.zip \
        && mv apache-ant-${ANT_VERSION} /usr/share/ant \
        && /wrapper_prerelease_${WRAPPER_VERSION}/build32.sh release \
        && tar -xvzf /wrapper_prerelease_${WRAPPER_VERSION}/dist/wrapper-linux-armhf-32-${WRAPPER_VERSION}.tar.gz \
        && cp -r /sonarqube-${SONAR_VERSION}/bin/linux-x86-64/ /sonarqube-${SONAR_VERSION}/bin/linux-pi \
        && cp -f /wrapper-linux-armhf-32-${WRAPPER_VERSION}/bin/wrapper /sonarqube-${SONAR_VERSION}/bin/linux-pi/wrapper \
        && cp -f /wrapper-linux-armhf-32-${WRAPPER_VERSION}/lib/libwrapper.so /sonarqube-${SONAR_VERSION}/bin/linux-pi/lib/libwrapper.so \
        && cp -f /wrapper-linux-armhf-32-${WRAPPER_VERSION}/lib/wrapper.jar /sonarqube-${SONAR_VERSION}/lib/wrapper-${WRAPPER_VERSION}.jar \
        && rm -rf /wrapper_prerelease_${WRAPPER_VERSION} /wrapper-linux-armhf-32-${WRAPPER_VERION} /usr/share/ant /var/lib/apt/lists/*


WORKDIR $SONARQUBE_HOME

RUN chown sonarqube:sonarqube -R $SONARQUBE_HOME

USER sonarqube

ENTRYPOINT ["./bin/sh"]