# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara'
require "active_attr/rspec"

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
  
  [AuthenticationMacros, PostMacros, DelayedJobMacros].each do |macro|
    config.include(macro)
  end
  
  unless File.directory?([Rails.root, "spec/data/blog"].join("/"))
    octopress_test_dir = [Rails.root, "spec/data"].join("/")
    git_path = "/usr/local/git/bin/git"
    octopress_install = "blog"
    puts "Cloning repo"
    system "cd #{octopress_test_dir};#{git_path} clone git://github.com/imathis/octopress.git #{octopress_install}"
    puts "scaffolding octopress install"
    system "cd #{octopress_test_dir}/#{octopress_install}; rake install"
  end

end
