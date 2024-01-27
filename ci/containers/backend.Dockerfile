FROM ghcr.io/brotholomew/python-non-root:3.12.0-bookworm
ARG ROOT_PATH

COPY requirements.txt /var/requirements.txt
COPY backend /var/backend

RUN pip install --user -r /var/requirements.txt
ENV SWIPE_LIMIT 20
ENV ROOT_PATH ${ROOT_PATH}

WORKDIR /var
CMD PYTHONPATH=$PYTHONPATH:$PWD python3 backend/main.py --host 0.0.0.0 --port 80 --root-path ${ROOT_PATH}  --proxy-headers