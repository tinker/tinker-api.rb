require 'sinatra/base'
require 'rack/cors'
require 'mongo'
require 'json'
require 'tinker'

BASE62 = (('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a)
DB = Mongo::Connection.new['tinker']

module Tinker
  class Api < Sinatra::Base
    use Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :put, :options]
      end
    end

    post '/tinkers' do
      data = JSON.parse request.body.read
      if data['code'].class != Hash
        status 403
        {:error => 'No code found'}.to_json
      end

      tinker = Tinker.new data
      if tinker.store
        tinker.to_json
      else
        status 502
        {:error => 'Something went wrong while storing the tinker'}.to_json
      end
    end

    get %r{^/tinkers/([A-Za-z0-9]{5})(?:/([0-9]+))?$} do |hash, revision|
      revision ||= 0
      tinker = DB['tinker'].find_one({
        'meta.hash' => hash,
        'meta.revision' => revision.to_i
      })
      if tinker
        tinker.delete '_id'
        tinker.to_json
      else
        status 404
        {:error => "No tinker found with that hash and/or revision"}.to_json
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

