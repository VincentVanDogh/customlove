FROM python:3.12.0-slim-bookworm

RUN apt-get update -y
RUN apt-get install -y libpq-dev gcc

RUN useradd -m worker
USER worker
WORKDIR /home/worker

ENV PATH="/home/worker/.local/bin:${PATH}"

COPY --chown=worker:worker . .