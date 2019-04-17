FROM ruby:2.6.2-alpine
RUN apk add build-base tzdata sqlite sqlite-dev && gem install tzinfo-data
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install --deployment --without development test
COPY . /app
ENV RAILS_ENV production
CMD bundle exec rails db:migrate && bundle exec rails s -p 3000 -b 0.0.0.0
