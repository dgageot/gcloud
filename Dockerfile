# Build:
#   docker build -t dgageot/gloud .
#
# Run:
#   docker run -ti --name gcloud-config dgageot/gcloud auth login
#
#		alias gcloud='docker run --rm -ti --volumes-from gcloud-config -v `pwd`:/files dgageot/gcloud'
#   gcloud config set project code-story-blog
#   gcloud compute instances list
#
# Container Engine (Create cluster):
#   gcloud preview container clusters create jug --num-nodes 5 --zone europe-west1-c
#
# Container Engine (Deploy image):
#   gcloud preview container replicationcontrollers --cluster-name jug create --config-file=/files/web-controller.json --zone europe-west1-c
#   gcloud preview container pods --cluster-name jug list --zone europe-west1-c
#
# Container Engine (Expose to the world):
#   gcloud preview container services --cluster-name jug create --config-file=/files/web-service.json --zone europe-west1-c
#
# Container Engine (Delete):
#   gcloud preview container services --cluster-name jug delete web --zone europe-west1-c
#   gcloud preview container clusters delete jug --zone europe-west1-c

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

VOLUME ["/root/.config"]
ENV PATH /google-cloud-sdk/bin:$PATH

RUN yes | gcloud components update
RUN yes | gcloud components update preview
VOLUME ["/files"]

ENTRYPOINT ["/google-cloud-sdk/bin/gcloud"]
