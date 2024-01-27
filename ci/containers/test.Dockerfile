FROM registry.reset.inso-w.at/pub/docker/node-non-root-18:latest
COPY ci/containers/frontend.Dockerfile /demo_file.txt
RUN ls -la /