FROM ubuntu:15.10

RUN apt-get update && apt-get -y install runit postgresql libpq-dev curl redis-server
RUN apt-get update && apt-get -y build-dep perl

RUN curl -sL https://deb.nodesource.com/setup_5.x | bash -
RUN apt-get install -y nodejs

RUN npm install -g coffee-script

WORKDIR /app
COPY . /app

CMD /app/run
