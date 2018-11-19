# turniere-backend [![Build Status](https://travis-ci.org/turniere/turniere-backend.svg?branch=master)](https://travis-ci.org/turniere/turniere-backend) [![Coverage Status](https://coveralls.io/repos/github/turniere/turniere-backend/badge.svg)](https://coveralls.io/github/turniere/turniere-backend)
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
