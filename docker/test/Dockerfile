# Build development container locally first with following tag
FROM registry.gitlab.com/turniere/turniere-backend/development
WORKDIR /app
RUN bundle install --deployment --with test
ENV RAILS_ENV test
CMD bundle exec rails db:migrate && bundle exec rails spec