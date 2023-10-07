FROM python:3.10-alpine

ADD . /web

WORKDIR /web

RUN pip install -r requirements.txt

RUN apk add git

CMD ["mike", "serve", "--dev-addr=0.0.0.0:8000"]

