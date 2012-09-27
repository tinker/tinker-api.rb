$:.unshift File.expand_path('.') + '/lib'
require 'bundler/setup'
require 'api'
run Tinker::Api

