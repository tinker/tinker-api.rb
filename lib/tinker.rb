require 'json'

BASE62 = (('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a)

module Tinker
  class Tinker

    # Public: Find a tinker by hash and revision
    #
    # hash - A String
    # revision - A Fixnum
    #
    # Returns an instance of the Tinker class
    def self.find hash, revision
      if !defined? DB
        raise 'No connection to MongoDB available'
      end

      revision ||= 0

      begin
        data = DB['tinker'].find_one({
          'meta.hash' => hash,
          'meta.revision' => revision.to_i
        })
        new data
      rescue Exception => e
        raise 'Something appears to have died'
      end
    end

    # Public: Create a new tinker from passed data
    #
    # data - A hash containing the tinker's data
    #
    # Returns an instance of a Tinker
    def initialize data
      @data = {
        :meta => {}
      }

      # meta data
      if data['meta'].is_a? Hash
        meta = data['meta']
        if meta['hash'].is_a?(String) && meta['hash'] != ''
          @data[:meta][:hash] = meta['hash']
        end
        if meta['revision'].is_a?(Fixnum) && meta['revision'] >= 0
          @data[:meta][:revision] = meta['revision']
        end
        if meta['title'].is_a?(String) && meta['title'] != ''
          @data[:meta][:title] = meta['title']
        end
        if meta['description'].is_a?(String) && meta['description'] != ''
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
        next if !code[t.to_s].is_a? Hash
        type = code[t.to_s]
        @data[:code][t] = {}
        if type['type'].is_a?(String) && type['type'] != ''
          @data[:code][t][:type] = type['type']
        end
        if type['body'].is_a?(String) && type['body'] != ''
          @data[:code][t][:body] = type['body']
        end
      end
    end

    # Public: Get a value from the tinker
    #
    # key - The key to get
    def [] key
      @data[key] || nil
    end

    # Public: Store the current tinker
    #
    # Returns the data that was stored
    def store
      if !defined? DB
        raise 'No connection to MongoDB available'
      end

      if @data[:meta][:hash].nil?
        @data[:meta][:hash] = generate_hash
        @data[:meta][:revision] = 0
      else
        @data[:meta][:revision] += 1
      end

      begin
        DB['tinker'].insert(@data)
        @data.delete :_id
      rescue Exception => e
        raise 'Failed to save tinker'
      end
    end

    # Public: Get a JSON representation of the Tinker
    #
    # Returns a String with the JSON representation of the Tinker
    def to_json
      @data.to_json
    end

    private

    # Internal: Generate a new hash for a tinker
    #
    # Todo: This should check if the hash doesn't already exist
    def generate_hash
      5.times.map { BASE62.sample }.join
    end
  end
end

