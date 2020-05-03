FROM ruby:2.5.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN mkdir /app
WORKDIR /app

COPY . /app/
RUN gem install bundler && bundle install

EXPOSE 3000
CMD rm -f tmp/pids/server.pid && rails server


