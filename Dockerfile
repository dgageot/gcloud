# Build:
#   docker build -t dgageot/gloud .
#
# Run:
#   docker run -ti --name gcloud-config dgageot/gcloud auth login
#   docker run --rm -ti --volumes-from gcloud-config dgageot/gcloud config set project code-story-blog
#   docker run --rm -ti --volumes-from gcloud-config dgageot/gcloud compute instances list

# DOCKER_VERSION 1.2

FROM debian:wheezy
MAINTAINER David Gageot <david@gageot.net>
ENV DEBIAN_FRONTEND noninteractive

# Install pre-requisites
#
RUN sed -i '1i deb     http://gce_debian_mirror.storage.googleapis.com/ wheezy         main' /etc/apt/sources.list
RUN apt-get update && apt-get install -y \

  openjdk-7-jre-headless \
  openssh-client \
  php5-cgi \
  php5-cli \
  php5-mysql \
  python \
  unzip \
  wget \
  && apt-get clean

# Install gcloud
#
RUN wget https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.zip \
    && unzip google-cloud-sdk.zip \
    && rm google-cloud-sdk.zip
RUN google-cloud-sdk/install.sh --usage-reporting=true --path-update=true --bash-completion=true --rc-path=/.bashrc --disable-installation-options
RUN yes | google-cloud-sdk/bin/gcloud components update pkg-go pkg-python pkg-java

ENV PATH /google-cloud-sdk/bin:$PATH

VOLUME ["/root/.config"]

ENTRYPOINT ["/google-cloud-sdk/bin/gcloud"]
