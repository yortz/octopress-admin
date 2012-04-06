source 'https://rubygems.org'

gem 'rails', '3.2.2'
gem 'active_attr'
gem 'mysql2'
gem 'jquery-rails'
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'capistrano'
gem 'stringex'
gem 'nokogiri'
gem 'delayed_job_active_record'
gem 'will_paginate', '~> 3.0'
gem 'will_paginate-bootstrap'
gem "delayed_job_admin", :git => "git://github.com/dje29/delayed_job_admin.git"

group :octopress do
  gem 'rake'
  gem 'rack'
  gem 'jekyll', :git => "git@github.com:yortz/jekyll.git", :branch => "edge"
  gem 'rdiscount'
  gem 'pygments.rb'
  gem 'RedCloth'
  gem 'haml', '>= 3.1'
  gem 'compass', '>= 0.11'
  gem 'rubypants'
  gem 'rb-fsevent'
  gem 'stringex'
  gem 'liquid', '2.2.2'
  gem 'mini_magick'
end

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
  gem 'bootstrap-sass', '2.0.1' #momentarily sticking with 2.0.1 due to icon display issue
end

gem "rspec-rails", "~> 2.6", :group => [:test, :development]

group :test do
  gem 'capybara'
  gem "factory_girl_rails"
  gem 'launchy'
end
