FROM debian:bookworm

RUN apt-get -y update
RUN apt-get -y install git
RUN apt-get clean

RUN useradd -m worker
ENV PATH=$PATH:/opt/flutter/bin
WORKDIR /opt
USER worker

COPY --chown=worker flutter /opt/flutter
#RUN chown -R worker:worker /opt/