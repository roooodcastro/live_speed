# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.0'

gem 'pg'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.2'

gem 'bcrypt', '~> 3.1'
gem 'foreman'
gem 'jbuilder', '~> 2.5'
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
end

group :development do
  gem 'awesome_print', require: 'ap'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop'
  gem 'web-console', '>= 3.3.0'
end
