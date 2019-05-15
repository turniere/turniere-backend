[![Codacy Badge](https://api.codacy.com/project/badge/Grade/c273578244de4830b30f9f61ba35247a)](https://app.codacy.com/app/Malaber/turniere-backend?utm_source=github.com&utm_medium=referral&utm_content=turniere/turniere-backend&utm_campaign=Badge_Grade_Dashboard)
# turniere-backend [![Build Status](https://travis-ci.org/turniere/turniere-backend.svg?branch=master)](https://travis-ci.org/turniere/turniere-backend) [![pipeline status](https://gitlab.com/turniere/turniere-backend/badges/master/pipeline.svg)](https://gitlab.com/turniere/turniere-backend/commits/master) [![Coverage Status](https://coveralls.io/repos/gitlab/turniere/turniere-backend/badge.svg?branch=master)](https://coveralls.io/gitlab/turniere/turniere-backend?branch=master) [![](https://img.shields.io/badge/Protected_by-Hound-a873d1.svg)](https://houndci.com)
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
