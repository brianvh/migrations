require 'spec_helper'
require 'rspec'
require 'capybara/rspec'
require 'page_match/helpers'

RSpec.configure do |config|
  config.include(PageMatch::Helpers)
  config.include(PageHelpers)
  config.include(WebauthHelpers)
end
