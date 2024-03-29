# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

gem 'pg'
gem 'puma', '~> 4.3'
gem 'rails', '~> 6.0.0'

gem 'bcrypt', '~> 3.1'
gem 'faker'
gem 'foreman'
gem 'hiredis'
gem 'i18n-js'
gem 'jbuilder', '~> 2.5'
gem 'js-routes'
gem 'rainbow'
gem 'redis', '~> 4.0'
gem 'responders'
gem 'sass-rails', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'webpacker'

gem 'bootsnap', '>= 1.1', require: false

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry'
  gem 'rails_real_favicon'
end

group :development do
  gem 'awesome_print', require: 'ap'
  gem 'brakeman', require: false
  gem 'bundle-audit', require: false
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'overcommit', require: false
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'web-console', '>= 3.3.0'
end
