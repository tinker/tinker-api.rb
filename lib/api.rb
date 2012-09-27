require 'sinatra/base'
require 'rack/cors'
require 'mongo'
require 'json'

BASE62 = (('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a)
DB = Mongo::Connection.new['tinker']

module Tinker
  class Api < Sinatra::Base
    use Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end

    post '/tinkers' do
      data = JSON.parse request.body.read
      hash = 5.times.map { BASE62.sample }.join
      tinker = {}
      tinker[:meta] = {
        :hash => hash,
        :revision => 0
      }
      if data['dependencies'].is_a? Array
        deps = []
        data['dependencies'].each do |dep|
          if dep.is_a? String
            deps << dep
          end
        end
        if deps.length > 0
          tinker[:dependencies] = deps
        end
      end
      tinker[:code] = {
        :markup => {
          :type => :html,
          :body => data['code']['markup']['body'] || ''
        },
        :style => {
          :type => :css,
          :body => data['code']['style']['body'] || ''
        },
        :behaviour => {
          :type => :js,
          :body => data['code']['behaviour']['body'] || ''
        }
      }
      DB['tinker'].insert(tinker)
      tinker.to_json
    end

    get %r{^/tinkers/([A-Za-z0-9]{5})(?:/([0-9]+))?$} do |hash, revision|
      revision ||= 0
      tinker = DB['tinker'].find_one({
        'meta.hash' => hash,
        'meta.revision' => revision.to_i
      })
      if tinker
        tinker.to_json
      else
        status 404
        {:error => "No tinker found with that hash and/or revision"}.to_json
      end
    end
  end
end

