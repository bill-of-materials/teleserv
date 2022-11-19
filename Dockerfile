FROM python:alpine

ARG APP_NAME="teleserv"
ARG APP_DESCRIPTION="A lightweight teleserv container for Minitel services"
ARG APP_VCS_REF
ARG APP_VCS_URL="https://github.com/bill-of-materials/teleserv.git"
ARG APP_VERSION
ARG BUILD_DATE
ARG BUILD_VCS_REF
ARG BUILD_VCS_URL="https://github.com/bill-of-materials/teleserv.git"

WORKDIR /app
EXPOSE 3615

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.description=$APP_DESCRIPTION \
      org.label-schema.name=$APP_NAME \
      org.label-schema.schema-version="1.0" \
      org.label-schema.url=$BUILD_REPO \
      org.label-schema.vcs-ref=$APP_VCS_REF \
      org.label-schema.vcs-url=$APP_VCS_URL \
      org.label-schema.version=$APP_VERSION

COPY . /app

RUN set -x \
      && addgroup teleserv \
      && adduser -G teleserv -g "teleserv" -s /bin/ash -D teleserv \
      && /usr/bin/env python3 -m pip install -r requirements.txt

USER teleserv

ENV TELESERV_CONFIG=/app/config.yml
ENV TELESERV_VDT_ROOT=/app/vdt

CMD ["/app/teleserv.py"]
