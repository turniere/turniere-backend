# Build development container locally first with following tag
ARG base_commit
FROM registry.gitlab.com/turniere/turniere-backend/development/commits:$base_commit
WORKDIR /app
RUN bundle config set with 'test' && bundle install
ENV RAILS_ENV test
CMD bundle exec rails db:migrate && bundle exec rails spec
