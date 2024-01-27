FROM httpd:2.4

RUN useradd -m worker
RUN chown -R worker:worker /usr/local/apache2

USER worker
