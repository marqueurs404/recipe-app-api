FROM python:3.7-alpine
LABEL maintainer="Marcus Ong"

# make python run in unbuffered mode
ENV PYTHONUNBUFFERED 1

# copy requirements.txt from repo to image and install it
COPY ./requirements.txt /requirements.txt

# postgresql requirements:
#   postgresql-client, gcc, libc-dev, linux-headers, postgresql-dev
# Pillow requirements:
#   jpeg-dev, musl-dev, zlib, zlib-dev
RUN apk add --update --no-cache postgresql-client jpeg-dev \
  && apk add --update --no-cache --virtual .tmp-build-deps \
        gcc libc-dev linux-headers postgresql-dev \
        musl-dev zlib zlib-dev \
  && pip install -r /requirements.txt \
  && apk del .tmp-build-deps

# create app folder, set working directory to it and copy repo files to image
RUN mkdir /app
WORKDIR /app
COPY ./app /app

# store files that may need to be shared with other containers in subdir /vol
# e.g. if you have nginx to serve this folder.
# set permissions - owner can do everything while the rest can only read/execute
RUN mkdir -p /vol/web/media \
  && mkdir -p /vol/web/static \
  && adduser -D user \
  && chown -R user:user /vol/ \
  && chmod -R 755 /vol/web

# set cmd user to newly created user
USER user
