# turniere-backend [![pipeline status](https://gitlab.com/turniere/turniere-backend/badges/master/pipeline.svg)](https://gitlab.com/turniere/turniere-backend/commits/master) [![Coverage Status](https://coveralls.io/repos/gitlab/turniere/turniere-backend/badge.svg?branch=ticket%2FTURNIERE-155)](https://coveralls.io/gitlab/turniere/turniere-backend?branch=ticket%2FTURNIERE-155)
Ruby on Rails application serving as backend for turnie.re

# Installation
```
# install dependencies
$ bundle install
# run migrations
$ rails db:migrate
```

# Running
Development (without mail confirmation and separate database):
```
$ RAILS_ENV=development rails server
```

# Generate diagrams
```
rails diagram:all_with_engines
```
