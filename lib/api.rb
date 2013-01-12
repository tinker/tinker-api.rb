require 'sinatra/base'
require 'rack/cors'
require 'mongo'
require 'json'
require 'tinker'

begin
  DB = Mongo::Connection.new['tinker']
rescue Mongo::ConnectionFailure => e
  puts 'Failed to initialise connection to MongoDB'
end

module Tinker
  class Api < Sinatra::Base
    use Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :put, :options]
      end
    end

    before do
      content_type :json
    end

    post '/tinkers' do
      data = JSON.parse request.body.read
      if data['code'].class != Hash
        status 403
        {:error => 'No code found'}.to_json
      end

      tinker = Tinker.new data
      begin
        tinker.store
        tinker.to_json
      rescue Exception => e
        status 502
        {:error => 'Something went wrong while storing the tinker'}.to_json
      end
    end

    get %r{^/tinkers/([A-Za-z0-9]{5})(?:/([0-9]+))?$} do |hash, revision|
      begin
        tinker = Tinker.find hash, revision
        tinker.to_json
      rescue Exception => e
        status 404
        {:error => 'No tinker found with that hash and/or revision'}.to_json
      end
    end

    put %r{^/tinkers/([A-Za-z0-9]{5})?$} do |hash|
      data = JSON.parse request.body.read
      tinker = Tinker.new data
      if tinker.store
        tinker.to_json
      else
        status 502
        {:error => 'Something went wrong while storing the tinker'}.to_json
      end
    end
  end
end

