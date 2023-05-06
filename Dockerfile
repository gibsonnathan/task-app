FROM ruby:3.2.2
RUN apt-get update -qq && apt-get install -y nodejs
COPY . /app
WORKDIR /app
RUN bundle install

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]