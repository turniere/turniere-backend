# Build production container locally first with following tag
ARG base_commit
FROM registry.gitlab.com/turniere/turniere-backend/production/commits:$base_commit
WORKDIR /app
RUN bundle config set with 'development' && bundle install
ENV RAILS_ENV development
CMD bundle exec rails db:migrate && bundle exec rails s -p 3000 -b 0.0.0.0
