FROM python:3.8-alpine3.11

COPY . /

RUN    apk --no-cache add --virtual=.build-dep build-base libffi-dev \
    && apk --no-cache add zeromq-dev \
    && python3 -m pip install --no-cache-dir -r requirements.txt \
    && apk del .build-dep \
    && chmod +x /entrypoint.sh \
    && mkdir /locust
WORKDIR /locust
EXPOSE 8089 5557 5558

ENTRYPOINT ["/entrypoint.sh"]