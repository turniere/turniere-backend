FROM ruby:2.6.2-alpine
RUN apk add --no-cache build-base tzdata sqlite sqlite-dev postgresql-dev && gem install tzinfo-data
WORKDIR /app
COPY Gemfile* /app/
RUN bundle install --deployment --without development test
COPY . /app
ENV RAILS_ENV production
CMD bundle exec rails db:migrate && bundle exec rails s -p 3000 -b 0.0.0.0
