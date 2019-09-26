# Build production container locally first with following tag
FROM turniere-backend/production:local
WORKDIR /app
RUN bundle install --deployment --with development
ENV RAILS_ENV development
CMD bundle exec rails db:migrate && bundle exec rails s -p 3000 -b 0.0.0.0