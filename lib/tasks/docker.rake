# frozen_string_literal: true

IMAGE_NAME = 'turniere/backend'

namespace :docker do
  desc 'Build docker image'
  task :build, [:tag] do |_, args|
    args.with_defaults(tag: 'latest')
    sh "docker build -t #{IMAGE_NAME}:#{args.tag} ."
  end

  desc 'Tag docker image with Travis build number'
  task :tag do
    next if ENV['TRAVIS_PULL_REQUEST'] != 'false'

    tag = "build#{ENV['TRAVIS_BUILD_NUMBER']}"
    sh "docker tag #{IMAGE_NAME} #{IMAGE_NAME}:#{tag}"
  end

  desc 'Push docker image'
  task :push do
    sh "docker push #{IMAGE_NAME}"
  end

  desc 'Run TravisCI tasks'
  task travis: %i[build tag push] do
  end
end
