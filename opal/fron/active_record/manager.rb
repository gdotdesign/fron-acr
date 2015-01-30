module Fron
  module ActiveRecord
    class Manager
      class << self
        attr_reader :endpoint

        def endpoint=(endpoint)
          @endpoint = endpoint
        end
      end

      def initialize(path, klass = nil)
        @path = path
        @class = klass
      end

      def where(params = {})
        request :post, '/where', params do |data|
          yield data.to_a
        end
      end

      def all(&block)
        where(&block)
      end

      def find(id)
        request :post, '/find', id: id do |data|
          yield data
        end
      end

      def update(id, data, &block)
        request :post, '/update', { id: id}.merge(data), &block
      end

      def update_or_create(id, data, &block)
        if id
          update id, data, &block
        else
          create data, &block
        end
      end

      def destroy(id, &block)
        request :post, '/destroy', { id: id}, &block
      end

      def create(data)
        request :post, '/create', data do |response|
          yield response
        end
      end

      def request(method, url, params = {})
        req = Fron::Request.new "#{self.class.endpoint.to_s}#{@path}#{url}", "Content-Type" => 'application/json'
        req.request method.upcase, params do |response|
          if (200..300).cover?(response.status)
            yield response.json
          else
            `console.warn(#{response.json['error']})`
          end
        end
      end
    end
  end
end
