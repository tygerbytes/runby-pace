source 'https://rubygems.org'

group :test do
  gem 'coveralls', require: false
end

group :development, :test do
  gem 'guard'
  gem 'guard-rspec'
  gem 'rb-notifu'
  gem 'wdm', '>= 0.1.0' if Gem.win_platform?
end

# Specify your gem's dependencies in runby_pace.gemspec
gemspec
