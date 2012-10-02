require 'json'

module Tinker
  class Tinker
    def initialize data
      @data = {
        :meta => {}
      }

      # meta data
      if data['meta'].class == Hash
        meta = data['meta']
        if meta['hash'].class == String && meta['hash'] != ''
          @data[:meta][:hash] = meta['hash']
        end
        if meta['revision'].class == Fixnum && meta['revision'] >= 0
          @data[:meta][:revision] = meta['revision']
        end
        if meta['title'].class == String && meta['title'] != ''
          @data[:meta][:title] = meta['title']
        end
        if meta['description'].class == String && meta['description'] != ''
          @data[:meta][:description] = meta['description']
        end
      end

      # dependencies
      if data['dependencies'].is_a? Array
        deps = []
        data['dependencies'].each do |dep|
          if dep.is_a? String
            deps << dep
          end
        end
        if deps.length > 0
          @data[:dependencies] = deps
        end
      end

      # code
      @data[:code] = {}
      code = data['code']
      [:markup, :style, :behaviour].each do |t|
        next if code[t.to_s].class != Hash
        type = code[t.to_s]
        @data[:code][t] = {}
        if type['type'].class == String && type['type'] != ''
          @data[:code][t][:type] = type['type']
        end
        if type['body'].class == String && type['body'] != ''
          @data[:code][t][:body] = type['body']
        end
      end
    end

    def [] key
      @data[key] || nil
    end

    def generate_hash
      5.times.map { BASE62.sample }.join
    end

    def store
      if @data[:meta][:hash].nil?
        @data[:meta][:hash] = generate_hash
        @data[:meta][:revision] = 0
      else
        @data[:meta][:revision] += 1
      end

      DB['tinker'].insert(@data)
      @data.delete :_id
    end

    def to_json
      @data.to_json
    end
  end
end

