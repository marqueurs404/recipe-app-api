FROM python:3.7-alpine
LABEL maintainer="Marcus Ong"

# make python run in unbuffered mode
ENV PYTHONUNBUFFERED 1

# copy requirements.txt from repo to image and install it
COPY ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

# create app folder, set working directory to it and copy repo files to image
RUN mkdir /app
WORKDIR /app
COPY ./app /app

# limit user access
RUN adduser -D user
USER user